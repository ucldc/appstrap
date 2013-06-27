#!/bin/env bash
# check http://aws.amazon.com/amazon-linux-ami/ for current AMI
AMI_EBS="ami-05355a6c"
EC2_SIZE="m1.large"
ZONE=us-east-1b

ec2-run-instances $AMI_EBS          \
     --verbose                        \
     --user-data-file user-data/nuxeo.sh  \
     --key majorTom-keypair                \
     --monitor                        \
     --instance-type $EC2_SIZE         \
     --iam-profile "arn:aws:iam::563907706919:instance-profile/s3-readonly" \
     --availability-zone $ZONE
