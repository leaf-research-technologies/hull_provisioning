#!/bin/bash

RUBY="2.4.1"
USER="hyrax"

if [ "$(whoami)" != $USER ]; then
  echo "Script must be run as user: $USER"
  exit -1
fi

################################################
# Install rbenv https://github.com/rbenv/rbenv #
# Install rbenv into /usr/local                #
################################################

# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7

echo 'Installing rbenv'

cd ~/
HOMEPATH=$(pwd)

if [ ! -d $HOMEPATH/rbenv ]
then
  echo 'rbenv not installed; installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git $HOMEPATH/rbenv
  echo "export RBENV_ROOT=$HOMEPATH/rbenv" >> $HOMEPATH/.bash_profile
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> $HOMEPATH/.bash_profile
  echo 'eval "$(rbenv init -)"' >> $HOMEPATH/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git $HOMEPATH/rbenv/plugins/ruby-build
  git clone https://github.com/rbenv/rbenv-vars.git $HOMEPATH/rbenv/plugins/rbenv-vars
  echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> $HOMEPATH/.bash_profile
else
  echo 'rbenv is installed, moving on ...'
fi

# Reload bash_profile
source ~/.bash_profile

################
# Install ruby #
################

echo 'Installing ruby '$RUBY
# If Ruby is already installed, don't reinstall
echo 'N' | rbenv install $RUBY
rbenv global $RUBY

exit 0