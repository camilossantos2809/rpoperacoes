/*
    Comandos para serem utilizados para remover a movimentação na base de dados antes da implantação

    Observações:
        - Em alguns casos onde na base de dados existem muitas tabelas geradas por mês (vdadet, movprodd, invfisc) a quantidade de
        locks geradas na transação pode ser maior que o default do postgres, gerando erro ao rodar os comandos.
        Para contornar esse problema deve ser aumentado o valor do parâmetro max_locks_per_transaction no postgresql.conf, ou executar
        os comandos sem isolar a transação (remover begin e commit).
*/

set client_encoding='latin1';

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
truncate conscadastronfe;
truncate consprotnfe;
truncate consultacte;
truncate consprotmdfe;
truncate consrecnfe;
truncate consultanfservico;
truncate dados2;
truncate errosimpautom;
truncate inutnfe;
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
truncate textos;
truncate vdonlinefi;
truncate vdonlineprod;
truncate xmlnfe;

/*
    Deleta formatos criados para relatórios e configurações de posicionamento de colunas nos grids
*/
delete from formatosrel
where usuario <> '9999';

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
                relname like any (array['movprodd%', 'invfisc%', 'vdadet%', 'ra__'])
                and relkind = 'r' 
                and reltuples > 0
            order by relname
        loop
            raise notice 'Iniciando limpeza da tabela % ...', vTabelas.relname;
            execute format('truncate %I;', vTabelas.relname);
            raise notice 'truncate %; realizado', vTabelas.relname;
        end loop;
    end
$$ language plpgsql;

commit;
