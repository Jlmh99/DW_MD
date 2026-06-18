with grupos as (
    select distinct
        id              as grupo_id,
        nombre,
        grado,
        turno,
        num_alumnos,
        tutor_nombre
    from {{ source('staging', 'stg_grupos') }}
    where id is not null
)
select
    md5(cast(grupo_id as varchar))  as grupo_key,
    grupo_id,
    nombre,
    grado,
    turno,
    num_alumnos,
    -- tutor_nombre ya fue imputado como 'SIN_ASIGNAR' en la ingesta
    tutor_nombre
from grupos
