/*
    Comandos para serem utilizados para remover a movimentação na base de dados antes da implantação
*/

set client_encoding = 'latin1';

/*
    Necessário atualizar as estatísticas do postgres apenas para poder remover os registros
    somente de tabelas que possuam registros, diminuindo a quantidade de locks geradas na transação.
*/
analyze verbose;

do $$
    declare
        vNomeTabelas varchar[];
        vTabelaTruncate record;
    begin
        vNomeTabelas = array[
            'cuponsproc','fechamentosop','fechamentoz','itenscesta', 'itenspack',
            'exportacoes', 'leituraz', 'leituraztrib', 'logeventos', 'logprocessos',
            'mesa_historico', 'packvirtual', 'pedido_item_restaurante', 'pedido_restaurante',
            'retmov', 'tabcbalt', 'tabitens', 'tabprecos2', 'tabtrib',
            'tab_venda%', 'mov%', 'evento%', 'vendaitenscrm%', 'xmlpdv_%'
        ];
        
        for vTabelaTruncate in
            select relname
            from pg_class
            where
                relname like any (vNomeTabelas)
                and relkind = 'r'
                and relnamespace = 'public'::regnamespace -- apenas as tabelas do schema public serão considerados 
                and reltuples > 0
            order by relname
        loop
            raise notice 'Iniciando limpeza da tabela % ...', vTabelaTruncate.relname;
            execute format('truncate %I;', vTabelaTruncate.relname);
            raise notice 'Realizado truncate na tabela % ...', vTabelaTruncate.relname;
            raise notice 'Recriando índices da tabela % ...', vTabelaTruncate.relname;
            execute format('reindex table %I;', vTabelaTruncate.relname);
            raise notice 'Atualizando estatísticas da tabela % ...', vTabelaTruncate.relname;
            execute format('analyze %I;', vTabelaTruncate.relname);
            raise notice E'Processamento da tabela % concluído \n', vTabelaTruncate.relname;
        end loop;

        raise notice 'Limpeza de movimentos concluído!';
    end
$$ language plpgsql;
