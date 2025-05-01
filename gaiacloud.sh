#!/bin/bash

# Exit on error
set -e

# Variables
ARCHIVE_NAME="gaianet.7z"
DESTINATION="/root"

# Ensure mega-get and 7z are installed
if ! command -v mega-get &>/dev/null || ! command -v 7z &>/dev/null; then
  echo "ERROR: Required tools (mega-get or 7z) are not installed."
  exit 1
fi

# 1) Load credentials
if [[ -f mega.env ]]; then
  # echo "Loading MEGA creds..."
  source mega.env
else
  echo "❌ mega.env not found! Run gen_mega_env.sh first."
  exit 1
fi

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}


# Step 1: Download archive using mega-get
echo "Downloading $ARCHIVE_NAME from MEGA..."
mega-get "$ARCHIVE_NAME"

# Step 2: Set umask to ensure correct permissions
umask 022

# Step 3: Extract to /root with password from secret
echo "Extracting $ARCHIVE_NAME to $DESTINATION..."
7z x "$ARCHIVE_NAME" -p"$ZIP_PASSWORD" -o"$DESTINATION"

# Step 4: Set executable permissions for extracted files
echo "Setting executable permissions..."
sudo chmod -R u+x /root/gaianet

# Step 5: Clean up
rm "$ARCHIVE_NAME"

# Step 6: Run installation script
echo "Running installation script..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

# Step 7: Source ~/.bashrc
echo "Sourcing ~/.bashrc..."
source ~/.bashrc

# Step 8: Start gaianet
echo "Starting gaianet..."
gaianet start

# Self-destruct!
rm -- "$0"
