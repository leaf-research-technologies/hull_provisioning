#!/bin/bash

############################################
# This script will install and configure:  #
# - hyrax                                  #
############################################

USER=hyrax
APP=hyrax

##################
# Add user/group #
##################
echo 'Adding the hyrax user'
adduser $USER
groupadd $USER
usermod -a -G $USER $USER
echo $USER:$USER | sudo chpasswd

mkdir /var/lib/$APP
mkdir /var/log/$APP
mkdir /var/run/$APP
mkdir -p /data/$APP

chown $USER:$USER /var/lib/$APP
chown $USER:$USER /var/log/$APP
chown $USER:$USER /var/run/$APP
chown $USER:$USER /data/$APP

cd /tmp
sudo -u $USER bash -c "./rbenv.sh"
sudo -u $USER bash -c "./hyrax.sh"

echo 'Start puma, sidekiq; restart apache'
systemctl restart sidekiq
systemctl restart puma
systemctl restart httpd