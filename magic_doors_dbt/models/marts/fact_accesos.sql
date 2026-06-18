with accesos as (
    select * from {{ ref('stg_accesos') }}
),
sesiones as (
    select
        id              as sesion_id,
        aula_id,
        materia_id,
        grupo_id,
        hora_inicio,
        hora_fin,
        dias_semana
    from {{ source('staging', 'stg_sesiones_aula') }}
)
select
    -- Surrogate key de la tabla de hechos
    md5(cast(a.acceso_id as varchar))           as acceso_key,

    -- Claves foráneas hacia dimensiones
    md5(cast(a.usuario_id as varchar))          as usuario_key,
    md5(cast(a.aula_id as varchar))             as aula_key,
    md5(cast(s.materia_id as varchar))          as materia_key,
    md5(cast(s.grupo_id as varchar))            as grupo_key,
    md5(cast(cast(a.timestamp_acceso as date) as varchar)) as fecha_key,
    md5(cast(s.sesion_id as varchar))           as horario_key,

    -- Métricas y atributos del evento
    a.accion,
    a.motivo,
    a.timestamp_acceso,

    -- Métricas calculadas
    1                                           as cantidad_accesos,
    case when a.accion = 'apertura' then 1 else 0 end as cantidad_aperturas,
    case when a.accion = 'cierre'   then 1 else 0 end as cantidad_cierres

from accesos a
left join sesiones s
    on a.aula_id = s.aula_id
where a.usuario_id is not null
  and a.aula_id is not null
  and a.timestamp_acceso is not null
