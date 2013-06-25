#!/bin/env bash
AMI_EBS="ami-1624987f"
EC2_SIZE="t1.micro"
ZONE=us-east-1b

ec2-run-instances $AMI_EBS          \
     --verbose                        \
     --user-data-file base_user_data.sh  \
     --key majorTom-keypair                \
     --monitor                        \
     --instance-type $EC2_SIZE         \
     --availability-zone $ZONE
