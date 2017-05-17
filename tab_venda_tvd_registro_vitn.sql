/*
    Retorna os registros da tabela tab_venda do WRpdv com os registros do campo tvd_registro separados em colunas
*/
select
  tvd_unidade,
  tvd_data_hora,
  tvd_data_emissao,
  tvd_pdv, 
  tvd_estacao,
  tvd_cupom,
  tvd_operador,
  tvd_tipo_reg,
  tvd_registro[1] as cod_barras,
  tvd_registro[2] as descricao,
  tvd_registro[3]::numeric/100 as pr_unit_bruto,
  tvd_registro[4]::numeric/100 as qtde,
  tvd_registro[5]::numeric/100 as val_tot_bruto,
  tvd_registro[6]::numeric/100 as val_tot_bruto_desc,
  tvd_registro[7] as tribut,
  tvd_registro[8] as cod_vasilhame,
  tvd_registro[9] as item_pesado,
  tvd_registro[10] as cod_depart,
  tvd_registro[11] as cod_interno,
  tvd_registro[12] as desc_subtotal,
  tvd_registro[13] as acres_subtotal,
  tvd_registro[14] as pr_unit_desc_por_fin,
  tvd_registro[15] as cont_ccf,
  tvd_registro[16] as cod_vendedor,
  tvd_registro[17] as perc_comissao_depart,
  tvd_registro[18] as aliq_item,
  tvd_registro[19] as cod_trib_pdv,
  tvd_registro[20] as simbologia,
  tvd_registro[21] as tp_regra_venda,
  tvd_registro[22] as cod_sup_desconto,
  tvd_registro[23] as num_fab_impressora,
  tvd_registro[24] as marc_item_cancelado,
  tvd_registro[25] as relacao_desc,
  tvd_registro[26] as marca_produto,
  tvd_registro[27] as cod_grupo_produto,
  tvd_registro[28] as marc_prod_oferta,
  tvd_registro[29] as desc_fiscal,
  tvd_registro[30] as acres_fiscal,
  tvd_registro[31] as cod_cesta_basica,
  tvd_registro[32] as cod_barras_balanca,
  tvd_registro[33] as cod_prod_naocad,
  tvd_registro[34]::numeric as val_imposto_item
from (
  select 
    tvd_unidade, tvd_data_hora, tvd_data_emissao, tvd_pdv, 
    tvd_estacao, tvd_cupom, tvd_operador, tvd_tipo_reg,
    string_to_array(tvd_registro, '|') as tvd_registro
  from tab_venda_0615
  where 
    cast(tvd_data_hora as date) between '2015-06-01' and '2015-06-10'
    and tvd_tipo_reg like 'VIT%'
  ) as logs
--limit 20