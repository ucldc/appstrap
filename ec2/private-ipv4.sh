#! /bin/sh
# Returns the private ip address for the instance
curl http://169.254.169.254/latest/meta-data/local-ipv4
