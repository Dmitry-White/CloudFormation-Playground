#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="vpc-example"
PROFILE="DmitryPC"

create() {
  echo "Creating a VPC Example stack with File parameters..."

  aws cloudformation create-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS}.json" \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Waiting for VPC Example stack to complete creation..."

  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Creation of VPC Example stack completed!"
}

observe() {
  echo "Observing a VPC Example stack..."

  aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Observation of the VPC Example stack completed!"
}


delete() {
  echo "Deleting a VPC Example stack..."

  aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Waiting for VPC Example stack to complete deletion..."

  aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Deletion of VPC Example stack completed!"
}

help() {
  echo "Help Guide"
}

while [ $# -gt 0 ]; do      # Wait until there are no arguments
  case $1 in                # Check the 1st argument to match one of the cases
  start)                    # One of the cases
    command="create" # Assign the function name to the variable
    ;; # End of one of the cases
  check)
    command="observe"
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
