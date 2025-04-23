#!/bin/bash

# == CONFIG ==
ENV_FILE="down.env"
ZIP_PASSWORD="${ZIP_PASSWORD:?ZIP_PASSWORD not set in Codespace secrets}"
MEGA_PATH="/"
EXTRACT_DIR="$(pwd)"

# == CHECK ==
if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ down.env file not found!"
  exit 1
fi

echo "🚀 Downloading and extracting archives from MEGA..."

# == MAIN ==
while IFS= read -r FILE_NAME || [[ -n "$FILE_NAME" ]]; do
  [[ -z "$FILE_NAME" ]] && continue  # Skip empty lines

  echo "🔽 Trying to download: $FILE_NAME from MEGA..."
  
  # Try download and catch failure silently
  if mega-get "$MEGA_PATH/$FILE_NAME" . 2>/dev/null; then

    if [[ -f "$FILE_NAME" ]]; then
      echo "📦 Extracting $FILE_NAME ..."
      7z x -y -p"$ZIP_PASSWORD" "$FILE_NAME" -o"$EXTRACT_DIR" >/dev/null 2>&1

      if [[ $? -eq 0 ]]; then
        echo "🧹 Deleting archive: $FILE_NAME"
        rm -f "$FILE_NAME"
      else
        echo "❗ Extraction failed for $FILE_NAME — Wrong password maybe?"
      fi
    else
      echo "❌ Downloaded $FILE_NAME not found in current directory!"
    fi

  else
    echo "⚠️ File '$FILE_NAME' not found on MEGA or download failed. Skipping..."
  fi

done < "$ENV_FILE"

echo "✅ DONE! Sab files ka hisaab ho gaya — jo mile, unka extract; jo nahi mile, unko skip!"

# Self-destruct!
rm -- "$0"
