/*
    Atualiza o campo prun_etq dos produtos que possuem código de preço de forma que somente um produto
    com o mesmo código de preço tenha quantidade de etiquetas cadastradas.
*/

begin;

with codprecos as (
    select max(p.prod_codigo) over (partition by prod_codpreco, prun_unid_codigo) as max_codigo,
        p.prod_codigo,
        p.prod_codpreco, 
        pu.prun_unid_codigo
    from produtos p
        inner join produn pu
            on (p.prod_codigo=pu.prun_prod_codigo)
    where p.prod_codpreco > 0
    --and p.prod_codpreco in (1101, 1102)
)
update produn pu
set prun_etq=case 
                when cp.max_codigo = pu.prun_prod_codigo
                then 1
                else 0
            end
from codprecos cp
where cp.prod_codigo=pu.prun_prod_codigo
    and cp.prun_unid_codigo=pu.prun_unid_codigo;

commit;