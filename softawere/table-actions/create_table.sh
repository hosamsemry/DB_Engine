#!/usr/bin/bash

cd ../../databases/dbname

echo "
    already existing tables are:
    "

ls -s ../../databases/$dbname

while true
do 
    echo "Enter the name of the table you want to create: "
    read tablename
    if [[ ! "$tablename" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid table name. Please use only letters, numbers, and underscores, and start with a letter or underscore."
    elif [ -f ../../databases/$dbname/$tablename ]; then
        echo "Table already exists. Please try again."
    else
        touch ../../databases/$dbname/$tablename
        echo "Table '$tablename' created successfully."
        break
    fi
done