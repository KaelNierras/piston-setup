#!/bin/bash
set -e

echo "🔥 Updating system..."
apt update && apt upgrade -y

echo "🐳 Installing Docker, Node.js, and dependencies..."
apt install -y docker.io docker-compose ufw git curl nodejs npm build-essential

echo "🔥 Cloning or updating Piston repo..."
if [ ! -d "/opt/piston" ]; then
    git clone https://github.com/engineer-man/piston /opt/piston
else
    cd /opt/piston && git pull
fi

echo "🐳 Pulling Docker images..."
cd /opt/piston
docker-compose pull

echo "▶️ Starting Piston API..."
docker-compose up -d api

echo "🔥 Installing CLI dependencies..."
cd /opt/piston/cli
npm install
cd -

echo "🐍 Installing default runtimes (C, C++, Python, Java, JavaScript)..."
cd /opt/piston/cli
node index.js ppman install c
node index.js ppman install cpp
node index.js ppman install python
node index.js ppman install java
node index.js ppman install node
cd -

echo "🌐 Configuring firewall..."
ufw allow 22
ufw allow 2000
ufw --force enable

echo "✅ Piston is installed and running on port 2000 with default runtimes"
echo "Test with: curl http://YOUR_SERVER_IP:2000/api/v2/runtimes"
