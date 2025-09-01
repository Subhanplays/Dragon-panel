#!/bin/bash

# ASCII Art: Subhan Plays Panel
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
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the screen
clear
# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root.${NC}"
  exit 1
fi

echo -e "${CYAN}$ascii_art${NC}"

echo_message "* Installing Dependencies"

# Update package list and install dependencies
sudo apt update
sudo apt install -y curl software-properties-common
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs -y 
sudo apt install git -y

echo_message "* Installed Dependencies"

echo_message "* Installing Files"

# Create directory, clone repository, and install files
mkdir -p panel5
cd panel5 || { echo_message "Failed to change directory to panel5"; exit 1; }
git clone https://github.com/achul123/panel5.git
cd panel5 || { echo_message "Failed to change directory to panel"; exit 1; }
npm install

echo_message "* Installed Files"

echo_message "* Starting Subhan Plays Panel"

# Run setup scripts
npm run seed
npm run createUser

echo_message "* Starting Subhan Plays Panel With PM2"

# Install panel and start the application
sudo npm install -g pm2
pm2 start index.js

echo_message "* Subhan Plays Panel Installed and Started on Port 3001"

# Clear the screen after finishing
clear
echo "* Made by Subhanplays"

