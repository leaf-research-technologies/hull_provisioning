# Leaf Provisioning

## Hyrax

The included Vagrantfile and scripts will build, configure and start a working Hyrax either locally in Vagrant or (if configured) in AWS.

### Prerequisites

Before running either the local vagrant or aws provisioning:

1. create a local directory hyrax/fits and download the version of fits specified at the top of `provision_scripts/provision_prereq.sh` (currently fits-1.2.0.zip)
2. create a local directory hyrax/extras - put any extra files or configurations that you want to use in this folder

### Vagrant

```
cd hyrax
vagrant up
```

Hyrax: https://localhost

Fedora: http://localhost:8080/fcrepo

Solr: http://localhost:8983/solr

### AWS

Install the vagrant env plugin

```
vagrant plugin install vagrant-env
```

Create a file called `.env` containing the following

```
KEYPAIR_NAME="NAME_OF_KEYPAIR"
KEYPAIR_FILE="KEYPAIR_FILE.pem"
AWS_ACCESS_KEY="ACCESS_KEY"
AWS_SECRET_KEY="SECRET_KEY"
AWS_SECURITY_GROUPS="SECURITY_GROUP_IDS" # (space separated, eg. sg-1234 sg-5678)
AWS_SUBNET="SUBNET_ID"
AWS_IP="ELASTIC_IP_ADDRESS"
AWS_INSTANCE="AWS INSTANCE" # (eg. m4.large)
```

```
cd hyrax
vagrant up --provider aws
```

#### Additional Step for AWS
We need to set the IP of the server in the apache config and .rbenv-vars This is done using an elastic IP and the AWS_IP environment variable above - the elastic IP needs to be created in AWS.

### The box

#### 

User `centos` is automatically created and used for ssh.

User `hyrax` runs the hyrax application. Run any hyrax commands with this users, eg. rails db:migrate

#### Locations

* Hyrax application: /var/lib/hyrax 
* Hyrax, sidekiq and puma logs: /var/log/hyrax

#### Start/Stop

```
sudo service puma stop|start|restart
sudo service sidekiq stop|start|restart
```
