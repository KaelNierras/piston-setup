#!/bin/bash
set -e

echo "🔥 Updating system..."
apt update && apt upgrade -y

echo "🐳 Installing Docker, Docker Compose, Node.js, and dependencies..."
apt install -y docker.io docker-compose git curl npm ufw

# Optional: Install Node.js >= 15 if system version is lower
if ! node -v | grep -q "v1[5-9]\|v[2-9][0-9]"; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
fi

echo "🔥 Cloning Piston repo..."
if [ ! -d "/opt/piston" ]; then
    git clone https://github.com/engineer-man/piston /opt/piston
else
    cd /opt/piston && git pull
fi

echo "▶️ Starting Piston API container..."
cd /opt/piston
docker-compose up -d api

echo "🐙 Installing Piston CLI dependencies..."
cd cli && npm install && cd -

echo "🛠 Installing C and C++ runtimes..."
cd cli
node index.js install c
node index.js install cpp
cd ..

echo "🌐 Configuring firewall..."
ufw allow 22
ufw allow 2000
ufw --force enable

echo "✅ Piston is installed and running on port 2000 with C and C++ runtimes"
echo "Test with: curl http://YOUR_SERVER_IP:2000/api/v2/runtimes"
