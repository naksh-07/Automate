#!/bin/bash

# Exit if koi error ho jaaye toh
set -e

# Variables
ARCHIVE_NAME="gaianet.7z"
DESTINATION="/root"

# Step 1: Run installation script sabse pehle
echo "➡️ Running installation script (pehli baar setup)..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

# Step 2: Gaianet ko clean kar dete hai (fresh install hai boss)
echo "🧹 Cleaning up existing /root/gaianet..."
rm -rf /root/gaianet

# Step 3: Check kar le mega-get & 7z installed hai ya nahi
if ! command -v mega-get &>/dev/null || ! command -v 7z &>/dev/null; then
  echo "🚨 ERROR: Required tools (mega-get ya 7z) installed nahi hai bhai."
  exit 1
fi

# Step 4: Load mega creds
if [[ -f mega.env ]]; then
  echo "🔑 Loading MEGA creds..."
  source mega.env
else
  echo "❌ mega.env not found! Pehle gen_mega_env.sh chala bhai."
  exit 1
fi

# Step 5: Download archive from MEGA
echo "⬇️ Downloading $ARCHIVE_NAME from MEGA..."
mega-get "$ARCHIVE_NAME"

# Step 6: Set umask for sahi permissions
umask 022

# Step 7: Extract karte hai /root me
echo "📦 Extracting $ARCHIVE_NAME to $DESTINATION..."
7z x "$ARCHIVE_NAME" -p"$ZIP_PASSWORD" -o"$DESTINATION"

# Step 8: Permissions set karte hai
echo "🔧 Setting executable permissions..."
chmod -R u+x /root/gaianet

# Step 9: Clean up archive
echo "🗑️ Cleaning up archive..."
rm "$ARCHIVE_NAME"

# Step 10: Source bashrc (taaki sab changes load ho jaaye)
echo "🔄 Sourcing ~/.bashrc..."
source ~/.bashrc

# Step 11: Start karte hai gaianet
echo "🚀 Starting gaianet..."
gaianet start

# Final move: Self-destruct jaise MI movie 😄
echo "💣 Script khatam, self-destructing..."
rm -- "$0"
