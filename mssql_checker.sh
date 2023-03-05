#!/bin/bash

echo "What is the database name?"
read database

for i in {1..20};
do
    # Check if Database already exists
    RESULT=`sqlcmd -U <Username> -P <Password> -S localhost -C -Q "IF DB_ID('$database') IS NOT NULL print 'YES'"`
    CODE=$?

    if [[ $RESULT == "YES" ]]
    then
        echo "Congrats the database with the name $database exists and is online!"
        break

    elif [[ $CODE -eq 0 ]] && [[ $RESULT == "" ]]
    then
        echo "If this comes up, $database doesn't exist."
        sleep 1
        echo "Here is a list of all the available databases"
        sleep 1
        sqlcmd -U <Username> -P <Password> -S localhost -C -Q "sp_databases"
        break

    # If the code is different than 0, an error occured. (most likely database wasn't online) Retry.
    else
        echo "Database not ready yet..."
        sleep 1
    fi
done
