#!/bin/bash

USER="hyrax"
RAILS="5.1.4"
BRANCH="master"
GEM="git@bitbucket.org:ulcc-art/hyrax_skel.git"
GEM_KEY="hyrax_skel"
# Create a sample model (just one)
MODEL=""
  
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

git checkout $BRANCH

# Add the Gem
if [ ! -z "$GEM" ]; then
  yes | git clone $GEM vendor/$GEM_KEY
  # add to Gemfile

  if ! grep -q "$GEM_KEY" "/var/lib/hyrax/Gemfile"; then
    echo -e "\ngem '"$GEM_KEY"', :path => 'vendor/"$GEM_KEY"'" >> /var/lib/hyrax/Gemfile
  fi
fi

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
rake hyrax:default_admin_set:create
rake hyrax:workflow:load
rake hyrax:default_collection_types:create
rake hyrax:controlled_vocabularies:language
if [ ! -z "$MODEL" ]; then
  rails generate hyrax:work $MODEL
fi

# Install the gem
if [ ! -z "$GEM" ]; then
  rails g $GEM_KEY:install -f
fi

# add the qa index as per https://github.com/samvera/questioning_authority
bash -c "PGPASSWORD=$USER psql -U $USER -h 127.0.0.1 $USER -c \"CREATE INDEX index_qa_local_authority_entries_on_lower_label ON qa_local_authority_entries (local_authority_id, lower(label));\""

exit 0