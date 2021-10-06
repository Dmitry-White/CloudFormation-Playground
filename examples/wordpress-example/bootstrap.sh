#! /bin/bash

TEMPLATE="template"
PARAMETERS="parameters"
STACK_NAME="wordpress-example"

createKeyPair() {
  echo "Creating a Wordpress Example key pair..."

  aws ec2 create-key-pair \
    --key-name $STACK_NAME \
    --profile dmitry \
    --output text > "${STACK_NAME}.pem"

  echo "Creation of the Wordpress Example key pair completed!"
}

deleteKeyPair() {
  echo "Deleting a Wordpress Example key pair..."

  aws ec2 delete-key-pair \
    --key-name $STACK_NAME \
    --profile dmitry

  rm ./"${STACK_NAME}.pem"

  echo "Deletion of the Wordpress Example key pair completed!"
}

create() {
  echo "Creating a Wordpress Example stack with File parameters..."

  aws cloudformation create-stack \
    --template-body "file://${TEMPLATE}.yml" \
    --parameters "file://${PARAMETERS}.json" \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for Wordpress Example stack to complete creation..."

  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Creation of Wordpress Example stack completed!"
}

observe() {
  echo "Observing a Wordpress Example stack..."

  aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Observation of the Wordpress Example stack completed!"
}


delete() {
  echo "Deleting a Wordpress Example stack..."

  aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Waiting for Wordpress Example stack to complete deletion..."

  aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --profile dmitry

  echo "Deletion of Wordpress Example stack completed!"
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
  prepare)
    command="createKeyPair"
    ;;
  clean)
    command="deleteKeyPair"
    ;;
  *)
    command="help"
    ;;
  esac
  shift # Delete an argument from the list
done

$command # Run the function stored in the command variable
