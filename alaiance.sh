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
    if [[ -z "$MAC_ADDRESS" ]]; then
        echo -e "${ERROR}Error: MAC_ADDRESS is not defined in $env_file.${NC}"
        exit 1
    fi
    if [[ -z "$UUID" ]]; then
        echo -e "${ERROR}Error: UUID is not defined in $env_file.${NC}"
        exit 1
    fi
    if [[ -z "$USER_DID" ]]; then
        echo -e "${ERROR}Error: USER_DID is not defined in $env_file.${NC}"
        exit 1
    fi
    if [[ -z "$DEVICE_ID" ]]; then
        echo -e "${ERROR}Error: DEVICE_ID is not defined in $env_file.${NC}"
        exit 1
    fi
    if [[ -z "$DEVICE_NAME" ]]; then
        echo -e "${ERROR}Error: DEVICE_NAME is not defined in $env_file.${NC}"
        exit 1
    fi

    echo -e "${INFO}Loaded MAC_ADDRESS: $MAC_ADDRESS${NC}"
    echo -e "${INFO}Loaded UUID: $UUID${NC}"
    echo -e "${INFO}Loaded USER_DID: $USER_DID${NC}"
    echo -e "${INFO}Loaded DEVICE_ID: $DEVICE_ID${NC}"
    echo -e "${INFO}Loaded DEVICE_NAME: $DEVICE_NAME${NC}"
}

# Load identifiers
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

# Step 2: Use the provided MAC address
echo -e "${INFO}Using predefined MAC address: $MAC_ADDRESS${NC}"

# Convert device_name to lowercase for container naming
device_name_lower=$(echo "$DEVICE_NAME" | tr '[:upper:]' '[:lower:]')

# Step 3: Pull the pre-built Docker image
echo -e "${INFO}Pulling the latest Docker image 'rohan014233/alliance_games'...${NC}"
docker pull rohan014233/alliance_games

# Step 4: Run the Docker container
echo -e "${INFO}Starting the Docker container '${DEVICE_NAME}'...${NC}"
docker run -it --mac-address="$MAC_ADDRESS" \
    -v "$fake_product_uuid_file:/sys/class/dmi/id/product_uuid" \
    --name="$DEVICE_NAME" rohan014233/alliance_games

echo -e "${SUCCESS}Congratulations! The Docker container '${DEVICE_NAME}' is running successfully.${NC}"
