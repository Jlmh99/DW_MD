-- hechos.sql

CREATE TABLE fact_accesos (
    acceso_key SERIAL PRIMARY KEY,
    usuario_key INTEGER REFERENCES dim_usuario(usuario_key),
    aula_key INTEGER REFERENCES dim_aula(aula_key),
    materia_key INTEGER REFERENCES dim_materia(materia_key),
    grupo_key INTEGER REFERENCES dim_grupo(grupo_key),
    fecha_key INTEGER REFERENCES dim_fecha(fecha_key),
    horario_key INTEGER REFERENCES dim_horario(horario_key),
    accion VARCHAR(50),
    motivo VARCHAR(255),
    cantidad_accesos INTEGER DEFAULT 1
);
