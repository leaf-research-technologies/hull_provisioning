#!/bin/bash

############################################
# This script will install and configure:  #
# - hyrax                                  #
############################################

AWS_IP=aws-ip

mkdir -p /data/hyrax/derivatives /data/hyrax/uploads /data/hyrax/imports /data/hyrax/working /data/hyrax/network_files

echo 'cloning hyrax_leaf into /var/lib'
cd /var/lib
git clone https://github.com/leaf-research-technologies/hyrax_leaf hyrax

source ~/.bash_profile

cd /var/lib/hyrax

cp /tmp/rbenv/.rbenv-vars-todo .rbenv-vars

if [ -d /vagrant ]; then 
    sed -i "s/APPLICATION_HOST_TODO/localhost/g" .rbenv-vars
else
    sed -i "s/APPLICATION_HOST_TODO/$AWS_IP/g" .rbenv-vars
fi
rbenv vars

# Install and Setup
gem install pg -v '0.21.0' -- --with-pg-config=/usr/pgsql-9.6/bin/pg_config

bundle install --without development test

KEY=$(rake secret)
sed -i "s/SECRET_KEY_BASE_TODO/$KEY/g" .rbenv-vars

# generators will fail if db doesn't exist
# DB will exist on production server, so you may see an error here
rake db:create

echo 'Setting up ... '
rake db:migrate
rake hyrax:default_admin_set:create
rake hyrax:workflow:load

# add the qa index as per https://github.com/samvera/questioning_authority
echo 'Add the index to the database - the password here is the'
echo 'hyrax DATABASE PASSWORD:'
bash -c "psql -U hyrax -h 127.0.0.1 hyrax -c \"CREATE INDEX index_qa_local_authority_entries_on_lower_label ON qa_local_authority_entries (local_authority_id, lower(label));\""

# precompile assets
rake assets:precompile

# TODO add some users


echo 'Start puma, sidekiq; restart apache'
sudo systemctl start sidekiq
sudo systemctl start puma
sudo systemctl restart httpd