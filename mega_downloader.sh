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
  echo "🔽 Downloading: $FILE_NAME from MEGA..."
  mega-get "$MEGA_PATH/$FILE_NAME" . >/dev/null 2>&1

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
    echo "❌ File $FILE_NAME not found after download. Something went wrong!"
  fi
done < "$ENV_FILE"

echo "✅ DONE! All files downloaded, extracted, and cleaned up!"
