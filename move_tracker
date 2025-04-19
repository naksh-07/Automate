#!/bin/bash

# Clone the repository
git clone https://github.com/naksh-07/Tracker.git

# Check if clone was successful
if [ -d "Tracker/codespace-tracker" ]; then
  # Move the codespace-tracker directory to current directory
  mv Tracker/codespace-tracker .

  echo "✅ Moved 'codespace-tracker' to current directory."

  # Optional: Remove the now-empty Tracker repo
  rm -rf Tracker
else
  echo "❌ Failed to find 'Tracker/codespace-tracker'."
  exit 1
fi
