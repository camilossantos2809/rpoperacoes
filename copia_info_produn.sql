/*
    Atualiza informações na tabela produn de uma unidade com base em uma outra.
    
    Pode ser útil em casos onde na implantação o cliente decide que informações de status
    do produto, ou custos e preços, da matriz sejam atribuídos para unidades filiais.
    Também pode ser útil quando houver a criação de mais unidades no sistema.

    alt = Registros da produn que serão modificados (destino)
    cop = Registros da produn que serão copiados/consultados (origem)
*/
update produn as alt
set 
    prun_ativo = cop.prun_ativo,
    prun_bloqueado = cop.prun_bloqueado
from produn as cop
where 
    alt.prun_prod_codigo = cop.prun_prod_codigo
    and alt.prun_unid_codigo = '003' -- Informar o código da unidade que será alterada (destino)
    and cop.prun_unid_codigo = '002' -- Informar o código da unidade origem dos dados
