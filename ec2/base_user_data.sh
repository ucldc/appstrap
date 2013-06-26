#!/bin/bash
# cloudinit script
# https://help.ubuntu.com/community/CloudInit
# this gets run as root on the amazon machine when it boots up

# This should be sharable across the various UCLDC machines using 
# appstrap & pkgsrc to build out the installed software

# Start your ec2 launch script with
# cat base_user_data.sh > <your_user_data_init_file.sh>
# and then append additional requirements of that particular server with
# inline documents
# cat >> bozo_ec2_init.sh << DELIM
# useradd bozo
# DELIM

# install packages we need from amazon's repo
yum -y update			# get the latest security updates

# install the rest of the software we need
# git is needed for the build
yum -y install git 
# ant gives us better java
yum -y install ant 

yum -y groupinstall "Development Tools"
pip install boto_rsync      # put this in the system python
yum -y install python-devel  # needed to install(init?) virtualenv with local python
yum -y install dialog

################################################################################
#   pkgsrc requirements
yum -y install ncurses-devel # needed to install pkgsrc python
yum -y install zlib-devel
yum -y install openssl-devel
yum -y install gcc
yum -y install gcc-c++
yum -y install libstdc++-devel # for java
#   pkgsrc requirements end
################################################################################
