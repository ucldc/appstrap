#!/bin/bash 
#
# grabs apache tomcat from a mirror and unpacks it to $HOME/java
# ansible will set up twincat style conf
#
set -eu

# will nedd to keep this up to date, server.xml template is for tomcat7
tomcatVer=7.0.41
tomcat=apache-tomcat-$tomcatVer
md5=cca4176d9901ca1300a56390c36fd6f0

export DIR_INSTALL="$HOME/java"
export DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR_INSTALL
if [ -e $tomcat.tar.gz ]; then
  echo "did you run me before? this should only be run once"
  exit 1
fi
checksum() {	# http://stackoverflow.com/questions/1299833/bsd-md5-vs-gnu-md5sum-output-format
        (md5sum <"$1"; test $? = 127 && md5 <"$1") | cut -d' ' -f1
}
which wget	# abort now if commands I need are not installed
# select a random mirror from mirrors.txt
# http://www.hilarymason.com/blog/how-to-get-a-random-line-from-a-file-in-bash/
mirror_length=`wc -l<${DIR_SCRIPT}/mirrors.txt|tr -d ' '`
mirror=`tail -$((RANDOM/(32767/$mirror_length))) ${DIR_SCRIPT}/mirrors.txt|head -1|tr -d "\n"`

wget "$mirror/tomcat/tomcat-7/v$tomcatVer/bin/$tomcat.tar.gz"
check=`checksum $tomcat.tar.gz` 	# check the checksum
# http://tldp.org/LDP/abs/html/comparison-ops.html
# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
if ! [[ "$check" == $md5* ]]; then
  echo "files don't match"
  exit 1
fi
tar zxf $tomcat.tar.gz
ln -s $tomcat tomcat
