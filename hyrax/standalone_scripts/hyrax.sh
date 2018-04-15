#!/bin/bash

USER="hyrax"
RAILS="5.1.4"
  
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

git clone https://github.com/leaf-research-technologies/hyrax_leaf.git hyrax

cd /var/lib/hyrax

cp /tmp/rbenv/.rbenv-vars-todo .rbenv-vars

gem install pg -v '0.21.0' -- --with-pg-config=/usr/pgsql-9.6/bin/pg_config

echo "gem 'dog_biscuits', :git => 'git://github.com/geekscruff/dog_biscuits.git'" >> /var/lib/hyrax/Gemfile

bundle install --without development test

KEY=$(rake secret)
sed -i "s/SECRET_KEY_BASE_TODO/$KEY/g" .rbenv-vars

rbenv vars

echo 'Setting up ... '
rake db:migrate
rake hyrax:default_admin_set:create
rake hyrax:workflow:load

# Generate works
rails generate dog_biscuits:install
cp /tmp/config/dog_biscuits.rb /var/lib/hyrax/config/initializers/dog_biscuits.rb
rails generate dog_biscuits:generate_all

# add the qa index as per https://github.com/samvera/questioning_authority
bash -c "PGPASSWORD=$USER psql -U $USER -h 127.0.0.1 $USER -c \"CREATE INDEX index_qa_local_authority_entries_on_lower_label ON qa_local_authority_entries (local_authority_id, lower(label));\""

# precompile assets
rake assets:precompile

exit 0