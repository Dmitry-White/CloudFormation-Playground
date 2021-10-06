#! /bin/bash

TEMPLATE="template"
PARAMETERS_CREATE="parametersCreate"
PARAMETERS_UPDATE="parametersUpdate"
STACK_NAME="dynamodb-table"
CHANGE_SET_NAME="dynamodb-table-update"

create() {
  echo "Creating a DynamoDB table stack..."

  aws cloudformation create-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS_CREATE}.json" \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete creation..."

  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Creation of DynamoDB table stack completed!"
}

prepareUpdate() {
  echo "Preparing update for the DynamoDB table stack..."

  aws cloudformation create-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS_UPDATE}.json" \
    --profile dmitry

  echo "Waiting for DynamoDB table stack to complete update preparation..."

  aws cloudformation wait change-set-create-complete \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --profile dmitry

  echo "Update of DynamoDB table stack prepared!"
}

viewUpdate() {
  echo "Retrieving updates for the DynamoDB table stack..."

  aws cloudformation list-change-sets \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Retrieving update details for the DynamoDB table stack..."

  aws cloudformation describe-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --output table \
    --profile dmitry

  echo "Updates of DynamoDB table stack retrieved!"
}

update() {
  prepareUpdate
  viewUpdate
}

applyUpdate() {
  echo "Applying update for the DynamoDB table stack..."

  aws cloudformation execute-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
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

  echo "Deletion of DynamoDB table tack completed!"
}

help() {
  echo "Help Guide"
}

while [ $# -gt 0 ]; do # Wait until there are no arguments
  case $1 in           # Check the 1st argument to match one of the cases
  start)               # One of the cases
    command="create"   # Assign the function name to the variable
    ;;                 # End of one of the cases
  reboot)
    command="update"
    ;;
  apply)
    command="applyUpdate"
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
