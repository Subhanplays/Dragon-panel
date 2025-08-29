#!/bin/bash

clear

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'
YEL='\033[1;33m'
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

# Animated ASCII logo
animate_logo() {
  logo=("
███████╗██████╗ 
██╔════╝██╔══██╗
███████╗██████╔╝
╚════██║██╔═══╝ 
███████║██║     
╚══════╝╚═╝     "
  )
  for line in "${logo[@]}"; do
    type_text "$line" 0.005
  done
}

# Display animated logo
echo -e "${YEL}"
animate_logo
echo -e "${NC}"

type_text "Welcome, Subhan Zahid! Select an option to get started..." 0.05
sleep 0.5

# Menu loop
while true; do
  clear
  type_text "${GRN}========== MAIN MENU ==========${NC}" 0.01
  options=("Install Pterodactyl Panel" "Install Pterodactyl Wings" "Set up 24/7 Server" "Set up Playit Tunneling" "Exit")
  
  # Animated menu display
  for i in "${!options[@]}"; do
    type_text "$((i+1))) ${options[$i]}" 0.02
  done

  echo -ne "${CYN}Enter your choice [1-5]: ${NC}"
  read choice

  case $choice in
    1)
      type_text "🚀 Installing Pterodactyl Panel..."
      # Example: run local script or command
      bash <(curl -s https://raw.githubusercontent.com/Subhanplays/pterodactyl-panel/main/panel.sh)
      spinner "Installing Panel..."
      ;;
    2)
      type_text "🚀 Installing Pterodactyl Wings..."
      bash <(curl -s https://raw.githubusercontent.com/Subhanplays/pterodactyl-panel/main/wing.sh)
      spinner "Installing Wings..."
      ;;
    3)
      type_text "🔁 Setting up 24/7 server..."
      wget https://raw.githubusercontent.com/Subhanplays/24-7/main/24-7.py
      python 24-7.py
      spinner "Setting up 24/7 server..."
      ;;
    4)
      type_text "🌐 Setting up Playit tunneling..."
      bash <(curl -s https://raw.githubusercontent.com/Subhanplays/pterodactyl-panel/main/playit-gg.sh)
      spinner "Setting up Playit..."
      ;;
    5)
      type_text "👋 Exiting. Goodbye!" 0.05
      exit 0
      ;;
    *)
      type_text "${RED}Invalid choice! Please enter a number between 1-5.${NC}" 0.05
      ;;
  esac

  type_text "${GRN}Press Enter to return to the menu...${NC}" 0.02
  read
done
