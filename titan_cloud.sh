#!/bin/bash

# Load env for ZIP_PASSWORD
source mega.env

# Titan loop from 1 to 5
for i in {1..5}; do
  ZIP_NAME="titan_${i}.7z"
  DIR_NAME=".titanedge_${i}"
  EXTRACTED_PATH="/root/${DIR_NAME}"

  echo "🔍 Checking for $ZIP_NAME on MEGA..."
  if mega-ls | grep -q "$ZIP_NAME"; then
    echo "📥 $ZIP_NAME found! Downloading..."
    mega-get "$ZIP_NAME" .

    if [ -f "$ZIP_NAME" ]; then
      echo "🗜️ Extracting $ZIP_NAME to $EXTRACTED_PATH..."
      mkdir -p "$EXTRACTED_PATH"
      7z x "$ZIP_NAME" -o"$EXTRACTED_PATH" -p"$ZIP_PASSWORD" -y

      if [ $? -eq 0 ]; then
        echo "✅ Extraction successful for $ZIP_NAME"

        echo "🐳 Running Docker container for $DIR_NAME..."
        docker run -d \
          -v "$EXTRACTED_PATH:/root/.titanedge" \
          nezha123/titan-edge

        echo "⏳ Waiting 10 seconds before next..."
        sleep 10
      else
        echo "❌ Extraction failed for $ZIP_NAME"
      fi
    else
      echo "❌ Download failed for $ZIP_NAME"
    fi
  else
    echo "⚠️ $ZIP_NAME not found on MEGA. Skipping..."
  fi
done

echo "🚀 All possible TITANs launched (or skipped if not found). Chak de phatte!"
