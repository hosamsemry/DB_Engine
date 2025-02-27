#!/usr/bin/bash

echo "Select the database from the list below:"

PS3="Enter the number corresponding to the database: "

# Get a list of databases (directories)
databases=($(ls -d ../databases/*/ | xargs -n 1 basename))

select dbname in "${databases[@]}"
do
    if [[ -n "$dbname" ]]; then
        export dbname="$dbname"
        cd "../databases/$dbname" || { echo "Failed to switch directory"; exit 1; }
        echo "Connected to $dbname"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

echo "What do you want to do?"

PS3="Choose an option: "
options=("Create a table" "Insert into a table" "Select from a table" "Update a table" "Delete from a table" "Exit")

select action in "${options[@]}"
do
    case "$action" in 
        "Create a table")
            ../../softawere/table-actions/create_table.sh
            ;;

        "Insert into a table")
            read -p "Enter the name of the table you want to insert into: " tablename
            read -p "Enter the values you want to insert separated by commas: " values
            echo "Values inserted successfully."
            ;;

        "Select from a table")
            read -p "Enter the name of the table you want to select from: " tablename
            read -p "Enter the columns you want to select separated by commas: " columns
            echo "Select query executed successfully."
            ;;

        "Update a table")
            read -p "Enter the name of the table you want to update: " tablename
            read -p "Enter the column you want to update: " column
            read -p "Enter the new value: " newvalue
            echo "Table updated successfully."
            ;;

        "Delete from a table")
            read -p "Enter the name of the table you want to delete from: " tablename
            read -p "Enter the condition for deletion: " condition
            echo "Values deleted successfully."
            ;;

        "Exit")
            echo "Exiting..."
            break
            ;;
        
        *) 
            echo "Invalid option, please try again."
            ;;
    esac
done