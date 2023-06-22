#!/bin/bash

# Set the source directory path on the EC2 instance where the backup files are located
SOURCE_DIRECTORY="/path/to/backup/files"

# Set the destination S3 bucket name and key prefix (subfolder) where the files will be copied
S3_BUCKET_NAME="your-s3-bucket-name"
S3_KEY_PREFIX="backup-files/"

# Iterate over each file in the source directory and copy it to the S3 bucket
for FILE in "$SOURCE_DIRECTORY"/*; do
    # Extract the file name from the path
    FILE_NAME=$(basename "$FILE")
    
    # Copy the file to the S3 bucket
    aws s3 cp "$FILE" "s3://$S3_BUCKET_NAME/$S3_KEY_PREFIX$FILE_NAME"
    
    echo "Copied $FILE_NAME to S3 bucket $S3_BUCKET_NAME at key $S3_KEY_PREFIX$FILE_NAME"
done
