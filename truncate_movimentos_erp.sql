/*
    Comandos para serem utilizados para remover os registros de movimentação na base de dados antes da implantação
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
        -- Nomes das tabelas que terão os registros removidos na execução do script
        vNomeTabelas := array[
            'agforn', 'agrec', 'ajustemvto', 'apurimpostos', 'apuroutros', 'auditest',
            'biometrias', 'bxparcial', 'bxpendest', 'conccartoes', 'conscadastronfe', 
            'consprotnfe', 'consultacte', 'consprotmdfe', 'consrecnfe', 'consultanfservico', 
            'dados2', 'errosimpautom', 'inutnfe', 'log', 'marketplacecontroleprodutos', 
            'marketplaceocorrencia', 'marketplacepromocao', 'marketplacepromocaocb', 
            'mensagens', 'metasprod', 'negociacoesc', 'negociacoesd', 'negociacoesp', 
            'nfcc', 'nfec', 'nfed', 'pedcomprac', 'pedcomprad', 'pedvendac', 'pedvendad', 
            'pendest', 'pendfin', 'rascunhos', 'recmerc', 'recnfe', 'refdctos', 'regrasneg', 
            'regforn', 'regrastxadm', 'resdpto', 'resdptodia', 'saldosger', 'saldosbco', 
            'saldoscon', 'seqmapa', 'susplcto', 'tabforn', 'textos', 'vdonlinefi', 
            'vdonlineprod', 'xmlauxiliar', 'xmlcte', 'xmlnfe', 'xmlnfeautd',
            'mov%', 'invfisc%', 'vdadet%', 'ra__'
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

        /*
            Deleta formatos criados para relatórios e configurações de posicionamento de colunas nos grids
        */
        raise notice 'Deletando formatos e configurações de grid...';
        delete from formatosrel where usuario <> '9999';
        raise notice E'Formatos e configurações de grid deletados.\n';

        raise notice 'Limpeza de movimentos concluído!';
    end
$$ language plpgsql;
