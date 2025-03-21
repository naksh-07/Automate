#!/bin/bash

# Function to create or update an env file
create_env_file() {
    local filename="$1"
    echo "Generating $filename..."

    # Backup if the file exists
    if [ -f "$filename" ]; then
        mv "$filename" "$filename.bak"
        echo "Existing $filename found. Backup created: $filename.bak"
    fi

    # Ask for values with default options
    read -p "Enter VALUE1 for $filename [default: default_value1]: " VALUE1
    VALUE1=${VALUE1:-default_value1}

    read -p "Enter VALUE2 for $filename [default: default_value2]: " VALUE2
    VALUE2=${VALUE2:-default_value2}

    read -p "Enter SECRET_KEY for $filename [default: auto-generate]: " SECRET_KEY
    SECRET_KEY=${SECRET_KEY:-$(openssl rand -hex 16)}

    # Write to the env file
    cat <<EOF > "$filename"
# Environment variables for $filename
VALUE1="$VALUE1"
VALUE2="$VALUE2"
SECRET_KEY="$SECRET_KEY"
EOF

    # Secure the env file
    chmod 600 "$filename"
    echo "$filename created successfully with secure permissions."
    echo "--------------------------------------------"
}

# List of env files to generate
env_files=("mac.env" "og.env" "nid.env" "frpc.env")

# Loop through each env file and create it
for env_file in "${env_files[@]}"; do
    create_env_file "$env_file"
done

echo "All environment files have been created successfully!"
