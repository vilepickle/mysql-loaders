#############################################################################################
# MySQL Database Dump Script
#
# By David Lohmeyer
# vilepickle@gmail.com
# Vilepickle.com
# 1/4/13
# Version 1.0
#
#############################################################################################
#
# INSTRUCTIONS
# Configure the variables below.
# Place this in a directory where you want your database dump to be output and execute
# the script.
#
#############################################################################################
#
# Copyright (c) 2013 David Lohmeyer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
# the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#############################################################################################

# Define your server variables for MySQL.

SERVER="localhost"
USER="username"
PW="password"

#############################################################################################
# If PROMPT is set to 1, the script will ask for DB file
# and DB values.  If not, change the variables below.
PROMPT=0

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

EXTRACTEDFILE=$(echo $DBFILENAME | sed "s/\..*$//")
if [ -s $EXTRACTEDFILE ]
	then
		rm $EXTRACTEDFILE
fi

# Dump the database
mysqldump -u $USER -p$PW -h $SERVER $DATABASE | gzip -9 > $DBFILENAME