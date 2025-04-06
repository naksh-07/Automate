#!/bin/bash

# Bhai yeh tera dream setup hai: 4 Core + 16GB RAM + Ubuntu 22.04
# Codespace ka Ronaldo bana diya isko 🚀

WORKSPACE="/workspaces/$(basename $PWD)"
DEVCONTAINER_PATH="$WORKSPACE/.devcontainer"

mkdir -p "$DEVCONTAINER_PATH"

echo "⚙️ Setting up Ultra OP Dev Container in $DEVCONTAINER_PATH..."

# devcontainer.json — with machine specs
cat <<EOF > "$DEVCONTAINER_PATH/devcontainer.json"
{
  "name": "OP Ubuntu Dev Container 4Core-16GB",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-22.04",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-azuretools.vscode-docker"
      ]
    }
  },
  "hostRequirements": {
    "cpus": 4,
    "memory": "16gb"
  },
  "postCreateCommand": "bash /workspaces/$(basename $PWD)/.devcontainer/setup.sh",
  "remoteUser": "root",
  "mounts": [
    {
      "source": "\${localWorkspaceFolder}",
      "target": "/workspaces/$(basename $PWD)",
      "type": "bind"
    }
  ]
}
EOF

echo "✅ devcontainer.json ready!"

# Dockerfile — OP Level Setup
cat <<EOF > "$DEVCONTAINER_PATH/Dockerfile"
FROM ubuntu:22.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
curl git vim nano wget python3 python3-pip build-essential \
htop zram-tools docker.io tlp jq unzip nodejs npm cmake \
&& apt clean && rm -rf /var/lib/apt/lists/*

RUN echo 'ALGO=lz4' > /etc/default/zramswap && echo 'PERCENT=50' >> /etc/default/zramswap && systemctl enable zramswap
RUN systemctl enable docker

WORKDIR /workspaces/$(basename $PWD)

CMD ["/bin/bash"]
EOF

echo "✅ Dockerfile done!"

# setup.sh — full custom tuning
cat <<EOF > "$DEVCONTAINER_PATH/setup.sh"
#!/bin/bash

echo "🔥 Running OP Setup - Performance Mode ON..."

apt update && apt install -y python3-venv tlp unzip jq && apt clean && rm -rf /var/lib/apt/lists/*

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
systemctl restart zramswap
systemctl start docker
systemctl enable tlp && systemctl start tlp

npm install -g npm yarn pm2

echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576

cd "$WORKSPACE"
wget -q https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/thorium.sh && chmod +x thorium.sh && ./thorium.sh

curl -sSLO https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/gaianet.sh && bash gaianet.sh
curl -sSLO https://raw.githubusercontent.com/naksh-07/Automate/refs/heads/main/ognode.sh && bash ognode.sh

echo "✅ All Done Bhai! Ultra OP Container READY 🚀"
EOF

chmod +x "$DEVCONTAINER_PATH/setup.sh"

echo "🎉 Setup complete Bhai! Jaake Codespace rebuild maar!"

echo -e "\n🛠️ Command to rebuild:\n"
echo "devcontainer rebuild-container"
