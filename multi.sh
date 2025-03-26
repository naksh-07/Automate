#!/bin/bash
set -e

# Stop and remove existing container if it's running
if docker ps -a | grep -q multiple-container; then
    echo "🛑 Removing existing container..."
    docker stop multiple-container && docker rm multiple-container
fi

# Pull the latest image from GHCR
echo "📥 Pulling the latest image from GHCR..."
docker pull ghcr.io/sujarnam/multiple-service:latest

# Run the container in detached mode
echo "🚀 Starting the container in detached mode..."
docker run -d --name multiple-container --env-file=multi.env ghcr.io/sujarnam/multiple-service:latest

# Show success message
echo "✅ Container started successfully!"
echo "📜 To view logs, run: docker logs -f multiple-container"
