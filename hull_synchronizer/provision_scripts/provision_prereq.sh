#!/bin/bash

########################
# Install dependencies #
########################
echo 'Installing all the things'
yes | yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel bzip2 autoconf automake libtool bison curl sqlite-devel java-1.8.0-openjdk.x86_64 wget unzip
# Need make for installing the pg gem
yes | yum install -y make

########
# EPEL #
########
yes | yum install -y epel-release
# If the above doesn't work
if yum repolist | grep epel; then
  echo 'EPEL is enabled'
else
  echo 'Adding the EPEL Repo'
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -Uvh epel-release-latest-7*.rpm
fi

##################
# Install nodejs #
##################
# Temporary workaround for http-parser issue: https://bugs.centos.org/view.php?id=13669&nbn=1
# or yum--enablerepo=cr
echo 'Installing nodejs'
rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
yes | yum install -y nodejs
