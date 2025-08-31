#!/bin/bash
set -e

echo "🔥 Updating system..."
apt update && apt upgrade -y

echo "🐳 Installing Docker and dependencies..."
apt install -y docker.io docker-compose ufw git curl nodejs npm build-essential

echo "🔥 Cloning Piston repo..."
if [ ! -d "/opt/piston" ]; then
    git clone https://github.com/engineer-man/piston /opt/piston
else
    cd /opt/piston && git pull
fi

echo "🐳 Pulling Docker images..."
cd /opt/piston
docker compose pull

echo "▶️ Starting Piston API..."
docker compose up -d api

echo "🌐 Configuring firewall..."
ufw allow 22
ufw allow 2000
ufw --force enable

echo "✅ Piston API is running on port 2000"

echo "⚡ Installing default runtimes (C, C++, Python, Node.js)..."
cd /opt/piston/cli

# Install C runtime
node index.js ppman install gcc=10.2.0

# Install Python latest
node index.js ppman install python

# Install Node.js latest
node index.js ppman install node

echo "✅ Runtimes installed successfully!"
echo "Test with: curl http://YOUR_SERVER_IP:2000/api/v2/runtimes"
