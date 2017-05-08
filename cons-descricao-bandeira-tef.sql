select 
  split_part(tvd_registro,'|',1) as finalizadora,
  split_part(tvd_registro,'|',49) as bandeira
from tab_venda_1116
where
  tvd_tipo_reg like 'FIN%' --Somente logs de finalização
  and split_part(tvd_registro,'|',1) in('04','05') --Códigos das finalizadoras referentes ao cartão
  and tvd_unidade = '101'
  and cast(tvd_data_hora as date) = '2016-11-28'
group by 1,2
order by 1,2;
