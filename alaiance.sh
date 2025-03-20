#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

# Load predefined device-specific identifiers
load_device_identifiers() {
    local env_file="mac.env"
    if [ ! -f "$env_file" ]; then
        echo -e "${ERROR}Error: The file $env_file does not exist. Please create it with required variables.${NC}"
        exit 1
    fi

    # Source the file
    source "$env_file"

    # Validate required variables
    if [[ -z "$MAC_ADDRESS" || -z "$UUID" || -z "$USER_DID" || -z "$DEVICE_ID" || -z "$DEVICE_NAME" ]]; then
        echo -e "${ERROR}Error: Missing required variables in $env_file.${NC}"
        exit 1
    fi

    echo -e "${INFO}Loaded device-specific identifiers:${NC}"
    echo -e "${INFO}MAC_ADDRESS: $MAC_ADDRESS${NC}"
    echo -e "${INFO}UUID: $UUID${NC}"
    echo -e "${INFO}USER_DID: $USER_DID${NC}"
    echo -e "${INFO}DEVICE_ID: $DEVICE_ID${NC}"
    echo -e "${INFO}DEVICE_NAME: $DEVICE_NAME${NC}"
}

# Load device identifiers
load_device_identifiers

# Create a directory for this device's configuration
device_dir="./$DEVICE_NAME"
if [ ! -d "$device_dir" ]; then
    mkdir "$device_dir"
    echo -e "${INFO}Created directory for $DEVICE_NAME at $device_dir${NC}"
fi

# Step 1: Write the UUID to a file
fake_product_uuid_file="$device_dir/fake_uuid.txt"
if [ ! -f "$fake_product_uuid_file" ]; then
    echo "$UUID" > "$fake_product_uuid_file"
fi

# Step 2: Use the predefined MAC address
echo -e "${INFO}Using predefined MAC address: $MAC_ADDRESS${NC}"

# Step 3: Pull the prebuilt Docker image instead of building it
echo -e "${INFO}Pulling the prebuilt Docker image 'rohan014233/alliance_games:latest'...${NC}"
docker pull rohan014233/alliance_games:latest

# Step 4: Run the Docker container
echo -e "${INFO}Running the Docker container '${DEVICE_NAME}'...${NC}"
docker run -it --rm --mac-address="$MAC_ADDRESS" \
    -v "$fake_product_uuid_file:/sys/class/dmi/id/product_uuid" \
    --name="$DEVICE_NAME" rohan014233/alliance_games:latest

echo -e "${SUCCESS}Docker container '${DEVICE_NAME}' has been successfully started.${NC}"
