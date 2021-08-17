#!/bin/bash

########################
#     DEPENDENCIES     #
########################

sudo apt-get update &&
    sudo apt-get install -yqq \
        curl \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common

########################
#     DOCKER SETUP     #
########################

# Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" &&
    sudo apt-get update &&
    sudo apt-get install docker-ce docker-ce-cli containerd.io -yqq

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

########################
#      PWN SETUP       #
########################

docker-compose -f docker-compose-admin.yml -p "pwn-admin" up -d
docker-compose -f docker-compose-private.yml -p "pwn-private" up -d
