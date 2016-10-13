docker_run = docker run --env-file role_credentials --rm -it
dckimage = buildpack-$(shell basename `git rev-parse --show-toplevel`)

build.toolset:
	docker build -t $(dckimage) .

provision: role_credentials build.toolset
	@$(docker_run) $(dckimage) -i inventories site.yml	

# AWS access and authorization management
AWS_DEFAULT_PROFILE ?= sts
oktaname ?= $(LOGNAME)
login:
	oktaauth \
    --username $(oktaname) \
    --server thoughtworks.okta.com \
    --apptype amazon_aws \
    --appid exk1au43i2tG7m4Nc0h8 | \
    aws_role_credentials saml \
    --profile $(AWS_DEFAULT_PROFILE)

# assume role specific ami build role for the sake of standard
role_credentials: $(HOME)/.aws/credentials
	./set_role_credentials.sh InfraBuilderAdmin 921251377951 $(oktaname)

destroy: build.toolset
	@$(docker_run) --entrypoint /bin/bash $(dckimage) -c \
	"aws cloudformation delete-stack --stack-name gocd-server-rafa --region us-east-1"

# buildpack container shell for build tasks debugging
docker.shell: role_credentials
	@$(docker_run) --entrypoint /bin/bash $(dckimage)
