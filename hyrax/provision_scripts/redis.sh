#!/bin/bash

##############################
# Install Redis (needs EPEL) #
##############################
# See https://support.rackspace.com/how-to/install-epel-and-additional-repositories-on-centos-and-red-hat/

yes | sudo yum install -y epel-release

# If the above doesn't work
if yum repolist | grep epel; then
  echo 'EPEL is enabled'
else
  echo 'Adding the EPEL Repo'
  sudo hyrax wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo rpm -Uvh epel-release-latest-7*.rpm
fi

yes | sudo yum install -y redis

##################################
# Start Redis and enable at boot #
##################################

# See http://sharadchhetri.com/2014/10/04/install-redis-server-centos-7-rhel-7/
# bind redis to 0.0.0.0 to allow external monitoring
# sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf

echo 'Starting Redis'
sudo systemctl start redis.service
echo 'Enable Redis start at boot'
sudo systemctl enable redis.service