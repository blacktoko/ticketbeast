# ticketbeast

[![pipeline status](https://git.proserve.nl/tkoggel/ticketbeast/badges/develop/pipeline.svg)](https://git.proserve.nl/tkoggel/ticketbeast/commits/develop)
[![coverage report](https://git.proserve.nl/tkoggel/ticketbeast/badges/develop/coverage.svg)](https://git.proserve.nl/tkoggel/ticketbeast/commits/develop)

## Local/dev install

**Requirements:**
- [Docker](https://docs.docker.com/install/)
- [Ansible](https://docs.docker.com/install/)
- [docker/proxy](https://git.proserve.nl/dev/docker/proxy#install-and-usage-instructions)
- Login to our Docker Registry. More info [here](https://git.proserve.nl/dev/docker/proxy#docker-registry-login).
- Add Ansible Vault Password. More info [here](https://git.proserve.nl/dev/docker/proxy/wikis/ansible/vault-pass).

Start your project by running this:

```bash
ansible-playbook ./ansible/play/dev.yml --verbose
# if you want to override your existing (dot) config files:
ansible-playbook ./ansible/play/dev.yml -e envfiles_force=yes
docker network create satis
docker-compose up -d
```

## Ansible

Execute the below commands from the root of the project to encrypt/decrypt the Ansible variables:

```bash
ansible-vault decrypt ansible/envs/{000_cross_env_vars,*/*/*}/vault.yml
ansible-vault encrypt ansible/envs/{000_cross_env_vars,*/*/*}/vault.yml
```

### Vault password

Make sure that the file `ansible./vault_pass.txt` exists and that it contains the 40 character long "password". See [this](https://git.proserve.nl/dev/docker/proxy/wikis/ansible/vault-pass) Wiki page for the precise location. 

### Local testing of Ansible

```bash
ansible-playbook ./ansible/play/local_testing.yml -i ./ansible/envs/ci --verbose
```

## Miscellaneous

### Fixing composer.lock (auto)merges 

Fix merge conflicts in `composer.lock`:

```
composer update --lock
```

### Local package development

Create a `packages`-folder and make sure you git pull your packages in there.

Update Composer.json:

```
"repositories": 
    "local": {
        "type": "path",
        "url": "/packages/laravel-json-api"
    }
},
```

Update the php service in `docker-compose.override.yml`:

```
php:
  environment:
    COMPOSER_INSTALL_DEV: "false"
  volumes:
    - ./packages:/packages
```

Don't forget to restart the services!
