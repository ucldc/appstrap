sudo yum -y groupinstall "Development Tools"
sudo yum --enablerepo epel -y install \
  boost141-devel \
  cronolog \
  curl-devel \
  git \
  httpd24-devel \
  jq \
  libxml2-devel \
  libxslt-devel \
  mod24_ssl \
  mod24_wsgi-python27 \
  monit \
  mysql-devel \
  openssl-devel \
  python26-virtualenv \
  python27-devel \
  python27-pip \
  python27-virtualenv
