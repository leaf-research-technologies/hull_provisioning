# hull_provisioning

## Hyrax

The included Vagrantfile and scripts will build, configure and start a working Hyrax.

NOTE: Before running either the local vagrant or aws provisioning, create a local directory hyrax/fits and download fits-1.2.0.zip - this is excluded from github because it's quite a big file.

### Vagrant Box

```
cd hyrax
vagrant up
```

Hyrax: https://localhost
Fedora: http://localhost:8080/fcrepo
Solr: http://localhost:8983/solr

### AWS

TODO