#!/usr/bin/env bash
if [[ -n "$DEBUG" ]]; then 
  set -x
fi

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR

. ../bashrc/role-account

virtualenv --no-site-packages .
set +u
source bin/activate
set -u
pip install -r requirements.txt --use-mirrors

echo "don't forget to `. bin/activate` to activate virtualenv"
