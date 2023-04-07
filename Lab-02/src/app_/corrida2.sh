#!/bin/bash
docker build -t app-python:1.0.0 . 
docker network create flask
docker run -d --name service-flask-app --network flask -p 8000:8000 app-python:1.0.0
