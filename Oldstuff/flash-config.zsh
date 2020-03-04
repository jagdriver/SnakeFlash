#!/bin/bash

#
# WaveSnake Swarm Flash Configuration script
# This script must be executed in the Flashing directory
# You can choose to edit properties in swarmconfig.txt
# or be prompted for properties.
# WaveSnake Technologies
# 2020-02-20 Niels Jørgen Nielsen

# TODO:
# TODO: Configure Instance name meta-data Ok
# TODO: Register with Letsencrypt ? I don't think it's necssecary to register
# TODO: Get DynDns username and password Ok
# TODO: Test DynDns install input
# TODO: Generate SSH Private/Public keys

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'
SWARM_MANAGER_NODE='ws01'
SWARM_PORT='2377'
CURRENT_DIR=$(pwd)

# cd /Users/nielsjorgennielsen/Flashing

# Ask for prompted or file input
# Select based on input

read -p "Select input file or prompt? f/p " -n 1 -r
if [[ $REPLY =~ ^[Ff]$ ]]
then
   # Read all properties from swarmconfig.txt
   source swarmconfig.txt
   # Swarm Properties
   NODE=$NODE_NAME
   SWARM_MANAGER_NODE=$SWARM_MANAGER_NODE
   SWARM_PORT=$SWARM_PORT
   MANAGER_NAME=$MANAGER_NAME
   SWARM_MANAGER_NODE=$SWARM_MANAGER_NODE
   MANAGER_PASSWORD=$MANAGER_PASSWORD
   TIME_ZONE=$TIME_ZONE
   # WiFi properties
   COUNTRY_CODE=$COUNTRY_CODE
   WIFI_SSID=$WIFI_SSID
   WIFI_PASSWD=$WIFI_PASSWORD
   # LAN ETH0 properties
   ETH0_LAN=$ETH0_LAN
   ETH0_IP_ADDRESS=$ETH0_IP_ADDRESS
   ETH0_STATIC_ROUTERS=$ETH0_STATIC_ROUTERS
   ETH0_STATIC_DNS_SERVERS=$ETH0_STATIC_DNS_SERVERS
   # LAN WLAN0 properties
   WLAN0_LAN=$WLAN0_LAN
   WLAN0_IP_ADDRESS=$WLAN0_IP_ADDRESS
   WLAN0_STATIC_ROUTERS=$WLAN0_STATIC_ROUTERS
   WLAN0_STATIC_DNS_SERVERS=$WLAN0_DNS_SERVERS
   # Domain properties
   INTERNAL_DOMAIN_NAME=$INTERNAL_DOMAIN_NAME
   EXTERNAL_DOMAIN_NAME=$EXTERNAL_DOMAIN_NAME
   # Dynamic DNS properties
   GRATIS_DNS_USER=$GRATIS_DNS_USER
   GRATIS_DNS_PASSWD=$GRATIS_DNS_PASSWD
   CLOUDFLARE_DNS_USER=CLOUDFLARE_DNS_USER
   CLOUDFLARE_DNS_PASSWD=CLOUDFLARE_DNS_PASSWD
   # ACME properties
   ACME_EMAIL_ADDRESS=$ACME_EMAIL_ADDRESS
   # Traefik properties
   TRAEFIK_ENTRYPOINT_ADDRESS=$TRAEFIK_ENTRYPOINT_ADDRESS
fi

echo -e "\n"
echo -e "\n"

echo -e "${RED}${BOLD}WaveSnake Flash Configuration\n"
echo -e "This utility will prepare a Flash configuration file"
echo -e "by prompting for configuration parameters.\n"
echo -e "${GREEN}\n"

read -p "Flash configuration for Swarm Node ws01, ws02, ws03 or ws04, please type the Node to configure > "
NODE=$REPLY

echo -e "${RED}You have choosen" $NODE "which will be overridden!!!!"
echo -e "${GREEN}\n"

read -p "Are you ready for Configuring $NODE? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd $NODE
   echo -e "\n${RED} Configuring $NODE...\n"
   cp default-user-data new-user-data
   cp default-meta-data new-meta-data

#  # Do all common changes first

#  # Configura Instance Id (common)
   sed -i -n "s/INSTANCE-ID/$NODE/g" new-meta-data

#  # Configura Swarm Node (worker)
   sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data

#  # Configura Swarm Port (worker)
   sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data

#  # Configure Node name (common)
   read -p "Type Node name > "
   NODE_NAME=$REPLY
   sed -i -n "s/NODE-NAME/$NODE_NAME/g" new-user-data

#  # Configure swarm manager (common) 
   read -p "Type $NODE Manager name > "
   MANAGER_NAME=$REPLY
   sed -i -n "s/MANAGER-NAME/$MANAGER_NAME/" new-user-data

#  # Configure manager password (common)
   read -p "Type $NODE Manager password > "
   PASSWORD=$REPLY
   sed -i -n "s/MANAGER-PASSWORD/$PASSWORD/" new-user-data
 
#  # Configure external domain name (common)
   read -p "Type Swarm external domain name > "
   EXTERNAL_DOMAIN_NAME=$REPLY
   sed -i -n "s/EXTERNAL-DOMAIN-NAME/$EXTERNAL_DOMAIN_NAME/" new-user-data

#  # Configure internal domain name (common)
   # TODO: We might fix the internal domain name eg. wsswarm.local
   read -p "Type Swarm internal domain name > "
   INTERNAL_DOMAIN_NAME=$REPLY
   sed -i -n "s/INTERNAL-DOMAIN-NAME/$INTERNAL_DOMAIN_NAME/" new-user-data

#  # Configure Dynamic DNS (manager)
   # TODO: have to be tested with the different DNS providers
   # TODO: GratisDNS
   # TODO: CloudFlare
   read -p "Use Dynamic DNS y/n > "
   if [[ $REPLY =~ ^[Yy]$ ]]
   then
      # TODO: Ask for GratisDNS or CloudFlare

      DYNAMIC_DNS="sudo apt-get -y install dyndns-gd"
      sed -i -n "s/DYNAMIC-DNS/$DYNAMIC_DNS/" new-user-data
   else 
      DYNAMIC_DNS="logger !!! wavesnake !!! No Dynamic DNS client installed"
      sed -i -n "s/DYNAMIC-DNS/$DYNAMIC_DNS/" new-user-data
   fi
   
#  # Configure Time Zone (common)
   read -p "Type $NODE Time Zone, ex. Europe/Copenhagen > "
   TIME_ZONE=$REPLY
   sed -i -n "s#TIME-ZONE#$TIME_ZONE#" new-user-data

#  # Configure ETH0 LAN (common)
   read -p "Type $NODE ETH0 LAN, ex. 192.168.8.0/24 > "
   ETH0_LAN=$REPLY
   sed -i -n "s#ETH0-LAN#$ETH0_LAN#" new-user-data

#  # Configure ETH0 IP address (common)
   read -p "Type $NODE ETH0 IP address > "
   ETH0_IP_ADDRESS=$REPLY
   sed -i -n "s/ETH0-IP-ADDRESS/$ETH0_IP_ADDRESS/" new-user-data

#  # Configure $NODE ETH0 static routers (common)
   read -p "Type $NODE ETH0 static routers > "
   ETH0_STATIC_ROUTERS=$REPLY
   sed -i -n "s/ETH0-STATIC-ROUTERS/$ETH0_STATIC_ROUTERS/" new-user-data

#  # Configure $NODE ETH0 DNS servers (common)
   read -p "Type $NODE ETH0 static DNS servers > "
   ETH0_STATIC_DNS_SERVERS=$REPLY
   sed -i -n "s/ETH0-STATIC-DNS-SERVERS/$ETH0_STATIC_DNS_SERVERS/" new-user-data

#  # Configure WLAN0 LAN (manager)
   read -p "Type $NODE WLAN0 LAN, ex. 192.168.1.0/24 > "
   WLAN0_LAN=$REPLY
   sed -i -n "s#WLAN0-LAN#$WLAN0_LAN#" new-user-data

#  # Configure WLAN0 WIFI Country Code (manager)
   read -p "Type $NODE WLAN0 WiFi Country Code > "
   COUNTRY_CODE=$REPLY
   sed -i -n "s/COUNTRY-CODE/$COUNTRY_CODE/" new-user-data

#  # Configure WLAN0 WIFI SSID (manager)
   read -p "Type $NODE WLAN0 WiFi SSID to connect to > "
   WIFI_SSID=$REPLY
   sed -i -n "s/WIFI-SSID/$WIFI_SSID/" new-user-data

#  # Configure WLAN0 WIFI Password (manager)
   read -p "Type $NODE WIFI Password > "
   WIFI_PASSWD=$REPLY
   sed -i -n "s/WIFI-PASSWD/$WIFI_PASSWD/" new-user-data

#  # Configure WLAN0 IP address (manager)
   read -p "Type $NODE WLAN0 IP address > "
   WLAN0_IP_ADDRESS=$REPLY
   sed -i -n "s/WLAN0-IP-ADDRESS/$WLAN0_IP_ADDRESS/" new-user-data

#  # Configure $NODE WLAN0 static routers (manager)
   read -p "Type $NODE WLAN0 static routers > "
   WLAN0_STATIC_ROUTERS=$REPLY
   sed -i -n "s/WLAN0-STATIC-ROUTERS/$WLAN0_STATIC_ROUTERS/" new-user-data

#  # Configure $NODE WLAN0 DNS servers (manager)
   read -p "Type $NODE WLAN0 static DNS servers > "
   WLAN0_STATIC_DNS_SERVERS=$REPLY
   sed -i -n "s/WLAN0-STATIC-DNS-SERVERS/$WLAN0_STATIC_DNS_SERVERS/" new-user-data

#  # Configure TRAEFIK entrypoint listen address (manager)
   read -p "Type $NODE Traefik entrypoint listen address > "
   TRAEFIK_ENTRYPOINT_ADDRESS=$REPLY
   sed -i -n "s/TRAEFIK-ENTRYPOINT-ADDRESS/$TRAEFIK_ENTRYPOINT_ADDRESS/" new-user-data
   
#  # Configure TRAEFIK ACME Email Address (manager)
   read -p "Type $NODE Traefik ACME Email address > "
   ACME_EMAIL_ADDRESS=$REPLY
   sed -i -n "s/ACME-EMAIL-ADDRESS/$ACME_EMAIL_ADDRESS/" new-user-data

#  # Configure GratisDNS UserName (manager)
   read -p "Type GratisDNS User Name > "
   GRATISDNS_USER=$REPLY
   sed -i -n "s/GRATISDNS-USER/$GRATISDNS_USER/" new-user-data

#  # Configure GratisDNS UserName (manager)
   read -p "Type GratisDNS User Password > "
   GRATISDNS_PASSWORD=$REPLY
   sed -i -n "s/GRATISDNS-PASSWORD/$GRATISDNS_PASSWORD/" new-user-data

#  # TODO: Register with Letsencrypt
#  # TODO: Get DynDns username and password


   mv new-user-data user-data
   mv new-meta-data meta-data
   cd ..
   echo "\n"
fi
echo "\n"
