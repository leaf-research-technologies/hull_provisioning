#!/bin/bash

# TODO https://github.com/seuros/capistrano-puma

####################################
# Add puma as a systemd service #
####################################
sudo cp /tmp/config/puma.service /etc/systemd/system/

######################
# Change permissions #
######################
sudo chmod 664 /etc/systemd/system/puma.service

####################
# Reload systemctl #
####################
sudo systemctl daemon-reload

#####################
# Enable at startup #
#####################
sudo systemctl enable puma.service
