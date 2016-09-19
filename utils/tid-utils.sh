# source this script on your shell to use its functions on cli

# docker engine provisioning on aws
function tid-dm-create {
  echo -e "Creating docker-host with docker-machine utility...\n"
  echo    "Remember to have valid AWS creds available either"
  echo    "on your session or in $HOME/.aws/credentials."
  echo -e "ELK VPN connection is required as well.\n"
  docker-machine create \
    --driver amazonec2 \
    --amazonec2-region us-east-1 \
    --amazonec2-vpc-id vpc-b2c22cd6 \
    --amazonec2-zone e \
    --amazonec2-subnet-id subnet-4d2bc070 \
    --amazonec2-private-address-only \
    --amazonec2-instance-type t2.medium docker-infradel-$(whoami)

  echo -e "\nRunning docker env setup"
  eval $(docker-machine env docker-$(whoami)) && echo "Ready" || echo "ERROR"
}

function tid-dm-destroy {
  echo -e "\nTerminating docker-host with docker-machine utility"
  docker-machine rm docker-$(whoami)
}

# snippet to help w/ multiple aws cli profiles
function tid-aws-set-profile {
  if [[ -z $1 ]]; then
    echo "Usage: aws-set-profile <AWS profile name>"
    echo -e "Available profiles are:\n"
    sed -n  's|\[\(.*\)\]|\1|gp' ~/.aws/credentials
    return 1
  fi
  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}

# list cloudformation stacks (excludes deleted stacks)
# awscli query language for JSON: http://jmespath.org/
function tid-cfn-list {
  aws cloudformation list-stacks --region us-east-1 --output table \
  --query "StackSummaries[?StackStatus != 'DELETE_COMPLETE'].\
          {\
            Stack: StackName,\
            Status: StackStatus, \
            Created: CreationTime, \
            Updated: LastUpdatedTime\
          }"
}

