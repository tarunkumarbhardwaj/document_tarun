[ec2-user@ip-172-31-43-140 database]$ cat table.sh 
#!/bin/bash

# MySQL database credentials
DB_USER="metapay"
DB_PASSWORD="Metapay#2023"
DB_NAME="metapay"

# Directory to store the exported SQL files
 EXPORT_DIR="exported_tables"

# Create the export directory if it doesn't exist
mkdir -p "$EXPORT_DIR"

# Extract table names from the MySQL database
TABLES=$(mysql -u$DB_USER -p$DB_PASSWORD -e "USE $DB_NAME; SHOW TABLES;" | awk '{ print $1}' | grep -v '^Tables' )

# Iterate through each table and export its contents
for TABLE in $TABLES; do
    OUTPUT_FILE="${EXPORT_DIR}/${TABLE}.sql"
    mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME $TABLE > "$OUTPUT_FILE"
    echo "Exported $TABLE to $OUTPUT_FILE"
done

echo "All tables exported to $EXPORT_DIR"

