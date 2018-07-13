select
    prun_unid_codigo as loja,
    cast(rpad(trim(rpad(prod_descrpdvs || ' ' || prod_complemento, 30, '0')), 30, '0') as varchar(30)) as descricao_promocao,
    cast('06' as varchar(2)) as tipo_promocao,
    cast(lpad(cast(prun_prod_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo_gatilho,
    cast(lpad(cast(cast(prun_extra5 as integer) as varchar), 6, '0') as varchar(6)) as quantidade_gatilho,
    cast(lpad(cast(prun_prod_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo_desconto,
    cast(lpad(cast(cast(prun_extra5 as integer) as varchar), 6, '0') as varchar(6)) as quantidade_grupo_desconto,
    cast('00000' as varchar(5)) as perc_desconto,
    cast('000000000' as varchar(9)) as valor_desconto_unitario,
    cast(lpad(cast(cast((prun_prvenda2 * 100) as integer) as varchar), 9, '0') as varchar(9)) as valor_final_unitario,
    cast('2015-01-01' as varchar(10)) as data_inicio,
    cast(cast((current_date + interval '3' day) as date) as varchar(10)) as data_fim,
    cast(
        case when prun_fatorpr3 > 0 then
            lpad(cast(prun_fatorpr3 - 1 as varchar), 6, '0')
        else
            '030000'
        end as varchar(6)) as qtd_max_faixa_gatilho,
    cast(lpad(cast(prun_prod_codigo as varchar), 9, '0') as varchar(9)) as codigo_promocao
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
    prun_unid_codigo as loja,
    cast(rpad(trim(rpad(prod_descrpdvs || ' ' || prod_complemento, 30, '0')), 30, '0') as varchar(30)) as descricao_promocao,
    cast('06' as varchar(2)) as tipo_promocao,
    cast(lpad(cast(prun_prod_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo_gatilho,
    cast(lpad(cast(cast(prun_fatorpr3 as integer) as varchar), 6, '0') as varchar(6)) as quantidade_gatilho,
    cast(lpad(cast(prun_prod_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo_desconto,
    cast(lpad(cast(cast(prun_fatorpr3 as integer) as varchar), 6, '0') as varchar(6)) as quantidade_grupo_desconto,
    cast('00000' as varchar(5)) as perc_desconto,
    cast('000000000' as varchar(9)) as valor_desconto_unitario,
    cast(lpad(cast(cast((prun_prvenda3 * 100) as integer) as varchar), 9, '0') as varchar(9)) as valor_final_unitario,
    cast('2015-01-01' as varchar(10)) as data_inicio,
    cast(cast((current_date + interval '3' day) as date) as varchar(10)) as data_fim,
    cast('030000' as varchar(6)) as qtd_max_faixa_gatilho,
    cast(lpad(cast(prun_prod_codigo as varchar), 9, '0') as varchar(9)) as codigo_promocao
from
    produn
    inner join produtos on (prod_codigo = prun_prod_codigo)
where
    prun_prvenda3 > 0
    and prun_fatorpr3 > 0
    and prun_ativo = 'S'
    and prun_bloqueado = 'N'
    and prun_unid_codigo = '040'
union all
select
    distinct loja,
    initcap(descricao_grupo) as descricao_promocao,
    cast('02' as varchar(2)) as tipo_promocao,
    codigo_grupo as codigo_grupo_gatilho,
    cast(lpad(cast(cast(pacd_qtde as integer) as varchar), 6, '0') as varchar(6)) as qtde_gatilho,
    case when pacc_tipo = 'B' then
        lpad(cast(pacc_prod_codigo as varchar(7)), 7, '0')
    else
        codigo_grupo
    end as codigo_grupo_desconto,
    cast(lpad(cast(cast(pacc_qtde as integer) as varchar), 6, '0') as varchar(6)) as qtde_grupo_desconto,
    cast(lpad(cast(
                case when pacc_tipo = 'F' then
                    cast((pacc_desconto * 100) as integer)
                else
                    '0'
                end as varchar), 5, '0') as varchar(5)) as perc_desconto,
    cast(lpad(cast(
                case when pacc_tipo <> 'F' then
                    cast((pacc_desconto * 100) as integer)
                else
                    '0'
                end as varchar), 9, '0') as varchar(9)) as valor_desconto,
    cast(lpad(cast(cast((pacc_prvenda * 100) as integer) as varchar), 9, '0') as varchar(9)) as valor_final_unit,
    cast(pacc_datainicio as varchar(10)),
    cast(pacc_datafinal as varchar(10)),
    cast('030000' as varchar(6)),
    cast(lpad(codigo_grupo, 9, '0') as varchar(9)) as codigo_promocao
from (
    select
        cast(unnest(string_to_array(pacc_unidades, ';')) as varchar(3)) as loja,
        cast(lpad(cast(packvirtualc.pacc_codigo as varchar), 7, '0') as varchar(7)) as codigo_grupo,
        cast(rpad(coalesce(pacc_descritivo, '0'), 30, '0') as varchar(30)) as descricao_grupo,
        cast(lpad(
                case when pacc_produtos <> '' then
                    unnest(string_to_array(pacc_produtos || ';' || pacd_produtos, ';'))
                else
                    unnest(string_to_array(cast(pacc_prod_codigo as varchar) || ';' || pacd_produtos, ';'))
                end, 14, '0') as varchar(14)) as codigo_interno,
        *
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
    4) as packs
where
    loja = '040';