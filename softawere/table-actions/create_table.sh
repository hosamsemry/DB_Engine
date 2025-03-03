#!/usr/bin/bash

# Ensure dbname is set
if [[ -z "$dbname" ]]; then
    echo "No database selected. Please connect to a database first."
    exit 1
fi

DB_PATH="../../databases/$dbname"
TABLES_PATH="$DB_PATH"

echo "Already existing tables in '$dbname':"
ls -1 "$TABLES_PATH"

while true; do 
    echo "Enter the name of the table you want to create: "
    read tablename

    if [[ ! "$tablename" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid table name. Use letters, numbers, and underscores, starting with a letter or underscore."
    elif [ -f "$TABLES_PATH/$tablename" ]; then
        echo "Table '$tablename' already exists. Try again."
    else
        touch "$TABLES_PATH/$tablename"
        echo "Table '$tablename' created successfully."
        break
    fi
done

echo "Enter the number of columns for the table: "
read num_columns

columns=()
types=()

for (( i=1; i<=num_columns; i++ )); do
    while true; do
        echo "Enter the name of column $i: "
        read column_name

        if [[ ! "$column_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "Invalid column name. Must start with a letter/underscore and contain only letters, numbers, and underscores."
        else
            break
        fi
    done

    columns+=("$column_name")

    echo "Enter the type of column $i (INT, VARCHAR, etc.): "
    read column_type
    types+=("$column_type")
done

# Assign Primary Key
primary_key=""
echo "Do you want to assign a primary key? (yes/no): "
read assign_pk
if [[ "$assign_pk" == "yes" ]]; then
    while true; do
        echo "Enter the column name to be used as primary key: "
        read primary_key

        if [[ " ${columns[@]} " =~ " $primary_key " ]]; then
            break
        else
            echo "Invalid column name. It must be one of the defined columns."
        fi
    done
fi

# Assign Foreign Key
foreign_key=""
ref_table=""
ref_column=""
echo "Do you want to assign a foreign key? (yes/no): "
read assign_fk
if [[ "$assign_fk" == "yes" ]]; then
    while true; do
        echo "Enter the column name to be used as a foreign key: "
        read foreign_key

        if [[ " ${columns[@]} " =~ " $foreign_key " ]]; then
            break
        else
            echo "Invalid column name. It must be one of the defined columns."
        fi
    done

    echo "Enter the referenced table name: "
    read ref_table

    echo "Enter the referenced column name: "
    read ref_column
fi

# Store table metadata
metadata_file="$TABLES_PATH/${tablename}_metadata"

for (( i=0; i<num_columns; i++ )); do
    echo "${columns[$i]}|${types[$i]}" >> "$metadata_file"
done

if [[ -n "$primary_key" ]]; then
    echo "Primary Key|$primary_key" >> "$metadata_file"
fi

if [[ -n "$foreign_key" ]]; then
    echo "Foreign Key|$foreign_key|References|$ref_table|($ref_column)" >> "$metadata_file"
fi

echo "Table '$tablename' created successfully with $num_columns columns."

# Loop for creating another table
while true; do
    echo "Do you want to create another table? (yes/no): "
    read create_another
    case "$create_another" in
        yes) bash "$0"; break ;;
        no) exit 0 ;;
        *) echo "Invalid input. Please enter 'yes' or 'no'." ;;
    esac
done
