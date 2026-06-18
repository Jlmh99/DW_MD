with usuarios as (
    select distinct
        id          as usuario_id,
        nombre,
        email,
        departamento,
        activo,
        rol_id
    from {{ source('staging', 'stg_usuarios') }}
    where id is not null
)
select
    md5(cast(usuario_id as varchar))    as usuario_key,
    usuario_id,
    nombre,
    email,
    coalesce(departamento, 'SIN_DEPARTAMENTO') as departamento,
    activo,
    rol_id
from usuarios
