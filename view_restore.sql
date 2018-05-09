/**
    Cria views com base em comandos SQL gravados na tabela backup.view.

    Para utilização desse código, presume-se que o arquivo view_delete_backup.sql,
    deste repositório, tenha sido executado anteriormente, gerando os dados necessários
    na tabela backup.view.
    https://github.com/camilossantos2809/rpoperacoes/blob/master/view_delete_backup.sql

    Na tabela backup.view podem existir mais de um registro com o mesmo nome, a 
    restauração será gerada considerando o registro que tenha o maior valor 
    no campo data_execucao.
**/

do $$
    declare
        v_registros record;
    begin
        for v_registros in
            with ult_reg as (
                select 
                    nome as ult_nome,
                    max(data_execucao) as ult_data
                from backup.view 
                group by nome
            )
            select ult_nome, query
            from backup.view
                inner join ult_reg on (
                    ult_nome=nome
                    and ult_data=data_execucao
                )
            order by view_oid
        loop
            raise notice 'Criando view % ...', v_registros.ult_nome;
            execute format('create or replace view %s as %s;', v_registros.ult_nome, v_registros.query);
        end loop;
    end
$$ language plpgsql;

