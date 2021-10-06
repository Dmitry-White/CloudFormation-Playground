#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="vpc-example"
PROFILE="DmitryPC"

CHANGE_SET_NAME="vpc-example-update"
TEMPLATE_UPDATED="template-updated"
PARAMETERS_UPDATED="parameters-updated"

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


prepareUpdate() {
  echo "Preparing update for the VPC Example stack..."

  aws cloudformation create-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --template-body "file://${TEMPLATE_UPDATED}.yml" \
    --parameters "file://${PARAMETERS_UPDATED}.json" \
    --profile $PROFILE

  echo "Waiting for VPC Example stack to complete update preparation..."

  aws cloudformation wait change-set-create-complete \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --profile $PROFILE

  echo "Update of VPC Example stack prepared!"
}

viewUpdate() {
  echo "Retrieving updates for the VPC Example stack..."

  aws cloudformation list-change-sets \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Retrieving update details for the VPC Example stack..."

  aws cloudformation describe-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --output table \
    --profile $PROFILE

  echo "Updates of VPC Example stack retrieved!"
}

update() {
  prepareUpdate
  viewUpdate
}

applyUpdate() {
  echo "Applying update for the VPC Example stack..."

  aws cloudformation execute-change-set \
    --stack-name $STACK_NAME \
    --change-set-name $CHANGE_SET_NAME \
    --profile $PROFILE

  echo "Waiting for VPC Example stack to complete update..."

  aws cloudformation wait stack-update-complete \
    --stack-name $STACK_NAME \
    --profile $PROFILE

  echo "Update of VPC Example stack completed!"
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
