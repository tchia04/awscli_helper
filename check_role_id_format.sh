#!/bin/bash

set -e
usage() {
  echo "Syntax: $0 role regions-separated-by-comma"
  echo "For example, $0 root us-east-1,us-west-1"
}

AWS_ACCOUNT_NUMBER=$(aws sts get-caller-identity --output text --query 'Account')

if [ "$1" == "" ]; then
  echo "Missing role id."
  usage
  exit 1
elif [ "$1" != "root" ]; then
  ROLE="role/$1"
fi

DEFAULT_REGIONS="eu-west-1 ap-southeast-2 us-east-1 us-west-1"
if [ "$2" == "" ]; then
  echo "Missing AWS region. Using the following default regions $DEFAULT_REGIONS"
  REGIONS=$DEFAULT_REGIONS
else
  REGIONS=$(echo $2 | sed s'/,/ /g')
fi

echo "Checking the id format for root "
echo "----------------------------------------------------"
echo "AWS_ACCOUNT_NUMBER=$AWS_ACCOUNT_NUMBER"
echo "REGIONS=$REGIONS"
echo "ROLE=$ROLE"
echo "----------------------------------------------------"
for REGION in ${REGIONS}; do
    echo "REGION=$REGION"
		aws --region $REGION ec2 describe-identity-id-format --principal-arn arn:aws:iam::${AWS_ACCOUNT_NUMBER}:${ROLE} --output table
done
