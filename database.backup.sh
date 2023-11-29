#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

DB_BACKUP_PATH='/home/ec2-user/backup'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='8jpnAqZ]|O%O/]fm'
DATABASE_NAME='future_g_coin'
BACKUP_RETAIN_DAYS=10   ## Number of days to keep local backup copy
 
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
 
mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
   ${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
 
DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi




--------------------------------------------------------------------------------------------------------------
file no ---o2         script for code backup of more project to another server
--------------------------------------------------------------------------------------------------------------


#!/bin/bash

# Define your source directories
source_directories=(
    "/home/angleconstructio"
    "/home/ausyescom"
    "/home/autismhometherap"
    "/home/betasoftdigitalc"
    "/home/clientprojects"
    "/home/delhiclubadelaid"
    "/home/devlinpoolandspa"
    "/home/fussfreefinance"
    "/home/getcurried"
    "/home/ipkcmall"
    "/home/kelvincleaningse"
    "/home/laurenjanehairco"
    "/home/lisapcom"
    "/home/mordogcom"
    "/home/nextgencom"
    "/home/nextgenvirtualhu"
    "/home/ozeemigrationcom"
    "/home/primewebtech"
    "/home/quickmenucom"
    "/home/sharktechnologie"
    "/home/supportdesk"
    "/home/techremit"
    "/home/vsmartmigration"
    "/home/webcomsystemscom"
    "/home/xpertstrade"


)

# Remote server details
remote_server="root@69.64.67.42"
remote_directory="/backup/server-65.254.92.237/"

# Backup directory
backup_dir="/root/backup"

# Maximum number of backup files to keep on the remote server
max_backups=25

# Create a timestamp for backup files
timestamp=$(date +"%d%b%Y")

# Create a backup archive (tar.gz) of each source directory
for src_dir in "${source_directories[@]}"; do
    base_name=$(basename "${src_dir}")
    backup_file="${backup_dir}/${base_name}_${timestamp}.tar.gz"

    tar czf "${backup_file}" "${src_dir}"

    # Transfer the backup file to the remote server using scp
    scp "${backup_file}" "${remote_server}:${remote_directory}"

    # Check if the transfer was successful (exit code 0 indicates success)
    if [ $? -eq 0 ]; then
        echo "Backup of ${base_name} successfully transferred to remote server."

        # Remove the local backup file
        rm -f "${backup_file}"
        echo "Local backup file removed."
    else
        echo "Error: Backup transfer to remote server failed."
    fi
done

## Remove old backup files on the remote server
#ssh "${remote_server}" "cd ${remote_directory} && ls -t | tail -n +$((max_backups + 25)) | xargs rm -f"
#echo "Old backup files on remote server removed."

# Remove old backup files on the remote server (older than 3 days)
ssh "${remote_server}" "find ${remote_directory} -type f -mtime +2 -exec rm {} \;"
echo "Old backup files on remote server (older than 3 days) removed."


# All backups are done and transferred, exit the script
exit 0


--------------------------------------------------------------------------------------------------------------------------------------------
backup  file 3                                database backup of all account  mysql-bak.sh
----------------------------------------------------------------------------------------------------------------------------------------------


#!/bin/bash

# Remote server details
REMOTE_SERVER="69.64.67.42"
REMOTE_USER="root"
REMOTE_PATH="/backup/mysql-backup-65.254.92.237"
BACKUP_RETENTION_DAYS=3

# Local backup directory
LOCAL_BACKUP_BASE="/root/backup/mysql-backup"
CURRENT_DATE=$(date +%Y%m%d)
LOCAL_BACKUP_FOLDER="$LOCAL_BACKUP_BASE/mysql_backup_$CURRENT_DATE"

# Create the local backup directory for the current date
mkdir -p $LOCAL_BACKUP_FOLDER

# Get a list of all databases
databases=$(mysql -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Loop through the databases and create individual backup files
for db in $databases
do
    BACKUP_FILE="$LOCAL_BACKUP_FOLDER/${db}_backup.sql"

    # Create the individual database backup
    mysqldump $db > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "MySQL backup for $db successfully created: $BACKUP_FILE"
    else
        echo "MySQL backup for $db failed. Check your MySQL credentials and permissions."
        continue
    fi
done

# Create a .tar.gz archive for the local backup folder
LOCAL_ARCHIVE_FILE="$LOCAL_BACKUP_BASE/mysql_backup_$CURRENT_DATE.tar.gz"
tar -czf $LOCAL_ARCHIVE_FILE -C $LOCAL_BACKUP_BASE "mysql_backup_$CURRENT_DATE"

# Transfer the .tar.gz archive to the remote server using SCP
scp $LOCAL_ARCHIVE_FILE $REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH

if [ $? -eq 0 ]; then
    echo "Backup for $CURRENT_DATE transferred to remote server: $REMOTE_SERVER:$REMOTE_PATH"
else
    echo "SCP transfer for $CURRENT_DATE backup failed. Check your remote server configuration and permissions."
fi

# Clean up the local backup folder and .tar.gz archive
rm -r $LOCAL_BACKUP_FOLDER
rm $LOCAL_ARCHIVE_FILE

# Remove backups on the remote server that are older than 3 days
ssh $REMOTE_USER@$REMOTE_SERVER "find $REMOTE_PATH -type f -mtime +$BACKUP_RETENTION_DAYS -exec rm {} \;"

echo "Backup for all databases on $CURRENT_DATE completed, and old backups removed from the remote server."



