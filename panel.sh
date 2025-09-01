#!/bin/bash

# -----------------------------
# Subhan Plays Panel Installer
# -----------------------------

# ASCII Art: Subhan Plays
ascii_art="
  ____        _     _                 ____  _                 
 / ___| _   _| |__ | | ___  _ __     |  _ \\| | __ _ _   _ ___ 
 \\___ \\| | | | '_ \\| |/ _ \\| '_ \\    | |_) | |/ _\` | | | / __|
  ___) | |_| | |_) | | (_) | | | |   |  __/| | (_| | |_| \\__ \\
 |____/ \\__,_|_.__/|_|\\___/|_| |_|   |_|   |_|\\__,_|\\__, |___/
                                                     |___/     
"

# Colors
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
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
echo -e "${GREEN}* Installing Dependencies...${NC}"
apt update -y
apt install -y curl software-properties-common git zip unzip
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo -e "${GREEN}* Dependencies installed successfully!${NC}"

# -----------------------------
# Cloning Panel Repository
# -----------------------------
echo -e "${GREEN}* Cloning Subhan Plays Panel repository...${NC}"
git clone https://github.com/teryxlabs/v4panel
cd v4panel || { echo -e "${RED}Failed to enter v4panel directory${NC}"; exit 1; }

# -----------------------------
# Installing Panel Files
# -----------------------------
if [ -f panel.zip ]; then
  echo -e "${GREEN}* Extracting panel.zip...${NC}"
  unzip v4panel.zip
fi

if [ -d panel ]; then
  cd v4panel || { echo -e "${RED}Failed to enter panel directory${NC}"; exit 1; }
fi

echo -e "${GREEN}* Installing Node.js dependencies...${NC}"
npm install

# -----------------------------
# Setting up Database & Admin
# -----------------------------
echo -e "${GREEN}* Setting up Panel database and admin user...${NC}"
npm run seed
npm run createUser

# -----------------------------
# Installing PM2 and Starting Panel
# -----------------------------
echo -e "${GREEN}* Installing PM2 and starting Panel...${NC}"
npm install -g pm2

# Replace 'index.js' with your main JS file if different
pm2 start index.js --name "subhan-panel"

echo -e "${GREEN}* Subhan Plays Panel installed and running on port 3001!${NC}"
