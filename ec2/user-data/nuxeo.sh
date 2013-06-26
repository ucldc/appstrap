#!/bin/bash
# cloudinit script
# https://help.ubuntu.com/community/CloudInit
yum -y update    # for security
yum -y install git
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

useradd nuxeo
touch ~nuxeo/init.sh
chown nuxeo:nuxeo ~nuxeo/init.sh
chmod 700 ~nuxeo/init.sh
# write the file
cat > ~nuxeo/init.sh <<EOSETUP
#!/usr/bin/env bash
cd
git clone https://github.com/tingletech/appstrap.git
./appstrap/cronic/atnow ./appstrap/stacks/stack_nuxeo
EOSETUP
su - nuxeo -c ~nuxeo/init.sh
rm ~nuxeo/init.sh 
