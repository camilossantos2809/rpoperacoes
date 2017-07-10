/* 
  file_fdw (https://www.postgresql.org/docs/current/static/file-fdw.html)
  Extensão utilizada para criar tabelas externas no PostgreSQL com base em um arquivo de texto.
  
  É uma boa alternativa em relação ao documento IMP, visto que o arquivo uma vez mapeado no banco
  pode ser utilizado como uma tabela, portanto, todos os comandos SQL de leitura seriam compatíveis.
  Também a leitura é mais rápida, visto que são utilizados os mesmos algoritmos de leitura das tabelas.

  Obs: Foram realizados os comandos abaixo utilizando a versão 9.6 do postgres.
*/

/*
  Criar a extensão file_fdw no database, caso ainda não exista.
*/
create extension if not exists file_fdw;

/*
  Criar servidor.
  O mesmo servidor pode ser utilizado para vários arquivos e foreign table.
*/
create server files foreign data wrapper file_fdw;

/*
  Criar tabela estrangeira com base no arquivo de texto. As opções são semelhantes às utilizadas no comando COPY

  O arquivo de texto precisa estar em uma pasta no servidor em que o usuário postgres possua permissão de acesso.
*/
create foreign table prod_importar (
  codigo integer,
  descricao text,
  barras varchar(14),
) 
server arquivos
options (
  filename '/tmp/prod_importar.csv', --local onde o arquivo está salvo.
  delimiter ';', --separador das colunas
  header 'true', --indica se o arquivo possui colunas de título ou não
  format 'csv'
);

/*
  Se for necessário alterar algo nas opções de vinculação do arquivo texto, pode-se utilizar o comando
  ALTER FOREIGN TABLE conforme exemplo abaixo.
*/
ALTER FOREIGN TABLE public.prod_importar 
OPTIONS (
  SET filename '/tmp/prod_importar2.csv',
  set delimiter '|'
);

/*
  Após a vinculação a foreign table irá funcionar como uma tabela qualquer do postgresql, porém, somente leitura.

  No exemplo abaixo está sendo realizada uma consulta na tabela referente ao arquivo texto fazendo um relacionamento
  com a tabela produtos utilizada pelo FlexDB.
*/
select 
  teste_file.*,
  prod_codigo,
  prod_descricao
from prod_importar
  inner join produtos
    on (barras=prod_codbarras)
limit 100;
