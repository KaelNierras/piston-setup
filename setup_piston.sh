#!/bin/bash
set -e

echo "🔥 Updating system..."
apt update && apt upgrade -y

echo "🐳 Installing Docker and dependencies..."
apt install -y docker.io docker-compose ufw git curl nodejs npm

echo "🔥 Cloning Piston repo..."
if [ ! -d "/opt/piston" ]; then
    git clone https://github.com/engineer-man/piston /opt/piston
else
    cd /opt/piston && git pull
fi

cd /opt/piston

echo "▶️ Starting Piston API container..."
docker compose up -d api

# Wait a few seconds for the API to be ready
sleep 10

echo "🐚 Installing C and C++ runtimes via CLI inside the container..."
docker exec -it piston_api bash -c "
    cd cli &&
    npm install &&
    node index.js -u http://localhost:2000 ppman install c &&
    node index.js -u http://localhost:2000 ppman install cpp
"

echo "🌐 Configuring firewall..."
ufw allow 22
ufw allow 2000
ufw --force enable

echo "✅ Piston is installed and running on port 2000 with C and C++ runtimes"
echo "Test with: curl http://YOUR_SERVER_IP:2000/api/v2/runtimes"
