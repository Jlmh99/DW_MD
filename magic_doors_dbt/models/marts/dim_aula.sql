with aulas as (
    select distinct
        id          as aula_id,
        nombre,
        edificio,
        piso,
        capacidad,
        estado
    from {{ source('staging', 'stg_aulas') }}
    where id is not null
)
select
    md5(cast(aula_id as varchar))   as aula_key,
    aula_id,
    nombre,
    edificio,
    piso,
    capacidad,
    estado
from aulas
