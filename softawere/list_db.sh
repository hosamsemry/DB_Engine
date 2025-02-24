#!/usr/bin/bash
echo "
Exsisting Databases"
echo "-------------------"
for dir in ../databases/*/; do
    basename "$dir"
done