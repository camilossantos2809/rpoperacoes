/**
* Remove opção "WITH OIDS" das tabelas.
* Essa opção foi removida a partir do postgres 12 e pode gerar erros na atualização.
*
* A depender da quantidade de registros nas tabelas pode ser necessário aumentar o valor do
* parâmetro max_locks_per_transaction no postgresql.conf.
* OBS: Alterar esse parâmetro requer reinicialização do serviço do postgres.
*/

set client_encoding = 'latin1';

do $$ 
declare
  tables record;
begin

for tables in
  select relname
  from pg_class
  where relhasoids
    and relnamespace not in ('11')
  order by relname
loop
  raise notice 'Removendo oid da tabela % ...', tables.relname;
  execute format('ALTER TABLE %I SET WITHOUT OIDS;', tables.relname);
  raise notice 'Removido oid da tabela % ', tables.relname;
end loop;

raise notice 'Removida opção WITH OIDS das tabelas!';

end
$$ language plpgsql;
