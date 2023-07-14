#!/bin/bash
#make sure you have installed AWS CLI and mysql client on you system before running script
BUCKET_NAME="s3-bucket-mysql-dump"
S3_DIRECTORY="$BUCKET_NAME/$DB_NAME-$DATE"
DB_HOST="localhost"
DB_USER="username"
DB_PASS="password"
DB_NAME="demo_db"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
#get the latest dump file from s3 bucket
latest_dump=$(aws s3api list-objects-v2 --bucket "$S3_BUCKET" --prefix "$S3_DIRECTORY/" --query 'reverse(sort_by(Contents,&LastModified))[0].Key' --output text)
#download the latest dump file
aws s3 cp "s3://$S3_BUCKET/$latest_dump" .
#restore the database from the dump file
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$latest_dump"
rm "$latest_dump"