#!/bin/env bash
AMI_EBS="ami-23d9a94a" # Ubuntu 12.04.2 LTS (Precise Pangolin) http://cloud-images.ubuntu.com/releases/precise/release/
EC2_SIZE="m1.large"
EC2_REGION="us-east-1"
ZONE=us-east-1b

instance=$(ec2-run-instances $AMI_EBS          \
     --verbose                        \
     --user-data-file user-data/pdfu.sh  \
     --key majorTom-keypair                \
     --monitor                        \
     --instance-type $EC2_SIZE         \
     --iam-profile "arn:aws:iam::563907706919:instance-profile/s3-readonly" \
     --availability-zone $ZONE | awk '/^INSTANCE/ {print $2}' )

echo $instance

aws ec2 create-tags --region $EC2_REGION --resources ${instance} --tags key=Name,value=OAC_pdfu
