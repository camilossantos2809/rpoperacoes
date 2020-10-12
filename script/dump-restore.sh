# Exemplos de utilização do pg_dump, pg_restore e psql para carga de dados e restauração

# Backup/Restore utilizando paralelismo (método mais ágil)
# Caso ocorra algum erro referente a usuário inexistente ou sem permissão utilizar --no-owner para assumir o usuário informado no script
pg_dump -h ip -U usuario -v -F d -j 4 -f caminho/arquivo.bkp databasename
pg_restore -h ip -U usuario -v -F d -j 4 -d databasename camilo/arquivo.bkp

# Backup/Restore "compactado"
pg_dump -v -h ip -p porta -U usuario -Fc -f "caminho/nomedoarquivo" "bancodedados"
pg_restore -v -h ip -p porta -U usuario -d "bancodedados"  "caminho\nomedoarquivo"

# Backup/Restore "MODO TEXTO"
pg_dump -h ip -U usuario -v bancodedados > caminho/nomedoarquivo #-t tabela (somente as tabelas definidas) -T tabela (exceto as tabelas definidas)
psql -h ip -U usuario -v -d bancodedados < caminho/nomedoarquivo

# Backup/Restore de todas as bases de dados do cluster
pg_dumpall -v -h ip -p porta -d template1 -U postgres -f /home/camilo/Documentos/backup/9.5.backup
psql -v -U postgres -h ip -p 5433 -d template1 < /home/camilo/Documentos/backup/9.5.backup

# Criação de usuários utilizados pelos aplicativos da RP
# Usuário utilizado pelo FlexDB
psql -h ip -U usuario -d bancodedados -c "CREATE ROLE erp LOGIN
  ENCRYPTED PASSWORD 'md518bece2cf526c5de3e3208516719fa29'
  SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;"

# Usuário utilizado pelo WRpdv
psql -h ip -U usuario -d bancodedados -c "CREATE ROLE rpdv LOGIN
  ENCRYPTED PASSWORD 'md5336b5a9e57865b05f53d4f6fcb21959f'
  SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;"

# Usuário utilizado pelo Nota Paulista
psql -h ip -U usuario -d bancodedados -c "CREATE ROLE ntpaulista LOGIN
  ENCRYPTED PASSWORD 'md5f42471fc3f43b6217dac7999ab9d4d0b'
  SUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION;"

# Criação de database utilizando executável do postgres
createdb erp_cliente -E latin1 --lc-ctype C --lc-collate C -T template0

# Atualização de clusters (versão)
# Após instalação da versão nova é necessário parar os serviços do postgres para executar o pg_upgrade
# É necessário estar logado com o usuário postgres no terminal
# Verificar espaço em disco e configurações do diretório "data" antes de executar o script
# https://www.postgresql.org/docs/13/pgupgrade.html
/usr/lib/postgresql/13/bin/pg_upgrade \
  -b /usr/lib/postgresql/12/bin -B /usr/lib/postgresql/13/bin \
  -d /home/postgres/12/main/ -D /home/postgres/13/main \
  -p 5432 -P 5433 \
  -o '-c config_file=/etc/postgresql/12/main/postgresql.conf' -O '-c config_file=/etc/postgresql/13/main/postgresql.conf' \
  -j 4
