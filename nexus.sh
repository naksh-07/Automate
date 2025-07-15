#!/bin/bash

set -e  # Stop on error

echo "🚀 Downloading nexus.txt from MEGA to current directory: $PWD"

# ✅ CORRECTED PATH
mega-get "/nexus.txt" "$PWD"

# Check if the file exists
if [[ ! -f "$PWD/nexus.txt" ]]; then
  echo "❌ nexus.txt not found in $PWD after download!"
  ls -la "$PWD"  # Show directory contents
  exit 1
fi

echo "✅ Downloaded nexus.txt successfully!"

# Extract node-id
NODE_ID=$(grep -oE '[0-9]{5,}' "$PWD/nexus.txt" | head -n 1)

if [[ -z "$NODE_ID" ]]; then
  echo "❌ Could not find any valid node-id in nexus.txt!"
  exit 1
fi

echo "📌 Found node-id: $NODE_ID"

# Remove old container if exists
if docker ps -a --format '{{.Names}}' | grep -q '^nexus-node$'; then
  echo "⚠️ Stopping and removing existing container 'nexus-node'..."
  docker stop nexus-node || true
  docker rm nexus-node || true
fi

# Run the container
echo "🐳 Running Docker container with node-id: $NODE_ID"
docker run -dit \
  --name nexus-node \
  --network host \
  rohan014233/nexus-image \
  --node-id "$NODE_ID"

echo "🎉 Nexus node launched successfully with ID: $NODE_ID"
