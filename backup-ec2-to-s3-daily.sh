#! /bin/bash

# AWS CLI configuration
AWS_REGION="your_aws_region"
AWS_PROFILE="your_aws_profile"
AWS_INSTANCE_ID="your_ec2_instance_id"
S3_BUCKET_NAME="your_s3_bucket_name"

# Create S3 bucket with folders
aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE"
aws s3api put-public-access-block --bucket "$S3_BUCKET_NAME" --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" --profile "$AWS_PROFILE"
aws s3api put-bucket-encryption --bucket "$S3_BUCKET_NAME" --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' --profile "$AWS_PROFILE"
aws s3api put-bucket-versioning --bucket "$S3_BUCKET_NAME" --versioning-configuration Status=Enabled --profile "$AWS_PROFILE"

# Create cron job
(crontab -l 2>/dev/null; echo "@daily /path/to/backup_script.sh daily") | crontab -
(crontab -l 2>/dev/null; echo "0 0 * * MON /path/to/backup_script.sh weekly") | crontab -
(crontab -l 2>/dev/null; echo "0 0 1 * * /path/to/backup_script.sh monthly") | crontab -

# Backup script
backup_script() {
    BACKUP_TYPE=$1
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_NAME="${BACKUP_TYPE}_${TIMESTAMP}.tar.gz"

    # Create backup
    aws ec2 create-image --instance-id "$AWS_INSTANCE_ID" --name "$BACKUP_NAME" --description "Backup of EC2 instance" --no-reboot --profile "$AWS_PROFILE"
    
    # Wait for the image creation to complete
    sleep 10s

    # Get the image ID of the newly created backup
    IMAGE_ID=$(aws ec2 describe-images --owners self --filters "Name=name,Values=$BACKUP_NAME" --query "Images[0].ImageId" --output text --profile "$AWS_PROFILE")

    # Create a temporary directory to store the backup files
    TEMP_DIR=$(mktemp -d)

    # Export the backup image to the temporary directory
    aws ec2 create-instance-export-task --instance-id "$AWS_INSTANCE_ID" --target-environment vmware --export-to-s3-task DiskImageFormat=VMDK,ContainerFormat=ova,S3Bucket="$S3_BUCKET_NAME/$BACKUP_TYPE",S3Prefix="$BACKUP_TYPE/$BACKUP_NAME",ImageId="$IMAGE_ID" --profile "$AWS_PROFILE"
    
    # Wait for the export task to complete
    sleep 10s

    # Clean up the temporary directory
    rm -rf "$TEMP_DIR"

            # Delete the oldest backup if more than 7 backups exist in the daily folder
        if [ "$BACKUP_COUNT" -gt 7 ]; then
            OLDEST_BACKUP=$(aws s3 ls "s3://$S3_BUCKET_NAME/daily/" --profile "$AWS_PROFILE" | sort | awk 'NR==1{print $4}')
            aws s3 rm "s3://$S3_BUCKET_NAME/daily/$OLDEST_BACKUP" --profile "$AWS_PROFILE"
        fi
    fi
}

# Check the backup type passed as an argument
if [ "$1" == "daily" ]; then
    backup_script "daily"
elif [ "$1" == "weekly" ]; then
    DAY_OF_WEEK=$(date +"%u")
    if [ "$DAY_OF_WEEK" == "1" ]; then
        backup_script "weekly"
    fi
elif [ "$1" == "monthly" ]; then
    DAY_OF_MONTH=$(date +"%e")
    if [ "$DAY_OF_MONTH" == "1" ]; then
        backup_script "monthly"
    fi
fi
