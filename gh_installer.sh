#!/bin/bash

set -e  # Agar kuch bhi fail ho gaya toh script turant rukega

echo "👀 Checking if we're inside a GitHub Codespace..."

# Detect Codespace
if [ -z "$CODESPACES" ] && [ -z "$CODESPACE_NAME" ]; then
    echo "❌ Bro, tu Codespace ke andar nahi hai! Yeh script sirf GitHub Codespace ke liye hai! 🥲"
    exit 1
fi

echo "✅ Codespace detected, bhai ready hai! Let's roll! 🎬"

# 1. Install GitHub CLI (gh)
echo "🚀 Installing GitHub CLI..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

echo "✅ gh CLI installation done, bhai!"


# 3. Self Destruct
echo "💣 Work done bro! Script is self-destructing now..."
rm -- "$0"

