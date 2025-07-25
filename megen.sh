#!/usr/bin/env bash
set -euo pipefail

# 1. Trim leading/trailing whitespace
CLEANED=$(echo "$MEGA_CREDENTIALS" | xargs)

# 2. Split into 3 vars safely
read -r MEGA_EMAIL MEGA_PASSWORD ZIP_PASSWORD <<< "$CLEANED"

# Debugging (optional): Check the values
# echo "Email: '$MEGA_EMAIL'"
# echo "Password: '$MEGA_PASSWORD'"
# echo "Zip: '$ZIP_PASSWORD'"

# 3. Write into mega.env
cat > mega.env <<EOF
MEGA_EMAIL=$MEGA_EMAIL
MEGA_PASSWORD=$MEGA_PASSWORD
ZIP_PASSWORD=$ZIP_PASSWORD
EOF

echo "✅ mega.env created successfully!"

# Self-destruct the script
rm -- "$0"
