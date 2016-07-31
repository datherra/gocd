
provision:
	docker build -t provision .
	docker run --rm \
		-v $(shell pwd):/iac \
		provision \
		pb-instance.yml --connection=local
