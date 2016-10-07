# source this script on your shell to use its functions on cli

# docker engine provisioning on aws
function tid-dm-create {
  echo -e "Creating docker-host with docker-machine utility...\n"
  echo    "Remember to have valid AWS creds available either"
  echo    "on your session or in $HOME/.aws/credentials."
  docker-machine create \
    --driver amazonec2 \
    --amazonec2-ami ami-13be557e \
    --amazonec2-region us-east-1 \
    --amazonec2-vpc-id vpc-221fae47 \
    --amazonec2-zone e \
    --amazonec2-subnet-id subnet-4e8eec74 \
    --amazonec2-instance-type t2.medium docker-devopslabs-$(whoami)

  echo -e "\nRunning docker env setup"
  eval $(docker-machine env docker-devopslabs-$(whoami)) && echo "Ready" || echo "ERROR"
}

function tid-dm-destroy {
  echo -e "\nTerminating docker-host with docker-machine utility"
  docker-machine rm docker-devopslabs-$(whoami)
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

