with roles as (
    select distinct
        id      as rol_id,
        nombre  as nombre_rol
    from {{ source('staging', 'stg_roles') }}
    where id is not null
)
select
    md5(cast(rol_id as varchar))    as rol_key,
    rol_id,
    nombre_rol
from roles
