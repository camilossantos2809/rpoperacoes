/*
    Retorna um ranking de produtos com melhor classificação de cada grupo.

    No exemplo abaixo serão retornados os 10 produtos mais vendidos de cada grupo de produtos
    durante o mês 06/2017 para a unidade 001.
*/
select
  *
from (
    select
        mprd_prod_codigo,
        prod_descricao,
        prod_marca,
        prod_dpto_codigo,
        dpto_descricao,
        prod_grup_codigo,
        prod_grup_nome,
        row_number() over (
            partition by prod_grup_codigo
            order by sum(mprd_qtde) desc
        ) as ranking
        round(sum(mprd_qtde),3) as mprd_qtde,
        round(sum(mprd_prvenda),2) as mprd_prvenda,
        prod_comp_codigo,
        comp_nome
    from movprodd0617
        inner join unidades 
            on (mprd_unid_codigo=unid_codigo)
        inner join produtos 
            on (mprd_prod_codigo=prod_codigo)
        inner join produn 
            on (prun_prod_codigo=prod_codigo and prun_unid_codigo=mprd_unid_codigo)
        left join compradores 
            on (prod_comp_codigo=comp_codigo)
        left join departamentos 
            on (dpto_codigo=prod_dpto_codigo)
    where 
        mprd_datamvto between '2017-06-01' and '2017-06-30'
        and mprd_unid_codigo in ('001')
        and mprd_dcto_tipo='EVP'
        and mprd_status='N'
        --and CONDICAOESCOPO
    group by   
        mprd_prod_codigo,
        prod_descricao,
        prod_marca,
        prod_dpto_codigo,
        dpto_descricao,
        prod_grup_codigo,
        prod_grup_nome,  
        prod_comp_codigo,
        comp_nome
) as x
where
    ranking <= 10
order by 
    prod_grup_codigo,
    ranking;
