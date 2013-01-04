# MySQL Database Loader Scripts

## Shell scripts for loading and dumping MySQL databases easily.

### INSTRUCTIONS FOR DUMPER
+ Configure the variables as required. The MySQL server, user, and password are needed.
+ Place the dump script in the folder you want your DB dump to be and run the script.

### INSTRUCTIONS FOR LOADER
+ Configure the variables as required. The MySQL server, user, and password are needed.
+ Configure the prompt variable if you want to be asked the database file and the database name upon execution.  Useful for multiple DB loading.
+ Place your database file in .gz format alongside this script and execute the script to import your DB.  You could first run the dumper to get a .gz file that can be loaded.

Your DB will be cleared out (not dropped) if it exists and re-loaded from the file. If the DB does not exist it will be created first and then loaded.