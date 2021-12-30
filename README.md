# Private Wireguard Network (PWN)
A dual `Wireguard` network configuration to help seperate common use services from admin tools. The admin network (pwn-admin) comes with `Portainer`, as well as a `Portainer Agent`, to help manage `Docker` containers. The private network (pwn-private) comes with a `Pi-Hole` and `Unbound` configuration to provide ad-blocking and a caching DNS resolver.

## Archived - 12/30/21
This project has been archieved in favor of a new approach to a Wireguard networking stack ([link](https://github.com/rmayobre/easy-pwn)). This project still works as of writing this update to the `README`, however, I will not be applying bug fixes to the scripts or docker-compose file.

I would recommend trying the new stack I created in the link above, as it address some issues with managing the peer connections of the Wireguard server.

## Admin Network
* 12.2.0.0/24 - Admin Network's subnet
* 12.6.0.0/24 - Admin Wireguard's internal subnet
* 12.2.0.100:9000 - Portainer Web UI
* 12.2.0.101:9001 - Portainer Agent

## Private Network
* 10.2.0.0/24 - Private Network's subnet
* 10.6.0.0/24 - Private Wireguard's internal subnet
* 10.2.0.100/admin - Pi Hole Web UI

# Installation
PWN uses Docker for deployment. 
Clone the repo:
```
git clone https://github.com/rmayobre/private-wireguard-network.git
```
Once the repo is cloned, run `docker-compose` inside the project's diectory to build:
```bash
cd private-wireguard-network
docker-compose up -d
```

## CentOS 8 Script
For `CentOS 8` based distros, there is a setup script to help install required dependencies and then run the `docker-compose.yml` file.

```bash
# Update and install Git.
dnf update -y
dnf install git -y

# Clone repo and change directories.
git clone https://github.com/rmayobre/private-wireguard-network.git
cd private-wireguard-network

# Give script executable permissions and run.
chmod +x ./scripts/setup_centos8.sh
./scripts/setup_centos8.sh
```

## Ubuntu Script
For `Ubuntu` based distros, there is a setup script to help install required dependencies and then run the `docker-compose.yml` file.

```bash
# Update and install Git.
dnf update -y
dnf install git -y

# Clone repo and change directories.
git clone https://github.com/rmayobre/private-wireguard-network.git
cd private-wireguard-network

# Give script executable permissions and run.
chmod +x ./scripts/setup_ubuntu.sh
./scripts/setup_ubuntu.sh
```

# Gaining Access
How to gain access to the PWN networks. **NOTE**: Once you have access to admin network, you can download all `Wireguard` conf files from `Portainer` (requires Portainer configuration).

## PWN Admin
Do gain access to the admin network, you will need a Wireguard conf file from the `wireguard-admin-config` directory. The code snippet below shows where peer 1's conf file is located. If Wireguard is configured for more peer connections, iterate the directory's name to locate other peer conf files.
```bash
cd /var/lib/docker/volumes/wireguard-admin-config/_data/peer1/
ls
peer1.conf  peer1.png  privatekey-peer1  publickey-peer1 # Print out
```
For mobile access, you can get the logs of the `wireguard-admin` container to get a QR code.

```bash
docker logs wireguard-admin # run this

█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████
████ ▄▄▄▄▄ █▀▄▀▀█▄███▀ ▄█▀█   ▀█▄█ ██▄▀█ ▄▀▄█ ▄▄▄█▄ ██       ████
████ █   █ █▀▄▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█    ▄▄▄ ██ █   █ ████
████       █▀▀▀ ██ ▄█▀█▄   ▀ █ ▄▄▄ ▄ █▀█ ▄▀▄   ▄▄ ▀▄█        ████
████▄ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄ █ █▄▄▄▄▄▄▄████
████ ▄ ▄ ▀▄ ▄██▄▄ █ █ ▄▀▄▀██ ▄▄ ▄ ▀▀▀▄▄ █▀ ▄▀█▄▄▀ █   █▄█▄█▄█████
████ █▀▄█▀▄▀ ▄▄ █▄▀▄ ▀▄▄█▀▀█▀▄█ ▀ ▀▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀█████
████▄█▄ ▄▀▄▄▀█ ▀ ▄▄▄▄▀ ▀▄▀▄▀▀▀▀██▄ ▀▄▄█▄█ ▄█▀▄▀▄█▄▄█ ▀█▀▀█▄▄█████
████▀   ▄▄▄▀▄   ▄▀▄██ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄ █   ▀████
████▀▀█  █▄ ▀▄  ▄█▄▄▄ ▀█▄▀  ▀▄▀   █▀▀██   ██▀▄▀██▀▄████ ▀▄▄▀▀████
█████ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄         ██████
████  ▀   ▄  ▄ █▀▀█▄▀ ▀▀  ███▄▀▀▄▄█▀▀ █████                  ████
████▀ ▀▀ ▄▄▄ ▀ █▄▄▀▄  ▄███▀█▀   █  ▀▀██▀▄▄ █  █▄▄▀▀  █ ▀▄▄█ █████
████▄▀▀█ ▄▄    ▀ ██▀▀█▄▀▄▀▀▄▀▄ ▄▀▄ ▀▀ ██▀▄█▄▀████            ████
████▀█ █ ▄▄▄ ▄  ▀▄▄█▄▄█  ▄█▄▄ ▄▄▄ ▀█ ▀█ ▀▀▄▀█ ▄▀ █▀ ▄▄▄    ▄█████
████ ▄█▄ █▄  ███   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄      ▄  ████
████▄▄▄█  ▄ ▄█▀ ▄▄█ █▄▀▄  ▄▄ ▄  ▄ ▄ ▀▀▄▀█  █▀ █ ▀ ▄▄▄  ▄▄ ▀ █████
████  ▀▄█▄▄▀█▄██▄█▀▄█▄▄▀▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  █▄ █▄▀ █ ████
████▀▀▄▀▄█▄▄█▀███▄█▀ █▄█▀▄██ ▄▀█▀█ █ ▀▄█  █▄▀ █▀▀▄ ▀██  ▄▀█  ████
████▀█ █ ▄▄  ▀     ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄        █████
█████▄▀▀▄▀▄▀█ █▄ ▀▀█ ▀ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█ ▄▄▄ ▄████
████▀ █ ▀█▄▄▀██ █▄▄ ▄▀▄▀▄▀▀▀ █▀▄▄▄ ▀  ▄▄█▀ █ ▄▀ ▀▄ ▀▀▀█▀▄ ▄█▀████
████▄▄█  ▀▄█▀▄▄ ▄▄ █▀ ██▀ █▀█▀ ▀ ▀▀▄██ █▄▄▀ █ ▀▄█▀▄▄▀ █▀▀▄▄  ████
████ ▄▀▄ ▄▄█  ██▀▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄     █▄█▄▀ ████
████ ▀ ▀▀▄▄█▀ ██▀▄█   ▀█ ██▀██▄▄ ▀▄▀ ▄▄▀▄▄  ██▀ ▄ ▀▄▄█▀█▀ ▄█ ████
████ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄  ▀ ▄▄▄ ▄▄ ▄████
████ ▄▄▄▄▄ █ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█ ██▀▄▄▀▀▀  ▄█   ████
████       █  █▄▀▀█▄▀█ ▄█ █▀▄█ ▄  ▄ █▄▄█▄ █ █▀▀▄█ ██  ▄  ▀▀▄█████
████ █▄▄▄█ █  ▄█ █▄▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█▄▄█  █▀█▄▀██████
████▄▄▄▄▄▄▄█▄███▄██▄▄█▄▄▄██▄███▄██▄█▄█▄█▄▄▄▄███▄▄▄▄█▄▄███▄▄▄█████
█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████

```

## PWN Private
You can obtain a Wireguard conf file from Portainer, `wireguard-private-config` volume, or docker logs (mobile QR code).
```bash
cd /var/lib/docker/volumes/wireguard-private-config/_data/peer1/
ls
peer1.conf  peer1.png  privatekey-peer1  publickey-peer1 # Print out
```
For mobile access, you can get the logs of the `wireguard-private` container to get a QR code.

```bash
docker logs wireguard-admin # run this

█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████
████ ▄▄▄▄▄ █▀▄▀▀█▄███▀ ▄█▀█   ▀█▄█ ██▄▀█ ▄▀▄█ ▄▄▄█▄ ██       ████
████ █   █ █▀▄▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█    ▄▄▄ ██ █   █ ████
████       █▀▀▀ ██ ▄█▀█▄   ▀ █ ▄▄▄ ▄ █▀█ ▄▀▄   ▄▄ ▀▄█        ████
████▄ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄ █ █▄▄▄▄▄▄▄████
████ ▄ ▄ ▀▄ ▄██▄▄ █ █ ▄▀▄▀██ ▄▄ ▄ ▀▀▀▄▄ █▀ ▄▀█▄▄▀ █   █▄█▄█▄█████
████ █▀▄█▀▄▀ ▄▄ █▄▀▄ ▀▄▄█▀▀█▀▄█ ▀ ▀▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀█████
████▄█▄ ▄▀▄▄▀█ ▀ ▄▄▄▄▀ ▀▄▀▄▀▀▀▀██▄ ▀▄▄█▄█ ▄█▀▄▀▄█▄▄█ ▀█▀▀█▄▄█████
████▀   ▄▄▄▀▄   ▄▀▄██ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄ █   ▀████
████▀▀█  █▄ ▀▄  ▄█▄▄▄ ▀█▄▀  ▀▄▀   █▀▀██   ██▀▄▀██▀▄████ ▀▄▄▀▀████
█████ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄         ██████
████  ▀   ▄  ▄ █▀▀█▄▀ ▀▀  ███▄▀▀▄▄█▀▀ █████                  ████
████▀ ▀▀ ▄▄▄ ▀ █▄▄▀▄  ▄███▀█▀   █  ▀▀██▀▄▄ █  █▄▄▀▀  █ ▀▄▄█ █████
████▄▀▀█ ▄▄    ▀ ██▀▀█▄▀▄▀▀▄▀▄ ▄▀▄ ▀▀ ██▀▄█▄▀████            ████
████▀█ █ ▄▄▄ ▄  ▀▄▄█▄▄█  ▄█▄▄ ▄▄▄ ▀█ ▀█ ▀▀▄▀█ ▄▀ █▀ ▄▄▄    ▄█████
████ ▄█▄ █▄  ███   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄      ▄  ████
████▄▄▄█  ▄ ▄█▀ ▄▄█ █▄▀▄  ▄▄ ▄  ▄ ▄ ▀▀▄▀█  █▀ █ ▀ ▄▄▄  ▄▄ ▀ █████
████  ▀▄█▄▄▀█▄██▄█▀▄█▄▄▀▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  █▄ █▄▀ █ ████
████▀▀▄▀▄█▄▄█▀███▄█▀ █▄█▀▄██ ▄▀█▀█ █ ▀▄█  █▄▀ █▀▀▄ ▀██  ▄▀█  ████
████▀█ █ ▄▄  ▀     ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄        █████
█████▄▀▀▄▀▄▀█ █▄ ▀▀█ ▀ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█ ▄▄▄ ▄████
████▀ █ ▀█▄▄▀██ █▄▄ ▄▀▄▀▄▀▀▀ █▀▄▄▄ ▀  ▄▄█▀ █ ▄▀ ▀▄ ▀▀▀█▀▄ ▄█▀████
████▄▄█  ▀▄█▀▄▄ ▄▄ █▀ ██▀ █▀█▀ ▀ ▀▀▄██ █▄▄▀ █ ▀▄█▀▄▄▀ █▀▀▄▄  ████
████ ▄▀▄ ▄▄█  ██▀▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄     █▄█▄▀ ████
████ ▀ ▀▀▄▄█▀ ██▀▄█   ▀█ ██▀██▄▄ ▀▄▀ ▄▄▀▄▄  ██▀ ▄ ▀▄▄█▀█▀ ▄█ ████
████ ▄▀▀▀▄█▄▀   ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█▄  ▀ ▄▄▄ ▄▄ ▄████
████ ▄▄▄▄▄ █ ▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█ ▄█ ██▀▄▄▀▀▀  ▄█   ████
████       █  █▄▀▀█▄▀█ ▄█ █▀▄█ ▄  ▄ █▄▄█▄ █ █▀▀▄█ ██  ▄  ▀▀▄█████
████ █▄▄▄█ █  ▄█ █▄▄▀██ ▄▀█▄█ █▀▀ ▀▄ ██▀▄▄▀▀▀  ▄█▄▄█  █▀█▄▀██████
████▄▄▄▄▄▄▄█▄███▄██▄▄█▄▄▄██▄███▄██▄█▄█▄█▄▄▄▄███▄▄▄▄█▄▄███▄▄▄█████
█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████

```

# Portainer Configuration
Go to `Portainer` (http://12.2.0.100:9000) and create a profile. After creating a profile, connect to the `Protainer Agent`. Connect to the the following endpoint: https://12.2.0.101:9001. Once connected, Portainer is ready to use.
