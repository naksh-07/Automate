#!/bin/bash

# Ensure required env var
if [ -z "$CODESPACE_NAME" ]; then
  echo "Error: CODESPACE_NAME environment variable is not set."
  exit 1
fi

# Check if port 8085 is already forwarded
PORT_INFO=$(gh codespace ports list --codespace "$CODESPACE_NAME" --json port,visibility -q '.[] | select(.port == 8080)')

if [ -z "$PORT_INFO" ]; then
  echo "Forwarding port 8085..."
  gh codespace ports forward 8080 --codespace "$CODESPACE_NAME"
  PORT_INFO=$(gh codespace ports list --codespace "$CODESPACE_NAME" --json port,visibility -q '.[] | select(.port == 8080)')
fi

# Extract visibility from port info
VISIBILITY=$(echo "$PORT_INFO" | jq -r '.visibility')

# If visibility is already public, exit silently
if [ "$VISIBILITY" = "public" ]; then
  exit 0
fi

# Otherwise, make it public
echo "Setting port 8080 visibility to public..."
gh codespace ports visibility 8080:public --codespace "$CODESPACE_NAME"
