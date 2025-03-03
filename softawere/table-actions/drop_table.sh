#!/usr/bin/bash

read -p "Enter the name of the table you want to drop: " tablename
rm "${tablename}" "${tablename}_metadata" 2>>./.error.log
if [[ $? == 0 ]]; then
    echo "Table dropped successfully."
else
    echo "Error dropping table $tablename."
fi
