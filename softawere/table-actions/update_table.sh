#!/usr/bin/bash
echo "Update a table selected."
# Update logic
echo "Enter the database name: "
read dbname
echo "Enter the table name: "
read tablename
if ! [ -f ../../databases/$dbname/$tablename ]; then
     echo "Table '$tablename' does not exist."
     return
fi

echo "Enter the column name to update: "
read colName
echo "Enter the old value: "
read oldVal
echo "Enter the new value: "
read newVal

# Check if the column exists
header=$(head -n 1 ../../databases/$dbname/$tablename)
if ! echo "$header" | grep -q "$colName"; then
     echo "Column '$colName' does not exist."
     return
fi

# Get the column index
colIndex=$(echo "$header" | tr ',' '\n' | grep -n "^$colName$" | cut -d: -f1)

# Update the data in the specified column
awk -F, -v col="$colIndex" -v old="$oldVal" -v new="$newVal" 'BEGIN {OFS=FS} NR==1 {print $0} NR>1 {if ($col == old) $col = new; print $0}' ../../databases/$dbname/$tablename > temp && mv temp ../../databases/$dbname/$tablename

echo "Data updated successfully."

# Verify if the update was successful
if grep -q "$newVal" ../../databases/$dbname/$tablename; then
     echo "Update verified successfully."
else
     echo "Update failed."
fi