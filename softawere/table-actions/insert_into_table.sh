#!/usr/bin/bash

echo "Insert into a table selected."

echo -e "Table Name: \c"
read tablename

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
    echo -e "$idColName ($idColType): \c"
    read idData
    row="$idData$sep"
fi

for (( i = 2; i <= $colsNum; i++ )); do
    colName=$(awk -F '|' 'NR=='$i' {print $1}' ../../databases/$dbname/${tablename}_metadata)
    colType=$(awk -F '|' 'NR=='$i' {print $2}' ../../databases/$dbname/${tablename}_metadata)

    echo -e "$colName ($colType): \c"
    read data

    if [[ "$colType" == "int" ]]; then
        while ! [[ "$data" =~ ^[0-9]+$ ]]; do
            echo "Invalid data type! Must be an integer."
            echo -e "$colName ($colType): \c"
            read data
        done
    fi

    row+="$data$sep"
done

echo -e "${row::-1}$rSep" >> ../../databases/$dbname/$tablename

echo "Row inserted successfully!"
