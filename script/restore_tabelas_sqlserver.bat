@echo off

REM Restaurar uma base de dados via script (*.sql) no SQLSERVER
SET IP_BD=127.0.0.1
SET USUARIO_BD=sa
SET SENHA_BD=123456AsD!@#
SET DIRETORIO_ARQUIVO_BACKUP=/home/user/backup.sql
SET DIRETORIO_ARQUIVO_LOG=/home/user/log.txt

sqlcmd -S %IP_BD% -U %USUARIO_BD% -P %SENHA_BD% -i %DIRETORIO_ARQUIVO_BACKUP% -o %DIRETORIO_ARQUIVO_LOG% -p
