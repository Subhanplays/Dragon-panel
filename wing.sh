#!/bin/bash

clear

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

# Spinner function
spinner() {
  pid=$!
  spin='-\|/'
  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r${CYN}${spin:$i:1} $1${NC}"
    sleep 0.2
  done
  printf "\r\033[K"
}

# Typing effect function
type_text() {
  text="$1"
  delay="${2:-0.03}"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $delay
  done
  echo
}

# ASCII Logo for Wings
echo -e "${YEL}"
cat << "EOF"
███████╗██████╗ 
██╔════╝██╔══██╗
███████╗██████╔╝
╚════██║██╔═══╝ 
███████║██║     
╚══════╝╚═╝     
EOF
echo -e "${NC}"

type_text "🚀 Installing Pterodactyl Wings with Docker..." 0.05
sleep 1

# Step 1: Create directory structure
type_text "📁 Creating Wings directory..."
mkdir -p pterodactyl/wings
cd pterodactyl/wings || exit

# Step 2: Write docker-compose.yml
type_text "📝 Writing docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  wings:
    image: ghcr.io/pterodactyl/wings:v1.6.1
    restart: always
    networks:
      - wings0
    ports:
      - "8080:8080"
      - "2022:2022"
      - "443:443"
    tty: true
    environment:
      TZ: "UTC"
      WINGS_UID: 988
      WINGS_GID: 988
      WINGS_USERNAME: pterodactyl
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/containers/:/var/lib/docker/containers/
      - /etc/pterodactyl/:/etc/pterodactyl/
      - /var/lib/pterodactyl/:/var/lib/pterodactyl/
      - /var/log/pterodactyl/:/var/log/pterodactyl/
      - /tmp/pterodactyl/:/tmp/pterodactyl/
      - /etc/ssl/certs:/etc/ssl/certs:ro

networks:
  wings0:
    name: wings0
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16
    driver_opts:
      com.docker.network.bridge.name: wings0
EOF

# Step 3: Start Docker container with spinner
type_text "🚀 Starting Wings Docker container..."
(docker-compose up -d) &
spinner "Starting Wings container..."

type_text "✅ Pterodactyl Wings installation complete, Subhan Zahid!" 0.05
