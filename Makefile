#!/usr/bin/make -f
IMAGE := daccbr/phalcon
PHALCON_VERSION := 3.4.2
DEVTOOLS_VERSION := 3.4.1
PHP_VERSION := 7.3
DOCKER_BUILD_ARG := --build-arg http_proxy --build-arg https_proxy
# PSR_VERSION := 0.6.1

.PHONY: all build push update variants clean

# ------------------------------------------------------------------------------

all: build

build: update
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE) -f dockerfiles/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION) -f dockerfiles/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-alpine -f dockerfiles/alpine/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):php$(PHP_VERSION)-alpine -f dockerfiles/alpine/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):alpine -f dockerfiles/alpine/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-apache -f dockerfiles/apache/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):php$(PHP_VERSION)-apache -f dockerfiles/apache/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):apache -f dockerfiles/apache/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-fpm -f dockerfiles/fpm/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):php$(PHP_VERSION)-fpm -f dockerfiles/fpm/Dockerfile .
	# docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):fpm -f dockerfiles/fpm/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-fpm-alpine -f dockerfiles/fpm-alpine/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):php$(PHP_VERSION)-fpm-alpine -f dockerfiles/fpm-alpine/Dockerfile .
	docker build $(DOCKER_BUILD_ARG) -t=$(IMAGE):fpm-alpine -f dockerfiles/fpm-alpine/Dockerfile .

push:
	docker push $(IMAGE):$(PHALCON_VERSION)
	docker push $(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)
	docker push $(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-alpine
	docker push $(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-apache
	docker push $(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-fpm
	docker push $(IMAGE):$(PHALCON_VERSION)-php$(PHP_VERSION)-fpm-alpine

pull:
	docker pull php:$(PHP_VERSION)
	docker pull php:$(PHP_VERSION)-alpine
	docker pull php:$(PHP_VERSION)-apache
	docker pull php:$(PHP_VERSION)-fpm
	docker pull php:$(PHP_VERSION)-fpm-alpine

update:
	@echo Update Phalcon version to $(PHALCON_VERSION) ...
	@find */**/Dockerfile */Dockerfile -exec sed -i 's/^ARG PHALCON_VERSION=.*/ARG PHALCON_VERSION=$(PHALCON_VERSION)/g' {} +;
	@echo Update PHP version to $(PHP_VERSION) ...
	@find */**/Dockerfile */Dockerfile -exec sed -i 's/^FROM php:[0-9.]*/FROM php:$(PHP_VERSION)/g' {} +;
	@echo Update PSR version to $(PSR_VERSION) ...
	@find */**/Dockerfile */Dockerfile -exec sed -i 's/^ARG PSR_VERSION=[0-9.]*/ARG PSR_VERSION=$(PSR_VERSION)/g' {} +;
	@# Makefile
	@sed -i 's/^VERSION := .*/VERSION := $(PHALCON_VERSION)/g' Makefile
	@# shields
	@sed -i 's/Phalcon-[^-]*/Phalcon-$(PHALCON_VERSION)/g' README.md
	@# readme test version
	@sed -i 's/Version => .*/Version => $(PHALCON_VERSION)/g' README.md
	@echo Update Phalcon-devtools version to $(DEVTOOLS_VERSION) ...
	@find docker-phalcon-install-devtools -exec sed -i 's/^INSTALL_VERSION=.*/INSTALL_VERSION=$(DEVTOOLS_VERSION)/g' {} +;
	@sed -i 's/^DEVTOOLS_VERSION := .*/DEVTOOLS_VERSION := $(DEVTOOLS_VERSION)/g' Makefile
	@sed -i 's/^PHP_VERSION := .*/PHP_VERSION := $(PHP_VERSION)/g' Makefile
	@# shields
	@sed -i 's/phalcon--devtools-[^-]*/phalcon--devtools-$(DEVTOOLS_VERSION)/g' README.md

variants: php
	@find php -name "Dockerfile" | sed 's/php\/\(.*\)\/Dockerfile/\1/'

php:
	git clone -q --depth 1 https://github.com/docker-library/php.git php

clean:
	rm -rf php
