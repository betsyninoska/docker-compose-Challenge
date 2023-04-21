#!/bin/bash

cd docker-compose-Challenge/docker-onfire-poke-app/backend-pokemon-app


docker build -t backend_pokemon .

docker images

docker run -d -p 8000:8000 backend_pokemon
docker ps -a
cd 
cd docker-compose-Challenge/docker-onfire-poke-app/frontend-pokemon-app/

docker build -t frontend_pokemon .
docker images
docker run -d -p 3000:3000 frontend_pokemon
docker ps -a


docker-compose up -d
