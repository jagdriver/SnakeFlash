#!/bin/bash
#
# WaveSnake Swarm Flash Configuration script
# This script must be executed in the Flashing directory
# You can choose to edit properties in swarmconfig.txt
# or be prompted for properties.
# WaveSnake Technologies
# 2020-02-20 Niels Jørgen Nielsen

# TODO:
# 1 Configure Instance name meta-data Ok
# 2 Register with Letsencrypt ? I don't think it's necssecary to register
# 3 Get DynDns username and password Ok
# 4 Test DynDns install input OK
# 5 Generate SSH Private/Public keys and description
# 6 Set Swarm net to 192.168.230.0/24 OK
# 7 Retype password to check for correctness
# 8 User must type ACME email address and it must be checked for validity
# 9 User must paste in the Swarm Worker token, on Worker node config
# 10 Rearrange menu system OK
# 11 Make it possible to change node names
# 12 Make it possible to change internal IP addresses
# 13 Make it possible to change Manager WiFi IP address
# 14 Obfuscate passwords in files OK

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'
BLACK='\033[0;30m'
WHITE='\033[0;97m'
CURRENT_DIR=$(pwd)
RESETALL='\033[0m'
RD=$'\e[31m'
GR=$'\e[32m'
WH=$'\e[97m'
BC=$'\e[4m'
EC=$'\e[0m'
BO=$'\e[1m'
SWARM_NODES=()
NODE_DIRS=()
ETH0_ADDRESS_BYTES=()
function quit() {
   echo -e "${WHITE}"
   echo "\nLeaving Swarm Configuration"
   exit
}

function EditProperties() {
   cd $1
   cp ../Artifacts/default-meta-data new-meta-data

   case $1 in
   "ws01")
      cp ../Artifacts/default-manager-user-data new-user-data
      # Docker
      sed -i -n "s/SWARM-INTERFACE/$SWARM_INTERFACE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data

      # Dynamic DNS
      sed -i -n "s/DYNAMIC-DNS-USER/$DYNAMIC_DNS_USER/" new-user-data
      sed -i -n "s/DYNAMIC-DNS-PASSWD/$DYNAMIC_DNS_PASSWD/" new-user-data

      # ACME
      sed -i -n "s/ACME-EMAIL-ADDRESS/$ACME_EMAIL_ADDRESS/" new-user-data

      # Traefik
      sed -i -n "s/TRAEFIK-ENTRYPOINT-ADDRESS/$TRAEFIK_ENTRYPOINT_ADDRESS/" new-user-data

      # WLAN0
      sed -i -n "s/WLAN0-DNS-SERVERS/$WLAN0_DNS_SERVERS/" new-user-data
      sed -i -n "s/WLAN0-STATIC-ROUTERS/$WLAN0_STATIC_ROUTERS/" new-user-data
      sed -i -n "s/WLAN0-IP-ADDRESS/$WLAN0_IP_ADDRESS/" new-user-data
      sed -i -n "s/WIFI-PASSWD/$WIFI_PASSWD/" new-user-data
      sed -i -n "s/WIFI-SSID/$WIFI_SSID/" new-user-data
      sed -i -n "s/COUNTRY-CODE/$COUNTRY_CODE/" new-user-data
      sed -i -n "s#WLAN0-LAN#$WLAN0_LAN#" new-user-data

      # Setup DNSMasq A records
      sed -i -n "s#DNS-STRING1#$WS02_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING2#$WS03_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data

      # Setup Traefik SSH Rules
      sed -i -n "s#WS01-IP-ADDRESS#$WS01_IP_ADDRESS#" new-user-data
      sed -i -n "s#WS02-IP-ADDRESS#$WS02_IP_ADDRESS#" new-user-data
      sed -i -n "s#WS03-IP-ADDRESS#$WS03_IP_ADDRESS#" new-user-data
      sed -i -n "s#WS04-IP-ADDRESS#$WS04_IP_ADDRESS#" new-user-data
      ;;
   "ws02")
      cp ../Artifacts/default-worker-user-data new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data
      # Setup DNSMasq A records
      sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING2#$WS03_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data

      ;;
   "ws03")
      cp ../Artifacts/default-worker-user-data new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data

      # Setup DNSMasq A records
      sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING2#$WS02_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data
      ;;
   "ws04")
      cp ../Artifacts/default-worker-user-data new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data

      # Setup DNSMasq A records
      sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING2#$WS02_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING3#$WS03_DNS_STRING#" new-user-data

      # USB Drive mount command
      sed -i -n "s#USB-MOUNT-COMMAND#$USB_MOUNT_COMMAND#" new-user-data

      ;;
   *)
      echo -n "EditProperties unknown input parameter"
      ;;
   esac

   # Swarm Common properties
   echo -n "Editing GLOBAL Properties"

   # Redis properties
   #sed -i -n "s#REDIS-DEFAULT-CONFIG#$REDIS_DEFAULT_CONFIG#" new-user-data

   # Global application properties
   sed -i -n "s#REDIS-MASTER-SERVER-ADDRESS#$REDIS_MASTER_SERVER_ADDRESS#" new-user-data
   sed -i -n "s#REDIS-MASTER-SERVER-PORT#$REDIS_MASTER_SERVER_PORT#" new-user-data
   sed -i -n "s#REDIS-REPLICA-SERVER-ADDRESS#$REDIS_REPLICA_SERVER_ADDRESS#" new-user-data
   sed -i -n "s#REDIS-REPLICA-SERVER-PORT#$REDIS_REPLICA_SERVER_PORT#" new-user-data
   sed -i -n "s#SKETCH-SERVER-ADDRESS#$SKETCH_SERVER_ADDRESS#" new-user-data
   sed -i -n "s#SKETCH-SERVER-PORT#$SKETCH_SERVER_PORT#" new-user-data
   sed -i -n "s#API-SERVER-ADDRESS#$API_SERVER_ADDRESS#" new-user-data
   sed -i -n "s#API-SERVER-PORT#$API_SERVER_PORT#" new-user-data
   sed -i -n "s#MQTT-SERVER-ADDRESS#$MQTT_SERVER_ADDRESS#" new-user-data
   sed -i -n "s#MQTT-SERVER-PORT#$MQTT_SERVER_PORT#" new-user-data
   sed -i -n "s#APPLICATION-LIST#$APPLICATION_LIST#" new-user-data
   sed -i -n "s#ENVIRONMENT-LIST#$ENVIRONMENT_LIST#" new-user-data

   # ETH0
   sed -i -n "s/ETH0-DNS-SERVERS/$ETH0_DNS_SERVERS/" new-user-data
   sed -i -n "s/ETH0-STATIC-ROUTERS/$ETH0_STATIC_ROUTERS/" new-user-data
   sed -i -n "s/ETH0-IP-ADDRESS/$ETH0_IP_ADDRESS/" new-user-data
   sed -i -n "s#ETH0-LAN#$ETH0_LAN#" new-user-data

   # Locale
   sed -i -n "s#SWARM-LOCALE#$SWARM_LOCALE#" new-user-data

   # TimeZone
   sed -i -n "s#TIME-ZONE#$TIME_ZONE#" new-user-data
   sed -i -n "s#ISO-DATE#$ISO_DATE#" new-user-data
   sed -i -n "s#ISO-TIME#$ISO_TIME#" new-user-data

   # Domains
   sed -i -n "s/INTERNAL-DOMAIN-NAME/$INTERNAL_DOMAIN_NAME/" new-user-data
   sed -i -n "s/EXTERNAL-DOMAIN-NAME/$EXTERNAL_DOMAIN_NAME/" new-user-data

   # Swarm Manager
   sed -i -n "s/MANAGER-PASSWORD/$MANAGER_PASSWORD/" new-user-data
   sed -i -n "s/MANAGER-NAME/$MANAGER_NAME/" new-user-data
   sed -i -n "s*MANAGER-ENCRYPTED-PASSWORD*$MANAGER_ENCRYPTED_PASSWORD*" new-user-data

   # Swarm Node
   sed -i -n "s/NODE-NAME/$NODE_NAME/g" new-user-data

   # Meta Data
   sed -i -n "s/INSTANCE-ID/$NODE_NAME/g" new-meta-data

   mv new-user-data user-data
   mv new-meta-data meta-data
   cd ..
}

function PromptForInput() {
   case $1 in
   "ws01")
      # # Configure External domain name (Manager)
      echo -e "\n"
      GETDOM=true
      while $GETDOM; do
         read -p "${GR}Type External domain name ${WH}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "You must supply external domain name"
         else
            EXTERNAL_DOMAIN_NAME=$REPLY
            echo -e -n "${EXTERNAL_DOMAIN_NAME}"
            GETDOM=FALSE
         fi
      done

      #  # Configure WLAN0 LAN (Manager)
      echo -e "\n"
      read -p "${GR}Type WLAN0 Lan${RD}${BO} default=[${WLAN0_LAN}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${WLAN0_LAN}"
      else
         WLAN0_LAN=$REPLY
         echo -e -n "${WLAN0_LAN}"
      fi

      #  # Configure WLAN0 IP Address (Manager)
      echo -e "\n"
      read -p "${GR}Type WLAN0 IP address${RD}${BO} default=[${WLAN0_IP_ADDRESS}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${WLAN0_IP_ADDRESS}"
      else
         WLAN0_IP_ADDRESS=$REPLY
         echo -e -n "${WLAN0_IP_ADDRESS}"
      fi

      #  # Configure WLAN0 Static Routers (Manager)
      echo -e "\n"
      read -p "${GR}Type WLAN0 Static Routers${RD}${BO} default=[${WLAN0_STATIC_ROUTERS}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${WLAN0_STATIC_ROUTERS}"
      else
         WLAN0_STATIC_ROUTERS=$REPLY
         echo -e -n "${WLAN0_STATIC_ROUTERS}"
      fi

      #  # Configure WLAN0 DNS Servers (Manager)
      echo -e "\n"
      read -p "${GR}Type WLAN0 DNS Servers${RD}${BO} default=[${WLAN0_DNS_SERVERS}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${WLAN0_DNS_SERVERS}"
      else
         WLAN0_DNS_SERVERS=$REPLY
         echo -e -n "${WLAN0_DNS_SERVERS}"
      fi

      #  # Configure WiFi Country Code (Manager)
      echo -e "\n"
      read -p "${GR}Type WiFi Country Code${RD}${BO} default=[${COUNTRY_CODE}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${COUNTRY_CODE}"
      else
         COUNTRY_CODE=$REPLY
         echo -e -n "${COUNTRY_CODE}"
      fi

      #  # Configure WiFi SSID (Manager)
      echo -e "\n"
      GETSSID=true
      while $GETSSID; do
         read -p "${GR}Type WiFi SSID ${WH}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "You must provide WiFi SSID"
         else
            WIFI_SSID=$REPLY
            echo -e -n "${WIFI_SSID}"
            GETSSID=FALSE
         fi
      done

      #  # Configure WiFi Password (Manager)
      echo -e "\n"
      GETPW=true
      while $GETPW; do
         read -p "${GR}Type WiFi Password ${WH}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "You must provide WiFi SSID"
         else
            WIFI_PASSWD=$REPLY
            echo -e -n "${WIFI_PASSWD}"
            GETPW=FALSE
         fi
      done

      #  # Configure Dynamic DNS (Manager)
      echo -e "\n"
      read -p "${GR}Use Dynamic DNS ? ${WH}y | n > " -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]; then
         echo -e "\n$REPLY\n"
         read -p "${GR}Type Dynamic DNS Provider ${RD}${BO} GratisDNS=1, CloudFlare=2 ${GR}or${RD} OneCom=3 ${WH}> " -n 1 -r
         case $REPLY in
         "1")
            DYNAMIC_DNS_PROVIDER="GRATISDNS"
            echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
            ;;
         "2")
            DYNAMIC_DNS_PROVIDER="CLOUDFLARE"
            echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
            ;;
         "3")
            DYNAMIC_DNS_PROVIDER="ONECOM"
            echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
            ;;
         *)
            echo -e -n "\nDNS Provider not supported"
            ;;
         esac

         #  # Configure Dynamic DNS User Name (Manager)
         echo -e "\n"
         GETUSR=true
         while $GETUSR; do
            read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} DNS User Name ${WH}> "
            if [[ -z "$REPLY" ]]; then
               echo -e -n "You must provide DNS user name"
            else
               DYNAMIC_DNS_USER=$REPLY
               echo -e -n "${DYNAMIC_DNS_USER}"
               GETUSR=false
            fi
         done

         #  # Configure Dynamic DNS User Password (Manager)
         echo -e "\n"
         GETPW=true
         while $GETPW; do
            read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} Dynamic DNS User Password${RD}${BO} default=[${DYNAMIC_DNS_PASSWD}] ${WH}> "
            if [[ -z "$REPLY" ]]; then
               echo -e -n "You must provide Dynamic DNS user password"
            else
               DYNAMIC_DNS_PASSWD=$REPLY
               echo -e -n "${DYNAMIC_DNS_PASSWD}"
               GETPW=false
            fi
         done
      else
         echo -e -n "No Dynamic DNS"
      fi

      #  # Configure ACME Email Address (Manager)
      echo -e "\n"
      read -p "${GR}Type ACME Email Address${RD}${BO} default=[${ACME_EMAIL_ADDRESS}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${ACME_EMAIL_ADDRESS}"
      else
         ACME_EMAIL_ADDRESS=$REPLY
         echo -e -n "${ACME_EMAIL_ADDRESS}"
      fi

      #  # Configure Traefik EntryPoint Address (Manager)
      echo -e "\n"
      read -p "${GR}Type Traefik Entrypoint address${RD}${BO} default=[${TRAEFIK_ENTRYPOINT_ADDRESS}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
      else
         TRAEFIK_ENTRYPOINT_ADDRESS=$REPLY
         echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
      fi

      ;;
   "ws02" | "ws03" | "ws04")
      #  # Configure Swarm Port (worker)
      echo -e "\n"
      read -p "${GR}Type Swarm TCP Port number ${RD}${BO}default=[${SWARM_PORT}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${SWARM_PORT}"
      else
         SWARM_PORT=$REPLY
         echo -e -n "${SWARM_PORT}"
      fi
      #  # Configure Swarm Worker Token (worker)
      echo -e "\n"
      read -p "${GR}Paste Swarm Worker Token, obtained from Manager Node ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${SWARM_WORKER_TOKEN}"
      else
         SWARM_WORKER_TOKEN=$REPLY
         echo -e -n "${SWARM_PORT}"
      fi
      ;;
   *)
      echo -e -n "\nNode not supported"
      ;;
   esac

   # # Configure Manager name (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type Swarm Manager name ${RD}${BO}default=[${MANAGER_NAME}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${MANAGER_NAME}"
   else
      MANAGER_NAME=$REPLY
      echo -e -n "${MANAGER_NAME}"
   fi

   # # Configure Manager password (Manager & Worker)
   # # The password are SHA512 hashed
   echo -e "\n"
   GETPW=true
   while $GETPW; do
      read -p "${GR}Type Swarm Manager password ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must supply password"
      else
         #MANAGER_PASSWORD=$(GetPWHash $REPLY)
         MANAGER_PASSWORD=$REPLY
         echo -e -n "${MANAGER_ENCRYPTED_PASSWORD}"
         GETPW=false
      fi
   done

   # # Configure Time Zone (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type Time Zone ${RD}${BO}default=[${TIME_ZONE}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${TIME_ZONE}"
   else
      TIME_ZONE=$REPLY
      echo -e -n "${TIME_ZONE}"
   fi

   #  # Configure ETH0 LAN (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 Lan${RD}${BO} default=[${ETH0_LAN}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_LAN}"
   else
      ETH0_LAN=$REPLY
      echo -e -n "${ETH0_LAN}"
   fi

   #  # Configure ETH0 IP Address (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 IP address${RD}${BO} default=[${ETH0_IP_ADDRESS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_IP_ADDRESS}"
   else
      ETH0_IP_ADDRESS=$REPLY
      echo -e -n "${ETH0_IP_ADDRESS}"
   fi

   #  # Configure ETH0 Static Routers (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 Static Routers${RD}${BO} default=[${ETH0_STATIC_ROUTERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   else
      ETH0_STATIC_ROUTERS=$REPLY
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   fi

   #  # Configure ETH0 DNS Servers (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 DNS Servers${RD}${BO} default=[${ETH0_DNS_SERVERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_DNS_SERVERS}"
   else
      ETH0_DNS_SERVERS=$REPLY
      echo -e -n "${ETH0_DNS_SERVERS}"
   fi

   #  # Configure USB Drive mount
   echo -e "\n"
   read -p "${GR}Mount USB Drive ? ${WH}y | n > " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n"
      read -p "${GR}Type USB UUID ${WH}> "
      #USB_MOUNT_COMMAND = ${USB_MOUNT_COMMAND#USB_UUID#$REPLY}
      USB_MOUNT_COMMAND=$(echo "$USB_MOUNT_COMMAND" | sed "s/USB_UUID/$REPLY/")
   else
      USB_MOUNT_COMMAND="logger No USB Drive Mount"
   fi
}

function ListProperties() {
   # List in memory properties
   #
   echo -e "\n" $2
   echo -e "--------- $1 -----------\n"
   echo -e "\n--- Node properties ---"
   echo -e "NODE_NAME: " $NODE_NAME
   echo -e "TIME_ZONE: " $TIME_ZONE
   echo -e "ISO_DATE: " $ISO_DATE
   echo -e "ISO_TIME: " $ISO_TIME

   echo -e "\n--- User properties ---"
   echo -e "MANAGER_NAME: " $MANAGER_NAME
   echo -e "MANAGER_PASSWORD: " $MANAGER_PASSWORD
   echo -e "MANAGER_ENCRYPTED_PASSWORD: " $MANAGER_ENCRYPTED_PASSWORD

   echo -e "\n--- Swarm properties ---"
   echo -e "SWARM_INTERFACE: " $SWARM_PORT
   echo -e "SWARM_PORT: " $SWARM_PORT
   echo -e "SWARM_LOCALE: " $SWARM_LOCALE
   echo -e "SWARM_MANAGER_NODE: " $SWARM_MANAGER_NODE
   echo -e "SWARM_WORKER_TOKEN: " $SWARM_WORKER_TOKEN
   echo -e "SWARM_MANAGER_TOKEN: " $SWARM_MANAGER_TOKEN

   echo -e "\n--- WiFi properties ---"
   echo -e "COUNTRY_CODE: " $COUNTRY_CODE
   echo -e "WIFI_SSID: " $WIFI_SSID
   echo -e "WIFI_PASSWD: " $WIFI_PASSWD

   echo -e "\n--- ETH0 properties ---"
   echo -e "ETH0_LAN: " $ETH0_LAN
   echo -e "ETH0_IP_ADDRESS: " $ETH0_IP_ADDRESS
   echo -e "ETH0_STATIC_ROUTERS: " $ETH0_STATIC_ROUTERS
   echo -e "ETH0_DNS_SERVERS: " $ETH0_DNS_SERVERS

   echo -e "\n--- WLAN0 properties ---"
   echo -e "WLAN0_LAN: " $WLAN0_LAN
   echo -e "WLAN0_IP_ADDRESS: " $WLAN0_IP_ADDRESS
   echo -e "WLAN0_STATIC_ROUTERS: " $WLAN0_STATIC_ROUTERS
   echo -e "WLAN0_DNS_SERVERS: " $WLAN0_DNS_SERVERS

   echo -e "\n--- Domain properties ---"
   echo -e "INTERNAL_DOMAIN_NAME: " $INTERNAL_DOMAIN_NAME
   echo -e "EXTERNAL_DOMAIN_NAME: " $EXTERNAL_DOMAIN_NAME

   echo -e "\n--- Dynamic DNS properties ---"
   echo -e "DYNAMIC_DNS_PROVIDER: " $DYNAMIC_DNS_PROVIDER
   echo -e "DYNAMIC_DNS_USER: " $DYNAMIC_DNS_USER
   echo -e "DYNAMIC_DNS_PASSWD: " $DYNAMIC_DNS_PASSWD

   echo -e "\n--- Node Default IP Address ---"
   echo -e "WS01_IP_ADDRESS: " $WS01_IP_ADDRESS
   echo -e "WS02_IP_ADDRESS: " $WS02_IP_ADDRESS
   echo -e "WS03_IP_ADDRESS: " $WS03_IP_ADDRESS
   echo -e "WS04_IP_ADDRESS: " $WS04_IP_ADDRESS

   echo -e "\n--- Traefik properties ---"
   echo -e "ACME_EMAIL_ADDRESS: " $ACME_EMAIL_ADDRESS
   echo -e "TRAEFIK_ENTRYPOINT_ADDRESS: " $TRAEFIK_ENTRYPOINT_ADDRESS

   echo -e "\n--- USB Mount Command ---"
   echo -e "USB_MOUNT_COMMAND: " $USB_MOUNT_COMMAND

   echo -e "\n--- GLOBAL APPLICATION Properties ---"
   echo -e "REDIS_MASTER_SERVER_ADDRESS: " $REDIS_MASTER_SERVER_ADDRESS
   echo -e "REDIS_MASTER_SERVER_PORT: " $REDIS_MASTER_SERVER_PORT
   echo -e "REDIS_REPLICA_SERVER_ADDRESS: " $REDIS_REPLICA_SERVER_ADDRESS
   echo -e "REDIS_REPLICA_SERVER_PORT: " $REDIS_REPLICA_SERVER_PORT
   echo -e "API_SERVER_ADDRESS: " $API_SERVER_ADDRESS
   echo -e "API_SERVER_PORT: " $API_SERVER_PORT
   echo -e "MQTT_SERVER_ADDRESS: " $MQTT_SERVER_ADDRESS
   echo -e "MQTT_SERVER_PORT: " $MQTT_SERVER_PORT
   echo -e "SKETCH_SERVER_ADDRESS: " $SKETCH_SERVER_ADDRESS
   echo -e "SKETCH_SERVER_PORT: " $SKETCH_SERVER_PORT
   echo -e "APPLICATION_LIST: " $APPLICATION_LIST
   echo -e "ENVIRONMENT_LIST: " $ENVIRONMENT_LIST

   # Test of json string
   echo -e "REDIS_DEFAULT_CONFIG: " $REDIS_DEFAULT_CONFIG
   echo -e "---------- $1 ----------\n"
}

function ReadProperties() {
   # Keep sections/lines in this function synchronized
   # with swarmconfig.txt
   #
   # Read all properties from swarmconfig.txt
   # source ./Artifacts/swarmconfig.txt
   source "$INPUT_FILE"
   echo -e "Input File: $INPUT_FILE"
   # Node properties
   NODENAME_PREFIX=$NODENAME_PREFIX
   NODENAME_COUNT=$NODENAME_COUNT

   # MANAGER Properties
   MANAGER_NAME=$MANAGER_NAME
   MANAGER_PASSWORD=$MANAGER_PASSWORD
   MANAGER_PASSWORD=$MANAGER_PASSWORD
   MANAGER_ENCRYPTED_PASSWORD=$MANAGER_ENCRYPTED_PASSWORD

   # NODE Properties
   NODE_NAME=$NODE_NAME
   SWARM_LOCALE=$SWARM_LOCALE
   TIME_ZONE=$TIME_ZONE

   # Docker Swarm Properties
   #SWARM_MANAGER_NODE=$SWARM_MANAGER_NODE
   SWARM_PORT=$SWARM_PORT
   #SWARM_INTERFACE=$SWARM_INTERFACE
   SWARM_WORKER_TOKEN=$SWARM_WORKER_TOKEN
   SWARM_MANAGER_TOKEN=$SWARM_MANAGER_TOKEN

   # Swarm External Application URL's
   API_SERVER_URL=$API_SERVER_URL
   DB_SERVER_URL=$DB_SERVER_URL
   MQTT_SERVER_URL=$MQTT_SERVER_URL
   SKETCH_SERVER_URL=$INTERNAL_SKETCH_SERVER_URL

   # Swarm Application DNS Prefix's
   API_PREFIX=$API_PREFIX
   DB_PREFIX=$DB_PREFIX
   MQTT_PREFIX=$MQTT_PREFIX
   SKETCH_PREFIX=$SKETCH_PREFIX

   # Swarm Internal Application URL's
   INTERNAL_API_SERVER_URL=$INTERNAL_API_SERVER_URL
   INTERNAL_DB_SERVER_URL=$INTERNAL_DB_SERVER_URL
   INTERNAL_MQTT_SERVER_URL=$INTERNAL_MQTT_SERVER_URL
   INTERNAL_SKETCH_SERVER_URL=$INTERNAL_SKETCH_SERVER_URL

   # WiFi properties
   COUNTRY_CODE=$COUNTRY_CODE
   WIFI_SSID=$WIFI_SSID
   WIFI_PASSWD=$WIFI_PASSWORD

   # Swarm Node ETH0 properties
   ETH0_LAN=$ETH0_LAN
   ETH0_IP_ADDRESS=$ETH0_IP_ADDRESS
   ETH0_STATIC_ROUTERS=$ETH0_STATIC_ROUTERS
   ETH0_DNS_SERVERS=$ETH0_DNS_SERVERS

   # Swarm Node IP Address
   WS01_DNS_ADDRESS=$WS01_DNS_ADDRESS
   WS02_DNS_ADDRESS=$WS02_DNS_ADDRESS
   WS03_DNS_ADDRESS=$WS03_DNS_ADDRESS
   WS04_DNS_ADDRESS=$WS04_DNS_ADDRESS

   # Manager Node WLAN0 properties
   WLAN0_LAN=$WLAN0_LAN
   WLAN0_IP_ADDRESS=$WLAN0_IP_ADDRESS
   WLAN0_STATIC_ROUTERS=$WLAN0_STATIC_ROUTERS
   WLAN0_DNS_SERVERS=$WLAN0_DNS_SERVERS

   # Domain properties
   INTERNAL_DOMAIN_NAME=$INTERNAL_DOMAIN_NAME
   EXTERNAL_DOMAIN_NAME=$EXTERNAL_DOMAIN_NAME

   # Dynamic DNS properties
   DYNAMIC_DNS_PROVIDER=$DYNAMIC_DNS_PROVIDER
   DYNAMIC_DNS_USER=$DYNAMIC_DNS_USER
   DYNAMIC_DNS_PASSWD=$DYNAMIC_DNS_PASSWD

   # ACME properties
   ACME_EMAIL_ADDRESS=$ACME_EMAIL_ADDRESS

   # Traefik properties
   TRAEFIK_ENTRYPOINT_ADDRESS=$TRAEFIK_ENTRYPOINT_ADDRESS

   # SnakeApi properties
   API_SERVER_ADDRESS=$API_SERVER_ADDRESS
   API_SERVER_PORT=$API_SERVER_PORT

   # SnakeConfig properties
   APPLICATION_LIST=$APPLICATION_LIST
   ENVIRONMENT_LIST=$ENVIRONMENT_LIST

   # Redis properties
   REDIS_MASTER_SERVER_ADDRESS=$REDIS_MASTER_SERVER_ADDRESS
   REDIS_MASTER_SERVER_PORT=$REDIS_MASTER_SERVER_PORT
   REDIS_REPLICA_SERVER_ADDRESS=$REDIS_REPLICA_SERVER_ADDRESS
   REDIS_REPLICA_SERVER_PORT=$REDIS_REPLICA_SERVER_PORT

   # Sketch properties
   SKETCH_SERVER_ADDRESS=$SKETCH_SERVER_ADDRESS
   SKETCH_SERVER_PORT=$SKETCH_SERVER_PORT

   # MQTT properties
   MQTT_SERVER_ADDRESS=$MQTT_SERVER_ADDRESS
   MQTT_SERVER_PORT=$MQTT_SERVER_PORT

   # USB Drive mount command
   USB_MOUNT_COMMAND=$USB_MOUNT_COMMAND

   REDIS_DEFAULT_CONFIG=$REDIS_DEFAULT_CONFIG
}

function SetNetAddress() {
   # Lookup current Lan address, and set the Swarm public IP address
   # by setting the last byte "WLAN0_IP_ADDRESS_LAST_BYTE"
   LAN_STR=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2)
   IFS='.'                                  # Dot is set as delimiter
   read -ra LANADDR <<<"$LAN_STR"           # LAN_STR is read into an array as tokens separated by IFS
   read -ra ETH0ADDR <<<"$ETH0_LAN_ADDRESS" # ETH0_IP_ADDRESS is read into an array as tokens separated by IFS
   WLAN0_LAN="${LANADDR[0]}.${LANADDR[1]}.${LANADDR[2]}.0/24"
   WLAN0_IP_ADDRESS="${LANADDR[0]}.${LANADDR[1]}.${LANADDR[2]}.${WLAN0_IP_ADDRESS_LAST_BYTE}"
   ETH0_LAN_NET="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}"
   WS01_IP_ADDRESS="${ETH0_LAN_NET}.1"
   WS02_IP_ADDRESS="${ETH0_LAN_NET}.2"
   WS03_IP_ADDRESS="${ETH0_LAN_NET}.3"
   WS04_IP_ADDRESS="${ETH0_LAN_NET}.4"
   IFS=' '
}

function SetNodeNames() {
   # Set node names from NODENAME_PREFIX and NODENAME_COUNT
   nodeCount=1
   while [ $nodeCount -le $(($NODENAME_COUNT)) ]; do
      echo "Nodename $NODENAME_PREFIX"0"$nodeCount"
      SWARM_NODES[$nodeCount - 1]=$"$NODENAME_PREFIX"0"$nodeCount"
      NODE_DIRS[$nodeCount - 1]=$""ws0"$nodeCount"
      echo "Nodedir ${NODE_DIRS[$nodeCount - 1]}"
      nodeCount=$(($nodeCount + 1))
   done
   SWARM_MANAGER_NODE=${SWARM_NODES[1]}
}

function SetDnsStrings() {
   IFS='.'                      # Dot is set as delimiter
   read -ra ADDR <<<"$ETH0_LAN" # str is read into an array as tokens separated by IFS
   WS01_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1 ws01 ws01.${INTERNAL_DOMAIN_NAME}"
   WS02_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.2 ws02 ws02.${INTERNAL_DOMAIN_NAME}"
   WS03_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.3 ws03 ws03.${INTERNAL_DOMAIN_NAME}"
   WS04_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.4 ws04 ws04.${INTERNAL_DOMAIN_NAME}"

   WS01_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1"
   WS02_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.2"
   WS03_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.3"
   WS04_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.4"
   IFS=' '
}

function SetDateTime() {
   DATE_ISO=$(date "+DATE: %Y-%m-%d")
   ISO_DATE=${DATE_ISO:6:10}
   TIME_ISO=$(date "+TIME: %H:%M:%S")
   ISO_TIME=${TIME_ISO:6:10}
}

function HidePassword() {
   # Hide Password with base64 blur
   MANAGER_PASSWORD=$(python3 ./Artifacts/Hidepw.py $MANAGER_PASSWORD)
   WIFI_PASSWD=$(python3 ./Artifacts/Hidepw.py $WIFI_PASSWD)
}

function ShowPassword() {
   # Show Password with base64
   MANAGER_PASSWORD=$(python3 ./Artifacts/Showpw.py $MANAGER_PASSWORD)
   WIFI_PASSWD=$(python3 ./Artifacts/Showpw.py $WIFI_PASSWD)
}

function SelectInputConfig() {
   INPUT_CONFIG_FILES=()
   j=0
   for i in ./Artifacts/*.mvf; do
      [ -f "$i" ] || break
      INPUT_CONFIG_FILES[j]="$i"
      j+=1
   done
}

function SelectInputFile() {
   echo -e "\n${GR}Select Input file with predefined properties${WH}"
   select fav in "${INPUT_CONFIG_FILES[@]}"; do
      # Read and parse input file
      INPUT_FILE=$fav
      #echo -e "SelectInputFile $fav"
      break
   done
}

function SelectNodeTemplate() {
   INPUT_TEMPLATE_FILES=()
   j=0
   for i in ./Artifacts/*.yaml; do
      [ -f "$i" ] || break
      INPUT_TEMPLATE_FILES[j]="$i"
      j+=1
   done
   echo -e "\n${GR}Select Template file${WH}"
   select fav in "${INPUT_TEMPLATE_FILES[@]}"; do
      # Read and parse input file
      INPUT_TEMPLATE=$fav
      #echo -e "SelectInputTemplate $fav"
      break
   done
}

function ConfigureManagerNode() {

   # # Configure Manager name (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type Swarm Manager name ${RD}${BO}default=[${MANAGER_NAME}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${MANAGER_NAME}"
   else
      MANAGER_NAME=$REPLY
      echo -e -n "${MANAGER_NAME}"
   fi

   # # Configure Manager password (Manager & Worker)
   # # The password are SHA512 hashed
   echo -e "\n"
   GETPW=true
   while $GETPW; do
      read -p "${GR}Type Swarm Manager password ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must supply password"
      else
         #MANAGER_PASSWORD=$(GetPWHash $REPLY)
         MANAGER_PASSWORD=$(python3 ./Artifacts/Hidepw.py $REPLY)
         #MANAGER_PASSWORD=$REPLY
         echo -e -n "${MANAGER_PASSWORD}"
         GETPW=false
      fi
   done

   # # Configure Time Zone (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type Time Zone ${RD}${BO}default=[${TIME_ZONE}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${TIME_ZONE}"
   else
      TIME_ZONE=$REPLY
      echo -e -n "${TIME_ZONE}"
   fi

   #  # Configure Traefik EntryPoint Address (Manager)
   echo -e "\n"
   read -p "${GR}Type Traefik Entrypoint address${RD}${BO} default=[${TRAEFIK_ENTRYPOINT_ADDRESS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
   else
      TRAEFIK_ENTRYPOINT_ADDRESS=$REPLY
      echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
   fi
}

function ConfigureWorkerNode() {
   # First ask for node name to configure
   echo -e "\n"
   read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
   NODE_NAME=$REPLY

   # Configure Docker Swarm TCP port number
   echo -e "\n"
   read -p "${GR}Type Swarm TCP Port number ${RD}${BO}default=[${SWARM_PORT}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${SWARM_PORT}"
   else
      SWARM_PORT=$REPLY
      echo -e -n "${SWARM_PORT}"
   fi
   # Configure Swarm Worker Token (worker)
   # The token is obtained from the Swarm Manager Node
   echo -e "\n"
   read -p "${GR}Paste Swarm Worker Token, obtained from Manager Node ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${SWARM_WORKER_TOKEN}"
   else
      SWARM_WORKER_TOKEN=$REPLY
      echo -e -n "${SWARM_PORT}"
   fi
}

function ConfigureInternalNetwork() {
   #  # Configure ETH0 LAN (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 Lan${RD}${BO} default=[${ETH0_LAN}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_LAN}"
   else
      ETH0_LAN=$REPLY
      echo -e -n "${ETH0_LAN}"
   fi

   #  # Configure ETH0 IP Address (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 IP address${RD}${BO} default=[${ETH0_IP_ADDRESS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_IP_ADDRESS}"
   else
      ETH0_IP_ADDRESS=$REPLY
      echo -e -n "${ETH0_IP_ADDRESS}"
   fi

   #  # Configure ETH0 Static Routers (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 Static Routers${RD}${BO} default=[${ETH0_STATIC_ROUTERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   else
      ETH0_STATIC_ROUTERS=$REPLY
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   fi

   #  # Configure ETH0 DNS Servers (Manager & Worker)
   echo -e "\n"
   read -p "${GR}Type ETH0 DNS Servers${RD}${BO} default=[${ETH0_DNS_SERVERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_DNS_SERVERS}"
   else
      ETH0_DNS_SERVERS=$REPLY
      echo -e -n "${ETH0_DNS_SERVERS}"
   fi

}

function ConfigureWiFiNetwork() {
   #  # Configure WLAN0 LAN (Manager)
   echo -e "\n"
   read -p "${GR}Type WLAN0 Lan${RD}${BO} default=[${WLAN0_LAN}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_LAN}"
   else
      WLAN0_LAN=$REPLY
      echo -e -n "${WLAN0_LAN}"
   fi

   #  # Configure WLAN0 IP Address (Manager)
   echo -e "\n"
   read -p "${GR}Type WLAN0 IP address${RD}${BO} default=[${WLAN0_IP_ADDRESS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_IP_ADDRESS}"
   else
      WLAN0_IP_ADDRESS=$REPLY
      echo -e -n "${WLAN0_IP_ADDRESS}"
   fi

   #  # Configure WLAN0 Static Routers (Manager)
   echo -e "\n"
   read -p "${GR}Type WLAN0 Static Routers${RD}${BO} default=[${WLAN0_STATIC_ROUTERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_STATIC_ROUTERS}"
   else
      WLAN0_STATIC_ROUTERS=$REPLY
      echo -e -n "${WLAN0_STATIC_ROUTERS}"
   fi

   #  # Configure WLAN0 DNS Servers (Manager)
   echo -e "\n"
   read -p "${GR}Type WLAN0 DNS Servers${RD}${BO} default=[${WLAN0_DNS_SERVERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_DNS_SERVERS}"
   else
      WLAN0_DNS_SERVERS=$REPLY
      echo -e -n "${WLAN0_DNS_SERVERS}"
   fi

   #  # Configure WiFi Country Code (Manager)
   echo -e "\n"
   read -p "${GR}Type WiFi Country Code${RD}${BO} default=[${COUNTRY_CODE}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${COUNTRY_CODE}"
   else
      COUNTRY_CODE=$REPLY
      echo -e -n "${COUNTRY_CODE}"
   fi

   #  # Configure WiFi SSID (Manager)
   echo -e "\n"
   GETSSID=true
   while $GETSSID; do
      read -p "${GR}Type WiFi SSID ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must provide WiFi SSID"
      else
         WIFI_SSID=$REPLY
         echo -e -n "${WIFI_SSID}"
         GETSSID=FALSE
      fi
   done

   #  # Configure WiFi Password (Manager)
   echo -e "\n"
   GETPW=true
   while $GETPW; do
      read -p "${GR}Type WiFi Password ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must provide WiFi SSID"
      else
         WIFI_PASSWD=$REPLY
         WIFI_PASSWD=$(python3 ./Artifacts/Hidepw.py $REPLY)
         echo -e -n "${WIFI_PASSWD}"
         GETPW=FALSE
      fi
   done
}

function ConfigureUSBDrives() {
   #  # Configure USB Drive mount
   echo -e "\n"
   read -p "${GR}Mount USB Drive ? ${WH}y | n > " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n"
      read -p "${GR}Type USB UUID ${WH}> "
      #USB_MOUNT_COMMAND = ${USB_MOUNT_COMMAND#USB_UUID#$REPLY}
      USB_MOUNT_COMMAND=$(echo "$USB_MOUNT_COMMAND" | sed "s/USB_UUID/$REPLY/")
   else
      USB_MOUNT_COMMAND="logger No USB Drive Mount"
   fi
}

function ConfigureDNS() {
   # Configure External domain name (Manager)
   # An external domain is essential, so this is a must.
   echo -e "\n"
   GETDOM=true
   while $GETDOM; do
      read -p "${GR}Type External domain name ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must supply external domain name"
      else
         EXTERNAL_DOMAIN_NAME=$REPLY
         echo -e -n "${EXTERNAL_DOMAIN_NAME}"
         GETDOM=FALSE
      fi
   done

   #  # Configure LetsEncrype Certificate ACME Email Address (Manager)
   # This E-mail adddress must be registere by LetsEncrype together with
   # the external domain name
   echo -e "\n"
   read -p "${GR}Type ACME Email Address${RD}${BO} default=[${ACME_EMAIL_ADDRESS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ACME_EMAIL_ADDRESS}"
   else
      ACME_EMAIL_ADDRESS=$REPLY
      echo -e -n "${ACME_EMAIL_ADDRESS}"
   fi

   #  # Configure Dynamic DNS (Manager)
   echo -e "\n"
   read -p "${GR}Use Dynamic DNS ? ${WH}y | n > " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n$REPLY\n"
      read -p "${GR}Type Dynamic DNS Provider ${RD}${BO} GratisDNS=1, CloudFlare=2 ${GR}or${RD} OneCom=3 ${WH}> " -n 1 -r
      case $REPLY in
      "1")
         DYNAMIC_DNS_PROVIDER="GRATISDNS"
         echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
         ;;
      "2")
         DYNAMIC_DNS_PROVIDER="CLOUDFLARE"
         echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
         ;;
      "3")
         DYNAMIC_DNS_PROVIDER="ONECOM"
         echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
         ;;
      *)
         echo -e -n "\nDNS Provider not supported"
         ;;
      esac

      #  # Configure Dynamic DNS User Name (Manager)
      echo -e "\n"
      GETUSR=true
      while $GETUSR; do
         read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} DNS User Name ${WH}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "You must provide DNS user name"
         else
            DYNAMIC_DNS_USER=$REPLY
            echo -e -n "${DYNAMIC_DNS_USER}"
            GETUSR=false
         fi
      done

      #  # Configure Dynamic DNS User Password (Manager)
      echo -e "\n"
      GETPW=true
      while $GETPW; do
         read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} Dynamic DNS User Password${RD}${BO} default=[${DYNAMIC_DNS_PASSWD}] ${WH}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "You must provide Dynamic DNS user password"
         else
            DYNAMIC_DNS_PASSWD=$REPLY
            echo -e -n "${DYNAMIC_DNS_PASSWD}"
            GETPW=false
         fi
      done
   else
      echo -e -n "No Dynamic DNS"
   fi
}

function DetailMenu() {
   #
   # Detail menu
   #
   QUIT_MENU="---"
   while [ "$QUIT_MENU" == "---" ]; do
      echo -e "\n${GR}Detail Menu${WH}"
      DETAIL_MENU=("Configure_USB_Drives"
         "Change_Node_Names"
         "Change_IP_Addresses"
         "List_Properties"
         "Hide_Password"
         "Show_Password"
         "Quit")

      select fav in "${DETAIL_MENU[@]}"; do
         case $fav in
         "Configure_USB_Drives")
            echo "$fav"
            ConfigureUSBDrives
            ;;
         "Change_Node_Names")
            echo "$fav"
            SetNodedNames
            ;;
         "Change_IP_Addresses")
            echo "$fav"
            ;;
         "List_Properties")
            ListProperties
            break
            ;;
         "Hide_Password")
            HidePassword
            break
            ;;
         "Show_Password")
            ShowPassword
            break
            ;;
         "Quit")
            echo "$fav"
            QUIT_MENU="QUIT"
            break
            ;;
         esac
      done
   done
}
# Start Script execution
printf "\033c"
echo -e "\n"
echo -e "${RED}${BOLD}WaveSnake Flash Configuration Utility v1.0.3\n"
echo -e "This utility will prepare a Flash configuration file for a"
echo -e "single swarm node, by prompting for configuration parameters."
echo -e "You must choose between Manager or Worker Node\n"
echo -e "${WHITE}"

#ReadProperties
#SetNetAddress
#SetNodeNames
#SetDateTime
#SelectInputConfig

#
# Main menu
#
QUIT_MENU="---"
while [ "$QUIT_MENU" == "---" ]; do
   echo -e "\n${GR}Main Menu${WH}"

   SCRIPT_MENU=("Select_Configuration_File"
      "Select_Node_Template"
      "Configure_Manager_Node"
      "Configure_Worker_Node"
      "Configure_WiFi_Network"
      "Configure_Internal_Network"
      "Configure_DNS"
      "Save_Configuration_File"
      "Detail_Menu"
      "Quit")

   select fav in "${SCRIPT_MENU[@]}"; do
      case $fav in
      "Select_Configuration_File")
         echo "$fav"
         # Select both Config Input and template(Manager or Worker)
         SelectInputConfig
         SelectInputFile
         ReadProperties
         break
         ;;
      "Configure_Manager_Node")
         echo "$fav"
         ConfigureManagerNode
         break
         ;;
      "Configure_Worker_Node")
         echo "$fav"
         ConfigureWorkerNode
         break
         ;;
      "Configure_WiFi_Network")
         echo "$fav"
         ConfigureWiFiNetwork
         ;;
      "Configure_Internal_Network")
         echo "$fav"
         ConfigureInternalNetwork
         break
         ;;
      "Configure_DNS")
         echo "$fav"
         ConfigureDNS
         ;;
      "Save_Config_File")
         # And then take input from this template
         echo "$fav"
         ;;
      "Select_Node_Template")
         echo "$fav"
         SelectNodeTemplate
         break
         ;;
      "Detail_Menu")
         DetailMenu
         break
         ;;
      "Quit")
         echo "$fav"
         QUIT_MENU="QUIT"
         break
         ;;
      esac
   done
done
# Ask for Manager or Worker node
#read -p "${GR}Flash configuration for Swarm ${RD}${BO}Manager Node ${GR}or${RD} Worker Node${GR} ? m | w ${EC}${WH}> " -n 1 -r
read -p "${GR}Flash configuration for Swarm ${RD}${BO}Manager Node ${GR}or${RD} Worker Node${GR} ? m | w ${EC}${WH}> " -n 1 -r
if [[ $REPLY =~ ^[Mm]$ ]]; then
   echo -e "\n"
   #echo -e "$NODE_NAME"
   NODE_NAME=${SWARM_NODES[0]}
   echo -e "\n$NODE_NAME"
   echo -e "\n$SWARM_MANAGER_NODE"
   #echo -e "${SWARM_NODES[0]}"
elif [[ $REPLY =~ ^[Ww]$ ]]; then
   echo -e "\n"
   #read -p "${GR}Select node by typing ${RD}${BO}ws02, ws03 ${GR}or ${RD}ws04 ${EC}${WH}> " -n 4 -r
   read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
   NODE_NAME=$REPLY
   echo -e "\n$NODE_NAME"
else
   quit
fi

# Ready for Editing properties
echo -e "\n"
read -p "${GR}Are you ready for Configuring ${RD}${BO}${NODE_NAME}${GR}${EC}? ${WH}y | n >" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
   ListProperties $NODE_NAME "Properties before editing"
   PromptForInput $NODE_NAME
   SetDnsStrings
   #GetPWHash
   ListProperties $NODE_NAME "Properties after editing"
   EditProperties $NODE_NAME
fi
echo "\nFlashConfig finish"

# OLD CODE
#function GetPWHash() {
#   PYTHON_ARG="$1" python3 - <<END
#import os
#import crypt
#import getpass
#import pwd
#import dovecot
# print (os.environ['PYTHON_ARG'])
#print (crypt.crypt(os.environ['PYTHON_ARG'], crypt.mksalt(crypt.METHOD_SHA512)))
#saltsalt="FisOgPap2331321231231231231231231231"
#python -c "import crypt, getpass, pwd; print(crypt.crypt('wavesnake', '\$6\$saltsalt\$'))"
#print(crypt.crypt('wavesnake', crypt.mksalt(crypt.METHOD_SHA512)))

#doveadm pw -s SHA512-CRYPT

#print(crypt.crypt('wavesnake', crypt.mksalt(crypt.METHOD_SHA512)))

# Hide Password with base64 blur
# >>> import base64
# >>>  print(base64.b64encode("password".encode("utf-8")))
# cGFzc3dvcmQ=
# >>> print(base64.b64decode("cGFzc3dvcmQ=").decode("utf-8"))
# password

# END
# }
