sudo yum -y groupinstall "Development Tools"
sudo yum --enablerepo epel -y install \
  cronolog \
  curl-devel \
  git \
  hg \
  httpd-devel \
  java-1.8.0-openjdk-devel \
  jq \
  libxml2-devel \
  libxslt-devel \
  mod_ssl \
  monit \
  mysql-devel \
  openssl-devel \
  python27-devel \
  python27-pip \
  python27-virtualenv
