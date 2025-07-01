#!/bin/bash

set -e  # Script fails if any command fails

echo "🚀 Downloading nexus.txt from MEGA to current directory: $PWD"

# File is in MEGA base (root) directory
mega-get "mega:/nexus.txt" "$PWD" >/dev/null 2>&1

# Check if the file was downloaded
if [[ ! -f "$PWD/nexus.txt" ]]; then
  echo "❌ nexus.txt not found in $PWD after download!"
  exit 1
fi

echo "✅ Downloaded nexus.txt successfully!"

# Extract --node-id value from file (first 5+ digit number)
NODE_ID=$(grep -oE '[0-9]{5,}' "$PWD/nexus.txt" | head -n 1)

if [[ -z "$NODE_ID" ]]; then
  echo "❌ Could not find any valid node-id in nexus.txt!"
  exit 1
fi

echo "📌 Found node-id: $NODE_ID"

# If container already exists, remove it
if docker ps -a --format '{{.Names}}' | grep -q '^nexus-node$'; then
  echo "⚠️ Stopping and removing existing container 'nexus-node'..."
  docker stop nexus-node >/dev/null 2>&1 || true
  docker rm nexus-node >/dev/null 2>&1 || true
fi

# Run the container
echo "🐳 Running Docker container with node-id: $NODE_ID"
docker run -dit --network host --name nexus-node rohan014233/nexus-image nexus-network start --node-id "$NODE_ID"

echo "🎉 Nexus node launched successfully with ID: $NODE_ID"
