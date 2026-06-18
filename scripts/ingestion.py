import os
import re
import pandas as pd
from sqlalchemy import create_engine

DATA_PATH = '/opt/airflow/data'


def clean_usuarios(df):
    print("  [usuarios] Aplicando reglas de limpieza...")

    # REGLA 1: Validar emails institucionales @uteq.edu.mx
    # Cualquier email que no cumpla el formato se marca como INVALID_EMAIL
    patron_email = r'^[a-zA-Z0-9._%+-]+@uteq\.edu\.mx$'
    invalidos = ~df['email'].str.match(patron_email, na=False)
    print(f"    -> Emails con formato incorrecto detectados: {invalidos.sum()}")
    df.loc[invalidos, 'email'] = 'INVALID_EMAIL'

    # REGLA 2: Limpiar valores no numéricos en telefono
    # Los valores 'N/A', 'no disponible' o vacíos se reemplazan con None
    def limpiar_telefono(val):
        val = str(val).strip()
        if val in ('', 'nan', 'N/A', 'no disponible', 'None'):
            return None
        if re.match(r'^\d{10}$', val):
            return val
        return None

    df['telefono'] = df['telefono'].apply(limpiar_telefono)
    nulos = df['telefono'].isna().sum()
    print(f"    -> Telefonos invalidos/nulos corregidos: {nulos}")

    # REGLA 3: Eliminar columna password — no debe estar en el DW
    if 'password' in df.columns:
        df = df.drop(columns=['password'])
        print("    -> Columna 'password' eliminada por seguridad")

    return df


def clean_grupos(df):
    print("  [grupos] Aplicando reglas de limpieza...")

    # REGLA 1: Imputar tutor_nombre nulos con valor por defecto
    nulos = df['tutor_nombre'].isna().sum()
    print(f"    -> tutor_nombre nulos detectados: {nulos}")
    df['tutor_nombre'] = df['tutor_nombre'].fillna('SIN_ASIGNAR')
    print(f"    -> tutor_nombre imputados con 'SIN_ASIGNAR': {nulos}")

    return df


def clean_sesiones_aula(df):
    print("  [sesiones_aula] Aplicando reglas de limpieza...")

    # REGLA 1: Estandarizar creado_en y actualizado_en
    # El CSV tiene mezcla de formatos:
    #   - Correcto:   YYYY-MM-DD  (ej. 2026-01-01)
    #   - Incorrecto: DD-MM-YYYY  (ej. 01-01-2026)
    antes = df['creado_en'].str.match(r'^\d{2}-\d{2}-\d{4}', na=False).sum()
    print(f"    -> Fechas con formato incorrecto detectadas: {antes}")

    def estandarizar_fecha(val):
        try:
            return pd.to_datetime(val, dayfirst=False).strftime('%Y-%m-%d')
        except:
            try:
                return pd.to_datetime(val, dayfirst=True).strftime('%Y-%m-%d')
            except:
                return None

    df['creado_en'] = df['creado_en'].apply(estandarizar_fecha)
    df['actualizado_en'] = df['actualizado_en'].apply(estandarizar_fecha)
    print(f"    -> Fechas estandarizadas a YYYY-MM-DD")

    return df


def run_ingestion():
    print("=== [FASE 01] INICIO DEL PIPELINE DE INGESTA MAGIC DOORS ===")

    # ── Conexión a PostgreSQL ────────────────────────────────
    DB_HOST = "magic_doors_postgres"
    conn_str = f"postgresql+psycopg2://magic_user:magic_password@{DB_HOST}:5432/dw_magic_doors"
    engine = create_engine(conn_str)
    print(f"-> Conectado a PostgreSQL en {DB_HOST}")

    # ── Tablas sin transformaciones especiales ───────────────
    tablas_simples = ['roles', 'aulas', 'materias', 'qr_dinamicos', 'registro_accesos']
    for tabla in tablas_simples:
        path = os.path.join(DATA_PATH, f'{tabla}.csv')
        df = pd.read_csv(path)
        df.to_sql(
            f'stg_{tabla}',
            engine,
            if_exists='replace',
            index=False,
            chunksize=5000,
            method='multi'
        )
        print(f"-> stg_{tabla} cargada: {len(df)} registros")

    # ── Tablas con limpieza ──────────────────────────────────
    print("\n=== [FASE 02] LIMPIEZA Y TRANSFORMACIÓN ===")

    # usuarios — validación de emails y limpieza de teléfonos
    df_usuarios = pd.read_csv(
        os.path.join(DATA_PATH, 'usuarios.csv'),
        dtype={'telefono': str}
    )
    df_usuarios = clean_usuarios(df_usuarios)
    df_usuarios.to_sql('stg_usuarios', engine, if_exists='replace', index=False,
                       chunksize=5000, method='multi')
    print(f"-> stg_usuarios cargada: {len(df_usuarios)} registros\n")

    # grupos — imputación de tutor_nombre nulos
    df_grupos = pd.read_csv(os.path.join(DATA_PATH, 'grupos.csv'))
    df_grupos = clean_grupos(df_grupos)
    df_grupos.to_sql('stg_grupos', engine, if_exists='replace', index=False,
                     chunksize=5000, method='multi')
    print(f"-> stg_grupos cargada: {len(df_grupos)} registros\n")

    # sesiones_aula — estandarización de formatos de fecha
    df_sesiones = pd.read_csv(os.path.join(DATA_PATH, 'sesiones_aula.csv'))
    df_sesiones = clean_sesiones_aula(df_sesiones)
    df_sesiones.to_sql('stg_sesiones_aula', engine, if_exists='replace', index=False,
                       chunksize=5000, method='multi')
    print(f"-> stg_sesiones_aula cargada: {len(df_sesiones)} registros\n")

    print("=== [FASE 03] PIPELINE FINALIZADO CON ÉXITO ===")


if __name__ == "__main__":
    run_ingestion()
