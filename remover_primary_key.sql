/*
  Script utilizado para remover primary key de todas as tabelas do schema public e coluna id.

  OBS: Algumas vezes ocorre de acidentalmente atualizar a estrutura do WRpdv ativando a opção de replicação
  e ser criadas chaves primárias em todas as tabelas do database. 
  O problema disso é que numa próxima vez em que a estrutura é atualizada e são recriados os índices o WRpdv
  retorna erro e não consegue concluir o processo, sendo necessária a exclusão da primary key e da coluna id.
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
   
  raise notice 'Removendo coluna id da tabela %...', linhas.tabela;
  execute format('alter table %I drop column id;', linhas.tabela);
  raise notice 'Coluna id removida da tabela %.', linhas.tabela;
end loop;

raise notice 'Script finalizado';

end;
$$ language plpgsql;