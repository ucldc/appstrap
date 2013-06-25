#!/bin/bash
# launch an EC2 server and install application

# this script runs on a machine where "Universal Command Line Interface for Amazon Web Services"
# https://github.com/aws/aws-cli is installed and is authenticated to amazon web services
# AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY environment variables must be set

# like a russia doll, this script 
#    -   creates a script that runs as root on a brand new amazon linux ec2 
#    -   creates a script that runs as the 'aspace' unix role account that installs archives space

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
. $DIR/setenv.sh
cd $DIR
# make these parameters; not stuff read from setenv.sh
echo "$TAG $EC2_SIZE"

# start user-data script payload
# https://help.ubuntu.com/community/CloudInit
cat > aws_init.sh << DELIM
#!/bin/bash
set -eux
# this gets run as root on the amazon machine when it boots up

# install packages we need from amazon's repo
yum -y update			# get the latest security updates

## system configuration
# redirect port 8080 to port 80 so we don't have to run tomcat as root
# http://forum.slicehost.com/index.php?p=/discussion/2497/iptables-redirect-port-80-to-port-8080/p1
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
chkconfig sendmail off

# install the rest of the software we need
# git is needed for the build
yum -y install git 
# ant gives us better java
yum -y install ant 

################################################################################
#   pkgsrc requirements
yum -y install ncurses-devel ncurses
yum -y install zlib-devel zlib
yum -y install openssl-devel openssl
yum -y install gcc
yum -y install gcc-c++
yum -y install libstdc++-devel
#   pkgsrc requirements end
################################################################################

easy_install pip
pip install awscli

# if we run the jar file; we need daemonize
yum -y install http://fr2.rpmfind.net/linux/dag/redhat/el5/en/x86_64/dag/RPMS/daemonize-1.6.0-1.el5.rf.x86_64.rpm

# these aren't strictly necessary for the application but will be usful for debugging

# iotop is a handy utility on linux
pip install http://guichaz.free.fr/iotop/files/iotop-0.4.4.tar.gz


# _   /|  ack is a tool like grep, optimized for programmers
# \'o.O'  http://beyondgrep.com
# =(___)=
#    U    ack!
curl http://beyondgrep.com/ack-1.96-single-file > /usr/local/bin/ack && chmod 0755 /usr/local/bin/ack


DELIM

# only on the t1.micro, tune swap
if [ "$EC2_SIZE" == 't1.micro' ]; then
  cat >> aws_init.sh << DELIM
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

#TODO: Add ansible bootstrap and run of appropriate playbook

gzip aws_init.sh
#base64 aws_init.sh.gz > aws_init.sh.gz.base64

command="aws ec2 run-instances 
     --region $EC2_REGION 
     --monitoring file://monitoring.json
     --placement file://placement.json
     --instance-type $EC2_SIZE                       
     --min-count 1                                   
     --image-id $AMI_EBS                             
     --max-count 1                                   
     --user-data file://aws_init.sh.gz
     --key-name UCLDC_keypair_0
     --security-groups Solr
     --iam-instance-profile name=s3-readonly"

echo "ec2 launch command $command"

# launch an ec2 and grab the instance id
instance=`$command | jq '.Instances[0] | .InstanceId' -r`

echo "DONE WITH INSTANCE LAUNCH: $instance"

name_cmd="aws ec2 create-tags --region $EC2_REGION --resources ${instance} --tags key=Name,value=UCLDC_Solr"
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

#TODO: cleanup init file aws_init.sh.gz

#Associate with our solr-dev elastic ip address
#retval=`aws ec2 associate-address --region=$EC2_REGION --instance-id $instance --public-ip 107.21.228.130`
