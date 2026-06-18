with materias as (
    select distinct
        id          as materia_id,
        nombre,
        codigo,
        area,
        creditos,
        horas_semana
    from {{ source('staging', 'stg_materias') }}
    where id is not null
)
select
    md5(cast(materia_id as varchar))    as materia_key,
    materia_id,
    nombre,
    codigo,
    area,
    creditos,
    horas_semana
from materias
