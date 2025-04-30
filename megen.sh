#!/usr/bin/env bash
set -euo pipefail

# 1. Read the secret into three vars
#    read splits on IFS (default whitespace)
read -r MEGA_EMAIL MEGA_PASSWORD ZIP_PASSWORD <<< "$MEGA_CREDENTIALS"

# 2. Write them into mega.env
cat > mega.env <<EOF
MEGA_EMAIL=$MEGA_EMAIL
MEGA_PASSWORD=$MEGA_PASSWORD
ZIP_PASSWORD=$ZIP_PASSWORD
EOF

echo "✅ mega.env created with your credentials!"
