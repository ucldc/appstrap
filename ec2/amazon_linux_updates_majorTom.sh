#!/usr/bin/env bash
if [[ -n "$DEBUG" ]]; then
  set -x
fi
Merge branch 'master' of https://github.com/ucldc/appstrap into ec2

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

yum --security check-update || {
  sudo yum update --security -y
  # nginx updates make this dir owned by root
  chown -R ec2-user:ec2-user /usr/share/nginx/html/
  wall "applied security patches, time for a reboot in 30 seconds"
  sleep 30
  sudo init 6
}
