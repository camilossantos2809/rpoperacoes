/*
    Copia configurações (Configurações -> Configurações da Unidade) existentes de uma unidade para uma nova.
*/
do $$
declare
  sUnidOrigem varchar(3);
  sUnidNova varchar(3);

begin

-- Definir abaixo os códigos das unidades conforme nomenclatura das variáveis
sUnidOrigem := '001'; --Código da unidade já existente que possuem os dados que serão copiados
sUnidNova := '002'; --Código da nova unidade que ainda não possui configuração no FlexDB

insert into config1
select 
    replace(cfg1_nome, sUnidOrigem, sUnidNova),
    cfg1_tipo,
    cfg1_conteudo
from config1
where 
    cfg1_nome ilike '%' || sUnidOrigem;

insert into configautom
SELECT
    cfga_funcao, sUnidNova, cfga_cpo11, cfga_cpo12, cfga_cpo13, 
    cfga_cpo14, cfga_cpo15, cfga_cpo16, cfga_cpo17, cfga_cpo18, cfga_cpo19, 
    cfga_cpo20, cfga_cpo101, cfga_cpo102, cfga_cpo103, cfga_cpo104, 
    cfga_cpo105, cfga_cpo106, cfga_cpo107, cfga_cpo108, cfga_cpo109, 
    cfga_cpo110, cfga_cpo1001, cfga_cpo1002, cfga_cpo1003, cfga_cpo4001, 
    cfga_cpo4002, cfga_cpo4003
FROM configautom
where cfga_unid_codigo = sUnidOrigem;

end;
$$ language plpgsql;
