#!/bin/bash
#make sure you have installed AWS CLI and mysql client on you system before running script
BUCKET_NAME="s3-bucket-mysql-dump"
REGION="us-east-1"
DB_USER="username"
DB_PASS="password"
DB_NAME="demo_db"
BACKUP_DIR="/home/ubuntu"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
#create bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION 
#create dump file and copy to s3 bucket
mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME --ignore-table=$DB_NAME.logs > $BACKUP_DIR/$DB_NAME-$DATE.sql | \
gzip $BACKUP_DIR/$DB_NAME-$DATE.sql | aws s3 cp - s3://$BUCKET_NAME/$DB_NAME-$DATE

