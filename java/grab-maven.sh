#!/bin/bash 
#
# grabs apache maven from a mirror and unpacks it
#
set -eu

# will nedd to keep this up to date, server.xml template is for tomcat7
mavenVer=3.0.5
maven=apache-maven-$mavenVer-bin
md5=94c51f0dd139b4b8549204d0605a5859

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR
if [ -e $maven.tar.gz ]; then
  echo "did you run me before? this should only be run once"
  exit 1
fi
checksum() {	# http://stackoverflow.com/questions/1299833/bsd-md5-vs-gnu-md5sum-output-format
        (md5sum <"$1"; test $? = 127 && md5 <"$1") | cut -d' ' -f1
}
which wget	# abort now if commands I need are not installed
# select a random mirror from mirrors.txt
# http://www.hilarymason.com/blog/how-to-get-a-random-line-from-a-file-in-bash/
mirror_length=`wc -l<twincat/mirrors.txt|tr -d ' '`
mirror=`tail -$((RANDOM/(32767/$mirror_length))) twincat/mirrors.txt|head -1|tr -d "\n"`

# http://apac          e.mirrors.pair.com/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
# http://www.bizdirusa.com/mirrors/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
# http://apache.petsads.us/maven/maven-3/3.0.5/bin/apache-maven-3.0.5.tar.gz
#   http://www.eng.lsu.edu/mirrors/apache//maven/maven-3/v3.0.5/bin/apache-maven-3.0.5.tar.gz

url="${mirror}maven/maven-3/$mavenVer/binaries/$maven.tar.gz"
echo $mirror
echo $url
wget $url
check=`checksum $maven.tar.gz` 	# check the checksum
# http://tldp.org/LDP/abs/html/comparison-ops.html
# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
if ! [[ "$check" == $md5* ]]; then
  echo "files don't match"
  exit 1
fi
tar zxf $maven.tar.gz
ln -s ${maven/-bin/} maven
