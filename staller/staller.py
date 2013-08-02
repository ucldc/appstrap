# -*- coding: utf8 -*-

from lxml.html import parse
import os
from urllib2 import urlopen
import urllib2
import urllib
import hashlib
from functools import partial
# import gnupg
import subprocess
import tempfile

def key_import(urls, tmp):
    for url in urls:
        keys = downloadChunks(url , tmp)
        subprocess.check_call(["gpg", "--import", keys])

def scraper(url, package, tmp):
    """find and validate source tar.gz with md5 and pgp signatures
    searches for links to the 'package' on the 'url', downloads the .tar.gz, .tar.gz.md5, and .tar.gz.asc
    uses the .tar.gz.md5 and the .tar.gz.asc to validate the .tar.gz
    returns the path to the .tar.gz file inside of 'tmp'
    """
    # print "%s %s" % ( url, package )
    doc = parse(urlopen(url)).getroot()
    doc.make_links_absolute(url)
    links = doc.xpath("//a[contains(@href,'%s')]/@href" % package, )
    download_url = [i for i in links if i.endswith('.tar.gz')][0]
    # sometimes the download link does not let you download
    if download_url.startswith('http://www.apache.org/dyn/closer.cgi'):
        doc2 = parse(urlopen(download_url)).getroot()
        download_url = doc2.xpath("//a[contains(@href,'%s')][1]/@href" % package, )[0]
    # pp(download_url)
    archive = downloadChunks( download_url , tmp)
    md5_file = downloadChunks( [i for i in links if i.endswith('tar.gz.md5')][0], tmp)
    checksum = md5sum(archive)
    # make sure the checksum is correct
    print checksum
    assert(checksum in open(md5_file).read())
    pgp_file = downloadChunks( [i for i in links if i.endswith('tar.gz.asc')][0], tmp)
    subprocess.check_call(["gpg", "--verify", pgp_file, archive ])
    return archive

def md5sum(filename):
    # http://stackoverflow.com/a/7829658/1763984
    with open(filename, mode='rb') as f:
        d = hashlib.md5()
        for buf in iter(partial(f.read, 128), b''):
            d.update(buf)
    return d.hexdigest()

def downloadChunks(url, temp_path):
    """Helper to download large files https://gist.github.com/gourneau/1430932"""
 
    try:
         
        req = urllib.urlopen(url)  # urllib works with normal file paths
        # total_size = int(req.info().getheader('Content-Length').strip())
        baseFile = os.path.basename(req.url)
        file = os.path.join(temp_path,baseFile)
        downloaded = 0
        CHUNK = 256 * 10240
        with open(file, 'wb') as fp:
            while True:
                chunk = req.read(CHUNK)
                downloaded += len(chunk)
                # print math.floor( (downloaded / total_size) * 100 )
                if not chunk: break
                fp.write(chunk)
    except urllib2.HTTPError, e:
        print "HTTP Error:",e.code , url
        return False
    except urllib2.URLError, e:
        print "URL Error:",e.reason , url
        return False
 
    return file

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
