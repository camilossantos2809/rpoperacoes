/*
    Copia informações de produtos de uma unidade para a outra

    alt = Registros da produn que serão modificados
    cop = Registros da produn que serão copiados/consultados
*/
update produn as alt
set 
    prun_ativo = cop.prun_ativo,
    prun_bloqueado = cop.prun_bloqueado
from  produn as cop
where 
    prun1.prun_prod_codigo = prun2.prun_prod_codigo
    and alt.prun_unid_codigo = '003' -- Informar o código da unidade que será alterada
    and cop.prun_unid_codigo = '002' -- Informar o código da unidade origem dos dados
