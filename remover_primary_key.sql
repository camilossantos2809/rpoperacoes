/*
    Script utilizado para remover primary key de todas as tabelas do schema public.
*/

do $$
declare
  linhas record;
begin

raise notice 'Iniciando script para remoção de primary key de tabelas no schema public';

for linhas in
  select 
    conname, -- nome da primary key
    conrelid::regclass as tabela -- nome da tabela
  from pg_constraint 
  where contype = 'p' -- filtro para retornar somente primary key
    and connamespace = 'public'::regnamespace -- filtro para considerar somente as tabelas do schema public
loop
   raise notice 'Removendo primary key % da tabela %...', linhas.conname, linhas.tabela;
   execute format('alter table %I drop constraint %I;', linhas.tabela, linhas.conname);
   raise notice 'Primary key % da tabela % removida.', linhas.conname, linhas.tabela;
end loop;

raise notice 'Script finalizado';

end;
$$ language plpgsql;