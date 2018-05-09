/**
    Remove todas as views do schema public criando um backup/histórico dos comandos SQL
    de cada view na tabela backup.view.

    A partir da versão 3.20 do FlexDB será necessária a exclusão das views antes da
    atualização da estrutura. De qualquer maneira, o comando pode ser utilizado em
    situações onde seja necessário eliminar de forma automática as views do schema public.

    Para restaurar as views com base no backup gerado pelo código abaixo deverá 
    ser utilizado o código do arquivo view_restore.sql, deste repositório.
    https://github.com/camilossantos2809/rpoperacoes/blob/master/view_restore.sql
**/

do $$
    declare
        v_nome_view text;
        v_nome_views text[];
    begin
        raise notice 'Criando schema backup';
        create schema if not exists backup;

        raise notice 'Criando tabela backup.view';
        create table if not exists backup.view(
            view_oid oid,
            data_execucao timestamp default current_timestamp,
            nome text,
            query text
        );

        raise notice 'Inserindo dados das views na tabela backup.view';
        with views as (
            insert into backup.view (view_oid, data_execucao, nome, query)
            select oid, current_timestamp, relname, pg_get_viewdef(oid)
            from pg_class 
            where
                relnamespace='public'::regnamespace 
                and relkind='v'
            returning nome
        )
        select array_agg(nome)
        into v_nome_views
        from views;

        raise notice 'Iniciando comandos para remoção de views do schema public';
        foreach v_nome_view in array v_nome_views loop
            raise notice 'Removendo view % ...', v_nome_view;
            execute format('drop view if exists %I cascade;', v_nome_view);
            raise notice 'Comando de exclusão da view % executado', v_nome_view;
        end loop;
    end
$$ language plpgsql;
