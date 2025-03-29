#!/bin/bash

# Set Variables
CACHE_DIR="download_cache"
POP_ENV_FILE="pop.env"
NODE_ENV_FILE="node.env"
NODE_INFO_FILE="node_info.json"
DOCKER_IMAGE="rohan014233/pop_service"  # Updated to use Docker Hub image
DOCKER_CONTAINER="pop_container"

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo "Error: $1 is not installed. Please install it."; exit 1; }
}

# Check for required commands
check_command docker
check_command jq  # JSON processing tool for node_info.json

# Create required directory
mkdir -p "$CACHE_DIR"

# Ensure node.env exists
if [[ ! -f "$NODE_ENV_FILE" ]]; then
    echo "Error: Node configuration file $NODE_ENV_FILE not found!"
    exit 1
fi

# Generate node_info.json from node.env
echo "Generating node_info.json from $NODE_ENV_FILE..."
jq '.' "$NODE_ENV_FILE" > "$NODE_INFO_FILE"
echo "✅ node_info.json has been created!"

# Remove any existing container
docker rm -f "$DOCKER_CONTAINER" 2>/dev/null

# Pull the latest Docker image from Docker Hub
echo "Pulling latest Docker image from Docker Hub..."
docker pull "$DOCKER_IMAGE"

# Run the Docker container (Mounting pop.env & node_info.json)
echo "Running Docker container..."
docker run -d --name "$DOCKER_CONTAINER" \
  -v "$(pwd)/$CACHE_DIR:/data" \
  -v "$(pwd)/$POP_ENV_FILE:/app/pop.env" \
  -v "$(pwd)/$NODE_INFO_FILE:/app/node_info.json" \
  --restart unless-stopped \
  "$DOCKER_IMAGE"

echo "✅ Service is running in Docker as '$DOCKER_CONTAINER'!"
