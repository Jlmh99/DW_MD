# Magic Doors - Data Warehouse

## Proyecto
Magic Doors es una plataforma de acceso inteligente para aulas del edificio K de la UTEQ.

## Arquitectura DW

### Tabla de Hechos
- fact_accesos

### Dimensiones
- dim_usuario
- dim_rol
- dim_aula
- dim_materia
- dim_grupo
- dim_fecha
- dim_horario

## Dataset

- usuarios.csv
- aulas.csv
- materias.csv
- grupos.csv
- sesiones_aula.csv
- registro_accesos.csv
- qr_dinamicos.csv

## ETL

El script etl_magic_doors.py realiza:
1. Lectura de archivos CSV.
2. Eliminación de duplicados.
3. Estandarización de correos.
4. Conversión de fechas.
5. Preparación para carga al Data Warehouse.

## Base de Datos

Motor: PostgreSQL

## Esquema

Star Schema orientado al análisis de accesos a aulas.
