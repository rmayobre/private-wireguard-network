#!/bin/bash

########################
#    WIREGUARD SETUP   #
########################

# Install EPEL Release Repo
dnf install epel-release elrepo-release -y

# Install Wireguard kernel module repo
dnf copr enable -y jdoss/wireguard

# Update your repo data
dnf update -y 

# Install the Wireguard module and tools
dnf install -y wireguard-dkms wireguard-tools

mkdir /etc/wireguard/server/
mkdir /etc/wireguard/peer1/

# Generate public and private keys
wg genkey | tee /etc/wireguard/server/privatekey | wg pubkey | tee /etc/wireguard/server/publickey
wg genkey | tee /etc/wireguard/peer1/privatekey | wg pubkey | tee /etc/wireguard/peer1/publickey

# Create wireguard server config file
touch /etc/wireguard/wg0.conf

endpoint=$(curl ifconfig.me)
serverprivatekey=$(cat /etc/wireguard/server/privatekey)
serverpublickey=$(cat /etc/wireguard/server/publickey)
peer1privatekey=$(cat /etc/wireguard/peer1/privatekey)
peer1publickey=$(cat /etc/wireguard/peer1/publickey)

# Server Interface
echo "[Interface]" >> /etc/wireguard/wg0.conf
echo "Address=10.0.0.1/24" >> /etc/wireguard/wg0.conf
echo "SaveConfig = true" >> /etc/wireguard/wg0.conf
echo "ListenPort = 51820" >> /etc/wireguard/wg0.conf
echo "PrivateKey = ${serverprivatekey}" >> /etc/wireguard/wg0.conf
echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf
echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf

# Server Peer1 connection
echo "" >> /etc/wireguard/wg0.conf
echo "[Peer]" >> /etc/wireguard/wg0.conf
echo "PublicKey = ${peer1publickey}" >> /etc/wireguard/wg0.conf
echo "AllowedIPs = 10.0.0.2/32" >> /etc/wireguard/wg0.conf

# Create wireguard peer config file
touch /etc/wireguard/peer1/peer1.conf

# Peer Interface
echo "[Interface]" >> /etc/wireguard/peer1/peer1.conf
echo "Address = 10.0.0.2/32" >> /etc/wireguard/peer1/peer1.conf
echo "PrivateKey = ${peer1privatekey}" >> /etc/wireguard/peer1/peer1.conf
echo "DNS = 1.1.1.1" >> /etc/wireguard/peer1/peer1.conf

# Peer Server connection
echo "" >> /etc/wireguard/peer1/peer1.conf
echo "[Peer]" >> /etc/wireguard/peer1/peer1.conf
echo "PublicKey = ${serverpublickey}" >> /etc/wireguard/peer1/peer1.conf
echo "Endpoint = ${endpoint}:51820" >> /etc/wireguard/peer1/peer1.conf
echo "AllowedIPs = 10.0.0.0/24" >> /etc/wireguard/peer1/peer1.conf

# Start wg0 interface on boot.
systemctl enable wg-quick@wg0

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