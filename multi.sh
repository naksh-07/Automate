#!/bin/bash

# Define repository URL
REPO_URL="https://github.com/mahraarinuu/MultipleDocker.git"

# Get the directory where the script is running
TARGET_DIR="$(pwd)/MultipleDocker"

# Check if directory exists
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Pulling latest changes..."
    cd "$TARGET_DIR" && git pull origin main
else
    # Clone the repository in the current directory
    git clone "$REPO_URL" "$TARGET_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone repository. Exiting."
        exit 1
    fi
fi

# Navigate to the cloned repository
cd "$TARGET_DIR" || {
    echo "Error: Failed to change directory. Exiting."
    exit 1
}

# Remove default multi.env
rm -f multi.env

# Copy new multi.env from the script execution directory
if [ -f "../nmulti.env" ]; then
    cp "../nmulti.env" "multi.env"
else
    echo "Error: nmulti.env not found in the parent directory. Exiting."
    exit 1
fi

# Give execution permissions to all shell scripts inside the repo
chmod +x *.sh

# Run run.sh
./run.sh
if [ $? -ne 0 ]; then
    echo "Error: Failed to execute run.sh. Exiting."
    exit 1
fi

echo "Script executed successfully."

# Self-destruct!
rm -- "$0"
