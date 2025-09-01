#!/bin/bash

# -----------------------------
# Subhan Plays Panel Installer
# -----------------------------

# ASCII Art: Subhan Plays
ascii_art="
  ____        _     _                 ____  _                 
 / ___| _   _| |__ | | ___  _ __     |  _ \| | __ _ _   _ ___ 
 \___ \| | | | '_ \| |/ _ \| '_ \    | |_) | |/ _\` | | | / __|
  ___) | |_| | |_) | | (_) | | | |   |  __/| | (_| | |_| \__ \\
 |____/ \__,_|_.__/|_|\___/|_| |_|   |_|   |_|\__,_|\__, |___/
                                                     |___/     
"

# Colors
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Clear screen and show ASCII art
clear
echo -e "${CYAN}$ascii_art${NC}"

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root.${NC}"
  exit 1
fi

# -----------------------------
# Installing Dependencies
# -----------------------------
echo "* Installing Dependencies..."
apt update -y
apt install -y curl software-properties-common git zip unzip
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "* Dependencies installed successfully!"

# -----------------------------
# Cloning Panel Repository
# -----------------------------
echo "* Cloning Subhan Plays Panel repository..."
git clone https://github.com/teryxlabs/v4panel
cd v4panel || exit

echo "* Installing Panel files..."
apt install -y zip
unzip panel.zip
cd v4panel || exit
npm install

# Seed database and create admin
echo "* Setting up Panel database and admin user..."
npm run seed
npm run createUser

# Install PM2 and start panel
echo "* Installing PM2 and starting Panel..."
npm i -g pm2
pm2 start .

echo "* Subhan Plays Panel installed and running on port 3001!"
