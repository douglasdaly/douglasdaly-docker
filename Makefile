#!make
.PHONY: requirements configure \
		all build push deploy \
		debug debug_build debug_run \
		stage stage_build stage_push \
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
	docker-compose -f docker-compose.yml build --no-cache --force-rm --build-arg buildtype=production

push: aws_login
	@echo "[INFO] Pushing docker images to repository..."
	docker-compose -f docker-compose.yml push

deploy:
	ifeq ($(DEPLOYMENT_TYPE), AWS)
		@make deploy_aws
	else
		@echo "[ERROR] Not a supported platform for deployment!"
	endif

# - Staging related

stage: stage_build stage_push

stage_build:
	@echo "[INFO] Building Staging docker images..."
	docker-compose -f docker-compose.stage.yml build --no-cache --force-rm --build-arg buildtype=staging

stage_push: aws_login
	@echo "[INFO] Pushing staging docker images to repository..."
	docker-compose -f docker-compose.stage.yml push

# - Debug related

debug: debug_build debug_run

debug_build:
	@echo "[INFO] Building Debug docker images..."
	docker-compose -f docker-compose.debug.yml build --no-cache --force-rm --build-arg buildtype=development

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
