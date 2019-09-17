#!/bin/bash

# We make sure have the latest packages 
sudo apt-get update

# Here we install the required components for Docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# We add the docker repository to our apt-get key storer
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Checks the docker repo key fingerprint if uncommented
# This ensures the docker repo is the official one - integrity check
#sudo apt-key fingerprint 0EBFCD88

# Add the docker repo to our apt source list
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Re-run an update to load the new docker repo
sudo apt-get update

# Install Docker
sudo apt-get -y install docker-ce

# Add the user(s) to the Docker group, ensuring permissions
# Replace `root` with the username you want - usually you want your standard user/service account and root account.
sudo usermod -aG docker root

# Reload the docker daemon and restart the service
sudo systemctl daemon-reload && service docker restart
