#!/usr/bin/bash

regex='^[a-zA-Z][a-zA-Z0-9_]*$'

while true; do
    echo "Enter the name of the database"
    read dbname

    if [[ $dbname =~ $regex ]]; then
        break
    else
        echo "Invalid. It should start with a letter and contain only alphanumeric characters and underscores."
    fi
done

if [ -d ../databases/$dbname ]; then
    echo "Database already exists"
else
    mkdir ../databases/$dbname
    echo "Database created successfully"
fi