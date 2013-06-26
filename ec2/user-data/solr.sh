#!/bin/bash
# cloudinit script
# https://help.ubuntu.com/community/CloudInit
# this gets run as root on the amazon machine when it boots up
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

# This should be sharable across the various UCLDC machines using 
# appstrap & pkgsrc to build out the installed software
# just add your specific packages after this template file

# install packages we need from amazon's repo
yum -y update			# get the latest security updates

# install the rest of the software we need
# git is needed for the build
yum -y install git 

# handles pkgsrc requirements
yum -y groupinstall "Development Tools"
easy_install pip
pip install virtualenv

pip install boto_rsync      # put this in the system python
yum -y install python-devel  # needed to install(init?) virtualenv with local python
yum -y install ncurses-devel # needed to install pkgsrc python
yum -y install dialog
yum -y install openssl-devel
yum -y install libjpeg-devel
yum -y install freetype-devel
yum -y install libtiff-devel
yum -y install lcms-devel

su - ec2-user -c 'curl https://raw.github.com/tingletech/appstrap/master/cdl/ucldc-operator-keys.txt >> ~/.ssh/authorized_keys'

useradd solr
touch ~solr/init.sh
chown solr:solr ~solr/init.sh
chmod 700 ~solr/init.sh
# write the file
cat > ~solr/init.sh <<EOSETUP
#!/usr/bin/env bash
cd
git clone https://github.com/tingletech/appstrap.git
./appstrap/cronic/atnow ./appstrap/stacks/stack_solr
./appstrap/ansible-virtualenv/init.sh
. ./appstrap/ansible-virtualenv/bin/activate
ansible-playbook localhost ./appstrap/playbooks/solr-playbook.yml
EOSETUP
su - solr -c ~solr/init.sh
rm ~solr/init.sh 
