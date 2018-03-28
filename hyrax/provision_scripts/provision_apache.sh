#!/bin/bash

##############################
# Install Apache and mod_ssl #
##############################
yes | yum install -y httpd mod_ssl
systemctl enable httpd.service

#####################################################
# Configure httpd.conf to read other configurations #
#####################################################
# if ! grep -q sites-enabled "/etc/httpd/conf/httpd.conf"; then
# echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
# fi

######################################
# Add the new configs and soft links #
######################################
cp /tmp/config/hyrax.conf /etc/httpd/conf.d/hyrax.conf

###########
# SELinux #
###########
# http://sysadminsjourney.com/content/2010/02/01/apache-modproxy-error-13permission-denied-error-rhel/
# /etc/sysconfig/selinux - set to permissive
setenforce 0
# also set permenantly
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
# otherwise this is what's needed
# /usr/sbin/setsebool -P httpd_can_network_connect 1

########################################################################################
# Install IIPImage                                                                     #
# See http://iipimage.sourceforge.net/2013/07/iipimage-now-an-official-fedora-package/ #
########################################################################################

yes | yum install -y iipsrv iipsrv-httpd-fcgi

cp /tmp/config/iipsrv.conf /etc/httpd/conf.d/iipsrv.conf

# IIP runs as apache so we need to allow apache to write to the iip log file
touch /var/log/iipsrv/iipsrv.log
chown apache:apache /var/log/iipsrv/iipsrv.log