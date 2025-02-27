#!/usr/bin/bash

echo "Select the database you want to delete:"

databases=$(ls ../databases)

PS3="Please enter your choice: "
select dbname in ${databases[*]}
do
    if [ -n "$dbname" ]; then
        if [ -d ../databases/$dbname ]; 
        then
            rm -r ../databases/$dbname
            echo "Database deleted successfully"
        else
            echo "Database does not exist"
        fi
        break
    else
        echo "Invalid choice. Please try again."
    fi
done