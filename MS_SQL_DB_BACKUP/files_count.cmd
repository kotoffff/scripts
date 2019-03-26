@echo off

:: Get amount of databases which are backuped
SET TMP_DB_COUNT_FILE="C:\some_path\some_file.tmp"
SET MSSQL_USER="your_user"
SET MSSQL_USER_PASS="your_pass"
SET COUNT_SQL_DB_SCRIPT="C:\some_path\ms_sql_DB_list_getting.sql"
sqlcmd -U %MSSQL_USER% -P %MSSQL_USER_PASS% -i %COUNT_SQL_DB_SCRIPT% | find /v /c "" > %TMP_DB_COUNT_FILE%
SET /p DB_COUNT= < %TMP_DB_COUNT_FILE%
:: Set +1 to DB_COUNT because backup.txt file exists in %BACKUP_FOLDER% in my case
SET /a DB_COUNT= %DB_COUNT% + 1
)
del %TMP_DB_COUNT_FILE%


:: Count amount of files in selected dir where SQL bases backups are stored and compare with amount of bases from MS SQL server. If it isn't equal - exit with error code = 5
set BACKUP_FOLDER="C:\some path\backup"
set RESULT=0
FOR /F %%I in ('dir /B %FOLDER%') do @set /a RESULT= RESULT + 1
IF %RESULT% == %DB_COUNT% ( 
    echo "All MS SQL databases are successfully backuped in %FOLDER%"
    exit /b 0 
) ELSE ( 
    echo "Check that all MS SQL databases are successfully backuped in %FOLDER% !!"
    exit /b 5 )