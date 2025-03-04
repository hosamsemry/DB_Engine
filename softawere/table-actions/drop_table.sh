#!/usr/bin/bash

# Get a list of tables
tables=($(ls | grep -v '_metadata'))

# Check if there are any tables to drop
if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables available to drop."
    exit 1
fi

# Prompt the user to select a table to drop
PS3="Enter the number of the table you want to drop: "
select tablename in "${tables[@]}"; do
    if [[ -n "$tablename" ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

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