#!/bin/bash

# List of env files to generate
env_files=("mac.env" "og.env" "nid.env" "frpc.env")

# Loop through each env file and create it if it doesn't exist
for env_file in "${env_files[@]}"; do
    if [ ! -f "$env_file" ]; then
        touch "$env_file"
        echo "# Environment variables for $env_file" > "$env_file"
        chmod 600 "$env_file"
        echo "$env_file created."
    else
        echo "$env_file already exists. Skipping."
    fi
done

echo "All environment files are ready!"
