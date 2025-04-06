#!/bin/bash

# Update package lists and upgrade installed packages
echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y

# Install Screen if not installed
if ! command -v screen &> /dev/null; then
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
else
    echo -e "${YELLOW}Screen is already installed, skipping installation.${NC}"
fi

# Install Git if not installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Installing Git...${NC}"
    sudo apt install -y git
else
    echo -e "${YELLOW}Git is already installed, skipping installation.${NC}"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Installing Docker and dependencies...${NC}"
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        lsb-release \
        gnupg2

    echo -e "${YELLOW}Adding Docker's official GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker installation failed!${NC}"
        exit 1
    else
        echo -e "${GREEN}Docker successfully installed!${NC}"
    fi
else
    echo -e "${YELLOW}Docker is already installed, skipping installation.${NC}"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose installed!${NC}"
else
    echo -e "${YELLOW}Docker Compose is already installed, skipping installation.${NC}"
fi

# Add current user to Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}Adding user to Docker group...${NC}"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Please log out and log back in for changes to take effect.${NC}"
else
    echo -e "${YELLOW}User is already in the Docker group.${NC}"
fi

# Pull Docker image
echo -e "${YELLOW}Pulling Docker image rohan014233/0g-da-client...${NC}"
docker pull rohan014233/0g-da-client

# Load private key from environment variable (set via Codespace secret)
if [ -z "$COMBINED_SERVER_PRIVATE_KEY" ]; then
    echo -e "${RED}Environment variable COMBINED_SERVER_PRIVATE_KEY is not set! Make sure it's defined in Codespace secrets.${NC}"
    exit 1
else
    echo -e "${YELLOW}Loaded private key from Codespace secret.${NC}"
    YOUR_PRIVATE_KEY=$COMBINED_SERVER_PRIVATE_KEY
fi


echo -e "${GREEN}Private key loaded successfully.${NC}"

# Download environment file
echo -e "${YELLOW}Downloading environment file...${NC}"
wget -q -O "$HOME/0genvfile.env" https://raw.githubusercontent.com/CryptonodesHindi/Automated_script/refs/heads/main/0genvfile.env

# Inject private key into the environment file
sed -i "s|COMBINED_SERVER_PRIVATE_KEY=YOUR_PRIVATE_KEY|COMBINED_SERVER_PRIVATE_KEY=$YOUR_PRIVATE_KEY|" "$HOME/0genvfile.env"

# Run Docker container
echo -e "${YELLOW}Starting Docker container...${NC}"
docker run -d --env-file /root/0genvfile.env --name 0g-da-client -v ./run:/runtime -p 51001:51001 rohan014233/0g-da-client combined

# Display completion message
echo "========================================"
echo -e "${YELLOW}Thanks for using the script!${NC}"
echo "========================================"
