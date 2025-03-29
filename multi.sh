#!/bin/bash
set -e

# Stop and remove existing container
if docker ps -a | grep -q multiple-container; then
    echo "Removing existing container..."
    docker stop multiple-container && docker rm multiple-container
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t multiple-service .

# Run the container with the environment file
echo "Starting the container..."
docker run -d --name multiple-container --env-file=multi.env multiple-service

# Check logs
docker logs -f multiple-container
