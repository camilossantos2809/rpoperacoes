/*
    Função que cria comando SQL dinâmico concatenando o nome da tabela informada no parâmetro (movprodd, vdadet, invfisc)
    ao mes e ano e gerando a consulta para cada tabela correspondente ao período informado.
    
    Conforme o período solicitado no parâmetro, será gerado um comando SQL dinâmico adicionando um UNION
    para cada mês de movimento.

    A intenção é que essa função seja um utilitário para seu uso em outras funções, ela não foi
    idealizada para ser executada diretamente no frontend.

    Parametros:
        tabela - nome da tabela que será concatenada com mês e ano (movprodd, vdadet, invfisc)
        data_inicial - data inicial do período a ser consultado nas tabelas
        data_final - data final do período a ser consultado nas tabelas
        final_query - Trecho de código SQL a ser adicionado ao final da consulta (JOIN, WHERE e/ou GROUP BY)
        campos_select - Caso seja necessário especificar os campos a serem retornados na consulta, informar o array
            contendo os campos necessários
        union_all - Se "true" utilizará "UNION ALL" ao invés de "UNION" no comando SQL
    
    Exemplo de utilização:
        select 
            utils.fn_query_periodo(
                'vdadet',
                '2017-01-20'::date,
                '2017-02-10'::date,
                'inner join produtos 
                on (mprd_prod_codigo=prod_codigo) 
                where prod_codigo=100006',
                array['prod_codigo','prod_descricao','mprd_valor'],
                true
            );
    
    Exemplo de retorno:
        select
            prod_codigo,
            prod_descricao,
            mprd_valor
        from
            vdadet0117
            inner join produtos on (mprd_prod_codigo = prod_codigo)
        where
            prod_codigo = 100006
        union all
        select
            prod_codigo,
            prod_descricao,
            mprd_valor
        from
            vdadet0217
        inner join produtos on (mprd_prod_codigo = prod_codigo)
        where
            prod_codigo = 100006
*/
create or replace function utils.fn_query_periodo(
    tabela text,
    data_inicial date,
    data_final date,
    final_query text,
    campos_select text[],
    union_all boolean
    )
 RETURNS text 
 LANGUAGE plpgsql
AS $$
declare
    tSql text;
    aTabelas text[];
    i smallint;
begin
    with periodo as(
        select generate_series(date_trunc('month',data_inicial),data_final,'1 month') as mesano
    )
    select 
        array_agg(tabela||to_char(mesano,'MMyy'))
    into aTabelas
    from periodo;
    raise info 'Listagem de tabelas referente a período: %', aTabelas;

    for i in 1 .. array_upper(aTabelas, 1)
    loop
        -- Realiza verificação para se não for informados os campos para select utilizar *
        if campos_select is null then
            tSql = concat(tSql, 'select *', E'\n');
        else
            tSql = concat(tSql, 'select ', E'\n');
            for i in 1 .. array_upper(campos_select, 1) 
            loop
                if i < array_upper(campos_select, 1) then
                    tSql = concat(tSql, '  ',  campos_select[i], E',\n');
                else
                    tSql = concat(tSql, '  ',  campos_select[i], E'\n');
                end if;
            end loop;
        end if;

        --Adiciona o nome da tabela gerado dinamicamente
        tSql = concat(tSql, 'from ', aTabelas[i], E'\n');
        
        --Inclui o trecho de SQL a ser adicionado ao final de cada consulta (JOIN, WHERE e/ou GROUP BY)
        if final_query is not null then
            tSql = concat(tSql, ' ', final_query, E'\n');
        end if;

        --inclui a cláusula union somente se ainda não for a última tabela
        if i < array_upper(aTabelas, 1) then
            if union_all then
                tSql = concat(tSql, 'union all ', E'\n');
            else
                tSql = concat(tSql, 'union ', E'\n');
            end if;
        end if;
    end loop;

    return tSql;
end
$$;