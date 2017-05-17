/*
  Quando utilizada a função de item em cadastro do WRpdv, informando o código do produto
  que no momento da venda estava sem cadastro, o comando SQL abaixo retorna os dados do produto
  depois que ele já estiver cadastrado, de maneira a facilitar a consulta das informações.
*/
with codigos as(
  select distinct 
    case 
      when substring(split_part(tvd_registro,'|',33),1,1)='2' 
        then lpad(substring(split_part(tvd_registro,'|',33),2,4),13,'0')
      else split_part(tvd_registro,'|',33)
    end as codinf
  from tab_venda_1015 
  where tvd_tipo_reg ilike 'vit%'
    and cast(tvd_data_hora as date) >= '2015-10-03'
)
select distinct 
  cast(codinf as varchar(13)),
  ite_cod_interno,
  ite_descricao,
  ite_ttr_codigo
from codigos 
  left join tabitens 
    on codinf = ite_codbarra
where 
  ite_cod_interno is not null 
  or ite_ttr_codigo='999'
order by 
  ite_descricao
