#!/bin/bash
# launch an EC2 server and install application

# this script runs on a machine where "Universal Command Line Interface for Amazon Web Services"
# https://github.com/aws/aws-cli is installed and is authenticated to amazon web services
# AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY environment variables must be set
# 
# This script also requires installation of jq : http://stedolan.github.io/jq/

# like a russia doll, this script 
#    -   creates a script that runs as root on a brand new amazon linux ec2 

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
AMI_EBS="ami-05355a6c"
EC2_SIZE="t1.micro"
EC2_SIZE="m1.large"
ZONE=us-east-1b
EC2_REGION=us-east-1
cd $DIR

cat user-data/solr.sh > ec2_solr_init.sh

# only on the t1.micro, tune swap
if [ "$EC2_SIZE" == 't1.micro' ]; then
  cat >> ec2_solr_init.sh << DELIM
# t1.micro's don't come with any swap; let's add 1G
## to do -- add test for micro
# http://cloudstory.in/2012/02/adding-swap-space-to-amazon-ec2-linux-micro-instance-to-increase-the-performance/
# http://www.matb33.me/2012/05/03/wordpress-on-ec2-micro.html
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
# in case we get rebooted, add swap to fstab
cat >> /etc/fstab << FSTAB
/var/swap.1 swap swap defaults 0 0
FSTAB
# t1.micro memory optimizations
DELIM

fi

gzip ec2_solr_init.sh

command="aws ec2 run-instances 
     --region $EC2_REGION 
     --monitoring file://monitoring.json
     --placement file://placement.json
     --instance-type $EC2_SIZE                       
     --count 1:1                                   
     --image-id $AMI_EBS                             
     --user-data file://ec2_solr_init.sh.gz
     --key-name UCLDC_keypair_0
     --security-groups Solr
     --iam-instance-profile Name=s3-readonly"

echo "ec2 launch command $command"

# launch an ec2 and grab the instance id
instance=`$command | jq '.Instances[0] | .InstanceId' -r`

echo "DONE WITH INSTANCE LAUNCH: $instance"

name_cmd="aws ec2 create-tags --region $EC2_REGION --resources ${instance} --tags Key=Name,Value=UCLDC_Solr"
tags=`$name_cmd`

echo tags
echo "DONE WITH NAMING"

# wait for the new ec2 machine to get its hostname
hostname_cmd="aws ec2 describe-instances --region $EC2_REGION --instance-ids $instance | jq ' .Reservations[0] | .Instances[0] | .PublicDnsName'"
echo "CMD $hostname_cmd"
hostname=`aws ec2 describe-instances --region $EC2_REGION --instance-ids $instance | jq ' .Reservations[0] | .Instances[0] | .PublicDnsName'`
echo "instance started, waiting for hostname"
while [ "$hostname" = 'null' ]
  do
  sleep 15
  echo "."
  hostname=`aws ec2 describe-instances --region $EC2_REGION --instance-ids $instance | jq ' .Reservations[0] | .Instances[0] | .PublicDnsName'` 
  done

echo "INSTANCE:$instance"
echo $hostname

#TODO: cleanup init file ec2_solr_init.sh.gz

#Associate with our solr-dev elastic ip address
retval=`aws ec2 associate-address --region=$EC2_REGION --instance-id $instance --public-ip 107.21.228.130`
echo "ASSOCIATE ELASTIC IP ADDRESS RETURNED: $retval"
