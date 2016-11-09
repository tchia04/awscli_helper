#!/bin/sh

set -e

usage() {
  echo "Syntax: $0 user regions-separated-by-comma ID_FORMAT"
  echo "For example, to switch the root user in us-west-1 to long format"
  echo "  $0 root us-west-1 long"
  echo "For example, to switch the root user in us-west-1 to short format"
  echo "  $0 root us-west-1 short"
}

AWS_ACCOUNT_NUMBER=$(aws sts get-caller-identity --output text --query 'Account')

if [ "$1" == "" ]; then
  echo "Missing user id."
  usage
  exit 1
elif [ "$1" == "root" ]; then
  USER="root"
elif [ "$1" != "root" ]; then
  USER="user/$1"
fi

DEFAULT_REGIONS="eu-west-1 ap-southeast-2 us-east-1 us-west-1"
if [ "$2" == "" ]; then
  echo "Missing AWS region."
  usage
  exit 1
else
  REGIONS=$(echo $2 | sed s'/,/ /g')
fi

if [ "$3" == "long" ]; then
  ID_FORMAT="--use-long-ids"
elif [ "$3" == "short" ]; then
  ID_FORMAT="--no-use-long-ids"
else
  echo "Invalid id format"
  usage
  exit 1
fi

echo "Switch to the $ID_FORMAT id format for $USER"
echo "----------------------------------------------------"
echo "AWS_ACCOUNT_NUMBER=$AWS_ACCOUNT_NUMBER"
echo "REGIONS=$REGIONS"
echo "USER=$USER"
echo "ID_FORMAT=$ID_FORMAT"
echo "----------------------------------------------------"

RESOURCES="instance reservation snapshot volume"
ARN="arn:aws:iam::$AWS_ACCOUNT_NUMBER:$USER"

for REGION in ${REGIONS}; do
    echo "REGION=$REGION"
    for r in ${RESOURCES}; do
			echo "Changing the id format for resource=$r"
        aws ec2 modify-identity-id-format --principal-arn $ARN --region $REGION --resource $r $ID_FORMAT
    done
done

./check_user_id_format.sh $1 $2
