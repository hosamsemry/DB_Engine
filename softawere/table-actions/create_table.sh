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

    while true; do
        echo "Select the type of column $i: "
        select column_type in "INT" "VARCHAR"; do
            case $column_type in
                INT|VARCHAR)
                    types+=("$column_type")
                    break 2
                    ;;
                *)
                    echo "Invalid column type. Please select a valid option."
                    ;;
            esac
        done
    done
done

# Assign Primary Key
primary_key=""
echo "Do you want to assign a primary key? (yes/no): "
select assign_pk in "yes" "no"; do
    case $assign_pk in
        yes)
            while true; do
                echo "Enter the column name to be used as primary key: "
                read primary_key

                if [[ " ${columns[@]} " =~ " $primary_key " ]]; then
                    break
                else
                    echo "Invalid column name. It must be one of the defined columns."
                fi
            done
            break
            ;;
        no)
            break
            ;;
        *)
            echo "Invalid option. Please select 'yes' or 'no'."
            ;;
    esac
done

# Store table metadata
metadata_file="$TABLES_PATH/${tablename}_metadata"

for (( i=0; i<num_columns; i++ )); do
    if [[ "${columns[$i]}" == "$primary_key" ]]; then
        echo "${columns[$i]}|${types[$i]}|Primary Key" >> "$metadata_file"
    else
        echo "${columns[$i]}|${types[$i]}" >> "$metadata_file"
    fi
done

echo "Table '$tablename' created successfully with $num_columns columns."

# Loop for creating another table
while true; do
    echo "Do you want to create another table? (yes/no): "
    select create_another in "yes" "no"; do
        case "$create_another" in
            yes) bash "$0"; break 2 ;;
            no) exit 0 ;;
            *) echo "Invalid input. Please select 'yes' or 'no'." ;;
        esac
    done
done