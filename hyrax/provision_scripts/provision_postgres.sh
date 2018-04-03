#!/bin/bash

####################
# Install postgres #
####################
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7
# Install version 9.6

# Edit /etc/yum.repos.d/CentOS-Base.repo to add exclude=postgresql* in the [base] and [updates] sections
if ! grep -q /etc/yum.repos.d/CentOS-Base.repo "exclude=postgresql"; then
sed -i 's/#released updates/exclude=postgresql*\n\n#released updates/' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/#additional packages that may be useful/exclude=postgresql*\n\n#additional packages that may be useful/' /etc/yum.repos.d/CentOS-Base.repo
fi

yes | yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yes | yum install -y postgresql96-server postgresql96-contrib postgresql96-devel
/usr/pgsql-9.6/bin/postgresql96-setup initdb

# change ident to md5 in /var/lib/pgsql/data/pg_hba.conf
sed -i 's/ident/md5/' /var/lib/pgsql/9.6/data/pg_hba.conf

systemctl start postgresql-9.6.service
systemctl enable postgresql-9.6.service