#!/bin/sh

# Arguments
if [ -n "${1}" ]; then
  CUSTOM_DNS=${1}
else
  CUSTOM_DNS=localhost
fi

# 1.  install docker
## add gpd key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "added gpg key"

## docker repo to the apt sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## update the package database and install docker ce
sudo apt-get update -y
sudo apt-get install -y docker-ce
sudo apt install -y docker-compose
echo "installed docker"

sudo docker run -d -p 5000:5000 hariprakashohio/my-node-js-app:latest