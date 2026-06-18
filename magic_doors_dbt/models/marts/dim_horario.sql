with horarios as (
    select distinct
        id              as horario_id,
        hora_inicio,
        hora_fin,
        dias_semana
    from {{ source('staging', 'stg_sesiones_aula') }}
    where id is not null
)
select
    md5(cast(horario_id as varchar))    as horario_key,
    horario_id,
    cast(hora_inicio as time)           as hora_inicio,
    cast(hora_fin as time)              as hora_fin,
    dias_semana
from horarios
