#!/usr/bin/env bash
set -euo pipefail

# Versions and credentials
MYSQL_ROOT_PASS="rootpass"
MYSQL_GUAC_PASS="strongpass"

echo "=== Detecting latest Guacamole version ==="
LATEST=$(curl -s https://dlcdn.apache.org/guacamole/ \
  | grep -oP 'href="\K[0-9]+\.[0-9]+\.[0-9]+' \
  | sort -Vr | head -n1)
echo "Latest Guacamole version: $LATEST"

echo "=== Installing dependencies ==="
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev \
  libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev \
  libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev \
  freerdp2-dev libwebsockets-dev \
  tomcat10 mysql-server wget curl

echo "=== Building guacd (server proxy) ==="
cd /tmp
wget https://downloads.apache.org/guacamole/${LATEST}/source/guacamole-server-${LATEST}.tar.gz
tar -xzf guacamole-server-${LATEST}.tar.gz
cd guacamole-server-${LATEST}
./configure --with-init-dir=/etc/init.d
make -j$(nproc)
make install
ldconfig
systemctl enable guacd || true
systemctl start guacd || true

echo "=== Deploying guacamole.war (web app) ==="
cd /tmp
wget https://downloads.apache.org/guacamole/${LATEST}/binary/guacamole-${LATEST}.war -O guacamole.war
cp guacamole.war /var/lib/tomcat10/webapps/guacamole.war

echo "=== Setting up MySQL database ==="
service mysql start
mysql -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS guacamole_db;
CREATE USER IF NOT EXISTS 'guacamole_user'@'localhost' IDENTIFIED BY '${MYSQL_GUAC_PASS}';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "=== Initializing Guacamole schema ==="
wget https://downloads.apache.org/guacamole/${LATEST}/binary/guacamole-auth-jdbc-${LATEST}.tar.gz -O guac-jdbc.tar.gz
tar -xzf guac-jdbc.tar.gz
mkdir -p /etc/guacamole/extensions
cp guacamole-auth-jdbc-${LATEST}/mysql/guacamole-auth-jdbc-mysql-${LATEST}.jar /etc/guacamole/extensions/
cat guacamole-auth-jdbc-${LATEST}/mysql/schema/*.sql \
  | mysql -uguacamole_user -p${MYSQL_GUAC_PASS} guacamole_db

echo "=== Configuring guacamole.properties ==="
mkdir -p /etc/guacamole
cat > /etc/guacamole/guacamole.properties <<EOP
mysql-hostname: localhost
mysql-port: 3306
mysql-database: guacamole_db
mysql-username: guacamole_user
mysql-password: ${MYSQL_GUAC_PASS}
EOP

ln -s /etc/guacamole /usr/share/tomcat10/.guacamole || true

echo "=== Restarting services ==="
systemctl restart guacd || true
systemctl restart tomcat10 || true
service mysql restart

echo "======================================================"
echo "Guacamole ${LATEST} installed!"
echo "Access URL: http://localhost:8080/guacamole"
echo "Default login: guacadmin / guacadmin"
echo "======================================================"
