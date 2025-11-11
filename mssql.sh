#!/bin/bash
set -euo pipefail

echo "🚀 Starting MSSQL Server 2022 setup..."

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    echo "❌ Docker is not installed. Please run the Docker setup script first."
    exit 1
fi

# Remove old SQL container if exists
if sudo docker ps -a --format '{{.Names}}' | grep -q '^sql1$'; then
    echo "⚠️ Existing 'sql1' container found — removing..."
    sudo docker rm -f sql1
fi

# Pull latest SQL Server 2022 image
echo "⬇️ Pulling latest MSSQL Server 2022 Docker image..."
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest

# Set SA password (hardcoded or change here if needed)
SA_PASSWORD="Xj1Uk4e0#Db"

# Run SQL Server container
echo "⬇️ Running MSSQL Server container..."
sudo docker run -e "ACCEPT_EULA=Y" \
                -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" \
                -p 1433:1433 \
                --name sql1 \
                --hostname sql1 \
                -v sql1data:/var/opt/mssql \
                -d \
                mcr.microsoft.com/mssql/server:2022-latest
echo -e "\n🎉 MSSQL Server is now running!"
echo -e "🖥️ Container name: sql1"
echo -e "🌐 Exposed port: 1433"
echo -e "🔑 SA password: $SA_PASSWORD"
