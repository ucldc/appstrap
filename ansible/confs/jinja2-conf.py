#!/usr/bin/env python
import os
import sys

# figure out the data

# what variables need to be filled in?
#  hostname of the machine
#  /apps/<application> i.e. $HOME / ~  "ansible_user_id": "nuxeo", 
#  IP address of the application ansible_facts.ansible_default_ipv4.address
#  hostname for the application = ansible_fqdn
#  entityId of the shibboleth SP = "${ansible_fqdn}/shibboleth"
# "ansible_fqdn": "nuxeo-dev.cdlib.org", 
# "ansible_hostname": "nuxeo-dev", 

data = {
    "ansible_facts": {
        "ansible_default_ipv4": {
            "address": "192.35.209.164", 
        },
        "ansible_fqdn": "nuxeo-dev.cdlib.org", 
        "ansible_hostname": "nuxeo-dev", 
        "ansible_user_id": "nuxeo", 
    }
}

from optparse import OptionParser

import jinja2
from jinja2 import Environment, FileSystemLoader

# https://github.com/mattrobenolt/jinja2-cli/blob/master/jinja2cli/cli.py

try:
    # Python 2
    import ConfigParser
except ImportError:
    # Python 3
    import configparser as ConfigParser

parser = OptionParser(usage="usage: %prog [options] <input template>")

opts, args = parser.parse_args()

if len(args) == 0:
    parser.print_help()
    sys.exit(1)

if args[0] == 'help':
    parser.print_help()
    sys.exit(1)

env = Environment(loader=FileSystemLoader(os.getcwd()))
sys.stdout.write(env.get_template(args[0]).render(data).encode('utf-8'))
sys.exit(0)
