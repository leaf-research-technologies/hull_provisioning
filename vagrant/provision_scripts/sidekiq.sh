#!/bin/bash

# TODO https://github.com/seuros/capistrano-sidekiq

####################################
# Add sidekiq as a systemd service #
####################################
sudo cp /tmp/config/sidekiq.service /etc/systemd/system/

######################
# Change permissions #
######################
sudo chmod 664 /etc/systemd/system/sidekiq.service

####################
# Reload systemctl #
####################
sudo systemctl daemon-reload

#####################
# Enable at startup #
#####################
sudo systemctl enable sidekiq.service
