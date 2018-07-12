#!/bin/bash

USER="hullsync"
RAILS="5.2"
BRANCH="master"
  
if [ "$(whoami)" != $USER ]; then
  echo "Script must be run as user: $USER"
  exit -1
fi

# Make sure we our rbenv setup loaded
source ~/.bash_profile

#################
# Install rails #
#################

echo 'Installing rails '$RAILS
gem install rails -v $RAILS

cd /var/lib

git clone https://github.com/leaf-research-technologies/hull_synchronizer.git hullsync

cd /var/lib/hullsync

git checkout $BRANCH

cp /tmp/rbenv/.rbenv-vars-todo .rbenv-vars

gem install pg -v '0.21.0' -- --with-pg-config=/usr/pgsql-9.6/bin/pg_config

bundle install --without development test

KEY=$(rake secret)
sed -i "s/SECRET_KEY_BASE_TODO/$KEY/g" .rbenv-vars

rbenv vars

# precompile assets
rake assets:precompile

echo 'Setting up ... '
rake db:migrate

exit 0
