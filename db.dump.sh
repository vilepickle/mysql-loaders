#############################################################################################
# MySQL Database Dump Script
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
# Configure the variables below.
# Place this in a directory where you want your database dump to be output and execute
# the script.
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
		echo -n "Enter the database .gz file you wish to output..."
		read -e DBFILENAME
		if [ -s $DBFILENAME ]
			then
				echo "File elready exists. Are you sure? (y/n)"
				read -e EXISTS
				if [ "$EXISTS" = "y" ]
					then
						echo "Proceeding"
					else
						exit 1
				fi
			else
				echo "File doesn't exist.  Proceeding."
		fi

		echo -n "Enter the name of your database..."
		read -e DATABASE

		# Check to see if database exists
		DBS=`mysql -u$USER -p$PW -h $SERVER -Bse 'show databases'| egrep -v 'information_schema|mysql'`
		FOUNDDB=0
		for db in $DBS; do
			if [ $db = $DATABASE ]
				then
					FOUNDDB=1
				 	echo "Found the database '$DATABASE', proceeding with dump..."
			fi
		done
		if [ $FOUNDDB = 0 ]
			then
				# Create a new database
				echo "Didn't find the database, exiting..."
				exit 1
		fi
fi

# File cleanup
if [ -s $DBFILENAME ]
	then
		rm $DBFILENAME
fi

if [ $COMPRESS = 1 ]
	then
		EXTRACTEDFILE=$(echo $DBFILENAME | sed "s/\..*$//")
		if [ -s $EXTRACTEDFILE ]
			then
				rm $EXTRACTEDFILE
		fi
		# Dump the database
		mysqldump -u $USER -p$PW -h $SERVER $DATABASE --result-file=$EXTRACTEDFILE

		#GZip the file
		gzip -9 --force $EXTRACTEDFILE > $DBFILENAME
	else
		# Dump the database
		mysqldump --opt -u $USER -p$PW -h $SERVER $DATABASE --result-file=$DBFILENAME
fi