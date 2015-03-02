#!/usr/bin/env bash
# Install puppet
set -e


#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

yum -y install wget
yum -y install http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-11.noarch.rpm
yum -y install puppet facter
yum -y install rubygems

/bin/rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
/usr/bin/yum install -y puppet facter

echo "Puppet installed!"

