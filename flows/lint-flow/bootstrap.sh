#! /bin/bash

TEMPLATE="template"

validateSyntax() {
  echo "Validating syntax of CloudFormation templates..."

  aws cloudformation validate-template \
    --template-body "file://${TEMPLATE}.yml" \
    --profile dmitry

  echo "Syntax validation of CloudFormation templates completed!"
}

validateResources() {
  echo "Validating resources of CloudFormation templates..."

  cfn-lint "${TEMPLATE}.yml"

  echo "Resource validation of CloudFormation templates completed!"
}

lint() {
  validateSyntax
  validateResources
}

help() {
  echo "Help Guide"
}

while [ $# -gt 0 ]; do # Wait until there are no arguments
  case $1 in           # Check the 1st argument to match one of the cases
  lint)                # One of the cases
    command="lint"     # Assign the function name to the variable
    ;;                 # End of one of the cases
  *)
    command="help"
    ;;
  esac
  shift # Delete an argument from the list
done

$command # Run the function stored in the command variable
