#!/bin/bash
set -e

# Define the image
IMAGE="ghcr.io/sujarnam/multiple-service:latest"
CONTAINER_NAME="multiple-container"
ENV_FILE="multi.env"

# Stop and remove existing container if it exists
if docker ps -a | grep -q $CONTAINER_NAME; then
    echo "Removing existing container..."
    docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
fi

# Pull the latest image
echo "Pulling the latest image from GHCR..."
docker pull $IMAGE

# Run the container with the environment file
echo "Starting the container..."
docker run -d --name $CONTAINER_NAME --env-file=$ENV_FILE $IMAGE

# Check logs
docker logs -f $CONTAINER_NAME
