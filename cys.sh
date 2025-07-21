#!/bin/bash

set -e  # Error aaya toh turant exit ho ja

# Check if cys.env exists in current directory
if [[ ! -f "$(pwd)/cys.env" ]]; then
  echo "❌ Error: cys.env file not found in $(pwd)"
  exit 1
fi

# Remove existing container if running
if docker ps -a --format '{{.Names}}' | grep -q '^cysic-node$'; then
  echo "⚠️ Container 'cysic-node' already exists. Removing..."
  docker stop cysic-node || true
  docker rm cysic-node || true
fi

# Run the Docker container
echo "🚀 Running cysic-node container..."
docker run -d \
  --name cysic-node \
  -v "$(pwd)/cys.env:/env/cys.env" \
  rohan014233/cysic-runner

echo "✅ Container 'cysic-node' started successfully!"
