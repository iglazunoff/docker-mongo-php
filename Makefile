# Base
VERSION=1.0.0
PROJECT_NAME=app
GIT_BRANCH_PROD=master
GIT_BRANCH_DEV=dev

# Colors
RED=\033[0;31m
GREEN=\033[0;32m
ORANGE=\033[0;33m
BLUE=\033[0;34m
RED_B=\033[1;31m
GREEN_B=\033[1;32m
ORANGE_B=\033[1;33m
BLUE_B=\033[1;34m
RED_UL=\033[4;31m
GREEN_UL=\033[4;32m
ORANGE_UL=\033[4;33m
BLUE_UL=\033[4;34m
NC=\033[0m

# Content
LINE=------------------------------------------------------

# Commands
help:
	@echo "$(LINE)"
	@echo "$(ORANGE_UL)Application name: $(PROJECT_NAME)"
	@echo "$(GREEN_B)Makefile version: $(VERSION)"
	@echo "$(NC)"
	@echo "$(BLUE_B)Production git branch:$(NC)  $(BLUE_UL)$(GIT_BRANCH_PROD)$(NC)"
	@echo "$(BLUE_B)Development git branch:$(NC) $(BLUE_UL)$(GIT_BRANCH_DEV)$(NC)"
	@echo "$(NC)$(LINE)"
	@echo "$(ORANGE_UL)$(GREEN_B)Makefile commands:$(NC)"
	@echo "$(GREEN_B)env$(NC)...............$(ORANGE)Create ENV files$(NC)"
	@echo "$(GREEN_B)network$(NC)...........$(ORANGE)Create project network$(NC)"
	@echo "$(GREEN_B)network-drop$(NC)......$(ORANGE)Drop project network$(NC)"
	@echo "$(GREEN_B)networks$(NC)..........$(ORANGE)Show docker networks$(NC)"
	@echo "$(GREEN_B)build$(NC).............$(ORANGE)Build docker containers$(NC)"
	@echo "$(GREEN_B)build-no-cache$(NC)....$(ORANGE)Build docker containers without cache$(NC)"
	@echo "$(GREEN_B)start$(NC).............$(ORANGE)Start docker containers$(NC)"
	@echo "$(GREEN_B)up$(NC)................$(ORANGE)Up docker containers$(NC)"
	@echo "$(GREEN_B)stop$(NC)..............$(ORANGE)Stop docker containers$(NC)"
	@echo "$(GREEN_B)down$(NC)..............$(ORANGE)Down docker containers$(NC)"
	@echo "$(GREEN_B)down-all$(NC)..........$(ORANGE)Down docker containers with volumes and images$(NC)"
	@echo "$(GREEN_B)restart$(NC)...........$(ORANGE)Restart docker containers$(NC)"
	@echo "$(GREEN_B)reload$(NC)............$(ORANGE)Reload docker containers$(NC)"
	@echo "$(GREEN_B)ps$(NC)................$(ORANGE)Show docker containers$(NC)"
	@echo "$(GREEN_B)init$(NC)..............$(ORANGE)Init docker containers and project$(NC)"
	@echo "$(GREEN_B)php$(NC)...............$(ORANGE)Open console of PHP container$(NC)"
	@echo "$(GREEN_B)supervisor$(NC)........$(ORANGE)Open console of Supervisor container$(NC)"
	@echo "$(GREEN_B)mongo$(NC).............$(ORANGE)Open console of MongoDB container$(NC)"
	@echo "$(GREEN_B)npm-i$(NC).............$(ORANGE)Install NPM packages$(NC)"
	@echo "$(GREEN_B)npm-update$(NC)........$(ORANGE)Update NPM packages$(NC)"
	@echo "$(GREEN_B)npm-dev$(NC)...........$(ORANGE)Run NPM dev mode (watch)$(NC)"
	@echo "$(GREEN_B)npm-build$(NC).........$(ORANGE)Build project assets$(NC)"
	@echo "$(GREEN_B)composer$(NC)..........$(ORANGE)Run composer install$(NC)"
	@echo "$(GREEN_B)composer-dump$(NC).....$(ORANGE)Run composer dump-autoload$(NC)"
	@echo "$(GREEN_B)composer-update$(NC)...$(ORANGE)Composer update packages$(NC)"
	@echo "$(GREEN_B)pull-dev$(NC)..........$(ORANGE)Get updates from git branch $(GIT_BRANCH_DEV)$(NC)"
	@echo "$(GREEN_B)sync-dev$(NC)..........$(ORANGE)Sync updates with git branch $(GIT_BRANCH_DEV)$(NC)"
	@echo "$(GREEN_B)pull-prod$(NC).........$(ORANGE)Get updates from git branch $(GIT_BRANCH_PROD)$(NC)"
	@echo "$(GREEN_B)sync-prod$(NC).........$(ORANGE)Sync updates with git branch $(GIT_BRANCH_PROD)$(NC)"
	@echo "$(GREEN_B)dev$(NC)...............$(ORANGE)Run development mode & watch$(NC)"
	@echo "$(GREEN_B)deploy$(NC)............$(ORANGE)Run production mode & build$(NC)"
	@echo "$(LINE)"

env:
	@cp docker/environments/.env.example .env
	@cp docker/environments/.env.app.example .env.app

network:
	@docker network create \
    -o com.docker.network.bridge.name=$(PROJECT_NAME) \
    --driver=bridge \
    $(PROJECT_NAME)-network

networks:
	@docker network ls

network-drop:
	@docker network rm $(PROJECT_NAME)-network

build:
	@docker-compose build

build-no-cache:
	@docker-compose build --no-cache

start:
	@docker-compose start

up:
	@docker-compose up -d

stop:
	@docker-compose stop

down:
	@docker-compose down

down-all:
	@docker-compose down -v
	@make network-drop

restart:
	@make stop
	@make start

reload:
	@make down
	@make build
	@make up

ps:
	@docker-compose ps

init:
	@make network
	@make build-no-cache
	@make up
	@make npm-i
	@make composer
	@make ps

php:
	@docker exec -it "$(PROJECT_NAME)-php" bash

supervisor:
	@docker exec -it "$(PROJECT_NAME)-supervisor" bash

mongo:
	@docker exec -it "$(PROJECT_NAME)-mongo" bash

npm-i:
	@docker exec -it "$(PROJECT_NAME)-php" npm install

npm-update:
	@docker exec -it "$(PROJECT_NAME)-php" npm update

npm-dev:
	@docker exec -it "$(PROJECT_NAME)-php" npm run dev

npm-build:
	@docker exec -it "$(PROJECT_NAME)-php" npm run build

composer:
	@docker exec -it "$(PROJECT_NAME)-php" composer install

composer-dump:
	@docker exec -it "$(PROJECT_NAME)-php" composer dump-autoload

composer-update:
	@docker exec -it "$(PROJECT_NAME)-php" composer update

pull-dev:
	@git checkout $(GIT_BRANCH_DEV)
	@git pull

sync-dev:
	@git fetch
	@git merge/origin-$(GIT_BRANCH_DEV)

pull-prod:
	@git checkout $(GIT_BRANCH_PROD)
	@git pull

sync-prod:
	@git fetch
	@git merge/origin-$(GIT_BRANCH_PROD)

dev:
	@make stop
	@make pull-dev
	@make npm-i
	@make composer-install
	@make npm-dev
	@make start
	@make ps

deploy:
	@make stop
	@make pull-prod
	@make npm-i
	@make composer-install
	@make npm-build
	@make start
	@make ps