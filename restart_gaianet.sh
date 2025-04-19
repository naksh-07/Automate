#!/bin/bash

# Source .bashrc to load environment variables and paths
source ~/.bashrc

# Optional: echo PATH to check if sourced correctly
# echo "PATH: $PATH"

# Wait 2 seconds
sleep 2

# Stop the service
gaianet stop

# Wait 7 more seconds
sleep 7

# Start the service
gaianet start
