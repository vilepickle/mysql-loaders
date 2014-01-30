#############################################################################################
# MySQL Database Loader Scripts
#
# By David Lohmeyer
# vilepickle@gmail.com
# Vilepickle.com
# 1/4/13
# Version 1.1 (1/30/2014)
#
#############################################################################################
#
# INSTRUCTIONS
# Configure the variables below as required. The MySQL server, user, and password are required.
# Configure the prompt variable if you want to be asked the database file and the database
# name upon execution.  Useful for multiple DB loading.
#
# Place your database file in .gz format alongside this script and execute the script
# to import your DB.
#
# Your DB will be cleared out (not dropped) if it exists and re-loaded from the file.
# If the DB does not exist it will be created first and then loaded.
#
#############################################################################################

# Define your server variables for MySQL.

SERVER="localhost"
USER="username"
PW="password"

#############################################################################################
# If PROMPT is set to 1, the script will ask for DBFILENAME in .gz format
# and also DATABASE values.  If 0, change those two variables below.
PROMPT=0

# If COMPRESS is set to 1, DBFILENAME expects a .gz extension.
# If COMPRESS is 0, DBFILENAME should have a .sql extension.
COMPRESS=1

DBFILENAME="database.gz"
DATABASE="database_name"

#############################################################################################
# No need to edit below this line.

if [ $PROMPT = 1 ]
	then
		echo -n "Enter the database .gz file relative to this script ..."
		read -e DBFILENAME
		if [ -s $DBFILENAME ]
			then
				echo "File does exist, proceeding ..."
			else
				echo "File does not exist!"
				exit 1
		fi

		echo -n "Enter the name of your database ..."
		read -e DATABASE
fi
if [ -s $DBFILENAME ]
	then
		# Check to see if database exists
		DBS=`mysql -u$USER -p$PW -h $SERVER -Bse 'show databases'| egrep -v 'information_schema|mysql'`
		FOUNDDB=0
		for db in $DBS; do
			if [ $db = $DATABASE ]
				then
					# Remove the existing database in favor of the new file.
					# Instead of dropping the DB itself, iterate through
					# the tables and remove them
					# Thanks http://www.thingy-ma-jig.co.uk/blog/10-10-2006/mysql-drop-all-tables for the tip
					FOUNDDB=1
				 	echo "Found the database '$DATABASE', proceeding with removal..."
				 	mysqldump -u$USER -p$PW -h $SERVER --add-drop-table --no-data $DATABASE | grep ^DROP | mysql -u$USER -p$PW -h $SERVER $DATABASE
			fi
		done
		if [ $FOUNDDB = 0 ]
			then
				# Create a new database
				echo "Didn't find the database, creating '$DATABASE'..."
				mysqladmin -u$USER -p$PW -h $SERVER create $DATABASE
		fi
	else
		echo 'Database import file does not exist, exiting...'
		exit 1
fi

# Load the DB
echo "Importing new database from file '$DBFILENAME'..."
if [ $COMPRESS = 1 ]
	then
		echo 'Importing from a compressed .gz file...'
		gzip -d $DBFILENAME
		mysql -u $USER -p$PW -h $SERVER $DATABASE < $DATABASE
		gzip $DATABASE
	else
		echo 'Importing from a .sql file...'
		mysql -u $USER -p$PW -h $SERVER $DATABASE < $DBFILENAME
fi