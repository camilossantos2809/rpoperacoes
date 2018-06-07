# Para executar os procedimentos desse script é necessário que o docker já esteja instalado no host
# https://docs.docker.com/install/

# Executar os comandos aqui descritos logado como super-usuário

# Obter a imagem docker oficial do mssql server 2017
# https://docs.microsoft.com/pt-br/sql/linux/quickstart-install-connect-docker?view=sql-server-linux-2017
docker pull microsoft/mssql-server-linux:2017-latest


# Execução da imagem de contêiner
NOME_CONTEINER=sqlserver
DIRETORIO_ARQUIVOS_HOST=/home/mssql
PORTA_HOST=1433
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=123456ABC!@#' \
   -p 1433:$PORTA_HOST --name $NOME_CONTEINER \
   -v $DIRETORIO_ARQUIVOS_HOST:/var/opt/mssql --memory-swap=0 \
   -d microsoft/mssql-server-linux:2017-latest

# Inicialização do serviço do contêiner
docker start $NOME_CONTEINER
