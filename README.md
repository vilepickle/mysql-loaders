# MySQL Database Loader Scripts

## Shell scripts for loading and dumping MySQL databases easily.

### INSTRUCTIONS
+ Configure the variables as required. The MySQL server, user, and password are required.
+ Configure the prompt variable if you want to be asked the database file and the database name upon execution.  Useful for multiple DB loading.
+ Place your database file in .gz format alongside this script and execute the script to import your DB.

Your DB will be cleared out (not dropped) if it exists and re-loaded from the file. If the DB does not exist it will be created first and then loaded.