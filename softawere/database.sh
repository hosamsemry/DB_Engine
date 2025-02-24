#!/usr/bin/bash

while true; do
    echo " "
    echo "Enter the number of the operation you want to do"

    select choice in CREATE_DB LIST_DB DROP_DB CONNECT_DB EXIT; do
        case $choice in
            CREATE_DB)
                ./create_db.sh
                break
                ;;
            LIST_DB)
                ./list_db.sh
                break
                ;;
            DROP_DB)
                ./drop_db.sh
                break
                ;;
            CONNECT_DB)
                ./connect_db.sh
                break
                ;;
            EXIT)
                exit 0
                ;;
            *)
                echo "Invalid choice"
                break
                ;;
        esac
    done
done