with prod as (
    select
        prod_codigo,
        prod_grup_codigo,
        grup_descricao
    from
        produtos
        inner join produn on (prod_codigo = prun_prod_codigo)
        left join grupos on (prod_grup_codigo = grup_codigo)
    where
        prod_dpto_codigo = '001'
    group by
        prod_codigo,
        prod_grup_codigo,
        grup_descricao
),
vendas as (
    select
        prod_grup_codigo,
        grup_descricao,
        sum(mprd_valor) as valor,
        count(distinct mprd_prod_codigo) as qtd,
        coalesce(sum(mprd_prvenda - mprd_ctmedio - mprd_ctvenda), 0) as margem,
        round(((sum(mprd_valor) / sum(sum(mprd_valor))
                    over ()) * 100),
            3) as repr_venda,
        round(((sum(mprd_qtde) / sum(sum(mprd_qtde))
                    over ()) * 100),
            3) as repr_qtde,
        round(((sum(mprd_prvenda - mprd_ctmedio - mprd_ctvenda) / sum(coalesce(sum(mprd_prvenda - mprd_ctmedio - mprd_ctvenda), 0))
                    over ()) * 100),
            3) as repr_margem
    from
        movprodd0117 m
        inner join prod on (mprd_prod_codigo = prod_codigo)
    where
        mprd_unid_codigo = '001'
        and mprd_dcto_tipo = 'EVP'
        and mprd_status = 'N'
    group by
        prod_grup_codigo,
        grup_descricao),
    curva as (
        select
            prod_grup_codigo,
            case when sum(repr_venda)
                over (
                order by
                    repr_venda desc) <= 80 then
                'A'
            when sum(repr_venda)
                over (
                order by
                    repr_venda desc) <= 95 then
                'B'
            when sum(repr_venda)
                over (
                order by
                    repr_venda desc) <= 100 then
                'C'
            else
                'D'
            end class_venda,
            case when sum(repr_qtde)
                over (
                order by
                    repr_qtde desc) <= 20 then
                'A'
            when sum(repr_qtde)
                over (
                order by
                    repr_qtde desc) <= 50 then
                'B'
            when sum(repr_qtde)
                over (
                order by
                    repr_qtde desc) <= 100 then
                'C'
            else
                'D'
            end class_qtde,
            case when sum(repr_margem)
                over (
                order by
                    repr_margem desc) <= 80 then
                'A'
            when sum(repr_margem)
                over (
                order by
                    repr_margem desc) <= 95 then
                'B'
            when sum(repr_margem)
                over (
                order by
                    repr_margem desc) <= 100 then
                'C'
            else
                'D'
            end class_margem
        from
            vendas
)
    select
        class_venda,
        case when prod_grup_codigo is not null then
            rank()
            over (partition by
                    class_venda
                order by
                    valor_vendido desc) - 1
        end as rank_venda,
        class_margem,
        case when prod_grup_codigo is not null then
            rank()
            over (partition by
                    class_margem
                order by
                    qtd_produtos desc) - 1
        end as rank_margem,
        class_qtde,
        prod_grup_codigo,
        grup_descricao,
        valor_vendido,
        qtd_produtos,
        margem,
        round((valor_vendido / sum(valor_vendido)
                over (partition by
                        tipo)) * 100,
                3) as part_venda,
        round((margem / sum(margem)
                over (partition by
                        tipo)) * 100,
                3) as part_margem,
        round((qtd_produtos / sum(qtd_produtos)
                over (partition by
                        tipo)) * 100,
                3) as part_qtde,
        round((margem / valor_vendido) * 100,
            3) as "% margem",
        tipo
    from (
        select
            class_venda,
            class_margem,
            class_qtde,
            v.prod_grup_codigo,
            v.grup_descricao,
            sum(v.valor) as valor_vendido,
            sum(qtd) as qtd_produtos,
            sum(margem) as margem,
            case when class_venda is not null then
                cast('V' as varchar(1))
            when class_margem is not null then
                cast('M' as varchar(1))
            when class_qtde is not null then
                cast('Q' as varchar(1))
            end as tipo
        from
            vendas v
            inner join curva c on (v.prod_grup_codigo = c.prod_grup_codigo)
        group by
            grouping sets ((v.prod_grup_codigo,
                    v.grup_descricao,
                    class_venda,
                    class_margem,
                    class_qtde), (class_venda), (class_margem), (class_qtde), ())) as x
order by
    class_venda,
    valor_vendido desc;
