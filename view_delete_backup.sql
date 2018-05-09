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

        with views as (
            insert into backup.view (oid, data_execucao, nome, query)
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

        foreach v_nome_view in array v_nome_views loop
            raise notice 'drop views if exists % cascade;', v_nome_view;
            execute format('drop view if exists %I cascade;', v_nome_view);
        end loop;
    end
$$ language plpgsql;
