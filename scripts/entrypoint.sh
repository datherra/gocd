#!/bin/bash -e

# load ssh private key from credstash
credstash get devopslabs-us-east-1_ssh_key > /iac/devopslabs.priv
chmod 400 /iac/devopslabs.priv || echo "ERROR loading private ssh key"
ansible-playbook $@
