# hull_provisioning

## Hyrax

The included Vagrantfile and scripts will build, configure and start a working Hyrax either locally in Vagrant or (if configured) in AWS.

NOTE: Before running either the local vagrant or aws provisioning, create a local directory hyrax/fits and download fits-1.2.0.zip.

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
```

```
cd hyrax
vagrant up --provider aws
```

#### Additional Step
We need to set the IP of the server in the apache config and .rbenv-vars This is done using an elastic IP and the AWS_IP environment variable above - the elastic IP needs to be created in AWS.

### Troubleshooting

#### Solr hasn't installed

We download the latest solr from the apache mirror. When the version changes, our link breaks.  Check the version set at the top of provision_scripts/provision_solr.sh against the latest version on the apache solr site and update as necessary.
