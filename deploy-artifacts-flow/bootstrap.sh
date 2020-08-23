#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="lambdas-stack"
BUCKET_NAME="dw-lambdas-bucket"

create_bucket() {
  echo "Creating an S3 Bucket..."

  aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=eu-central-1 \
    --profile dmitry

  echo "Creation of S3 bucket completed!"
}

package() {
  echo "Creating a build folder..."
  mkdir build
  echo "Creation of build folder completed!"

  echo "Packaging Lambdas..."

  aws cloudformation package \
    --s3-bucket $BUCKET_NAME \
    --template-file "$TEMPLATE.yml" \
    --output-template-file "./build/$TEMPLATE.packaged.yml" \
    --profile dmitry

  echo "Packaging of Lambdas completed!"
}

deploy() {
  echo "Deploying a Lambda stack..."

  aws cloudformation deploy \
    --template-file "./build/$TEMPLATE.packaged.yml" \
    --parameter-overrides $(cat $PARAMETERS.properties) \
    --stack-name $STACK_NAME \
    --capabilities CAPABILITY_IAM \
    --profile dmitry

  echo "Deployment of Lambda stack completed!"
}

delete() {
  echo "Removing artifacts from S3 bucket..."

  aws s3 rm \
    --recursive \
    s3://$BUCKET_NAME/ \
    --profile dmitry

  echo "Remove of artifacts from S3 bucket completed!"

  echo "Deleting a Lambda stack..."

  aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for Lambda stack to complete deletion..."

  aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Deletion of Lambda stack completed!"

  echo "Deletion of build folder..."
  rm -rf build
  echo "Deletion of build folder completed!"
}

help() {
  echo "Help Guide"
}

while [ $# -gt 0 ]; do      # Wait until there are no arguments
  case $1 in                # Check the 1st argument to match one of the cases
  create)                   # One of the cases
    command="create_bucket" # Assign the function name to the variable
    ;;                      # End of one of the cases
  package)
    command="package"
    ;;
  start)
    command="deploy"
    ;;
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
