###
Using this repo:

```
make login
make provision
```

## Notes
https://github.com/ansible/ansible/issues/13026
`ec2.py` dynamic inventory is waiting this PR (https://github.com/ansible/ansible/issues/15215) to get sts assume_role feature in it. In this repo, we are already using the version mentioned on the thread

https://github.com/BWITS/ansible/blob/devel/contrib/inventory/ec2.py