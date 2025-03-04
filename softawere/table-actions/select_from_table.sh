#!/usr/bin/bash

echo "Select table."

# List available tables
tables=$(ls ../../databases/$dbname | grep -v '_metadata')
select tablename in $tables; do
    if [ -n "$tablename" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

if ! [ -f ../../databases/$dbname/$tablename ]; then
    echo "Table '$tablename' does not exist. Please create the table first."
    exit 1
fi

metadata_file="../../databases/$dbname/${tablename}_metadata"
table_file="../../databases/$dbname/$tablename"

# Get all column names
column_names=$(awk -F '|' '{print $1}' "$metadata_file" | tr '\n' ' ')
num_columns=$(awk 'END{print NR}' "$metadata_file")

# Prompt user to select a column
echo "Select the column name to select (or * for all columns):"
select column_name in $column_names "*"; do
    if [ -n "$column_name" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Function to format and display the table
format_table() {
    awk -F '|' -v cols="$column_names" -v num="$num_columns" '
    BEGIN {
        split(cols, headers, " ")
        for (i=1; i<=num; i++) {
            printf "%-20s", headers[i]
        }
        print "\n" sprintf("%s", str_repeat("-", num * 20))
    }
    {
        for (i=1; i<=num; i++) {
            printf "%-20s", $i
        }
        print ""
    }
    END {
        print sprintf("%s", str_repeat("-", num * 20))
    }
    function str_repeat(s, n) {
        res = ""
        for (i = 0; i < n; i++) res = res s
        return res
    }' "$1"
}

# Display the table
if [ "$column_name" == "*" ]; then
    format_table "$table_file"
else
    col_num=$(awk -F '|' -v col="$column_name" '{if ($1 == col) print NR}' "$metadata_file")

    if [ -z "$col_num" ]; then
        echo "Error: Column '$column_name' not found."
        exit 1
    fi

    awk -F '|' -v col="$col_num" '
    BEGIN { printf "\n%-20s\n------------------\n", "Column Data" }
    { printf "%-20s\n", $col }
    END { print "------------------" }' "$table_file"
fi