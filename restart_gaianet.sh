#!/bin/bash

# Add gaianet bin path to PATH
export PATH="/root/gaianet/bin:$PATH"

echo "🚀 Restarting gaianet..."

sleep 2
gaianet stop

sleep 7
gaianet start

echo "✅ Gaia restart complete!"

# Self-destruct!
rm -- "$0"
