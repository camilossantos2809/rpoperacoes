@echo off
REM ################################################
REM *** DEFINE O IP DA BASE E PORTA DE CONEXAO (PADRAO 5432)                                            
SET IPBASE=127.0.0.1
SET PORTA=5432
REM ################################################
REM *** DEFINE O NOME DA BASE A SER FEITO O BACKUP                                                
SET BASE=erp
REM ################################################
REM *** NOME DO ARQUIVO A SER SALVO APOS BACKUP            
SET NOME_ARQUIVO=bkp_erp
REM ################################################
REM *** DIRET�RIO ONDE SER� SALVO O BACKUP 
REM *** Não inclua a '\' no final do caminho.
SET CAMINHO=D:
REM ################################################
REM *** LOCALIZA��O DO PGDUMP
SET LOCPGDUMP=C:\Program Files\PostgreSQL\9.6\bin\pg_dump.exe
REM SET LOCPGDUMP=C:\PostgreSQL\pg10\bin\pg_dump.exe
REM ################################################
REM *** USU�RIO E SENHA (DO POSTGRESQL) DE QUEM IR� FAZER O BACKUP.
SET USUARIO=postgres
SET SENHA=postgres
REM ################################################
REM *** TIPO DE COMPRESS�O DO BACKUP (custom, tar e plain)
SET FORMATO=custom
REM ################################################

FOR /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') DO Set _DTS=%%a
Set _datetime=%_DTS:~0,4%-%_DTS:~4,2%-%_DTS:~6,2%@%_DTS:~8,2%-%_DTS:~10,2%-%_DTS:~12,2%

set BACKUP_FILE=%NOME_ARQUIVO%_%_datetime%.backup
REM set BACKUP_FILE=teste111.backup
echo backup file name is %BACKUP_FILE%
SET PGUSER=%USUARIO%
SET PGPASSWORD=%SENHA%
echo on
"%LOCPGDUMP%" --host %IPBASE% --port %PORTA% --username "%USUARIO%" --no-password --format %FORMATO% --blobs --verbose --file "%CAMINHO%\%BACKUP_FILE%" %BASE%

if exist "%CAMINHO%\%BACKUP_FILE%" (
    @echo *******************************************
    @echo BACKUP REALIZADO COM SUCESSO !
    @echo *******************************************
    @echo.
) else (
    @echo *******************************************
    @echo ATENÇAO: ERRO NA CRIACAO DO BACKUP !
    @echo *******************************************
    @echo.
    PAUSE
)
