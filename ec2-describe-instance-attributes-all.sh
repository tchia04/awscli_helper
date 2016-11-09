#!/bin/sh

ATTRIBUTES="
instanceType
kernel
ramdisk
userData
disableApiTermination
instanceInitiatedShutdownBehavior
rootDeviceName
blockDeviceMapping
productCodes
sourceDestCheck
groupSet
ebsOptimized
sriovNetSupport
enaSupport
"

if [ "$1" == "" ]; then
  echo "Please provide an instance id"
	exit 1
else
  INSTANCE_ID=$1
fi

if [ "$2" == "" ]; then
  echo "Please provide a REGION such as us-west-1 "
	exit 1
else
  REGION=$2
fi

echo "Instance ID=$1" > $INSTANCE_ID.log
for a in $ATTRIBUTES; do
  echo ATTRIBUTE=$a>> $INSTANCE_ID.log
  aws --region $REGION ec2 describe-instance-attribute --instance-id $INSTANCE_ID --attribute $a --output text >> $INSTANCE_ID.log 2>&1
	echo "------------------------------" >> $INSTANCE_ID.log
done

cat $INSTANCE_ID.log | grep -v $INSTANCE_ID
