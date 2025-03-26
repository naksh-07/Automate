#!/bin/bash

# Set Variables
POP_ENV_FILE="pop.env"
NODE_ENV_FILE="node.env"
NODE_INFO_FILE="node_info.json"
CACHE_DIR="download_cache"
DOCKER_IMAGE="rohan014233/pop_service"
DOCKER_CONTAINER="pop_container"

# Function to check if command exists
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo "Error: $1 is not installed. Please install it."; exit 1; }
}

# Check for required commands
check_command docker
check_command jq  # JSON processing tool for node_info.json

# Create required directory
mkdir -p "$CACHE_DIR"

# Ask if the user is a first-time user or experienced
echo "Are you running this for the first time? (yes/no)"
read -r FIRST_TIME_USER

if [[ "$FIRST_TIME_USER" == "yes" ]]; then
    # First-time user: Run normally
    echo "Proceeding with first-time setup..."
    
    # Prompt user for referral code
    echo "Please enter your referral code:"
    read -r REFERRAL_CODE

    # Ensure pop.env exists
    if [[ ! -f "$POP_ENV_FILE" ]]; then
        echo "Error: Configuration file $POP_ENV_FILE not found! Creating a template..."
        cat <<EOF > "$POP_ENV_FILE"
RAM=8
MAX_DISK=500
CACHE_DIR=/data
SOLANA_PUBKEY=your_solana_public_key_here
EOF
        echo "Please edit '$POP_ENV_FILE' to add your Solana Public Key before running again."
        exit 1
    fi

    # Load pop.env variables
    source "$POP_ENV_FILE"

else
    # Experienced user: Generate node_info.json from node.env
    if [[ ! -f "$NODE_ENV_FILE" ]]; then
        echo "Error: Node configuration file $NODE_ENV_FILE not found!"
        exit 1
    fi

    echo "Generating node_info.json from $NODE_ENV_FILE..."
    jq '.' "$NODE_ENV_FILE" > "$NODE_INFO_FILE"
    echo "✅ node_info.json has been created!"
fi

# Remove any existing container
docker rm -f "$DOCKER_CONTAINER" 2>/dev/null

# Pull the latest Docker image
echo "Pulling latest Docker image..."
docker pull "$DOCKER_IMAGE"

# Run the Docker container
echo "Running Docker container..."
docker run -d --name "$DOCKER_CONTAINER" \
  -v "$(pwd)/$CACHE_DIR:/data" \
  --restart unless-stopped \
  "$DOCKER_IMAGE"

echo "✅ Service is running in Docker as '$DOCKER_CONTAINER'!"
