#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="dynamodb-table"

createFromCLI() {
  echo "Creating a DynamoDB table stack with CLI parameters..."

  aws cloudformation create-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters ParameterKey=TableName,ParameterValue=UsersTable \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete creation..."

  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Creation of DynamoDB table stack completed!"
}

createFromFile() {
  echo "Creating a DynamoDB table stack with File parameters..."

  aws cloudformation create-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS}.json" \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete creation..."

  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Creation of DynamoDB table stack completed!"
}

update() {
  echo "Updating a DynamoDB table stack with File parameters..."

  aws cloudformation update-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS}.json" \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete update..."

  aws cloudformation wait stack-update-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Update of DynamoDB table stack completed!"
}

delete() {
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

while [ $# -gt 0 ]; do      # Wait until there are no arguments
  case $1 in                # Check the 1st argument to match one of the cases
  start)                    # One of the cases
    command="createFromCLI" # Assign the function name to the variable
    # command="createFromFile"
    ;; # End of one of the cases
  reboot)
    command="update"
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
