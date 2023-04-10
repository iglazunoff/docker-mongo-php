# Docker Mongo and PHP
Starter kit for projects with MongoDB, PHP and Redis.

## Navigation
- [Introduction](#introduction)
- [Quickstart](#quickstart)

## Introduction
### Containers
This starter kit includes the following containers and configurations for them:
- **PHP** (8.2.3 fpm)
- **Redis** (alpine)
- **MongoDB** (6.0.4)
- **Supervisor** (based on PHP container)
- **Nginx** like web-server

### Docker resources
Provide the following resources for Docker to work correctly:
- **RAM:** 2G and more
- **CPU:** 2 cores and more
- **Storage:** 6G and more
- **Swap:** 512M and more

### Environments
All default environment variables are located by paths:
- docker/environments/.env.example - for build containers
- docker/environments/.env.app.example - for your applications

### Make helpers
For simple project management, we recommend using the commands from the Makefile.
For show all make commands write in your terminal:
```shell
make help
```
OR
```shell
make
```

For open container terminal write in your terminal:
```shell
# php container
make php
```
```shell
# supervisor container
make supervisor
```
```shell
# MongoDB container
make mongo
```
Stop all containers:
```shell
make stop
```
Start all containers:
```shell
make start
```
Restart all containers:
```shell
make restart
```
Rebuild all containers:
```shell
make reload
```

## Quickstart
To initialize Docker containers and install composer and npm packages, write in your terminal:
```shell
make env
```
#### Write actual values to environment variables
```shell
make init
```
### OR
```shell
cp docker/environments/.env.example .env
cp docker/environments/.env.app.example .env.app
```
#### Write actual values to environment variables
```shell
docker network create \
    -o com.docker.network.bridge.name=$(PROJECT_NAME) \
    --driver=bridge \
    app-network

docker-compose build --no-cache
docker-compose up -d
docker exec -it "$(PROJECT_NAME)-php" composer install
docker exec -it "$(PROJECT_NAME)-php" npm install
```

## Nice!
### Follow these steps
- Initialization and first run will take 5 minutes or more, depending on the characteristics of your hardware and the resources allocated to Docker
- Write your code or install framework and then more
- It is recommended to use **root** or **src** as working directory
- The entry point will be the file **public/index.php**
- In the public directory, you can place all public files, such as robots.txt, sitemap.xml, etc. 
- Frontend assets will be in the directory **assets**

#### Good luck!