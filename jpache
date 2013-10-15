#!/usr/bin/env python
# -*- coding: utf8 -*-

import sys, os
import argparse
from pprint import pprint as pp
import tempfile
# import gnupg
import subprocess
import shutil
from staller.staller import scraper, key_import

def main(argv=None):
    packages = [
        ( 'http://ant.apache.org/bindownload.cgi', 
          'apache-ant', 
        ),
        ( 'http://maven.apache.org/download.cgi', 
          'apache-maven',
        ),
        ( 'http://tomcat.apache.org/download-70.cgi', 
          'apache-tomcat',
        ),
    ]

    parser = argparse.ArgumentParser( )
    parser.add_argument('-p', '--prefix', required=True)
    parser.add_argument('-t', '--tempdir', required=False)
    parser.add_argument('-f', '--force', action='store_true', required=False)

    if argv is None:
        argv = parser.parse_args()

    if os.path.isfile(os.path.join(argv.prefix,'apache-ant','bin','ant')) and not argv.force:
        print "been done? use -f/--force to force rebuild"
        exit(0)

    keys = [ 
        'http://www.apache.org/dist/ant/KEYS', 
        'http://www.apache.org/dist/maven/KEYS', 
        'https://www.apache.org/dist/tomcat/tomcat-connectors/KEYS',
	'https://www.apache.org/dist/tomcat/tomcat-7/KEYS'
    ]

    if argv.tempdir:
        tempfile.tempdir = argv.tempdir

    tmp = tempfile.mkdtemp(prefix="apache_java_")
    key_import(keys, tmp)
    os.chdir(tmp)
    pp(tmp)

    for (url, package) in packages:
        archive = scraper(url, package, tmp)
        os.chdir(argv.prefix)
        print subprocess.check_output(['tar', 'zxf', archive])
        src_dir = archive[:-7] # strip off '.tar.gz'
        src_dir = os.path.basename(src_dir)
        if src_dir.endswith('-bin'):
            src_dir = src_dir[:-4]
        print src_dir
        try:
            os.symlink(src_dir, package)
        except OSError, e:
            if e.errno != 17 and not argv.force: #symlink already exists OK
                raise e
    shutil.rmtree(tmp)

# main() idiom for importing into REPL for debugging 
if __name__ == "__main__":
    sys.exit(main())

"""
Copyright © 2013, Regents of the University of California
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
- Neither the name of the University of California nor the names of its
  contributors may be used to endorse or promote products derived from this 
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
"""
