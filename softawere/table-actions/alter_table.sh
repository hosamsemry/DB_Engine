#!/usr/bin/bash
# Logic to alter the table
echo "Enter the database name: "
read dbname
dbpath="../../databases/$dbname"

# Check if database exists
if [ ! -d "$dbpath" ]; then
    echo "Database '$dbname' does not exist."
    exit 1
fi

echo "Enter the table name: "
read tablename
table_metadata="$dbpath/${tablename}_metadata"

# Check if table exists
if [ ! -f "$table_metadata" ]; then
    echo "Table '$tablename' does not exist."
    exit 1
fi

echo "Do you want to alter the table? (y/n)"
read alter

if [ "$alter" == "y" ]; then
     echo "Enter the column name to alter: "
     read colName

     # Check if column exists
     if ! grep -wq "$colName" "$table_metadata"; then
          echo "Column '$colName' does not exist."
          exit 1
     fi

     echo "Enter the new column name: "
     read newColName
     echo "Enter the new column type: "
     read newColType

     # Modify the column name and type
     awk -F '|' -v col="$colName" -v newColName="$newColName" -v newColType="$newColType" '
     BEGIN {OFS=FS}
     {
         for (i=1; i<=NF; i++) {
             split($i, field, " ")
             if (field[1] == col) {
                 $i = newColName "|" newColType
             }
         }
         print
     }' "$table_metadata" > "$dbpath/${tablename}_metadata.temp" && mv "$dbpath/${tablename}_metadata.temp" "$table_metadata"

     echo "Table altered successfully."
fi
