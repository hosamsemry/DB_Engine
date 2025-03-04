#!/usr/bin/bash

echo "Insert into a table selected."

# List available tables and prompt user to select one
tables=($(ls ../../databases/$dbname | grep -v '_metadata$'))
if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables found in the database. Please create a table first."
    exit 1
fi

echo "Select the table you want to insert into:"
select tablename in "${tables[@]}"; do
    if [[ -n "$tablename" ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

if ! [ -f ../../databases/$dbname/$tablename ]; then
    echo "Table '$tablename' does not exist. Please create the table first."
    exit 1
fi

row=""
rSep="\n"
sep="|"

colsNum=$(awk 'END{print NR}' ../../databases/$dbname/${tablename}_metadata)

# Get the first column (assumed ID)
idColName=$(awk -F '|' 'NR==1 {print $1}' ../../databases/$dbname/${tablename}_metadata)
idColType=$(awk -F '|' 'NR==1 {print $2}' ../../databases/$dbname/${tablename}_metadata)

# Check if it's an integer ID
if [[ "$idColType" == "int" ]]; then
    lastID=$(awk -F '|' 'END{print $1}' ../../databases/$dbname/$tablename)
    if [[ -z "$lastID" ]]; then
        newID=1
    else
        newID=$((lastID + 1))
    fi
    row="$newID$sep"
else
    while true; do
        echo -e "$idColName ($idColType): \c"
        read idData
        if [[ -z "$idData" ]] || ! [[ "$idData" =~ ^[0-9]+$ ]]; then
            echo "Invalid data! Must be a non-empty integer."
        elif grep -q "^$idData$sep" ../../databases/$dbname/$tablename; then
            echo "ID '$idData' already exists. Please use a unique ID."
        else
            break
        fi
    done

    row="$idData$sep"
fi

for (( i = 2; i <= $colsNum; i++ )); do
    colName=$(awk -F '|' 'NR=='$i' {print $1}' ../../databases/$dbname/${tablename}_metadata)
    colType=$(awk -F '|' 'NR=='$i' {print $2}' ../../databases/$dbname/${tablename}_metadata)

    echo -e "$colName ($colType): \c"
    read data

    if [[ "$colType" == "INT" ]]; then
        while ! [[ "$data" =~ ^[0-9]+$ ]]; do
            echo "Invalid data type! Must be an integer."
            echo -e "$colName ($colType): \c"
            read data
        done
    elif [[ "$colType" == "VARCHAR" ]]; then
        while [[ -z "$data" ]] || ! [[ "$data" =~ ^[a-zA-Z]+$ ]]; do
            echo "Invalid data! Must be non-empty and contain only letters."
            echo -e "$colName ($colType): \c"
            read data
        done
    else
        echo "Unknown column type '$colType'."
        exit 1
    fi

    row+="$data$sep"
done

echo -e "${row::-1}$rSep" >> ../../databases/$dbname/$tablename

echo "Row inserted successfully!"