#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Prevent errors in piped commands from being masked

# Step 1: Install Gaianet Node
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash


# Step 3: Remove default nodeid.json and replace with new one
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

# Step 3: Remove default frpc.toml and replace with new one
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

# Step 2: Reload bash configuration
source ~/.bashrc

# Step 4: Initialize Gaianet with specific config
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

# Step 5: Start Gaianet
gaianet start

echo "Gaianet setup completed successfully!"
