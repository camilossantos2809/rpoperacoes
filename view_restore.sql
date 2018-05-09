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
            order by oid
        loop
            raise notice 'Criando view % ...', v_registros.ult_nome;
            execute format('create or replace view %s as %s;', v_registros.ult_nome, v_registros.query);
        end loop;
    end
$$ language plpgsql;

