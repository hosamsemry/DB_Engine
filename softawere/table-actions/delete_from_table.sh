#!/usr/bin/bash

# Ensure dbname is set
if [[ -z "$dbname" ]]; then
    echo "No database selected. Please connect to a database first."
    exit 1
fi

DB_PATH="../../databases/$dbname"

echo "Available tables in '$dbname':"
tables=($(ls -1 "$DB_PATH" | grep -v '_metadata$'))
select tablename in "${tables[@]}"; do
    if [[ -n "$tablename" ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

TABLE_FILE="$DB_PATH/$tablename"

# Check if table exists
if [[ ! -f "$TABLE_FILE" ]]; then
    echo "Table '$tablename' does not exist."
    exit 1
fi

# Display table data
echo "Current data in '$tablename':"
cat "$TABLE_FILE"

echo "Enter the primary key value of the row to delete:"
read pk_value

# Validate primary key value
if [[ -z "$pk_value" ]]; then
    echo "Primary key value cannot be empty."
    exit 1
fi

if [[ "$pk_value" =~ [^a-zA-Z0-9] ]]; then
    echo "Primary key value contains invalid characters."
    exit 1
fi

# Find the row with the primary key
row_index=$(awk -F '|' -v pk="$pk_value" '$1 == pk {print NR}' "$TABLE_FILE")

if [[ -z "$row_index" ]]; then
    echo "No row found with primary key '$pk_value'."
    exit 1
fi

# Delete the row and update the file
awk -F '|' -v row="$row_index" 'NR != row' "$TABLE_FILE" > "$TABLE_FILE.tmp" && mv "$TABLE_FILE.tmp" "$TABLE_FILE"

echo "Row with primary key '$pk_value' deleted successfully."