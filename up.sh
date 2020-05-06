#!/bin/bash

docker network create service_network

cd nginx-proxy
docker-compose up -d
cd ..
cd nextcloud
docker-compose up -d
cd ..
cd bitwarden
docker-compose up -d
cd ..
cd heimdall
docker-compose up -d
cd ..
cd downloadsrv
docker-compose up -d
cd ..
