#!/bin/bash
# cloudinit script
# https://help.ubuntu.com/community/CloudInit
yum -y update    # for security
yum -y install git
yum -y groupinstall "Development Tools"
pip install boto_rsync      # put this in the system python
yum -y install python-devel  # needed to install(init?) virtualenv with local python
yum -y install ncurses-devel # needed to install pkgsrc python
yum -y install dialog
yum -y install ant   # gives us the jdk

useradd nuxeo

# create role account
# copy authorized_keys into the role account

