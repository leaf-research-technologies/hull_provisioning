#!/bin/bash

##############################
# Install Apache and mod_ssl #
##############################
yes | yum install -y httpd mod_ssl
systemctl enable httpd.service

######################################
# Add the new configs and soft links #
######################################
cp /tmp/config/hyrax.conf /etc/httpd/conf.d/hyrax.conf

###########
# SELinux #
###########
# Disable SELINUX
setenforce 0
# Disable permenantly
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config