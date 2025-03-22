#!/bin/bash

set -e
set -o pipefail

# Step 1: Install Gaianet Node
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

# Step 2: Ensure Gaianet path is available
echo "Adding Gaianet to PATH..."
export PATH=$PATH:/root/gaianet/bin
echo 'export PATH=$PATH:/root/gaianet/bin' >> ~/.bashrc
source ~/.bashrc
hash -r

# Check if Gaianet is available
if ! command -v gaianet &> /dev/null; then
    echo "🚨 Error: 'gaianet' command not found! Manually check with 'which gaianet'"
    exit 1
fi

# Step 3: Remove and replace nodeid.json
NODEID_PATH="/root/gaianet/nodeid.json"
NID_ENV="$(pwd)/nid.env"

if [ -f "$NODEID_PATH" ]; then
    rm -f "$NODEID_PATH"
    echo "Removed default nodeid.json"
fi

if [ -f "$NID_ENV" ]; then
    cp "$NID_ENV" "$NODEID_PATH"
    echo "Replaced nodeid.json with new data from nid.env"
else
    echo "nid.env file not found! Exiting..."
    exit 1
fi

# Step 4: Remove and replace frpc.toml
FRPC_PATH="/root/gaianet/gaia-frp/frpc.toml"
FRPC_ENV="$(pwd)/frpc.env"

if [ -f "$FRPC_PATH" ]; then
    rm -f "$FRPC_PATH"
    echo "Removed default frpc.toml"
fi

if [ -f "$FRPC_ENV" ]; then
    cp "$FRPC_ENV" "$FRPC_PATH"
    echo "Replaced frpc.toml with new data from frpc.env"
else
    echo "frpc.env file not found! Exiting..."
    exit 1
fi

# Step 5: Initialize Gaianet
echo "Initializing Gaianet..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

# Step 6: Start Gaianet
echo "Starting Gaianet..."
gaianet start

echo "✅ Gaianet setup completed successfully!"
