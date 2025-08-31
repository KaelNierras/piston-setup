#!/bin/bash
set -e

echo "🔥 Updating system..."
apt update && apt upgrade -y

echo "🐳 Installing Docker and dependencies..."
apt install -y docker.io docker-compose ufw git curl

echo "🔥 Cloning Piston repo..."
if [ ! -d "/opt/piston" ]; then
    git clone https://github.com/engineer-man/piston /opt/piston
else
    cd /opt/piston && git pull
fi

echo "🐳 Pulling Docker images..."
cd /opt/piston
docker-compose pull

echo "▶️ Starting Piston..."
docker-compose up -d

echo "🌐 Configuring firewall..."
ufw allow 22
ufw allow 2000
ufw --force enable

echo "✅ Piston is installed and running on port 2000"
echo "Test with: curl http://YOUR_SERVER_IP:2000/api/v2/runtimes"
