#!/bin/bash

# A execução do script pode ser agendada no crontab. Para editá-lo use o comando crontab -e
# Adicionando uma linha ao arquivo conforme o exemplo abaixo o backup será realizado todos os dias às 23:00
# 0 23 * * * /home/meu-usuario/rpoperacoes/script/./backup_postgres.sh

# Altere os valores das variáveis abaixo conforme sua estrutura
DATABASE_IP='127.0.0.1'
DATABASE_PORTA='5432'
DATABASE_USUARIO='postgres'
DATABASE_SENHA='rp1064'
DATABASE_NOME='stackoverflow'
DIRETORIO_ARQUIVO_BACKUP='/home/camilo/Documentos/rp/backup/stackoverflow/' #informar a barra (/) no final
NOME_ARQUIVO_BACKUP='bkp_erp'
DIRETORIO_NOME_ARQUIVO_BACKUP=$DIRETORIO_ARQUIVO_BACKUP$NOME_ARQUIVO_BACKUP'_'`date +%Y%m%d_%H%M%S`.bkp
DIRETORIO_NOME_ARQUIVO_LOG=$DIRETORIO_ARQUIVO_BACKUP$NOME_ARQUIVO_BACKUP'_'`date +%Y%m%d_%H%M%S`.log

echo "Iniciando backup"
echo "Iniciando backup" >> $DIRETORIO_NOME_ARQUIVO_LOG

# Altera o arquivo .pgpass com os dados da conexão para não ser necessário informar a senha no bash
echo "Criando arquivo .pgpass em ~/.pgpass para usuário " `whoami` >> $DIRETORIO_NOME_ARQUIVO_LOG
echo $DATABASE_IP:$DATABASE_PORTA:$DATABASE_NOME:$DATABASE_USUARIO:$DATABASE_SENHA > ~/.pgpass
echo "Alterando as permissões do arquivo .pgpass" >> $DIRETORIO_NOME_ARQUIVO_LOG
chmod 0600 ~/.pgpass

echo "Iniciando execução do pg_dump" >> $DIRETORIO_NOME_ARQUIVO_LOG
# Executa o dump do banco de dados para o arquivo informado na variável utilizando o pg_dump
pg_dump -v -h $DATABASE_IP -p $DATABASE_PORTA -U $DATABASE_USUARIO --no-password \
    -Fc -n public -f $DIRETORIO_NOME_ARQUIVO_BACKUP $DATABASE_NOME 2>> $DIRETORIO_NOME_ARQUIVO_LOG
echo "Execução do pg_dump finalizada" >> $DIRETORIO_NOME_ARQUIVO_LOG

echo "Atribuindo permissões para o arquivo de backup e arquivo de log" >> $DIRETORIO_NOME_ARQUIVO_LOG
chmod 777 $DIRETORIO_NOME_ARQUIVO_BACKUP
chmod 777 $DIRETORIO_NOME_ARQUIVO_LOG

echo "Script finalizado!"
echo "Script finalizado" >> $DIRETORIO_NOME_ARQUIVO_LOG