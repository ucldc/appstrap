#!/usr/bin/env bash
set -u
. ${HOME}/appstrap/setenv.bash
. ${HOME}/.tomcat-setenv.bash
# http://stackoverflow.com/questions/3356476/debugging-monit
$@
