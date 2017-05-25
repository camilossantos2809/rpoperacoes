/*
    Geração de DRE simples contendo somente as contas que geraram movimentação na tabela movger ou que são do tipo TT na planoger
*/
select
    pger_classificacao,
    pger_descricao, pger_conta, pger_tipo, /*sum(mger_valor),*/ sum(mger_001)as mger_001,sum(mger_002) as mger_002
from planoger left join (
  select /*sum(
    case when mger_dc = 'D' then mger_valor * (-1) else mger_valor end
  ) as mger_valor,*/
  pger_classificacao as mger_classificacao,mger_pger_conta,
  case
    when mger_unid_codigo = '001' then (case when mger_dc = 'D' then mger_valor * (-1) else mger_valor end)
  end as mger_001,
  case
    when mger_unid_codigo = '002' then (case when mger_dc = 'D' then mger_valor * (-1) else mger_valor end)
  end as mger_002
  from planoger 
    left join movger on (pger_conta = mger_pger_conta )
  where mger_datamvto between '2014-03-01' and '2014-03-30'
  and mger_status <> 'C'
  and pger_classificacao like '3%'
  group by  mger_classificacao,mger_pger_conta,mger_001,mger_002
  order by mger_classificacao
) as mov on mger_classificacao like pger_classificacao || '%'
where pger_classificacao like '3%' --and mger_unid_codigo in ('001','002')
group by pger_classificacao, pger_tipo,pger_descricao, pger_conta--, mger_unid_codigo
having sum(mger_001) <> 0 or sum(mger_002) <> 0
order by pger_classificacao
