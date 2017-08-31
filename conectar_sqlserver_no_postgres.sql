/*
    tds_fdw (https://github.com/tds-fdw/tds_fdw)
    Extensão utilizada para conectar um bancos de dados MSSQLServer no PostgreSQL.

    Trata-se de um módulo de terceiros que utiliza o recurso de Foreign Data Wrapper (FDW) para conectar
    a uma base de dados MSSQLServer e poder consultar os registros das tabelas.

    Obs:
        - Exemplos criados utilizando versão 9.6 do postgres e sistema operacional Debian.
    
    O tds_fdw requer uma biblioteca que implemente a interface DB-Library, como FreeTDS.
    Para Debian e derivados é necessário executar os comandos abaixo:
        sudo apt-get install libsybdb5 freetds-dev freetds-common
    
    Também é necessário efetuar o download do tds_fdw no repositório e executar a instalação conforme abaixo
        wget https://github.com/tds-fdw/tds_fdw/archive/v1.0.8.tar.gz
        tar -xvzf tds_fdw-1.0.7.tar.gz
        cd tds_fdw-1.0.7
        make USE_PGXS=1
        sudo make USE_PGXS=1 install
*/

--Adicionar extensão ao database caso ainda não esteja criada
create extension if not exists tds_fdw;

/*
  Criar servidor com os dados de conexão ao database externo
  Nesse exemplo é configurada uma conexão com o database DBIrmaosRibeiro e o nome do servidor como irmaos_ribeiro
*/
create server irmaos_ribeiro
  foreign data wrapper tds_fdw
  options(
    servername '10.1.12.86',
    port '1433',
    database 'DBIrmaosRibeiro',
    msg_handler 'notice'
  );

/*
  Realizar mapeamento entre usuários da base de dados externa com a base local
  No exemplo está sendo realizado um mapeamento do usuário camilo ao usuário postgres. 
*/
create user mapping for postgres server irmaos_ribeiro options(username 'camilo', password 'rp1064');

/*
  Criar schema separado para as tabelas externas.
  Esse passo é opcional, porém, deixa o database mais organizado pois deixaria as tabelas externas separadas
  das tabelas utilizadas pelo sistema.
*/
create schema if not exists migracao;

/*
    Utilizar o comando CREATE FOREIGN TABLE para vincular as tabelas ou comandos SQL entre as bases de dados
*/
create foreign table migracao.produto(
    id_produto text,
    id_produto_master text,
    descricao text,
    ativo varchar(1),
    id_grupo text,
    id_unidade text,
    id_emb text,
    id_familia text,
    dtcadastro date,
    bloqueado varchar(1)
)
server irmaos_ribeiro
options (
    query $$select 
            idproduto,idprodutomaster,nmproduto,stativo,idgrupoproduto,idunidade,
            idunidadeembalagem,idfamiliaproduto,dtcadastro,stativocompra
        from produto$$,
    row_estimate_method 'showplan_all'
);

--Após a vinculação a tabela pode ser utilizada normalmente conforme abaixo
select *
from migracao.produto
limit 10;
