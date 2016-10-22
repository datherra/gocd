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

## Utils Folder
Check info there to find handy functions and wrappers for having a remote docker engine host on AWS (faster builds) and AWS CloudFormation infos on your CLI


## Notes
https://github.com/ansible/ansible/issues/13026
`ec2.py` dynamic inventory is waiting this PR (https://github.com/ansible/ansible/issues/15215) to get sts assume_role feature in it. In this repo, we are already using the version mentioned on the thread

https://github.com/BWITS/ansible/blob/devel/contrib/inventory/ec2.py

## TODO
[ ] VPC - add bastion host