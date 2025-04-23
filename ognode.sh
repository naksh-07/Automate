#!/bin/bash

# =========================================
# COLORS
# =========================================
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# =========================================
# LOAD og.env SECRETS
# =========================================
if [[ -f "og.env" ]]; then
    echo -e "${YELLOW}🔐 Loading secrets from og.env...${NC}"
    set -o allexport
    source og.env
    set +o allexport
else
    echo -e "${RED}❌ og.env file not found! Please add it to the current directory.${NC}"
    exit 1
fi

# =========================================
# CHECK PRIVATE KEY VALUE
# =========================================
if [ -z "$COMBINED_SERVER_PRIVATE_KEY" ]; then
    echo -e "${RED}❌ COMBINED_SERVER_PRIVATE_KEY not set in og.env!${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Private key loaded successfully from og.env.${NC}"
    YOUR_PRIVATE_KEY=$COMBINED_SERVER_PRIVATE_KEY
fi

# =========================================
# SYSTEM SETUP
# =========================================
echo -e "${YELLOW}🔧 Updating system packages...${NC}"
sudo apt update -y

# Install Screen
if ! command -v screen &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Screen...${NC}"
    sudo apt install -y screen
fi

# Install Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Git...${NC}"
    sudo apt install -y git
fi

# Install Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}🐳 Installing Docker and dependencies...${NC}"
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release gnupg2
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Add user to docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo -e "${YELLOW}➕ Adding user to docker group...${NC}"
    sudo usermod -aG docker $USER
    echo -e "${YELLOW}⚠️  Please log out and log back in to activate Docker group changes.${NC}"
fi

# =========================================
# MAIN WORKFLOW
# =========================================
# Pull Docker image
echo -e "${YELLOW}📥 Pulling Docker image: rohan014233/0g-da-client...${NC}"
docker pull rohan014233/0g-da-client

# Download env template
echo -e "${YELLOW}🌐 Downloading env file template...${NC}"
wget -q -O "./0genvfile.env" https://raw.githubusercontent.com/CryptonodesHindi/Automated_script/refs/heads/main/0genvfile.env

# Inject private key
echo -e "${YELLOW}✍️ Injecting private key into env file...${NC}"
sed -i "s|COMBINED_SERVER_PRIVATE_KEY=YOUR_PRIVATE_KEY|COMBINED_SERVER_PRIVATE_KEY=$YOUR_PRIVATE_KEY|" "./0genvfile.env"

# Run Docker container
echo -e "${YELLOW}🚀 Starting Docker container...${NC}"
docker run -d --env-file ./0genvfile.env --name 0g-da-client -v ./run:/runtime -p 51001:51001 rohan014233/0g-da-client combined

# Done
echo -e "${GREEN}🎉 All set! 0G DA client is now running in Docker container!${NC}"

# Self-destruct!
rm -- "$0"
