#!/bin/bash -e
# borrowed from Erik Doernenburg:
# https://my.thoughtworks.com/groups/techops-community/blog/2015/11/17/aws-account-access-via-temporary-api-tokens#comment-38435
PROFILE="${AWS_DEFAULT_PROFILE:-sts}"
ROLE="${1:-ReadOnly}"
ACCOUNT="${2:-MISSING}"
NAME="${3:-$LOGNAME@`hostname -s`}"
DURATION="${4:-3600}"
echo "PROFILE: $PROFILE"
echo "ROLE: $ROLE"
echo "ACCOUNT: $ACCOUNT"
echo "NAME: $NAME"
echo "DURATION: $DURATION"
 
# KST=access*K*ey, *S*ecretkey, session*T*oken
KST=(`aws sts assume-role --role-arn "arn:aws:iam::$ACCOUNT:role/$ROLE" \
--role-session-name "$NAME" \
--duration-seconds $DURATION \
--query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' \
--output text --profile $PROFILE`)

# place temp creds in file for container usage
cat << EOF > role_credentials
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
AWS_ACCESS_KEY_ID=${KST[0]}
AWS_SECRET_ACCESS_KEY=${KST[1]}
AWS_SESSION_TOKEN=${KST[2]}
EOF

# place temp cred in environment for development via Vagrant
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
export AWS_ACCESS_KEY_ID=${KST[0]}
export AWS_SECRET_ACCESS_KEY=${KST[1]}
export AWS_SESSION_TOKEN=${KST[2]}

