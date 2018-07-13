with codigos as (
    select
        cast(unnest(string_to_array(pacc_unidades, ';')) as varchar(3)) as loja,
        cast(lpad(cast(packvirtualc.pacc_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo,
        cast(pacc_prod_codigo as varchar) as produto_desconto,
        cast(lpad(coalesce(pacc_descritivo, '0'), 30, '0') as varchar(30)) as descricao_grupo,
        cast(
            case when pacc_produtos <> '' then
                unnest(string_to_array(pacc_produtos || ';' || pacd_produtos, ';'))
            else
                unnest(string_to_array(pacd_produtos, ';'))
            end as varchar(14)) as codigo_interno,
        pacc_tipo
    from
        packvirtualc
    left join packvirtuald on (pacc_codigo = pacd_codigo)
where
    pacc_unidades ilike '%' || '040' || '%'
    and current_date between pacc_datainicio
    and pacc_datafinal
order by
    2,
    3,
    4
)
select
    prun_unid_codigo as loja,
    cast(lpad(cast(prun_prod_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo,
    cast(rpad(trim(rpad(prod_descrpdvs || ' ' || prod_complemento, 30, '0')), 30, '0') as varchar(30)) as descricao_grupo,
    cast(lpad(cast(prun_prod_codigo as varchar), 14, '0') as varchar(14)) as codigo_interno
from
    produn
    inner join produtos on (prod_codigo = prun_prod_codigo)
where
    prun_prvenda2 > 0
    and prun_extra5 > 0
    and prun_ativo = 'S'
    and prun_bloqueado = 'N'
    and prun_unid_codigo = '040'
union all
select
    loja,
    case when produto_desconto = codigo_interno
        and pacc_tipo = 'B' then
        cast(lpad(produto_desconto, 7, '0') as varchar(7))
    else
        cast(codigo_grupo as varchar(7))
    end as codigo_grupo,
    initcap(descricao_grupo),
    cast(lpad(codigo_interno, 14, '0') as varchar)
from
    codigos
where
    loja = '040';