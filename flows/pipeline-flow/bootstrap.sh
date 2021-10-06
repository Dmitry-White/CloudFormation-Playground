#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="designpatterns-pipeline"
BUCKET_NAME=$(cat $PARAMETERS.properties | grep WebsiteName | cut -d'=' -f2)-bucket

deploy() {
  echo "Deploying website pipeline stack..."

  aws cloudformation deploy \
    --template-file "$TEMPLATE.yml" \
    --parameter-overrides $(cat $PARAMETERS.properties) \
    --stack-name $STACK_NAME \
    --capabilities CAPABILITY_IAM \
    --profile dmitry

  echo "Deployment of website pipeline stack completed!"
}

delete() {
  echo "Removing artifacts from S3 bucket..."

  aws s3 rm \
    --recursive \
    s3://$BUCKET_NAME/ \
    --profile dmitry

  echo "Remove of artifacts from S3 bucket completed!"
  
  echo "Deleting website pipeline stack..."

  aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for website pipeline stack to complete deletion..."

  aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Deletion of website pipeline stack completed!"
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
