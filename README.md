# awscli_helper

This directory contains some scripts I created to bridge the gap that the aws-cli left behind.

## General
### ec2-describe-instance-attributes-all.sh
I don't understand why the aws-cli doesn't display all the instance attributes by default and have to list one at a time as desribed at https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instance-attribute.html so I came up with this script to display all the attributes listed below on an instance_id. The full list of attributes is listed below

* instanceType
* kernel
* ramdisk
* userData
* disableApiTermination
* instanceInitiatedShutdownBehavior
* rootDeviceName
* blockDeviceMapping
* productCodes
* sourceDestCheck
* groupSet
* ebsOptimized
* sriovNetSupport
* enaSupport  

example: ec2-describe-instance-attributes-all.sh instance-id region

## Long Resource ID testing and migration

The scripts in this section help with the testing and migration to the long resource id format as described here
https://aws.amazon.com/blogs/aws/theyre-here-longer-ec2-resource-ids-now-available/

### check_role_id_format.sh
This script let you check to see if the IAM role is opted in or opted out of the long resource id.

example: check_role_id_format.sh role regions-separated-by-comma

### check_user_id_format.sh
This script let you check to see if the IAM user is opted in or opted out of the long resource id.

example: check_user_id_format.sh user regions-separated-by-comma

### switch_user_id_format.sh
This script let you switch to the long or the short resource id of an IAM user including root user

Syntax: switch_user_id_format.sh regions-separated-by-comma [long|short]

Example:
To switch an IAM user to use long id format in the us-west-1 region
switch_user_id_format.sh <iam-user> us-west-1 long

To switch an IAM user to use short id format in the us-west-1 (avaiable until Dec 2016)
switch_user_id_format.sh <iam-user> us-west-1 short

To switch an IAM user to use long id format in the us-west-1 and us-west-2
switch_user_id_format.sh <iam-user> us-west-1,us-west-2 long

To switch the root user(for ASG) to use long id format in the us-west-1

switch_user_id_format.sh root us-west-1 long

After you have finished your testing and you would like to check or optIn/optOut all the users/roles etc in one shot use the migratelongerids.py script at

https://github.com/awslabs/ec2-migrate-longer-id
