
#!/bin/bash

clear

# Colors
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

# Function: typing effect
type_text() {
  text="$1"
  delay="${2:-0.03}"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $delay
  done
  echo
}

# Function: spinning loader
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

# Custom ASCII Logo
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

type_text "🚀 Setting up your Pterodactyl Panel environment..." 0.05
sleep 1

# Installing Docker Compose with spinner
type_text "📦 Installing Docker Compose..."
(apt update && apt install docker-compose -y) &
spinner "Installing Docker Compose..."

# Setting up directories with animated dots
type_text "🛠 Setting up Pterodactyl Panel directories..."
mkdir -p pterodactyl/panel
cd pterodactyl/panel || exit

dots="...."
for i in $(seq 1 3); do
  printf "\r${CYN}Creating directories${dots:0:$i}${NC}"
  sleep 0.5
done
echo -e "\r${CYN}Directories created!     ${NC}"

# Writing docker-compose.yml with typing effect
type_text "📝 Writing docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.8'

x-common:
  database:
    &db-environment
    MYSQL_PASSWORD: &db-password "CHANGE_ME"
    MYSQL_ROOT_PASSWORD: "CHANGE_ME_TOO"
  panel:
    &panel-environment
    APP_URL: "https://pterodactyl.example.com"
    APP_TIMEZONE: "UTC"
    APP_SERVICE_AUTHOR: "admin@subhanzahid.com"
    TRUSTED_PROXIES: "*"
  mail:
    &mail-environment
    MAIL_FROM: "admin@example.com"
    MAIL_DRIVER: "smtp"
    MAIL_HOST: "mail"
    MAIL_PORT: "1025"
    MAIL_USERNAME: ""
    MAIL_PASSWORD: ""
    MAIL_ENCRYPTION: "true"

services:
  database:
    image: mariadb:10.5
    restart: always
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - "./data/database:/var/lib/mysql"
    environment:
      <<: *db-environment
      MYSQL_DATABASE: "panel"
      MYSQL_USER: "pterodactyl"

  cache:
    image: redis:alpine
    restart: always

  panel:
    image: ghcr.io/pterodactyl/panel:latest
    restart: always
    ports:
      - "8030:80"
      - "4433:443"
    links:
      - database
      - cache
    volumes:
      - "./data/var:/app/var"
      - "./data/nginx:/etc/nginx/http.d"
      - "./data/certs:/etc/letsencrypt"
      - "./data/logs:/app/storage/logs"
    environment:
      <<: [*panel-environment, *mail-environment]
      DB_PASSWORD: *db-password
      APP_ENV: "production"
      APP_ENVIRONMENT_ONLY: "false"
      CACHE_DRIVER: "redis"
      SESSION_DRIVER: "redis"
      QUEUE_DRIVER: "redis"
      REDIS_HOST: "cache"
      DB_HOST: "database"
      DB_PORT: "3306"

networks:
  default:
    ipam:
      config:
        - subnet: 172.20.0.0/16
EOF

# Creating data directories with spinner
type_text "📁 Creating data directories..."
(mkdir -p ./data/{database,var,nginx,certs,logs}) &
spinner "Creating directories..."

# Starting containers with spinner
type_text "🚀 Starting Pterodactyl containers..."
(docker-compose up -d) &
spinner "Starting containers..."

# Creating admin user with typing effect
type_text "👤 Creating Admin User..."
docker-compose run --rm panel php artisan p:user:make

type_text "✅ All done! Enjoy your Pterodactyl Panel setup, SubhanPlayz!" 0.05
