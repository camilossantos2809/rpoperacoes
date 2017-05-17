/*
    Comandos para serem utilizados para remover a movimentação na base de dados antes da implantação

    Versão: 1.1
*/
begin;
truncate agforn;
truncate agrec;
truncate ajustemvto;
truncate apurimpostos;
truncate apuroutros;
truncate auditest;
truncate biometrias;
truncate bxparcial;
truncate bxpendest;
truncate errosimpautom;
truncate log;
truncate mensagens;
truncate metasprod;
truncate movbco;
truncate movcon;
truncate movdctos;
truncate movfechpdv;
truncate movfechtesouraria;
truncate movfinalizadoras;
truncate movfiscal;
truncate movfiscalaux;
truncate movfpdvc;
truncate movfpdvd;
truncate movger;
truncate movintbco;
truncate movneg;
truncate movocbens;
truncate movpesquisa;
truncate movprodc;
truncate movratger;
truncate movservicos;
truncate movtrib;
truncate movtribpdv;
truncate negociacoesc;
truncate negociacoesd;
truncate negociacoesp;
truncate nfcc;
truncate nfec;
truncate nfed;
truncate pedcomprac;
truncate pedcomprad;
truncate pedvendac;
truncate pedvendad;
truncate pendest;
truncate pendfin;
truncate rascunhos;
truncate recmerc;
truncate recnfe;
truncate regrasneg;
truncate regforn;
truncate regrastxadm;
truncate resdpto;
truncate resdptodia;
truncate saldosger;
truncate saldosbco;
truncate saldoscon;
truncate seqmapa;
truncate susplcto;
truncate tabforn;
truncate vdonlinefi;
truncate vdonlineprod;
truncate xmlnfe;

/*
    Realiza uma consulta dos nomes das tabelas criadas pelo flexdb para cada mês e
    efetua um truncate para limpar os registros de cada uma.
*/
do $$
    declare
        vTabelas record;
    begin
        for vTabelas in
            select relname
            from pg_class
            where
                relname like any (array['movprodd%', 'invfisc%', 'vdadet%', 'ra%'])
                and relkind='r'
            order by relname
        loop
            perform format('truncate %I;', vTabelas.relname);
            raise notice 'truncate %; realizado', vTabelas.relname;
        end loop;
    end
$$ language plpgsql;

commit;
