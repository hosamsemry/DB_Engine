#!/usr/bin/bash

echo "Delete from a table selected."
#delete logic
echo -e "Table Name: \c"
read tablename
if ! [ -f ../../databases/$dbname/$tablename ]; then
     echo "Table '$tablename' does not exist. Please create the table first."
     break
fi 
# echo "Enter the value to delete: "
# read value
# sed -i "/$value/d" ../../databases/$dbname/$tablename
# echo "Data deleted successfully."

Verify if the delete was successful

# logic to delete data from the table by column value
echo "Enter the column name to delete by: "
read colName
echo "Enter the value to delete: "
read value
if ! grep -q "$colName" ../../databases/$dbname/${tablename}_metadata; then
    echo "Column '$colName' does not exist."
    break
fi
awk -F '|' -v col="$colName" -v val="$value" 'BEGIN {OFS=FS} NR==1 {print $0} NR>1 {if ($col != val) print $0}' ../../databases/$dbname/$tablename > temp && mv temp ../../databases/$dbname/$tablename
echo "Data deleted successfully."

# echo 
