Scripts for backup MS SQL databases and check that backup is completed successfully 
------------

Description
------------
* **backup_mssql_databases.ps1** creates backup for all MS SQL databases which are got from **ms_sql_DB_list_getting.sql** script
* **ms_sql_DB_list_getting.sql** selects list of all DBs from MS SQL server, you can exclude some DB, please see inside
* **files_count** checks amount of *.bak files inside backup dir and compares it with list of DBs - if it isn't equal prints error and exit with error code = 5

Usage
------------
* edit **ms_sql_DB_list_getting.sql** for DBs list which you need
* edit **backup_mssql_databases.ps1** for variables which are required
* run **backup_mssql_databases.ps1** and check that script works correctly
* if you need check that backup is completed successfully - edit **files_count.cmd** for variables which are required and run

Additional information
-------------

It's useful for use this scripts via [Bareos](https://www.bareos.org/) or other backup system - you can check that backup is completed successfully automatically.
Please find below example for Bareos:
```
  before job = "powershell.exe C:/some_path/backup_mssql_databases.ps1"
  client run after job = "C:/some_path/files_count.cmd"
```
