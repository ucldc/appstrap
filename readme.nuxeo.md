circa 2021

as per
https://confluence.ucop.edu/display/CUG/Amazon+Linux+2+User+Guide#AmazonLinux2UserGuide-ShibbolethServiceProvider

```
$ curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "platform=CentOS_7" https://shibboleth.net/cgi-bin/sp_repo.cgi -o shib_centos7.repo
$ sudo yum-config-manager --add-repo shib_centos7.repo
$ rm shib_centos7.repo
$ sudo yum -y install shibboleth
```

## other packages
```
sudo yum install httpd
sudo yum install git
sudo yum install ansible
sudo yum install ack
sudo yum install patch
sudo yum install monit
sudo yum install mod_ssl
sudo yum install cronolog
```


## setup role account

```
sudo adduser nuxeo
sudo su - nuxeo
git clone -b linux2 git@github.com:ucldc/appstrap.git
cd appstrap/ansible
ansible-playbook -i host_inventory nuxeo-front-playbook.yml 
```

## shibboleth keys and certs

these go in `/home/nuxeo/servers/shibboleth/etc/`

## user setup from blackstar
