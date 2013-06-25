#!/bin/env bash
AMI_EBS="ami-1624987f"
EC2_SIZE="t1.micro"
ZONE=us-east-1b

cat base_user_data.sh > nuxeo_ec2_init.sh

cat >> nuxeo_ec2_init.sh << DELIM
useradd nuxeo
DELIM

ec2-run-instances $AMI_EBS          \
     --verbose                        \
     --user-data-file nuxeo_ec2_init.sh  \
     --key majorTom-keypair                \
     --monitor                        \
     --instance-type $EC2_SIZE         \
     --availability-zone $ZONE
