#!/bin/bash

FCREPO="4.7.4"

#############################
# Install and Enable tomcat #
#############################
yes | yum install -y tomcat tomcat-webapps
# optional tomcat-docs-webapp tomcat-admin-webapps
systemctl enable tomcat

##################
# Install Fcrepo #
##################
cd /var/lib/tomcat/webapps
wget -O fcrepo.war https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-$FCREPO/fcrepo-webapp-$FCREPO.war

################
# Add env vars #
################
if ! grep -q /usr/share/tomcat/conf/tomcat.conf "repo.modeshape.configuration"; then
echo "JAVA_OPTS=\"-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms1024m -Xmx2048m -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:+DisableExplicitGC -Dfcrepo.modeshape.configuration=file:/data/fcrepo/config/repository.json -Dfcrepo.home=/data/fcrepo/data -Dfcrepo.postgresql.username=fcrepo -Dfcrepo.postgresql.password=fcrepo -Dfcrepo.log=WARN -Dlogback.configurationFile=/data/fcrepo/config/logback.xml\""  >> /usr/share/tomcat/conf/tomcat.conf
fi

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
sudo -u postgres bash -c "psql -c \"CREATE DATABASE fcrepo;\""
sudo -u postgres bash -c "psql -c \"CREATE USER fcrepo WITH PASSWORD 'fcrepo';\""
sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE fcrepo TO fcrepo;\""

mkdir /data /data/fcrepo /data/fcrepo/data /data/fcrepo/config

cp /tmp/config/repository.json /data/fcrepo/config/
cp /tmp/config/logback.xml /data/fcrepo/config/

chown -R tomcat:tomcat /data/fcrepo

systemctl start tomcat
