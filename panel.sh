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
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Typing effect
type_text() {
  text="$1"
  delay="${2:-0.03}"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $delay
  done
  echo
}

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
type_text "* Installing Dependencies..."
(apt update -y && apt install -y curl software-properties-common git zip unzip) &
spinner "Updating and installing packages..."

type_text "* Installing Node.js 20..."
(curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt install -y nodejs) &
spinner "Installing Node.js..."

type_text "* Dependencies installed successfully!" 0.03

# -----------------------------
# Cloning Panel Repository
# -----------------------------
type_text "* Cloning Subhan Plays Panel repository..."
(git clone https://github.com/dragonlabsdev/v3panel && cd v3panel) &
spinner "Cloning repository..."

type_text "* Installing Panel files..."
(apt install -y zip && unzip panel.zip && cd panel && npm install) &
spinner "Installing Panel files..."

# Seed database and create admin
type_text "* Setting up Panel database and admin user..."
(npm run seed && npm run createUser) &
spinner "Seeding database..."

# Install PM2 and start panel
type_text "* Installing PM2 and starting Panel..."
(npm i -g pm2 && pm2 start .) &
spinner "Starting Panel with PM2..."

type_text "* Subhan Plays Panel installed and running on port 3001!" 0.03
