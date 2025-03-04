#!/usr/bin/bash

read -p "Enter the name of the table you want to drop: " tablename

# Check if the table and its metadata file exist
if [[ -f "${tablename}" && -f "${tablename}_metadata" ]]; then
    rm "${tablename}" "${tablename}_metadata" 2>>./.error.log
    if [[ $? == 0 ]]; then
        echo "Table dropped successfully."
    else
        echo "Error dropping table $tablename."
    fi
else
    echo "Table $tablename does not exist."
fi