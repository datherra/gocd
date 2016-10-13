# Template for AWS Shared Service Account

## Using this repo:

### pre-req
* Having access to the DevOps Labs AWS account.
  Get in touch with us via __#slack__ to request access:
  https://thoughtworks.slack.com/archives/devopslabs

* Python 2.7 and some libraries for authentication tooling
  ```
  pip install -r requirements.txt
  ```

### Provisioning everything 
```
make login
make provision
```

## Utils
Sometimes when running `docker build`, you can face problems with bandwith heavy operations like `apt-get update` commands and others.
To help with that, you can execute your docker containers on a docker host running in AWS, meaning that these operations will then use Amazon's Internet pipes.
On the __utils__ folder you find scripts to manage this remote docker host.

#### Provisioning docker host instance on AWS
Docker Machine is a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with `docker-machine` commands.
The script below has wrapper functions for this tool with custom DevOps Labs AWS configs already in it.
Make sure you have the latest version of [docker-machine](https://github.com/docker/machine/releases/), otherwise you're gonna run an unsecure EC2 Linux Instance.

First, source the script on your shell to use its functions:
```
source utils/tid-utils.sh
```

Then, to get your AWS Docker Hosts running, authenticate in AWS with `oktaauth` and run:
```
tid-dm-create
```

This will take sometime, as `docker-machine` tool is spining up one instance and provisioning it with the latest docker engine version. If it is taking too much time on `Waiting for SSH to be available...` message, verify your VPN connection to ELK.
That's all. Check the created machine name typing:
```
docker-machine active
```

PS: the configs for the remote docker host is available only on the current shell session. To enable on others, type:
```
eval $(docker-machine env <machine-name>)
```
Where machine name follows the `docker-<your_username>` pattern.

#### Overcoming docker-machine problem with AWS temporary tokens
Your AWS authentication via `oktaauth` uses AWS STS service and it lasts 1 hour.
After this time, `docker-machine` won't be able to manage the remote docker host anymore, even after you have re-authenticated yourself.
To fix this, authenticate in AWS with `oktaauth` again, then run:
```
utils/update-remote-docker-creds.py <profile_name> <machine_name>
```

This will help until Docker fix this:
https://github.com/docker/machine/issues/1840

## Notes
https://github.com/ansible/ansible/issues/13026
`ec2.py` dynamic inventory is waiting this PR (https://github.com/ansible/ansible/issues/15215) to get sts assume_role feature in it. In this repo, we are already using the version mentioned on the thread

https://github.com/BWITS/ansible/blob/devel/contrib/inventory/ec2.py

## TODO
[ ] VPC - add bastion host