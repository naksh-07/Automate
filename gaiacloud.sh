#!/bin/bash

# Exit on error
set -e

# Variables
ARCHIVE_NAME="gaianet.7z"
DESTINATION="/root"

# Use ZIPPASSWORD from environment (set as secret in Codespaces)
if [[ -z "$ZIP_PASSWORD" ]]; then
  echo "ERROR: ZIPPASSWORD environment variable is not set."
  exit 1
fi

# Step 1: Download archive using mega-get
echo "Downloading $ARCHIVE_NAME from MEGA..."
mega-get "$ARCHIVE_NAME"

# Step 2: Extract to /root with password from secret
echo "Extracting $ARCHIVE_NAME to $DESTINATION..."
7z x "$ARCHIVE_NAME" -p"$ZIP_PASSWORD" -o"$DESTINATION"

# Step 3: Source ~/.bashrc
echo "Sourcing ~/.bashrc..."
source ~/.bashrc

# Step 4: Start gaianet
echo "Starting gaianet..."
gaianet start
