#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${GREEN}=== Guacamole Setup (Workspace) ===${RESET}"

# Ensure required folders exist
mkdir -p guacamole/extensions guacamole/lib guacamole/initdb

# Start containers
echo -e "${GREEN}Starting Docker services...${RESET}"
docker compose up -d guacd guac-db guacamole

# Wait for DB to be ready
echo -e "${GREEN}Waiting for database to accept connections...${RESET}"
until docker exec guac-mysql mysqladmin ping -h "localhost" --silent; do
  sleep 2
done

# Generate initdb.sql if not present
if [ ! -f guacamole/initdb/initdb.sql ]; then
  echo -e "${GREEN}Generating initdb.sql...${RESET}"
  docker run --rm guacamole/guacamole \
    /opt/guacamole/bin/initdb.sh --mysql > guacamole/initdb/initdb.sql
fi

# Apply schema
echo -e "${GREEN}Initializing Guacamole database...${RESET}"
docker exec -i guac-mysql \
  mysql -uguacamole_user -pstrongpass guacamole_db < guacamole/initdb/initdb.sql

# Restart guacamole container to pick up DB
docker compose restart guacamole

# Info
echo -e "${GREEN}Guacamole is now running!${RESET}"
echo ""
echo "URL: http://localhost:8081/guacamole"
echo "Default login: guacadmin / guacadmin"
echo ""
echo "Extension directories (mount into ./guacamole/extensions):"
echo " - guacamole-auth-ldap*.jar (for LDAP/AD)"
echo " - guacamole-auth-totp*.jar (for 2FA)"
echo " - guacamole-auth-openid*.jar (for OIDC/SSO)"
echo ""
echo -e "${GREEN}=== Done! ===${RESET}"
