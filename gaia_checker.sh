#!/bin/bash

# === New gaianet logic ===
TARGET_FILE="gaianet.7z"

echo "🔍 Checking if $TARGET_FILE exists in MEGA root..."
if mega-ls | grep -q "$TARGET_FILE"; then
  echo "✅ $TARGET_FILE exists on MEGA! Running gaiacloud.sh..."
  if bash ./gaiacloud.sh; then
    echo "🎉 gaiacloud.sh succeeded! Now running restart_gaianet.sh..."
    if bash ./restart_gaianet.sh; then
      echo "🚀 restart_gaianet.sh completed successfully!"
    else
      echo "❗ restart_gaianet.sh failed with exit code $?"
    fi
  else
    echo "❗ gaiacloud.sh failed with exit code $?. Skipping restart_gaianet.sh."
  fi
else
  # Silent exit if gaianet.7z not present
  exit 0
fi
