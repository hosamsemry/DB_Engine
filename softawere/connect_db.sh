#!/usr/bin/bash

echo "Select the database from the list below:"

PS3="Enter the number corresponding to the database: "

# Get a list of databases (directories)
databases=($(ls -d ../databases/*/ | xargs -n 1 basename))

#Added => case: when no databases exist
if [ ${#databases[@]} -eq 0 ]; then
    echo "No databases found!"
    exit 1
fi


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


while true; do
echo "What do you want to do?"

PS3="Choose an option: "
options=("Create a table" "Insert into a table" "Select from a table" "Update a table" "Delete from a table" "Alter table" "Drop table" "Exit")

select action in "${options[@]}"
do
    case "$action" in 
        "Create a table")
            ../../softawere/table-actions/create_table.sh
            ;;

        "Insert into a table")
            ../../softawere/table-actions/insert_into_table.sh
            ;;
            # read -p "Enter the name of the table you want to insert into: " tablename
            # read -p "Enter the values you want to insert separated by commas: " values
            # echo "Values inserted successfully."
            # ;;

        "Select from a table")
            
            ../../softawere/table-actions/select_from_table.sh
            ;;
            # read -p "Enter the name of the table you want to select from: " tablename
            # read -p "Enter the columns you want to select separated by commas: " columns
            # echo "Select query executed successfully."
            # ;;

        "Update a table")
            ../../softawere/table-actions/update_table.sh
            ;;
            # read -p "Enter the name of the table you want to update: " tablename
            # read -p "Enter the column you want to update: " column
            # read -p "Enter the new value: " newvalue
            # echo "Table updated successfully."
            # ;;

        "Delete from a table")
            ../../softawere/table-actions/delete_from_table.sh
            ;;
            
            # read -p "Enter the name of the table you want to delete from: " tablename
            # read -p "Enter the condition for deletion: " condition
            # echo "Values deleted successfully."
            # ;;

        "Alter table")
            echo "Alter table selected."
            ../../softawere/table-actions/alter_table.sh
            ;;

        "Drop table")
            ../../softawere/table-actions/drop_table.sh
            ;;
            # read -p "Enter the name of the table you want to drop: " tablename
            # rm "$tablename" ".$tablename" 2>>./.error.log
            # if [[ $? == 0 ]]; then
            #     echo "Table dropped successfully."
            # else
            #     echo "Error dropping table $tablename."
            # fi
            # ;;

        "Exit")
            echo "Exiting..."
            break
            ;;
        
        *) 
            echo "Invalid option, please try again."
            ;;
    esac
    done
done