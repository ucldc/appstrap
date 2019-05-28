sudo yum -y groupinstall "Development Tools"
sudo amazon-linux-extras install epel
sudo yum -y install \
  boost \
  cronolog \
  git \
  httpd24 \
  jq \
  libxslt \
  mod_ssl \
  mod_wsgi \
  mariadb \
  mariadb-devel \
  openssl \
  python3 \
  python-virtualenv \
  stunnel

ln ~/bin/python /usr/lib/python3
ln ~/bin/pip /usr/lib/pip3