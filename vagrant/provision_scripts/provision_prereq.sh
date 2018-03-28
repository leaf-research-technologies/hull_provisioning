#!/bin/bash

FITS="1.2.0"

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

#######################################
# Install LibreOffice and ImageMagick #
#######################################
echo 'Installing LibreOffice, ImageMagick and Redis'
# LibreOffice
yes | yum install –y libreoffice
# Install ImageMagick
yes | yum install –y ImageMagick

##################################
# Install Mediainfo (needs EPEL) #
##################################
# Mediainfo is needed for Fits; it requires the EPEL repo
# otherwise fits "Error loading native library for MediaInfo please check that fits_home is properly set"
echo 'Installing Mediainfo'
yes | yum install -y libmediainfo libzen mediainfo

#####################
# Install Tesseract #
#####################
echo 'Installing tesseract'
yes | yum install -y tesseract

##########################
# Install Fits into /opt #
##########################
# See https://github.com/projecthydra-labs/hyrax#characterization
cd /usr/local
if [ ! -d fits ]
then
  echo 'Downloading Fits '$FITS
  # because of problems with the download, we use a local copy of fits
  # wget http://projects.iq.harvard.edu/files/fits/files/fits-$FITS.zip
  mv /tmp/fits-$FITS.zip /usr/local/
  unzip fits-$FITS.zip
  rm fits-$FITS.zip
  mv /usr/local/fits-$FITS/ /usr/local/fits
  chmod a+x fits/fits.sh
  ln -s /usr/local/fits/fits.sh /usr/bin/fits
  chmod -R 777 /usr/local/fits # TODO don't use 777!
else
  echo 'Fits is already here, moving on ... '
fi

##################
# Install nodejs #
##################
# Temporary workaround for http-parser issue: https://bugs.centos.org/view.php?id=13669&nbn=1
# or yum--enablerepo=cr
echo 'Installing nodejs'
rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
yes | yum install -y nodejs

##################
# Add user/group #
##################
echo 'Adding the hyrax user'
adduser hyrax
gpasswd -a hyrax wheel
groupadd hyrax
usermod -a -G hyrax hyrax
echo hyrax:hyrax | sudo chpasswd



