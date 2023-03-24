#!/bin/bash

#docker rm consumer-python
docker build -t consumer-python:1.0.0 .
docker images
docker run -it -e LOCAL=true --network flask consumer-python:1.0.0
docker ps -a

