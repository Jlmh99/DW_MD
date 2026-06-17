-- dimensiones.sql

CREATE TABLE dim_rol (
    rol_key SERIAL PRIMARY KEY,
    rol_id INTEGER,
    nombre_rol VARCHAR(100)
);

CREATE TABLE dim_usuario (
    usuario_key SERIAL PRIMARY KEY,
    usuario_id INTEGER,
    nombre VARCHAR(255),
    email VARCHAR(255),
    departamento VARCHAR(100),
    activo BOOLEAN,
    rol_id INTEGER
);

CREATE TABLE dim_aula (
    aula_key SERIAL PRIMARY KEY,
    aula_id INTEGER,
    nombre VARCHAR(100),
    edificio VARCHAR(50),
    piso INTEGER,
    capacidad INTEGER,
    estado VARCHAR(50)
);

CREATE TABLE dim_materia (
    materia_key SERIAL PRIMARY KEY,
    materia_id INTEGER,
    nombre VARCHAR(255),
    codigo VARCHAR(50),
    area VARCHAR(100),
    creditos INTEGER,
    horas_semana INTEGER
);

CREATE TABLE dim_grupo (
    grupo_key SERIAL PRIMARY KEY,
    grupo_id INTEGER,
    nombre VARCHAR(100),
    grado VARCHAR(20),
    turno VARCHAR(50),
    num_alumnos INTEGER
);

CREATE TABLE dim_fecha (
    fecha_key SERIAL PRIMARY KEY,
    fecha DATE,
    dia INTEGER,
    mes INTEGER,
    anio INTEGER,
    trimestre INTEGER,
    dia_semana VARCHAR(20)
);

CREATE TABLE dim_horario (
    horario_key SERIAL PRIMARY KEY,
    hora_inicio TIME,
    hora_fin TIME,
    dias_semana VARCHAR(50)
);
