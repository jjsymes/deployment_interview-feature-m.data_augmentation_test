IMAGE_TAG=data_augmentation_test

.DEFAULT_GOAL := help
.PHONY: help

help: # print make targets
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

build: # build image
	docker build --tag $(IMAGE_TAG) .

run: # run image
	docker run --name $(IMAGE_TAG) -p 8000:8000 $(IMAGE_TAG)

login: # login into running container
	docker exec -it $(IMAGE_TAG) /bin/bash

prune: # remover stopped containers
	docker container prune -f