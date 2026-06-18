with fechas as (
    select distinct
        cast(timestamp_acceso as date) as fecha
    from {{ ref('stg_accesos') }}
    where timestamp_acceso is not null
)
select
    md5(cast(fecha as varchar))                         as fecha_key,
    fecha,
    cast(extract(day   from fecha) as int)              as dia,
    cast(extract(month from fecha) as int)              as mes,
    cast(extract(year  from fecha) as int)              as anio,
    cast(extract(quarter from fecha) as int)            as trimestre,
    to_char(fecha, 'Day')                               as dia_semana
from fechas
