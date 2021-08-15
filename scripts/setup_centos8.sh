#!/bin/bash

########################
#    WIREGUARD SETUP   #
########################

# Install EPEL Release Repo
dnf install -y elrepo-release #epel-release

# Install Wireguard kernel module repo
dnf copr enable -y jdoss/wireguard

# Update your repo data
dnf update -y 

# Install the Wireguard module and tools
dnf install -y kmod-wireguard

# Activate the module
modprobe wireguard

########################
#     DOCKER SETUP     #
########################

# Install docker
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io

# Enable docker for startup on boot
systemctl enable --now docker

# Download docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

########################
#      PWN SETUP       #
########################

docker-compose up -d