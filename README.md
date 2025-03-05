# Database Management Shell Scripts
This project provides a set of shell scripts to manage databases and tables. The scripts allow you to create, list, drop, and connect to databases, as well as perform various table operations such as creating, inserting, selecting, updating, and deleting rows.

## Scripts Overview

### Database Management
- softawere/database.sh: Main script to manage databases. Provides options to create, list, drop, and connect to databases.
- softawere/create_db.sh: Script to create a new database.
- softawere/list_db.sh: Script to list all existing databases.
- softawere/drop_db.sh: Script to drop an existing database.
- softawere/connect_db.sh: Script to connect to a database and perform table operations.

### Table Actions
- softawere/table-actions/create_table.sh: Script to create a new table in the connected database.
- softawere/table-actions/insert_into_table.sh: Script to insert a new row into a table.
- softawere/table-actions/select_from_table.sh: Script to select and display data from a table.
- softawere/table-actions/update_table.sh: Script to update an existing row in a table.
- softawere/table-actions/delete_from_table.sh: Script to delete a row from a table.
- softawere/table-actions/drop_table.sh: Script to drop a table from the connected database.

## Usage
1. Run the main script:
### bash softawere/database.sh
2. Follow the prompts to select the desired operation (create, list, drop, or connect to a database).
3. If connecting to a database, follow the prompts to perform table operations (create, insert, select, update, delete, or drop a table).

## Notes
- Ensure that the databases directory exists at the same level as the softawere directory.
- The scripts assume that the database and table names follow specific naming conventions (e.g., starting with a letter and containing only alphanumeric characters and underscores).

### Feel free to modify and extend these scripts to suit your needs. Happy database management!
