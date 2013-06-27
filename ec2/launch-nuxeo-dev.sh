#!/bin/env bash
# check http://aws.amazon.com/amazon-linux-ami/ for current AMI
AMI_EBS="ami-05355a6c"
EC2_SIZE="t1.micro"
ZONE=us-east-1b

ec2-run-instances $AMI_EBS          \
     --verbose                        \
     --user-data-file user-data/nuxeo.sh  \
     --key majorTom-keypair                \
     --monitor                        \
     --instance-type $EC2_SIZE         \
     --availability-zone $ZONE
