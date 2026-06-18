select
    id                                          as acceso_id,
    usuario_id,
    aula_id,
    sesion_id,
    accion,
    motivo,
    estado_aula_snapshot,
    cast(timestamp as timestamp)                as timestamp_acceso,
    cast(extract(year  from cast(timestamp as timestamp)) as int) as anio,
    cast(extract(month from cast(timestamp as timestamp)) as int) as mes,
    cast(extract(day   from cast(timestamp as timestamp)) as int) as dia
from {{ source('staging', 'stg_registro_accesos') }}
where timestamp is not null
  and usuario_id is not null
  and aula_id is not null