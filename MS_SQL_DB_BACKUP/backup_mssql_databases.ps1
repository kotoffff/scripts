#credentials/parameteres
$MSSQL_USER = 'some ms sql user'
$MSSQL_USER_PASS = 'your_pass'
$MSSQL_GET_DB_LIST_SCRIPT = 'C:\some_path\ms_sql_DB_list_getting.sql'
$LOG_FILE = 'C:\some path\backup.txt'
$BACKUP_SQL_SCRIPT = 'C:\some path\backup.sql'
$BACKUP_DIR = "C:\some path\Backup\"
$DATE = (Get-Date).ToString('dd-MM-yyyy')
$BACKUP_FILE = $BACKUP_DIR+$DB_+$DATE

#delete old files
$FILES_FOR_REMOVING = $BACKUP_DIR + '*.*'
Remove-Item $FILES_FOR_REMOVING

#Get DB list
$DbListsArgs = @('-U', $MSSQL_USER, '-P', $MSSQL_USER_PASS, '-i', $MSSQL_GET_DB_LIST_SCRIPT)
$DB_LIST = & sqlcmd $DbListsArgs

#create backup
foreach ($DB in $DB_LIST) {
   Add-Content -Path $LOG_FILE -Value '-----------------------------------------'
   Add-Content -Path $LOG_FILE -Value '-----------------------------------------'
   Add-Content -Path $LOG_FILE -Value $DB
   $BACKUP_FILE = $BACKUP_DIR+$DB+'_'+$DATE+'.BAK'
   $BACKUP_NAME = $DB + '_full_backup'
   $TEMP_LOG_FILE = $BACKUP_DIR+$DB+'.txt'
   Add-Content -Path $BACKUP_SQL_SCRIPT -Value "DECLARE @DB VARCHAR(50)`nSET @DB = '$DB'`nBACKUP DATABASE @DB TO DISK = '$BACKUP_FILE' WITH FORMAT, INIT, CHECKSUM,  NAME = '$BACKUP_NAME', COMPRESSION, COPY_ONLY"
   $DbBackupArgs = @('-U', $MSSQL_USER, '-P', $MSSQL_USER_PASS, '-i', $BACKUP_SQL_SCRIPT, '-o', $TEMP_LOG_FILE)
   & sqlcmd $DbBackupArgs
   Get-Content -Path $TEMP_LOG_FILE | Add-Content -Path $LOG_FILE
   Remove-Item $TEMP_LOG_FILE
   Remove-Item $BACKUP_SQL_SCRIPT
 }
