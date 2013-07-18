#! /bin/sh
# Returns the public ip address for the instance
curl http://169.254.169.254/latest/meta-data/public-ipv4
