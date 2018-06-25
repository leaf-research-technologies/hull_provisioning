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

#############################
# Add ssh keys (if present) #
#############################
if [ -d /tmp/extras/ssh ]; then
    cp /tmp/extras/ssh/* /home/hyrax/.ssh/
    chmod 600 /home/hyrax/.ssh/id_rsa
    chmod 700 /home/hyrax/.ssh/id_rsa.pub
fi

########################################
# Create direcotories, change ownerhip #
########################################
mkdir /var/lib/$APP
mkdir /var/log/$APP
mkdir /var/run/$APP
mkdir -p /data/$APP

chown $USER:$USER /var/lib/$APP
chown $USER:$USER /var/log/$APP
chown $USER:$USER /var/run/$APP
chown $USER:$USER /data/$APP

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE $APP;\""
sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE $APP TO $USER;\""

##########################
# Run standalone scripts #
##########################
cd /tmp
sudo -u $USER bash -c "./rbenv.sh"
sudo -u $USER bash -c "./hyrax.sh"

##########################
# Start/Restart services #
##########################
systemctl restart sidekiq
systemctl restart puma
systemctl restart httpd