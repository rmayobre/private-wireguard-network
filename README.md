# Private Wireguard Network (PWN)
A private networking configuration, driven by Wireguard. This configuration provides two secure networks to help seperate services and administrative tools. The configuration comes with a WebUI on the admin network to manage services on the private network. The private network comes with Pi-Hole for ad blocking, and Unbound for DNS resolving. Both networks run on docker to help manage any environment configurations.

## Deploying a PWN Network
Currently, PWN has been tested on CentOS 8 and Docky Linux 8.

### CentOS 8
PWN comes with a script to install dependencies and configure the server for docker and wireguard.

Clone the repo:
```
git clone https://github.com/rmayobre/private-wireguard-network.git
```
Once the repo is cloned, go inside the project's directory and run the helper script:
```
chmod +x ./scripts/setup_centos8.sh
./scripts/setup_centos8.sh
```

#### Simple Shell Script
A simple shell script to help automate a PWN deployment on a CentOS 8 Distro.

```bash
#!/bin/bash

dnf update -y

dnf install git -y

git clone https://github.com/rmayobre/private-wireguard-network.git

cd private-wireguard-network

chmod +x ./scripts/setup_centos8.sh

./scripts/setup_centos8.sh
```

# Docker
The default configuration comees with Portainer to help manage the Private Network's services. You can also manage services within the Admin Network, however, deploying changes to the Wireguard-admin container can result in errors or connection lose. Because of this, it is recommended to apply changes to the wireguard-admin via Docker CLI.

# Admin Network
This network is designed to carry management services, such as Portainer. These are the kinds of services you don't particularlly want available for general use.

## Admin Wireguard Files
To get your wireguard configuration file for the admin network, as a QR code, run the following command:
```bash
docker logs wireguard-admin
```
You can also find your wireguard conf files inside the `/var/lib/docker/volumes/private-wireguard-network_wireguard_admin/_data/peer1`. directory.

## Portainer
By default, this network comes with Portainer to manage docker containers; however, you are welcome to change out for other docker GUIs. To launch Portainer, go to the `http://12.2.0.100:9000` IP address

If you decide to change out Portainer for another UI, make sure it runs within the admin network. The following template might help:
 ```yml
   docker-ui:
   ...
    networks:
      admin_network:
        ipv4_address: 12.2.0.100 # Change to any available IP under the same subnet 12.2.0.0/24.
 ```

# Private Network
For common use services, create your containers inside the private network. To deploy containers to the private network, use portainer (or the docker ui of your choice) and place the service inside the `admin_network` with it's own ip address. You can also use the following `docker-compose` template:
 ```yml
   private-network-service:
   ...
    networks:
      admin_network:
        ipv4_address: 10.2.0.1 # Change to any available IP under the same subnet 10.2.0.0/24.
 ```
 
## Private Network Wireguard Files
To get your wireguard configuration file for the private network, as a QR code, you can check the wireguard logs from within Portainer or run the following command:
```bash
docker logs wireguard
```
You can also find your wireguard conf files inside the `/var/lib/docker/volumes/private-wireguard-network_wireguard/_data/peer<NUMBER OF PEER>`. directory.

## Portainer
By default, this network comes with Portainer to manage docker containers; however, you are welcome to change out for other docker GUIs. To launch Portainer, go to the `http://12.2.0.100:9000` IP address

## Pi-Hole
The default IP address for Pi-Hole: `http://10.2.0.100/admin`
