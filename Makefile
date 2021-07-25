IMAGE_TAG=data_augmentation_test
PATH_TO_INFRASTRUCTURE_FILES=infrastructure
WORKING_DIR=working

.DEFAULT_GOAL := help
.PHONY: help

help: # print make targets
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

pip_install: # install depedencies for testing
	pip3 install --user -r tests/requirements.txt && pip3 install --user -r requirements.txt

test: pip_install # test app
	python3 -m pytest

build: # build image
	docker build --tag $(IMAGE_TAG) .

run: # run image
	docker run --name $(IMAGE_TAG) -p 8000:8000 $(IMAGE_TAG)

login: # login into running container
	docker exec -it $(IMAGE_TAG) /bin/bash

prune: # remover stopped containers
	docker container prune -f

init: # terraform init
	cd $(PATH_TO_INFRASTRUCTURE_FILES) && \
	terraform init

apply: init # terraform apply
	cd $(PATH_TO_INFRASTRUCTURE_FILES) && \
	terraform apply

plan: init # terraform plan
	cd $(PATH_TO_INFRASTRUCTURE_FILES) && \
	terraform plan

destroy: init # terraform destroy
	cd $(PATH_TO_INFRASTRUCTURE_FILES) && \
	terraform destroy

output: init # terraform output
	cd $(PATH_TO_INFRASTRUCTURE_FILES) && \
	mkdir -p $(WORKING_DIR) && \
	terraform output --json > $(WORKING_DIR)/tfoutput.json

smoke_test: output # test deployment of app infrastructure
	curl -Is -K HEAD $(shell cat $(PATH_TO_INFRASTRUCTURE_FILES)/$(WORKING_DIR)/tfoutput.json | jq -r '.["default_site_hostname"] .value')/?url=https://imgs.xkcd.com/comics/bad_code.png
