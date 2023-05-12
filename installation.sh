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
sudo apt-get install -y openjdk-8-jre-headless

echo "In a few weeks, a new version will be out with Graylog, OpenSearch and MongoDB"
