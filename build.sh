#!/bin/bash

USER_NAME=arnaudhb
IMG_NAME=$(basename $(pwd))
IMG_TAG=build-automation

# Make some cleanup
docker rm -f `docker ps -a | grep "$USER_NAME/$IMG_NAME " | awk '{print $1}'` > /dev/null 2>&1
docker rmi `docker images -f "dangling=true" -q` > /dev/null 2>&1

# Comment out to start from a fresh image (with no cache)
docker rmi `docker images  | grep "$USER_NAME/$IMG_NAME " | awk '{print $3}'` > /dev/null 2>&1 

docker build -t "$USER_NAME/$IMG_NAME" .
docker build -t "$USER_NAME/$IMG_NAME:$IMG_TAG" .
