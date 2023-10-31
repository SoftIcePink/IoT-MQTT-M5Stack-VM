#!/bin/bash
# Program made by SoftIcePink
# Find me at https://github.com/SoftIcePink

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install dependencies for Graylog and OpenSearch
sudo apt-get install -y apt-transport-https 
sudo apt-get install -y uuid-runtime 
sudo apt-get install -y pwgen 
sudo apt-get install -y curl 
sudo apt-get install -y mosquitto 
sudo apt-get install -y mosquitto-clients 
sudo apt-get install -y python3 
sudo apt-get install -y python3-pip 
sudo apt-get install -y gnupg 
sudo apt-get install -y pwgen 
sudo apt-get install -y openjdk-17-jre-headless

# Add OpenSearch repository and install OpenSearch
# Check if OpenSearch is already installed
# Check if MongoDB is installed
if dpkg -s mongodb-org >/dev/null 2>&1; then
  echo "MongoDB is already installed."
  # Get MongoDB version
  mongodb_version=$(dpkg -s mongodb-org | grep Version)
  echo "MongoDB version: $mongodb_version"
else
  echo "MongoDB is not installed. Proceeding with the installation..."
  # Install MongoDB
  # Add MongoDB repository and install MongoDB
  sudo curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
   echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
  sudo systemctl start mongodb
  
  
fi


echo "Sleeping for 20 sec to make sure mongo gets started..."
sudo systemctl restart mongod.service

sleep 20

# Create Graylog database and admin user
mongosh <<EOF
use graylog
db.createUser({
  user: "grayloguser",
  pwd: "secret",
  roles: [{ role: "readWrite", db: "graylog" }]
})
EOF

# Check if OpenSearch is installed
if dpkg -s opensearch >/dev/null 2>&1; then
  echo "OpenSearch is already installed."
  # Get OpenSearch version
  opensearch_version=$(dpkg -s opensearch | grep Version)
  echo "OpenSearch version: $opensearch_version"
else
  echo "OpenSearch is not installed. Proceeding with the installation..."
  # Install OpenSearch
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "39D319879310D3FC"
  sudo curl -SLO https://artifacts.opensearch.org/releases/bundle/opensearch/2.7.0/opensearch-2.7.0-linux-x64.deb
  sudo curl -SLO https://artifacts.opensearch.org/releases/bundle/opensearch/2.7.0/opensearch-2.7.0-linux-x64.deb.sig
  sudo curl -o- https://artifacts.opensearch.org/publickeys/opensearch.pgp | gpg --import -
  sudo gpg --verify opensearch-2.7.0-linux-x64.deb.sig opensearch-2.7.0-linux-x64.deb
  sudo dpkg -i opensearch-2.7.0-linux-x64.deb
  sudo systemctl enable opensearch
  sudo systemctl start opensearch
fi

# Check if Graylog is installed
if dpkg -s graylog-server >/dev/null 2>&1; then
  echo "Graylog is already installed."
  # Get Graylog version
  graylog_version=$(dpkg -s graylog-server | grep Version)
  echo "Graylog version: $graylog_version"
else
  echo "Graylog is not installed. Proceeding with the installation..."
  # Install Graylog
  echo "Graylog is not installed. Proceeding with the installation..."
  
  # Add Graylog repository and install Graylog
  sudo curl -LO https://packages.graylog2.org/repo/packages/graylog-5.0-repository_latest.deb
  sudo dpkg -i graylog-5.0-repository_latest.deb
  sudo apt-get update && sudo apt-get install graylog-server
fi


# Generate password and secret for Graylog
sudo echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1 > passwd.txt
sudo pwgen -N 1 -s 96 > secret.txt

# Update Graylog server.conf file
sudo sed -i "s/^password_secret.*/password_secret = $(cat secret.txt)/" /etc/graylog/server/server.conf
sudo sed -i "s/^root_password_sha2.*/root_password_sha2 = $(cat passwd.txt)/" /etc/graylog/server/server.conf
#sudo sed -i 's/^is_master.*/is_master = true/' /etc/graylog/server/server.conf
sudo sed -i 's/^root_username.*/root_username = admin/' /etc/graylog/server/server.conf
sudo sed -i 's/^#http_bind_address.*/http_bind_address = 127.0.0.1:9000/' /etc/graylog/server/server.conf
sudo sed -i 's/^#http_publish_uri.*/http_publish_uri = http:\/\/127.0.0.1:9000/' /etc/graylog/server/server.conf
sudo sed -i 's/^mongodb_uri.*/mongodb_uri = mongodb:\/\/grayloguser:secret@localhost:27017\/graylog/' /etc/graylog/server/server.conf
¨sudo sed -i 's/^#root_timezone = UTC*/#root_timezone = Europe\/Zurich/' /etc/graylog/server/server.conf

# Update OpenSearch configuration files
sudo sed -i 's/^#cluster.name*/cluster.name: graylog/' /etc/opensearch/opensearch.yml
sudo sed -i 's/^#network.host*/network.host: 0.0.0.0/' /etc/opensearch/opensearch.yml
sudo sed -i 's/^#http.port*/http.port: 9200/' /etc/opensearch/opensearch.yml
sudo sed -i '/^#discovery.seed_hosts:/a discovery.type: single-node' /etc/opensearch/opensearch.yml
sudo sed -i '/^plugins.security.audit.type:/a plugins.security.disabled: true' /etc/opensearch/opensearch.yml

# Install OpenSSH server
sudo apt-get install -y openssh-server

# Configure /etc/ssh/sshd_config
sudo sed -i 's/^#Subsystem[[:space:]]\+sftp[[:space:]]\+\/usr\/lib\/openssh\/sftp-server/Subsystem sftp \/usr\/lib\/openssh\/sftp-server/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication[[:space:]]\+yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#ListenAddress[[:space:]]\+0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config

# Restart sshd service
sudo systemctl restart sshd

# Configure Mosquitto default config
sudo tee /etc/mosquitto/conf.d/default.conf <<EOF
listener 1883
use_identity_as_username true
allow_anonymous true
EOF

# Allow Mosquitto port in UFW
sudo ufw allow 1883/tcp

# Change ownership of MongoDB files
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock

sudo pip install graypy

echo "Setup complete!"

echo "Starting up the services"
sudo systemctl restart opensearch
sudo systemctl restart mongodb
sudo systemctl restart graylog-server.service

# Check the running ports and services
graylog_port=$(sudo grep -oP 'http_bind_address = \K.*' /etc/graylog/server/server.conf)
mosquitto_port=$(sudo grep -oP 'listener \K.*' /etc/mosquitto/conf.d/default.conf)
mongodb_port="27017"
mongodb_db="graylog"
graylog_user="admin"
graylog_password=$(sudo grep -oP 'root_password_sha2 = \K.*' /etc/graylog/server/server.conf)

echo "Graylog is running at port: $graylog_port"
echo "Mosquitto is running at port: $mosquitto_port"
echo "MongoDB is running at port: $mongodb_port"
echo "MongoDB database is: $mongodb_db"
echo "Graylog account is: $graylog_user:$graylog_password"
