circa 2021

as per
https://confluence.ucop.edu/display/CUG/Amazon+Linux+2+User+Guide#AmazonLinux2UserGuide-ShibbolethServiceProvider

```
$ curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "platform=CentOS_7" https://shibboleth.net/cgi-bin/sp_repo.cgi -o shib_centos7.repo
$ sudo yum-config-manager --add-repo shib_centos7.repo
$ rm shib_centos7.repo
$ sudo yum -y install shibboleth
```

## Enable extra packages

```
sudo /usr/bin/amazon-linux-extras install epel
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

## no port mapping
Rather than the CDL standard of mapping 80<->18880; this host uses "linux capabilities" to give the apache server permission to listen on 80.

```
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/httpd
```
This needs to get reset whenver the package manager updates `httpd` or the binary otherwise changes.

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

made sure `authorized_keys` were set on the new machine (`ec2-user` and `nuxeo` acconts).  Set up TOFU from blackstar `nuxeo` account, and tested ssh command.
