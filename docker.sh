#!/bin/bash
set -euo pipefail

echo "🚀 Starting Docker setup..."

# Ensure system packages are up to date
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Create keyrings directory (if not exists)
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker’s official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, and Compose
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Make sure Docker service is running
sudo systemctl enable --now docker

echo -e "\n🎉 Docker installed successfully!"

