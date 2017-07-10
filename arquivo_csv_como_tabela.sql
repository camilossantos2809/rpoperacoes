/* ===============================================================================================================
  file_fdw
  Extensão utilizada para criar tabelas externas no PostgreSQL com base em um arquivo de texto .csv
  Caso ainda não esteja instalado utilizar o comando: CREATE EXTENSION file_fdw;
*/

--Cria o servidor. 
--O mesmo servidor pode ser utilizado para vários arquivos, ele é responsável
--por ligar a foreign table com o fdw
create server teste_file foreign data wrapper file_fdw;

--Cria a tabela com base no arquivo de texto. As opções são semelhantes às utilizadas no comando COPY
create foreign table teste_file (
  codigo integer,
  descricao text,
  barras varchar(14),
) server teste_file
options (
  filename '/home/camilo/teste_fdw.txt', --local onde o arquivo está salvo
  delimiter '|', --separador das colunas
  header 'true', --indica se o arquivo possui colunas de título ou não
  format 'csv');

--Exemplo de como alterar algum atributo no argumento OPTIONS
ALTER FOREIGN TABLE public.teste_file OPTIONS (SET filename '/home/camilo/teste_fdw.txt',set delimiter '|');

--Exemplo de como deletar uma foreign table
drop foreign table teste_file;

--Utilização. Irá funcionar como uma tabela qualquer do postgresql, porém, somente leitura.
select * from teste_file;