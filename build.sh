#!/bin/bash

# Variables for the docker commands
IMAGE_TAG=$1
CONTAINER_NAME=$2

# Build our image tag name
docker build -t $IMAGE_TAG .

# We run the container using the passed in values 
docker run --name="$CONTAINER_NAME" -dit $IMAGE_TAG