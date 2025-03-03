#!/usr/bin/bash

# Ensure dbname is set
if [[ -z "$dbname" ]]; then
    echo "No database selected. Please connect to a database first."
    exit 1
fi

DB_PATH="../../databases/$dbname"

echo "Available tables in '$dbname':"
ls -1 "$DB_PATH"

echo "Enter the name of the table you want to update:"
read tablename

TABLE_FILE="$DB_PATH/$tablename"
METADATA_FILE="$DB_PATH/${tablename}_metadata"

# Check if table exists
if [[ ! -f "$TABLE_FILE" ]]; then
    echo "Table '$tablename' does not exist."
    exit 1
fi

# Display table data
echo "Current data in '$tablename':"
cat "$TABLE_FILE"

# Read column names from metadata
columns=($(awk -F '|' '{print $1}' "$METADATA_FILE"))

echo "Enter the primary key value of the row to update:"
read pk_value

# Find the row with the primary key
row_index=$(awk -F '|' -v pk="$pk_value" '$1 == pk {print NR}' "$TABLE_FILE")

if [[ -z "$row_index" ]]; then
    echo "No row found with primary key '$pk_value'."
    exit 1
fi

# Ask user for new values for each column
new_values=()
for ((i = 0; i < ${#columns[@]}; i++)); do
    col="${columns[$i]}"
    echo "Enter new value for $col (leave empty to keep current value):"
    read new_value
    if [[ -n "$new_value" ]]; then
        new_values+=("$new_value")
    else
        # Keep existing value
        old_value=$(awk -F '|' -v row="$row_index" 'NR == row {print $0}' "$TABLE_FILE" | cut -d '|' -f $((i + 1)))
        new_values+=("$old_value")
    fi
done

# Convert array to string with | separator
new_row=$(IFS="|"; echo "${new_values[*]}")

# Replace the old row with new values (preserving | separator)
awk -F '|' -v row="$row_index" -v new_row="$new_row" 'BEGIN {OFS="|"} {if (NR == row) print new_row; else print}' "$TABLE_FILE" > "$TABLE_FILE.tmp" && mv "$TABLE_FILE.tmp" "$TABLE_FILE"

echo "Row updated successfully."
