/*
  postgres_fdw (https://www.postgresql.org/docs/current/static/postgres-fdw.html)
  Extensão utilizada para conectar a bancos de dados PostgreSQL externos, em outro host ou num mesmo servidor.
  
  A funcionalidade fornecida por esse módulo é semelhante a do módulo dblink. Mas postgres_fdw fornece uma
  sintaxe mais transparente, é compatível com padrões para acessar tabelas remotas (FDW) e em muitos casos
  provê um desempenho melhor.

  Obs:
    - Exemplos criados utilizando versão 9.6 do postgres.
*/

--Adicionar extensão ao database caso ainda não esteja criada
create extension if not exists postgres_fdw;

/*
  Criar servidor com os dados de conexão ao database externo
  Nesse exemplo é configurada uma conexão com o database wrpdv, o nome do servidor também como wrpdv
*/
CREATE SERVER wrpdv FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', port '5432', dbname 'wrpdv');

/*
  Realizar mapeamento entre usuários da base de dados externa com a base local
  No exemplo está sendo realizado um mapeamento do usuário postgres. 
*/
create user mapping for postgres server wrpdv options(user 'postgres', password 'rp1064');

/*
  Criar schema separado para as tabelas externas.
  Esse passo é opcional, porém, deixa o database mais organizado pois deixaria as tabelas externas separadas
  das tabelas utilizadas pelo sistema.
*/
create schema if not exists wrpdv;

/*
  Importar estrutura das tabelas externas para o database atual.
  
  No exemplo são importadas as tabelas finalizadoras e estac do schema public no banco de dados externo
  para o schema wrpdv do database local.
*/
import foreign schema public limit to(
  finalizadoras, estac
)
from server wrpdv
into wrpdv;

/*
  O IMPORT FOREIGN SCHEMA só está disponível a partir da versão 9.5 do postgres, para as versões antigas é necessário
  utilizar o comando CREATE FOREIGN TABLE semelhante ao exemplo abaixo.
*/
create foreign table wrpdv.finalizadoras(
  fin_config numeric(3,0),
  fin_codigo numeric(2,0),
  fin_descricao varchar(20)
)
server wrpdv
options(
  schema_name 'public',
  table_name 'finalizadoras'
);

--Após a vinculação a tabela pode ser utilizada normalmente conforme abaixo
select *
from wrpdv.finalizadoras
limit 10;
