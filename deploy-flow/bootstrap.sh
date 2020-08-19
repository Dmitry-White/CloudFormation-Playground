#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
WEBSITE_FOLDER="www"
STACK_NAME="designpatterns-website"
BUCKET_NAME="designpatterns-bucket"

deploy() {
  echo "Deploying a S3 bucket stack..."

  aws cloudformation deploy \
    --template-file "$TEMPLATE.yml" \
    --parameter-overrides $(cat $PARAMETERS.properties) \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Deployment of S3 bucket stack completed!"

  echo "Uploading website to S3 bucket..."

  aws s3 cp \
    --acl "public-read" \
    --recursive \
    ./$WEBSITE_FOLDER \
    s3://$BUCKET_NAME/ \
    --profile dmitry

  echo "Upload of website to S3 bucket completed!"
}

delete() {
  echo "Removing website from S3 bucket..."

  aws s3 rm \
    --recursive \
    s3://$BUCKET_NAME/ \
    --profile dmitry

  echo "Remove of website from S3 bucket completed!"

  echo "Deleting a DynamoDB table stack..."

  aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete deletion..."

  aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Deletion of DynamoDB table stack completed!"
}

help() {
  echo "Help Guide"
}

while [ $# -gt 0 ]; do # Wait until there are no arguments
  case $1 in           # Check the 1st argument to match one of the cases
  start)               # One of the cases
    command="deploy"   # Assign the function name to the variable
    ;;                 # End of one of the cases
  stop)
    command="delete"
    ;;
  *)
    command="help"
    ;;
  esac
  shift # Delete an argument from the list
done

$command # Run the function stored in the command variable
