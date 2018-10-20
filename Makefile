#!make
.PHONY: requirements configure \
		all build push deploy \
		debug debug_build debug_run \
		deploy_aws aws_login

#
#	Variables
#

PYTHON=python
PIP=pip


#
#	Helpers
#

ifneq ("$(wildcard .env)", "")
    include .env
endif


#
#	Recipes
#

# - Setup

requirements:
	@echo "[INFO] Installing pip requirements..."
	$(PIP) install -r requirements.txt

configure:
	@echo "[INFO] Running configuration script..."
	$(PYTHON) scripts/configure.py

# - Production related

all: build push deploy

build: 
	@echo "[INFO] Building docker images..."
	docker-compose -f docker-compose.yml build --no-cache --force-rm

push: aws_login
	@echo "[INFO] Pushing docker images to repository..."
	docker-compose -f docker-compose.yml push

deploy:
	ifeq ($(DEPLOYMENT_TYPE), AWS)
		@make deploy_aws
	else
		@echo "[ERROR] Not a supported platform for deployment!"
	endif

# - Debug related

debug: debug_build debug_run

debug_build:
	@echo "[INFO] Building Debug docker images..."
	docker-compose -f docker-compose.debug.yml build --no-cache --force-rm

debug_run:
	@echo "[INFO] Running on local machine..."
	docker-compose -f docker-compose.debug.yml up

# - Helpers

aws_login:
	@echo "[INFO] Logging into AWS ECR..."
	@eval `aws ecr get-login --no-include-email --region $(AWS_REGION) | sed 's|https://||'`

deploy_aws: aws_login
	@echo "[INFO] Deploying EB application..."
	#eb deploy
