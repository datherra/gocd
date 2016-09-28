dckimage = buildpack-$(shell basename `git rev-parse --show-toplevel`)

build.toolset:
	docker build -t $(dckimage) .

# AMIs creation and query targets
provision: role_credentials build.toolset
	docker run --env-file role_credentials --rm -it $(dckimage) \
    "ansible-playbook -i inventories site.yml"

# AWS access and authorization management
AWS_DEFAULT_PROFILE ?= sts
oktaname ?= $(LOGNAME)
login:
	oktaauth \
    --username $(oktaname) \
    --server thoughtworks.okta.com \
    --apptype amazon_aws \
    --appid exk1au43i2tG7m4Nc0h8 \
    aws_role_credentials saml \
    --profile $(AWS_DEFAULT_PROFILE)

# assume role specific ami build role for the sake of standard
role_credentials: $(HOME)/.aws/credentials
	./set_role_credentials.sh InfraBuilderAdmin 921251377951 $(oktaname)

destroy: build.toolset
	@$(DOCKER_RUN) $(dckimage) \
	"aws cloudformation delete-stack --stack-name gocd-server-rafa --region us-east-1"

# buildpack container shell for build tasks debugging
docker.shell: role_credentials
	docker build -t $(dckimage) .
	docker run --env-file role_credentials --rm -it $(dckimage) bash
