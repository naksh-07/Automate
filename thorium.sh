#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Updating System and Installing Dependencies...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl nano wget ca-certificates

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}🐳 Installing Docker...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}🛠 Installing Docker-Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo -e "${GREEN}🚀 Setting up Thorium Browser...${NC}"
mkdir -p ~/thorium && cd ~/thorium

# Create docker-compose.yml for Thorium
cat <<EOF > docker-compose.yml
version: "3.8"
services:
  thorium:
    image: zydou/thorium:latest
    container_name: thorium_browser
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Kolkata
    ports:
      - "8080:3000"
    security_opt:
      - seccomp:unconfined
    volumes:
      - ~/thorium/config:/config
    shm_size: "2gb"
    restart: unless-stopped
EOF

# Start Thorium container
docker-compose up -d

echo -e "${GREEN}✅ Thorium Browser is running! Access it at: http://localhost:8080${NC}"
echo -e "${GREEN}📌 Chrome Extensions Supported: Install directly from Chrome Web Store!${NC}"
