#!/bin/bash 
#
# grabs apache solr from a mirror and unpacks it to JAVA_HOME
#
set -eu

solrVer=4.3.1
solr=solr-$solrVer
md5="Can't find one for solr from it's download page"

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR
ls
if [ -e $solr.tgz ]; then
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

wget "$mirror/lucene/solr/$solrVer/$solr.tgz"
check=`checksum $solr.tgz` 	# check the checksum
# http://tldp.org/LDP/abs/html/comparison-ops.html
# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
if ! [[ "$check" == $md5* ]]; then
  echo "files don't match"
  exit 1
fi
tar zxf $solr.tgz
ln -s $solr solr
