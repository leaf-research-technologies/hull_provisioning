#!/bin/bash

RUBY="2.4.1"
RAILS="5.1.4"

################################################
# Install rbenv https://github.com/rbenv/rbenv #
# Install rbenv into /usr/local                #
################################################

# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7
# TODO (users/groups if needed) https://blakewilliams.me/posts/system-wide-rbenv-install

echo 'Installing rbenv'

cd ~/
HOMEPATH=$(pwd)

if [ ! -d rbenv ]
then
  echo 'rbenv not installed; installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git ~/rbenv
  echo "export RBENV_ROOT=$HOMEPATH/rbenv" >> ~/.bash_profile
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git ~/rbenv/plugins/ruby-build
  git clone https://github.com/rbenv/rbenv-vars.git ~/rbenv/plugins/rbenv-vars
  echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
else
  echo 'rbenv is installed, moving on ...'
fi

# Reload bash_profile
source ~/.bash_profile

################
# Install ruby #
################

echo 'Installing ruby '$RUBY
rbenv install $RUBY
rbenv global $RUBY

#################
# Install rails #
#################

echo 'Installing rails '$RAILS
gem install rails -v $RAILS
