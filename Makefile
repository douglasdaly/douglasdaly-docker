#!make
.PHONY: build push repo_login

#
#	Helpers
#

include .env


#
#	Recipes
#

all: build push

build:
	@echo "[INFO] Building docker images..."
	docker-compose build

push: repo_login
	@echo "[INFO] Pushing docker images to repository..."
	docker-compose push

repo_login:
	@echo "[INFO] Logging into AWS ECR..."
	@eval `aws ecr get-login --no-include-email --region $(AWS_REGION) | sed 's|https://||'`