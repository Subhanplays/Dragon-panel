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

# Animated Playit installation
type_text "🌐 Downloading Playit agent..."
(wget https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64 -O playit-linux-amd64) &
spinner "Downloading..."

type_text "⚡ Setting executable permissions..."
(chmod +x playit-linux-amd64) &
spinner "Applying permissions..."

type_text "🚀 Launching Playit agent..."
(./playit-linux-amd64) &
spinner "Starting agent..."

type_text "✅ Playit agent setup complete!" 0.05
