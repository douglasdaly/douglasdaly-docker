#!make

#
#	Default Configuration Settings
#

# Default Deployment Settings
#   (these can be overridden in local .env file)
DEPLOYMENT_TYPE=AWS


#
#	MAKEFILE
#

.PHONY: requirements configure \
		all build push deploy \
		debug debug_build debug_run \
		stage stage_build stage_push \
		deploy_aws aws_login

#
#	Tools
#

PYTHON=python
PIP=pip


#
#	Helpers
#

# Load env (if exists)
ifneq ("$(wildcard .env)", "")
    include .env
endif

# Deploy Types Handling
# - Push Command
PUSH_COMMAND_PRE=@echo ""
ifeq ($(DEPLOYMENT_TYPE), AWS)
	PUSH_COMMAND_PRE=@make --quiet aws_login
endif

# - Deploy Command
ifeq ($(DEPLOYMENT_TYPE), AWS)
	DEPLOY_COMMAND=@make --quiet deploy_aws
else
	DEPLOY_COMMAND=@echo "[ERROR] Not a supported platform for deployment!"
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
	
push:
	@echo "[INFO] Pushing production docker images to repository..."
	$(PUSH_COMMAND_PRE) && docker-compose -f docker-compose.yml push

deploy:
	$(DEPLOY_COMMAND)

# - Staging related

stage: stage_build stage_push

stage_build:
	@echo "[INFO] Building Staging docker images..."
	docker-compose -f docker-compose.stage.yml build --no-cache --force-rm

stage_push: aws_login
	@echo "[INFO] Pushing staging docker images to repository..."
	$(PUSH_COMMAND_PRE) && docker-compose -f docker-compose.stage.yml push

# - Debug related

debug: debug_build debug_run

debug_build:
	@echo "[INFO] Building Debug docker images..."
	docker-compose -f docker-compose.debug.yml build --no-cache --force-rm

debug_run:
	@echo "[INFO] Running on local machine..."
	docker-compose -f docker-compose.debug.yml up

# - Helpers

# -- AWS

aws_login:
	@echo "[INFO] Logging into AWS ECR..."
	@eval `aws ecr get-login --no-include-email --region $(AWS_REGION) | sed 's|https://||'`

deploy_aws: aws_login
	@echo "[INFO] Deploying EB application..."
	#eb deploy
