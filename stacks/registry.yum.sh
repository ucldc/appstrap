sudo yum -y groupinstall "Development Tools"
sudo amazon-linux-extras install epel
sudo yum -y install \
  boost-devel \
  cronolog \
  git \
  httpd-devel \
  jq \
  libxslt-devel \
  mariadb-devel \
  mod_ssl \
  mod_wsgi \
  monit \
  python36-devel \
  python36-pip \
  python36-virtualenv \
  stunnel