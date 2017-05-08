with codigos as (
  select 
    trib_codigo as tcod
  from 
    tributacao
  group by 
    trib_codigo
)
select 
  tcod,
  trib_codigo,
  trib_mvtos
from tributacao 
  right join codigos on (
    trib_codigo=tcod 
    and trib_mvtos like '%EVD%'
  )
where 
  trib_codigo is null
group by 
  tcod,
  trib_codigo,
  trib_mvtos;
