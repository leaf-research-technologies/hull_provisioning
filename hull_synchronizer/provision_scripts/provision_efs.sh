#!/bin/bash

EFS="fs-8506984c"
MNT="/data/efs"

################################
# Install dependencies for EFS #
################################
yes | yum install -y rpm-build

mkdir -p /data/efs
chown hullsync:hullsync /data/efs

##############################
# Mount EFS and add to fstab #
##############################

cd /tmp/
git clone https://github.com/aws/efs-utils
cd /tmp/efs-utils
make rpm
yes | yum -y install ./build/amazon-efs-utils*rpm

sudo mount -t efs $EFS:/ $MNT

echo -e "\n$EFS:/ $MNT efs defaults,nofail,_netdev 0 0" >> /etc/fstab

# TODO Stunnel tls stuff