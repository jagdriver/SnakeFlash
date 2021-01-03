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
# 11 Make it possible to change node names OK
# 12 Make it possible to change internal IP addresses OK
# 13 Make it possible to change Manager WiFi IP address OK
# 14 Obfuscate passwords in files OK
# 15 Test boot without setting date/time and let FakeTime manage

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'
BLACK='\033[0;30m'
WHITE='\033[0;97m'
CURRENT_DIR=$(pwd)
RESETALL=$'\e[0m'
echo -e "$RESETALL"
RD=$'\e[31m'
GR=$'\e[32m'
WH=$'\e[97m'
BC=$'\e[4m'
EC=$'\e[0m'
BO=$'\e[1m'
BL=$'\e[34m'
BLA=$'\e[30m'
# Configuration input file
INPUT_FILE="./Artifacts/swarmproperties.mvf"
PROPERTY_FILE_NAME="swarmproperties"
PROPERTY_FILE_EXT="mvf"

# Config Check Menu
CHECK_DONE_DEFAULT="\xE2\x9C\x94"
CHECK_DONE="$GR\xE2\x9C\x94$BLA"
CHECK_UNDONE="\xE2\x9D\x8C"

WLAN0_DONE=$CHECK_UNDONE
NODENAME_DONE=$CHECK_UNDONE
DNS_DONE=$CHECK_UNDONE
ETH0_DONE=$CHECK_UNDONE
MANAGER_DONE=$CHECK_UNDONE
USB_DONE=$CHECK_UNDONE
EDIT_DONE=$CHECK_UNDONE
MANAGER_DONE=$CHECK_UNDONE
WORKER_DONE=$CHECK_UNDONE
SSH_DONE=$CHECK_UNDONE
DATE_DONE=$CHECK_UNDONE

# Noded names
SWARM_NODES=()
# Current network address bytes
ETH0_ADDRESS_BYTES=()
# Node local DNS  URL's
DNS_URLS=()
# Node local IP addresses
IP_ADDRESSES=()

function Quit() {
   echo -e "${BLACK}"
   echo "\nLeaving Swarm Configuration"
   exit
}

function EditProperties() {
   cd $1
   cp ../Artifacts/metadata.yaml new-meta-data

   case $1 in
   "${SWARM_NODES[0]}")
      NODE_NAME="${SWARM_NODES[0]}"
      cp ../Artifacts/$MANAGER_TEMPLATE_FILE_NAME.$TEMPLATE_FILE_EXT new-user-data

      # Docker
      sed -i -n "s/SWARM-INTERFACE/$SWARM_INTERFACE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data

      # Dynamic DNS
      sed -i -n "s/EXTERNAL-DOMAIN-NAME/$EXTERNAL_DOMAIN_NAME/" new-user-data

      ALL_DNS_PROVIDER_LIST=${DNS_PROVIDER_LIST[@]}
      sed -i -n "s/DNS-PROVIDER-LIST/$ALL_DNS_PROVIDER_LIST/" new-user-data

      #sed -i -n "s/DNS-PROVIDER-LIST/${DNS_PROVIDER_LIST[@]}/" new-user-data

      sed -i -n "s#DNS-PROVIDER-URL#$DYNAMIC_DNS_URL#" new-user-data
      sed -i -n "s/DNS-PROVIDER-NAME/$DYNAMIC_DNS_PROVIDER/" new-user-data
      sed -i -n "s/DNS-PROVIDER-USER/$DYNAMIC_DNS_USER/" new-user-data
      sed -i -n "s/DNS-PROVIDER-PASSWD/$DYNAMIC_DNS_PASSWD/" new-user-data

      # ACME
      sed -i -n "s/ACME-EMAIL-ADDRESS/$ACME_EMAIL_ADDRESS/" new-user-data

      # Traefik
      sed -i -n "s/TRAEFIK-ENTRYPOINT-ADDRESS/$TRAEFIK_ENTRYPOINT_ADDRESS/" new-user-data

      # WLAN0
      sed -i -n "s#WLAN0-NETWORK-ADDRESS#$WLAN0_NETWORK_ADDRESS#" new-user-data
      sed -i -n "s#WLAN0-NETWORK-NETMASK#$WLAN0_NETWORK_NETMASK#" new-user-data
      sed -i -n "s#WLAN0-NETWORK-BITS#$WLAN0_NETWORK_BITS#" new-user-data
      sed -i -n "s/WLAN0-DNS-SERVERS/$WLAN0_DNS_SERVERS/" new-user-data
      sed -i -n "s/WLAN0-STATIC-ROUTERS/$WLAN0_STATIC_ROUTERS/" new-user-data
      sed -i -n "s/WLAN0-IP-ADDRESS/$WLAN0_IP_ADDRESS/" new-user-data

      #sed -i -n "s#WLAN0-LAN#$WLAN0_LAN#" new-user-data

      # WiFi
      sed -i -n "s/WIFI-PASSWD/$WIFI_PASSWD/" new-user-data
      sed -i -n "s/WIFI-SSID/$WIFI_SSID/" new-user-data
      sed -i -n "s#COUNTRY-CODE#$COUNTRY_CODE#" new-user-data

      # Setup DNS A records
      # sed -i -n "s#DNS-STRING1#$WS02_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING2#$WS03_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING1#${DNS_URLS[1]}#" new-user-data
      sed -i -n "s#DNS-STRING2#${DNS_URLS[2]}#" new-user-data
      sed -i -n "s#DNS-STRING3#${DNS_URLS[3]}#" new-user-data

      # Setup Traefik SSH Rules
      # sed -i -n "s#WS01-IP-ADDRESS#$WS01_IP_ADDRESS#" new-user-data
      # sed -i -n "s#WS02-IP-ADDRESS#$WS02_IP_ADDRESS#" new-user-data
      # sed -i -n "s#WS03-IP-ADDRESS#$WS03_IP_ADDRESS#" new-user-data
      # sed -i -n "s#WS04-IP-ADDRESS#$WS04_IP_ADDRESS#" new-user-data
      sed -i -n "s#WS01-IP-ADDRESS#${IP_ADDRESSES[0]}#" new-user-data
      sed -i -n "s#WS02-IP-ADDRESS#${IP_ADDRESSES[1]}#" new-user-data
      sed -i -n "s#WS03-IP-ADDRESS#${IP_ADDRESSES[2]}#" new-user-data
      sed -i -n "s#WS04-IP-ADDRESS#${IP_ADDRESSES[3]}#" new-user-data

      #
      # Global application properties, only manager node
      #

      # Redis Master and Replica Server
      sed -i -n "s#REDIS-MASTER-SERVER-ADDRESS#$REDIS_MASTER_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#REDIS-MASTER-SERVER-PORT#$REDIS_MASTER_SERVER_PORT#" new-user-data
      sed -i -n "s#REDIS-REPLICA-SERVER-ADDRESS#$REDIS_REPLICA_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#REDIS-REPLICA-SERVER-PORT#$REDIS_REPLICA_SERVER_PORT#" new-user-data

      # Logging
      sed -i -n "s#APPLICATION-LOG-PATH#$APPLICATION_LOG_PATH#" new-user-data
      sed -i -n "s#SNAKEUTIL-LOG-FILE#$SNAKEUTIL_LOG_FILE#" new-user-data
      sed -i -n "s#SNAKEAPI-LOG-FILE#$SNAKEAPI_LOG_FILE#" new-user-data
      sed -i -n "s#SNAKEHISTORY-LOG-FILE#$SNAKEHISTORY_LOG_FILE#" new-user-data
      sed -i -n "s#SNAKECONFIG-LOG-FILE#$SNAKECONFIG_LOG_FILE#" new-user-data
      sed -i -n "s#SNAKETIMER-LOG-FILE#$SNAKETIMER_LOG_FILE#" new-user-data
      #sed -i -n "s##$#" new-user-data

      # Portainer Server
      sed -i -n "s#PORTAINER-SERVER-ADDRESS#$PORTAINER_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#PORTAINER-SERVER-PORT#$PORTAINER_SERVER_PORT#" new-user-data

      # Sketch Server
      sed -i -n "s#SKETCH-SERVER-ADDRESS#$SKETCH_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#SKETCH-SERVER-PORT#$SKETCH_SERVER_PORT#" new-user-data

      # API Server
      sed -i -n "s#API-SERVER-ADDRESS#$API_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#API-SERVER-PORT#$API_SERVER_PORT#" new-user-data
      sed -i -n "s#SWARM-SECRET#$SWARM_SECRET#" new-user-data

      # SnakeApi Version
      sed -i -n "s#SNAKEAPI-VERSION#$SNAKEAPI_VERSION#" new-user-data

      # SQL Admin
      sed -i -n "s#SQL-DB-ADMIN#$SQL_DB_ADMIN#" new-user-data

      # SQL Database names
      sed -i -n "s#SQL-USERS-DB-NAME#$SQL_USERS_DB_NAME#" new-user-data
      sed -i -n "s#SQL-HOMES-DB-NAME#$SQL_HOMES_DB_NAME#" new-user-data
      sed -i -n "s#SQL-COLLECTIONS-DB-NAME#$SQL_COLLECTIONS_DB_NAME#" new-user-data

      # SQL Server
      sed -i -n "s#SQL-SERVER-ADDRESS#$SQL_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#SQL-SERVER-PORT#$SQL_SERVER_PORT#" new-user-data

      # MQTT Server
      sed -i -n "s#MQTT-SERVER-ADDRESS#$MQTT_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#MQTT-SERVER-PORT#$MQTT_SERVER_PORT#" new-user-data
      sed -i -n "s#MANAGER-ENCRYPTED-PASSWORD#$MANAGER_ENCRYPTED_PASSWORD#g" new-user-data

      # SKETCH Server
      sed -i -n "s#SKETCH-SERVER-ADDRESS#$SKETCH_SERVER_ADDRESS#" new-user-data
      sed -i -n "s#SKETCH-SERVER-PORT#$SKETCH_SERVER_PORT#" new-user-data

      # SWARM Mail
      sed -i -n "s#SWARM-MAIL-USER#$SWARM_MAIL_USER#" new-user-data
      sed -i -n "s#SWARM-MAIL-SUBJECT#$SWARM_MAIL_SUBJECT#" new-user-data
      sed -i -n "s#SWARM-MAIL-BODY#$SWARM_MAIL_BODY#" new-user-data
      sed -i -n "s#SWARM-MAIL-PATH#$SWARM_MAIL_PATH#" new-user-data

      # SQL Templates
      sed -i -n "s#SQL-TEMPLATE-DEFAULT#$SQL_TEMPLATE_DEFAULT#" new-user-data
      sed -i -n "s#SQL-TEMPLATE-LOOKUP-USER#$SQL_TEMPLATE_LOOKUP_USER#" new-user-data
      sed -i -n "s#SQL-TEMPLATE-CREATE-USER#$SQL_TEMPLATE_CREATE_USER#" new-user-data
      sed -i -n "s#SQL-TEMPLATE-GRANT-PRIVILEGES#$SQL_TEMPLATE_GRANT_PRIVILEGES#" new-user-data
      sed -i -n "s#SQL-TEMPLATE-FIND-USER#$SQL_TEMPLATE_FIND_USER#" new-user-data
      sed -i -n "s#SQL-TEMPLATE-GRANT-ALL-PRIVILEGES#$SQL_TEMPLATE_GRANT_ALL_PRIVILEGES#" new-user-data

      # Types
      sed -i -n "s#RULE-TYPES#$RULE_TYPES#" new-user-data
      sed -i -n "s#ACCESSORY-TYPES#$ACCESSORY_TYPES#" new-user-data
      sed -i -n "s#SERVICE-TYPES#$SERVICE_TYPES#" new-user-data
      local RESULT_STRING=$(echo | sed "s/\"/\'/g" <<<"$ACCESSORY_SERVICES")
      sed -i -n "s#ACCESSORY-SERVICES#$RESULT_STRING#" new-user-data

      # SnakeHistory
      sed -i -n "s#SNAKEHISTORY-VERSION#$SNAKEHISTORY_VERSION#" new-user-data
      sed -i -n "s#HISTORY-DB-NAME#$HISTORY_DB_NAME#" new-user-data
      sed -i -n "s#MANAGER-EMAIL#$MANAGER_EMAIL#" new-user-data

      # SnakeConfig
      sed -i -n "s#SNAKECONFIG-VERSION#$SNAKECONFIG_VERSION#" new-user-data
      sed -i -n "s#APPLICATION-LIST#$APPLICATION_LIST#" new-user-data
      sed -i -n "s#ENVIRONMENT-LIST#$ENVIRONMENT_LIST#" new-user-data
      sed -i -n "s#REDIS-SYNC-KEY#$REDIS_SYNC_KEY#" new-user-data
      sed -i -n "s#REDIS-SYNC-PATH#$REDIS_SYNC_PATH#" new-user-data

      # SnakeUtil
      sed -i -n "s#SNAKEUTIL-VERSION#$SNAKEUTIL_VERSION#" new-user-data
      sed -i -n "s#DNS-PROVIDER-LIST#$DNS_PROVIDER_LIST#" new-user-data

      # SnakeTimer
      sed -i -n "s#SNAKETIMER-VERSION#$SNAKETIMER_VERSION#" new-user-data

      ;;
   "${SWARM_NODES[1]}")
      cp ../Artifacts/$WORKER_TEMPLATE_FILE_NAME.$TEMPLATE_FILE_EXT new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data
      # Setup DNSMasq A records
      # sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING2#$WS03_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING1#${DNS_URLS[0]}#" new-user-data
      sed -i -n "s#DNS-STRING2#${DNS_URLS[2]}#" new-user-data
      sed -i -n "s#DNS-STRING3#${DNS_URLS[3]}#" new-user-data

      ;;
   "${SWARM_NODES[2]}")
      cp ../Artifacts/$WORKER_TEMPLATE_FILE_NAME.$TEMPLATE_FILE_EXT new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data

      # Setup DNSMasq A records
      # sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING2#$WS02_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING3#$WS04_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING1#${DNS_URLS[0]}#" new-user-data
      sed -i -n "s#DNS-STRING2#${DNS_URLS[1]}#" new-user-data
      sed -i -n "s#DNS-STRING3#${DNS_URLS[3]}#" new-user-data
      ;;
   "${SWARM_NODES[3]}")
      cp ../Artifacts/$WORKER_TEMPLATE_FILE_NAME.$TEMPLATE_FILE_EXT new-user-data
      # Worker node properties
      sed -i -n "s/SWARM-MANAGER-NODE/$SWARM_MANAGER_NODE/g" new-user-data
      sed -i -n "s/SWARM-PORT/$SWARM_PORT/g" new-user-data
      sed -i -n "s*SWARM-WORKER-TOKEN*$SWARM_WORKER_TOKEN*" new-user-data

      # Setup DNSMasq A records
      # sed -i -n "s#DNS-STRING1#$WS01_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING2#$WS02_DNS_STRING#" new-user-data
      # sed -i -n "s#DNS-STRING3#$WS03_DNS_STRING#" new-user-data
      sed -i -n "s#DNS-STRING1#${DNS_URLS[0]}#" new-user-data
      sed -i -n "s#DNS-STRING2#${DNS_URLS[1]}#" new-user-data
      sed -i -n "s#DNS-STRING3#${DNS_URLS[2]}#" new-user-data
      ;;
   *)
      echo -n "EditProperties unknown input parameter"
      ;;
   esac

   # Swarm Common properties
   echo -n "Editing GLOBAL Properties"

   # Redis properties
   #sed -i -n "s#REDIS-DEFAULT-CONFIG#$REDIS_DEFAULT_CONFIG#" new-user-data

   # ETH0
   sed -i -n "s#ETH0-NETWORK-ADDRESS#$ETH0_NETWORK_ADDRESS#" new-user-data
   sed -i -n "s#ETH0-NETWORK-NETMASK#$ETH0_NETWORK_NETMASK#" new-user-data
   sed -i -n "s#ETH0-NETWORK-BITS#$ETH0_NETWORK_BITS#" new-user-data
   sed -i -n "s/ETH0-DNS-SERVERS/$ETH0_DNS_SERVERS/" new-user-data
   sed -i -n "s/ETH0-STATIC-ROUTERS/$ETH0_STATIC_ROUTERS/" new-user-data
   sed -i -n "s/ETH0-IP-ADDRESS/$ETH0_IP_ADDRESS/" new-user-data
   #sed -i -n "s#ETH0-LAN#$ETH0_LAN#" new-user-data

   # Locale
   sed -i -n "s#SWARM-LOCALE#$SWARM_LOCALE#" new-user-data

   # TimeZone
   sed -i -n "s#TIME-ZONE#$TIME_ZONE#" new-user-data
   #sed -i -n "s#ISO-DATE#$ISO_DATE#" new-user-data
   #sed -i -n "s#ISO-TIME#$ISO_TIME#" new-user-data

   # SSH Authorized Key
   sed -i -n "s#AUTHORIZED-SSH-KEY#$AUTHORIZED_SSH_KEY#" new-user-data

   # Domains
   sed -i -n "s/INTERNAL-DOMAIN-NAME/$INTERNAL_DOMAIN_NAME/" new-user-data
   sed -i -n "s/EXTERNAL-DOMAIN-NAME/$EXTERNAL_DOMAIN_NAME/" new-user-data

   # Swarm Manager
   sed -i -n "s/MANAGER-PASSWORD/$MANAGER_PASSWORD/" new-user-data
   sed -i -n "s/MANAGER-NAME/$MANAGER_NAME/" new-user-data
   #sed -i -n "s/AUTHORIZED-SSH-KRY/$AUTHORIZED_SSH_KEY" new-user-data
   #sed -i -n "s*MANAGER-ENCRYPTED-PASSWORD*$MANAGER_ENCRYPTED_PASSWORD*" new-user-data

   # Swarm Node
   sed -i -n "s/NODE-NAME/$NODE_NAME/g" new-user-data

   # USB Drive mount command
   sed -i -n "s#USB-MOUNT-COMMAND#$USB_RESULT_STRING#" new-user-data

   # Meta Data
   sed -i -n "s/INSTANCE-ID/$NODE_NAME/g" new-meta-data

   mv new-user-data user-data
   mv new-meta-data meta-data
   cd ..
}

function PromptForInput() {
   # If we change IP properties, then SetNetAddress have to be called
   # If we change DNS properties, then SetDnsStrings have to be called
   # Net prompts commented out
   case $1 in
   "${SWARM_NODES[0]}")
      echo -e "Configuring Manager Node"
      ;;
   "${SWARM_NODES[1]}" | "${SWARM_NODES[2]}" | "${SWARM_NODES[3]}")
      #  # Configure Swarm Port (worker)
      echo -e "Configuring Worker Node"
      echo -e "\n"
      read -e -p "Type Swarm TCP Port number ${RD}${BO}default=[${SWARM_PORT}] ${BLA}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${SWARM_PORT}"
      else
         SWARM_PORT=$REPLY
         echo -e -n "${SWARM_PORT}"
      fi
      #  # Configure Swarm Worker Token (worker)
      echo -e "\n"
      read -e -p "Paste Swarm Worker Token, obtained from Manager Node ${BLA}> "
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
   read -e -p "Type Swarm Manager name ${RD}${BO}default=[${MANAGER_NAME}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${MANAGER_NAME}"
   else
      MANAGER_NAME=$REPLY
      echo -e -n "${MANAGER_NAME}"
   fi

   # # Configure Manager password (Manager & Worker)
   #
   echo -e "\n"
   GETPW=true
   while $GETPW; do
      read -e -p "Type Swarm Manager password ${BLA}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must supply password\n"
      else
         #MANAGER_PASSWORD=$(python3 ./Artifacts/Hidepw.py $REPLY)
         MANAGER_PASSWORD=$REPLY
         GETPW=false
      fi

      # Set Mosquitto Manager User and Password string
      MANAGER_ENCRYPTED_PASSWORD=$(./Utilities/HashUtil $MANAGER_NAME $MANAGER_PASSWORD)
   done

   # # Configure Time Zone (Manager & Worker)
   echo -e "\n"
   read -e -p "Type Time Zone ${RD}${BO}default=[${TIME_ZONE}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${TIME_ZONE}"
   else
      TIME_ZONE=$REPLY
      echo -e -n "${TIME_ZONE}"
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
   #echo -e "ISO_TIME: " $ISO_TIME

   echo -e "\n--- User properties ---"
   echo -e "MANAGER_NAME: " $MANAGER_NAME
   echo -e "MANAGER_PASSWORD: " $MANAGER_PASSWORD
   echo -e "MANAGER_ENCRYPTED_PASSWORD: " $MANAGER_ENCRYPTED_PASSWORD

   echo -e "\n--- Swarm properties ---"
   echo -e "NODENAME_COUNT: " $NODENAME_COUNT
   echo -e "NODE_NAME_PREFIX: " $NODENAME_PREFIX

   # TODO: Make node count repeat

   echo -e "SWARM_NODES[0]: " ${SWARM_NODES[0]}
   echo -e "SWARM_NODES[1]: " ${SWARM_NODES[1]}
   echo -e "SWARM_NODES[2]: " ${SWARM_NODES[2]}
   echo -e "SWARM_NODES[3]: " ${SWARM_NODES[3]}

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
   echo -e "ETH0_NETWORK_ADDRESS: " $ETH0_NETWORK_ADDRESS
   echo -e "ETH0_NETWORK_NETMASK: " $ETH0_NETWORK_NETMASK
   echo -e "ETH0_NETWORK_BITS: " $ETH0_NETWORK_BITS
   echo -e "ETH0_IP_ADDRESS: " $ETH0_IP_ADDRESS
   echo -e "ETH0_STATIC_ROUTERS: " $ETH0_STATIC_ROUTERS
   echo -e "ETH0_DNS_SERVERS: " $ETH0_DNS_SERVERS

   echo -e "\n--- WLAN0 properties ---"
   echo -e "WLAN0_NETWORK_ADDRESS: " $WLAN0_NETWORK_ADDRESS
   echo -e "WLAN0_NETWORK_NETMASK: " $WLAN0_NETWORK_NETMASK
   echo -e "WLAN0_NETWORK_BITS: " $WLAN0_NETWORK_BITS
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

   # echo -e "\n--- Node Default IP Address ---"
   # echo -e "WS01_IP_ADDRESS: " $WS01_IP_ADDRESS
   # echo -e "WS02_IP_ADDRESS: " $WS02_IP_ADDRESS
   # echo -e "WS03_IP_ADDRESS: " $WS03_IP_ADDRESS
   # echo -e "WS04_IP_ADDRESS: " $WS04_IP_ADDRESS

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

   echo -e "Internal API Url: " $INTERNAL_API_SERVER_URL
   echo -e "Internal DB Url: " $INTERNAL_DB_SERVER_URL
   echo -e "Internal MQTT Url: " $INTERNAL_MQTT_SERVER_URL
   echo -e "Internal SKETCH Url: " $INTERNAL_SKETCH_SERVER_URL

   echo -e "External API Url: " $API_SERVER_URL
   echo -e "External DB Url: " $DB_SERVER_URL
   echo -e "External MQTT Url: " $MQTT_SERVER_URL
   echo -e "External SKETCH Url: " $SKETCH_SERVER_URL

   # Test of json string
   # echo -e "REDIS_DEFAULT_CONFIG: " $REDIS_DEFAULT_CONFIG
   echo -e "---------- $1 ----------\n"
}

function SaveProperties() {
   # create new file
   # write  new file
   # Filename prefix swarmconfig-date.mvf (date = yyyy-mm-dd)

   #  # Ask for new file name
   echo -e "\n"
   read -p "${GR}Type new file name${WH}> "
   if [ $REPLY != "" ]; then
      echo -e -n "${PROPERTY_FILE_NAME}"
   else
      PROPERTY_FILE_NAME="$REPLY_"
      echo -e -n "${PROPERTY_FILE_NAME}"
   fi

}

function SaveTemplate() {

   echo -e "\n"
   read -p "${GR}Type new file name${WH}> "
   # Check that $REPLY is not empty
   if [[ $REPLY != "" ]]; then
      # And that we are not overwriting the current template file
      if [[ "./Artifacts/$REPLY.mvt" != $INPUT_TEMPLATE ]]; then
         echo 'WaveSnake Template File' >./Artifacts/$REPLY.mvt
         while read line; do
            echo $line >>"./Artifacts/$REPLY.mvt"
         done <$INPUT_TEMPLATE

         INPUT_TEMPLATE="$REPLY.mvt"
         echo -e "New Template file: $INPUT_TEMPLATE"
      fi
   fi
}

function ReadProperties() {
   # Keep sections/lines in this function synchronized
   # with swarmconfig.txt
   #
   # Read all properties from swarmconfig.txt
   # source ./Artifacts/swarmconfig.txt
   #source "./Artifacts/$PROPERTY_FILE_NAME"
   #source "$PROPERTY_FILE_NAME"
   source "$INPUT_FILE"
   #.$PROPERTY_FILE_EXT"
   #echo -e "Input File: ./Artifacts/$PROPERTY_FILE_NAME.$PROPERTY_FILE_EXT"
   echo -e "Selected file: $INPUT_FILE"

   # Script properties
   NODENAME_PREFIX=$NODENAME_PREFIX
   NODENAME_COUNT=$NODENAME_COUNT
   PROPERTY_FILE_NAME=$PROPERTY_FILE_NAME
   PROPERTY_FILE_EXT=$PROPERTY_FILE_EXT
   MANAGER_TEMPLATE_FILE_NAME=$MANAGER_TEMPLATE_FILE_NAME
   WORKER_TEMPLATE_FILE_NAME=$WORKER_TEMPLATE_FILE_NAME
   TEMPLATE_FILE_EXT=$TEMPLATE_FILE_EXT

   # MANAGER Properties
   MANAGER_NAME=$MANAGER_NAME
   MANAGER_PASSWORD=$MANAGER_PASSWORD
   MANAGER_EMAIL=$MANAGER_EMAIL
   AUTHORIZED_SSH_KEY=$AUTHORIZED_SSH_KEY
   SWARM_SECRET=$SWARM_SECRET
   #MANAGER_PASSWORD=$MANAGER_PASSWORD
   #MANAGER_ENCRYPTED_PASSWORD=$MANAGER_ENCRYPTED_PASSWORD

   # SSH Properties
   SSH_KEY_FILE=$SSH_KEY_FILE

   # NODE Properties
   NODE_NAME=$NODE_NAME
   SWARM_LOCALE=$SWARM_LOCALE
   TIME_ZONE=$TIME_ZONE

   # Docker Swarm Properties
   #SWARM_MANAGER_NODE=$SWARM_MANAGER_NODE
   SWARM_PORT=$SWARM_PORT
   #SWARM_INTERFACE=$SWARM_INTERFACE
   #SWARM_WORKER_TOKEN=$SWARM_WORKER_TOKEN
   #SWARM_MANAGER_TOKEN=$SWARM_MANAGER_TOKEN

   # Swarm External Application URL's
   #API_SERVER_URL=$API_SERVER_URL
   #DB_SERVER_URL=$DB_SERVER_URL
   #MQTT_SERVER_URL=$MQTT_SERVER_URL
   #SKETCH_SERVER_URL=$INTERNAL_SKETCH_SERVER_URL

   # Swarm Application DNS Prefix's
   API_PREFIX=$API_PREFIX
   DB_PREFIX=$DB_PREFIX
   MQTT_PREFIX=$MQTT_PREFIX
   SKETCH_PREFIX=$SKETCH_PREFIX

   # Swarm Internal Application URL's
   #INTERNAL_API_SERVER_URL=$INTERNAL_API_SERVER_URL
   #INTERNAL_DB_SERVER_URL=$INTERNAL_DB_SERVER_URL
   #INTERNAL_MQTT_SERVER_URL=$INTERNAL_MQTT_SERVER_URL
   #INTERNAL_SKETCH_SERVER_URL=$INTERNAL_SKETCH_SERVER_URL

   # WiFi properties
   COUNTRY_CODE=$COUNTRY_CODE
   WIFI_SSID=$WIFI_SSID
   WIFI_PASSWD=$WIFI_PASSWORD

   # Swarm Node ETH0 properties
   ETH0_NETWORK_ADDRESS=$ETH0_NETWORK_ADDRESS
   ETH0_NETWORK_NETMASK=$ETH0_NETWORK_NETMASK
   ETH0_IP_ADDRESS=$ETH0_IP_ADDRESS
   ETH0_STATIC_ROUTERS=$ETH0_STATIC_ROUTERS
   ETH0_DNS_SERVERS=$ETH0_DNS_SERVERS

   # Manager Node WLAN0 properties
   WLAN0_NETWORK_ADDRESS=$WLAN0_NETWORK_ADDRESS
   WLAN0_NETWORK_NETMASK=$WLAN0_NETWORK_NETMASK
   WLAN0_IP_ADDRESS=$WLAN0_IP_ADDRESS
   WLAN0_STATIC_ROUTERS=$WLAN0_STATIC_ROUTERS
   WLAN0_DNS_SERVERS=$WLAN0_DNS_SERVERS

   # Domain properties
   INTERNAL_DOMAIN_NAME=$INTERNAL_DOMAIN_NAME
   EXTERNAL_DOMAIN_NAME=$EXTERNAL_DOMAIN_NAME

   # Dynamic DNS properties
   DNS_PROVIDER_LIST=($DNS_PROVIDER_LIST)

   DNS_PROVIDER_NAMES=$DNS_PROVIDER_LIST

   DNS_PROVIDER_URL_LIST=($DNS_PROVIDER_URL_LIST)
   DYNAMIC_DNS_PROVIDER=$DYNAMIC_DNS_PROVIDER
   # Must also be lists
   DYNAMIC_DNS_USER=$DYNAMIC_DNS_USER
   DYNAMIC_DNS_PASSWD=$DYNAMIC_DNS_PASSWD

   # ACME properties
   ACME_EMAIL_ADDRESS=$ACME_EMAIL_ADDRESS

   # Global application properties
   APPLICATION_LOG_PATH=$APPLICATION_LOG_PATH

   # Traefik properties
   TRAEFIK_ENTRYPOINT_ADDRESS=$TRAEFIK_ENTRYPOINT_ADDRESS

   # SnakeApi properties
   SNAKEAPI_VERSION=$SNAKEAPI_VERSION
   SNAKEAPI_LOG_FILE=$SNAKEAPI_LOG_FILE
   SQL_DB_ADMIN=$SQL_DB_ADMIN
   SQL_USERS_DB_NAME=$SQL_USERS_DB_NAME
   SQL_HOMES_DB_NAME=$SQL_HOMES_DB_NAME
   SQL_COLLECTIONS_DB_NAME=$SQL_COLLECTIONS_DB_NAME
   SQL_SERVER_ADDRESS=$SQL_SERVER_ADDRESS
   SQL_SERVER_PORT=$SQL_SERVER_PORT
   MQTT_SERVER_ADDRESS=$MQTT_SERVER_ADDRESS
   MQTT_SERVER_PORT=$MQTT_SERVER_PORT
   SKETCH_SERVER_ADDRESS=$SKETCH_SERVER_ADDRESS
   SKETCH_SERVER_PORT=$SKETCH_SERVER_PORT
   SWARM_MAIL_USER=$SWARM_MAIL_USER
   SWARM_MAIL_SUBJECT=$SWARM_MAIL_SUBJECT
   SWARM_MAIL_BODY=$SWARM_MAIL_BODY
   SWARM_MAIL_PATH=$SWARM_MAIL_PATH
   SQL_TEMPLATE_DEFAULT=$SQL_TEMPLATE_DEFAULT
   SQL_TEMPLATE_LOOKUP_USER=$SQL_TEMPLATE_LOOKUP_USER
   SQL_TEMPLATE_CREATE_USER=$SQL_TEMPLATE_CREATE_USER
   SQL_TEMPLATE_GRANT_PRIVILEGES=$SQL_TEMPLATE_GRANT_PRIVILEGES
   SQL_TEMPLATE_FIND_USER=$SQL_TEMPLATE_FIND_USER
   SQL_TEMPLATE_GRANT_ALL_PRIVILEGES=$SQL_TEMPLATE_GRANT_ALL_PRIVILEGES
   RULE_TYPES=$RULE_TYPES
   ACCESSORY_TYPES=$ACCESSORY_TYPES
   SERVICE_TYPES=$SERVICE_TYPES
   ACCESSORY_SERVICES=$ACCESSORY_SERVICES

   # Not used in SnakeApi
   API_SERVER_ADDRESS=$API_SERVER_ADDRESS
   API_SERVER_PORT=$API_SERVER_PORT

   # Portainer properties
   PORTAINER_SERVER_ADDRESS=$PORTAINER_SERVER_ADDRESS
   PORTAINER_SERVER_PORT=$PORTAINER_SERVER_PORT

   # SnakeConfig properties
   SNAKECONFIG_VERSION=$SNAKECONFIG_VERSION
   SNAKECONFIG_LOG_FILE=$SNAKECONFIG_LOG_FILE
   APPLICATION_LIST=$APPLICATION_LIST
   ENVIRONMENT_LIST=$ENVIRONMENT_LIST
   REDIS_SYNC_KEY=$REDIS_SYNC_KEY
   REDIS_SYNC_PATH=$REDIS_SYNC_PATH

   # SnakeHistory properties
   SNAKEHISTORY_VERSION=$SNAKEHISTORY_VERSION
   SNAKEHISTORY_LOG_FILE=$SNAKEHISTORY_LOG_FILE
   HISTORY_DB_NAME=$HISTORY_DB_NAME

   # SnakeUtil properties
   SNAKEUTIL_VERSION=$SNAKEUTIL_VERSION
   SNAKEUTIL_LOG_FILE=$SNAKEUTIL_LOG_FILE

   # SnakeTimer properties
   SNAKETIMER_VERSION=$SNAKETIMER_VERSION
   SNAKETIMER_LOG_FILE=$SNAKETIMER_LOG_FILE

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
   # All IP adresses will default be set from the current LAN_NET and ETH0_LAN string.
   # You can change WLAN0_LAN an ETH0_LAN prroperties in the ConfigureInternalNetwork Menu, and then this
   # function will be run again based on the new property values.
   IFS='.' # Dot is set as delimiter
   if [ $1 == "AUTO" ]; then
      LAN_STR=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2)
      read -ra LANADDR <<<"$LAN_STR" # LAN_STR is read into an array as tokens separated by IFS
   else
      LAN_STR=$WLAN0_NETWORK_ADDRESS
      read -ra LANADDR <<<"$LAN_STR" # LAN_STR is read into an array as tokens separated by IFS
   fi

   WLAN0_NETWORK_BITS="${LANADDR[0]}.${LANADDR[1]}.${LANADDR[2]}.0/24"
   read -ra WLANIPTMP <<<"$WLAN0_IP_ADDRESS"
   #WLAN0_IP_ADDRESS="${LANADDR[0]}.${LANADDR[1]}.${LANADDR[2]}.${WLANIPTMP[3]}"
   WLAN0_DONE=$CHECK_DONE_DEFAULT

   read -ra ETH0ADDR <<<"$ETH0_NETWORK_ADDRESS" # ETH0_IP_ADDRESS is read into an array as tokens separated by IFS
   local ETH0_LAN_NET="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}"
   ETH0_NETWORK_BITS="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.0/24"

   # Set Swarm Node internal IP Address
   IP_ADDRESSES[0]="${ETH0_LAN_NET}.1"
   IP_ADDRESSES[1]="${ETH0_LAN_NET}.2"
   IP_ADDRESSES[2]="${ETH0_LAN_NET}.3"
   IP_ADDRESSES[3]="${ETH0_LAN_NET}.4"

   # Set Traefik entrypoint address
   TRAEFIK_ENTRYPOINT_ADDRESS="$WLAN0_IP_ADDRESS"

   # Set Application IP Adresses and possibly Node placement
   API_SERVER_ADDRESS="$WLAN0_IP_ADDRESS"
   SKETCH_SERVER_ADDRESS="$WLAN0_IP_ADDRESS"
   MQTT_SERVER_ADDRESS="$WLAN0_IP_ADDRESS"
   PORTAINER_SERVER_ADDRESS="$WLAN0_IP_ADDRESS"

   # Set Redis Master and Replica server IP addresses
   REDIS_MASTER_SERVER_ADDRESS="${ETH0_LAN_NET}.1"
   REDIS_REPLICA_SERVER_ADDRESS="${ETH0_LAN_NET}.4"
   IFS=' '
}

function SetNodeNames() {
   #  # Configure Node Name Count
   if [ $1 == "PROMPT" ]; then
      echo -e "\n"
      read -e -p "${GR}Type Node Count${RD}${BO} default=[${NODENAME_COUNT}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "${NODENAME_COUNT}"
      else
         NODENAME_COUNT=$REPLY
         echo -e -n "${NODENAME_COUNT}"
      fi

      #  # Configure Node Name Prefix
      echo -e "\n"
      read -e -p "${GR}Type Node Name Prefix${RD}${BO} default=[${NODENAME_PREFIX}] ${WH}> "
      if [[ -z "$REPLY" ]]; then
         echo -e "${NODENAME_PREFIX}"
      else
         NODENAME_PREFIX=$REPLY
         echo -e "${NODENAME_PREFIX}"
      fi
   fi
   # Set node names from NODENAME_PREFIX and NODENAME_COUNT
   local nodeCount=1
   while [ $nodeCount -le $(($NODENAME_COUNT)) ]; do
      SWARM_NODES[$nodeCount - 1]=$"$NODENAME_PREFIX"0"$nodeCount"
      #echo "Nodename ${SWARM_NODES[$nodeCount - 1]}"
      nodeCount=$(($nodeCount + 1))
   done
   SWARM_MANAGER_NODE=${SWARM_NODES[1]}

   # Create a subdir for each node
   for ((i = 0; i < $NODENAME_COUNT; i++)); do
      if [ ! -d "$CURRENT_DIR/${SWARM_NODES[i]}" ]; then
         mkdir "$CURRENT_DIR/${SWARM_NODES[i]}"
      fi
   done

}

function SetDnsStrings() {
   # Internal Application Url's
   INTERNAL_API_SERVER_URL="$API_PREFIX.$INTERNAL_DOMAIN_NAME"
   INTERNAL_DB_SERVER_URL="$DB_PREFIX.$INTERNAL_DOMAIN_NAME"
   INTERNAL_MQTT_SERVER_URL="$MQTT_PREFIX.$INTERNAL_DOMAIN_NAME"
   INTERNAL_SKETCH_SERVER_URL="$SKETCH_PREFIX.$INTERNAL_DOMAIN_NAME"

   # External application Url's
   API_SERVER_URL="$API_PREFIX.$EXTERNAL_DOMAIN_NAME"
   DB_SERVER_URL="$DB_PREFIX.$EXTERNAL_DOMAIN_NAME"
   MQTT_SERVER_URL="$MQTT_PREFIX.$EXTERNAL_DOMAIN_NAME"
   SKETCH_SERVER_URL="$SKETCH_PREFIX.$EXTERNAL_DOMAIN_NAME"
}

function SetDateTime() {
   ISO_DATE=$(date "+%d %b %Y  %H:%M")
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
   # Reads and presents all *.mvf files
   # so user kan choose properties file.
   INPUT_CONFIG_FILES=()
   j=0
   for i in ./Artifacts/*.mvf; do
      [ -f "$i" ] || break
      INPUT_CONFIG_FILES[$j]="$i"
      j=$(($j + 1))
   done

   echo -e "\nSelect Input file with predefined properties"
   select fav in "${INPUT_CONFIG_FILES[@]}"; do
      INPUT_FILE=$fav
      break
   done
}

function SelectNodeTemplate() {
   # Reads and presents all *.yaml files
   # so user can choose template file.
   INPUT_TEMPLATE_FILES=()
   j=0
   for i in ./Artifacts/*.yaml; do
      [ -f "$i" ] || break
      INPUT_TEMPLATE_FILES[j]="$i"
      j+=1
   done
   echo -e "\nSelect Template file${BLA}"
   select fav in "${INPUT_TEMPLATE_FILES[@]}"; do
      # Read and parse input file
      INPUT_TEMPLATE=$fav
      #echo -e "SelectInputTemplate $fav"
      break
   done
}

function ConfigureInternalNetwork() {
   #  # Configure ETH0 LAN (Manager & Worker)
   echo -e "\n"
   read -e -p "Type ETH0 Lan${RD}${BO} default=[${ETH0_NETWORK_ADDRESS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_NETWORK_ADDRESS}"
   else
      ETH0_NETWORK_ADDRESS=$REPLY
      ETH0_NETWORK_BITS="$REPLY/24"
      echo -e -n "${ETH0_NETWORK_ADDRESS}"
   fi

   #  # Configure ETH0 IP Address (Manager & Worker)
   echo -e "\n"
   read -e -p "Type ETH0 IP address${RD}${BO} default=[${ETH0_IP_ADDRESS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_IP_ADDRESS}"
   else
      ETH0_IP_ADDRESS=$REPLY
      echo -e -n "${ETH0_IP_ADDRESS}"
   fi

   #  # Configure ETH0 Static Routers (Manager & Worker)
   echo -e "\n"
   read -e -p "${GR}Type ETH0 Static Routers${RD}${BO} default=[${ETH0_STATIC_ROUTERS}] ${WH}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   else
      ETH0_STATIC_ROUTERS=$REPLY
      echo -e -n "${ETH0_STATIC_ROUTERS}"
   fi

   # # Configure ETH0 DNS Servers (Manager & Worker)
   echo -e "\n"
   read -e -p "Type ETH0 DNS Servers${RD}${BO} default=[${ETH0_DNS_SERVERS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${ETH0_DNS_SERVERS}"
   else
      ETH0_DNS_SERVERS=$REPLY
      echo -e -n "${ETH0_DNS_SERVERS}"
   fi

}

function ConfigureWiFiNetwork() {
   #  # Configure WLAN0 LAN (Manager)

   # WLAN0 Lan Address
   echo -e "\n"
   read -e -p "Type WLAN0 Lan address${RD}${BO} default=[${WLAN0_NETWORK_ADDRESS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_NETWORK_ADDRESS}"
   else
      WLAN0_NETWORK_ADDRESS=$REPLY
      WLAN0_NETWORK_BITS="$REPLY/24"
      echo -e -n "${WLAN0_NETWORK_ADDRESS}"
   fi

   #  # Configure WLAN0 IP Address (Manager)
   echo -e "\n"
   read -e -p "Type WLAN0 IP address${RD}${BO} default=[${WLAN0_IP_ADDRESS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_IP_ADDRESS}"
   else
      WLAN0_IP_ADDRESS=$REPLY
      echo -e -n "${WLAN0_IP_ADDRESS}"
   fi

   #  # Configure WLAN0 Static Routers (Manager)
   echo -e "\n"
   read -e -p "Type WLAN0 Static Routers${RD}${BO} default=[${WLAN0_STATIC_ROUTERS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_STATIC_ROUTERS}"
   else
      WLAN0_STATIC_ROUTERS=$REPLY
      echo -e -n "${WLAN0_STATIC_ROUTERS}"
   fi

   #  # Configure WLAN0 DNS Servers (Manager)
   echo -e "\n"
   read -e -p "Type WLAN0 DNS Servers${RD}${BO} default=[${WLAN0_DNS_SERVERS}] ${BLA}> "
   if [[ -z "$REPLY" ]]; then
      echo -e -n "${WLAN0_DNS_SERVERS}"
   else
      WLAN0_DNS_SERVERS=$REPLY
      echo -e -n "${WLAN0_DNS_SERVERS}"
   fi

   #  # Configure WiFi Country Code (Manager)
   echo -e "\n"
   read -e -p "Type WiFi Country Code${RD}${BO} default=[${COUNTRY_CODE}] ${BLA}> "
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
      read -e -p "Type WiFi SSID ${BLA}> "
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
      read -e -p "Type WiFi Password ${BLA}> "
      if [[ -z "$REPLY" ]]; then
         echo -e -n "You must provide WiFi SSID"
      else
         WIFI_PASSWD=$REPLY
         #WIFI_PASSWD=$(python3 ./Artifacts/Hidepw.py $REPLY)
         echo -e -n "${WIFI_PASSWD}"
         GETPW=FALSE
      fi
   done
}

function ConfigureUSBDrives() {
   #  # Configure USB Drive mount
   # USB stick UUID and PARTUUID are different on Mac and RaspberryPI
   # So we must verify the USB stick on RaspberryPI, and
   # Type in the UUID here.
   echo -e "\n"
   read -e -p "Mount USB Drive ? ${BLA}y | n > " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n"
      read -e -p "Type USB UUID ${BLA}> "
      #USB_MOUNT_COMMAND = ${USB_MOUNT_COMMAND#USB_UUID#$REPLY}
      USB_MOUNT_COMMAND=$(echo "$USB_MOUNT_COMMAND" | sed "s/USB_UUID/$REPLY/")
      echo -e ""
   else
      USB_MOUNT_COMMAND="'logger No USB Drive Mount'"
   fi
}

function ConfigureDNS() {
   # Configure External domain name (Manager)
   # An external domain is essential, so this is a must.
   echo -e "\n"
   GETDOM=false
   while [ $GETDOM = false ]; do
      read -e -p "Type External domain name ${RD}${BO} default=[${EXTERNAL_DOMAIN_NAME}] ${BLA}> "
      if [[ ! -z "$REPLY" ]]; then
         TEMP_EXTERNAL_DOMAIN_NAME=$REPLY
      else
         TEMP_EXTERNAL_DOMAIN_NAME=$EXTERNAL_DOMAIN_NAME
      fi

      if [[ "$TEMP_EXTERNAL_DOMAIN_NAME" =~ ^[a-zA-Z0-9]+\.[a-zA-Z]+$ ]]; then
         EXTERNAL_DOMAIN_NAME=$TEMP_EXTERNAL_DOMAIN_NAME
         GETDOM=true
         echo -e -n "External domain: ${EXTERNAL_DOMAIN_NAME}"
      else
         echo "Domain name $REPLY is invalid."
      fi

      # Now set internal domain name
      IFS='.'
      read -ra DOM <<<"$EXTERNAL_DOMAIN_NAME"
      INTERNAL_DOMAIN_NAME="${DOM[0]}.local"
      IFS=' '
   done

   # Set Swarm Node internal DNS Url. These URL's are written to /etc/hosts file
   DNS_URLS[0]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.1 ${SWARM_NODES[0]} ${SWARM_NODES[0]}.${INTERNAL_DOMAIN_NAME}"
   DNS_URLS[1]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.2 ${SWARM_NODES[1]} ${SWARM_NODES[1]}.${INTERNAL_DOMAIN_NAME}"
   DNS_URLS[2]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.3 ${SWARM_NODES[2]} ${SWARM_NODES[2]}.${INTERNAL_DOMAIN_NAME}"
   DNS_URLS[3]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.4 ${SWARM_NODES[3]} ${SWARM_NODES[3]}.${INTERNAL_DOMAIN_NAME}"

   # # Configure LetsEncrype Certificate ACME Email Address (Manager)
   # This E-mail adddress must must be a valid mail address, and be registere by
   # LetsEncrypt, together with the external domain name.

   EMAILOK=false
   while [ $EMAILOK = false ]; do
      echo -e "\n"
      read -e -p "Type LetsEncrypt ACME Email Address${RD}${BO} default=[${ACME_EMAIL_ADDRESS}] ${BLA}> "
      if [[ ! -z "$REPLY" ]]; then
         TEMP_ACME_EMAIL_ADDRESS=$REPLY
      else
         TEMP_ACME_EMAIL_ADDRESS=$ACME_EMAIL_ADDRESS
      fi
      if [[ "$TEMP_ACME_EMAIL_ADDRESS" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
         ACME_EMAIL_ADDRESS=$REPLY
         EMAILOK=true
         echo -e "LetsEncrypt registered Email address ${ACME_EMAIL_ADDRESS}."
      else
         echo "Email address $email is invalid."
      fi
   done

   #  # Configure Dynamic DNS (Manager)
   echo -e "\n"
   read -e -p "Use Dynamic DNS ? ${BLA}y | n > " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n"
      DYNCOUNT=${#DNS_PROVIDER_LIST[@]}    # Get length of array
      DYN_MENU=("${DNS_PROVIDER_LIST[@]}") # Convert list to array
      select fav in "${DYN_MENU[@]}"; do
         case $fav in
         *)
            for ((i = 0; i < $DYNCOUNT; i++)); do
               if [ $fav == ${DNS_PROVIDER_LIST[i]} ]; then
                  DYNAMIC_DNS_PROVIDER=${DNS_PROVIDER_LIST[i]^^}
                  DYNAMIC_DNS_URL=${DNS_PROVIDER_URL_LIST[i]}
                  echo -e "Provider: $DYNAMIC_DNS_PROVIDER"
               fi
            done
            break
            ;;
         esac
      done

      #  # Configure Dynamic DNS User Name (Manager)
      echo -e "\n"
      GETUSR=true
      while $GETUSR; do
         read -e -p "Type ${DYNAMIC_DNS_PROVIDER} User Name ${BLA}> "
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
         read -e -p "Type ${DYNAMIC_DNS_PROVIDER} User Password${RD}${BO} default=[${DYNAMIC_DNS_PASSWD}] ${BLA}> "
         if [[ -z "$REPLY" ]]; then
            echo -e -n "${DYNAMIC_DNS_PASSWD}"
            GETPW=false
            #echo -e -n "You must provide Dynamic DNS user password"
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

function GetNodeName() {
   echo -e "\n"
   #read -p "${GR}Select node by typing ${RD}${BO}ws02, ws03 ${GR}or ${RD}ws04 ${EC}${WH}> " -n 4 -r
   read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
   NODE_NAME=$REPLY
   echo -e "\n$NODE_NAME"
}

function SelectNodeName() {
   #
   # Select Node Name Menu
   #

   NODENAME_MENU=("${SWARM_NODES[0]}"
      "${SWARM_NODES[1]}"
      "${SWARM_NODES[2]}"
      "${SWARM_NODES[3]}"
      "Quit")

   select fav in "${NODENAME_MENU[@]}"; do
      case $fav in
      "${SWARM_NODES[0]}")
         NODE_NAME=$fav
         break
         ;;
      "${SWARM_NODES[1]}")
         NODE_NAME=$fav
         break
         ;;
      "${SWARM_NODES[2]}")
         NODE_NAME=$fav
         break
         ;;
      "${SWARM_NODES[3]}")
         NODE_NAME=$fav
         break
         ;;
      esac
   done

}

# function SelectNodeName() {
#    echo -e "\n"
#    #read -p "${GR}Select node by typing ${RD}${BO}ws02, ws03 ${GR}or ${RD}ws04 ${EC}${WH}> " -n 4 -r
#    read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
#    NODE_NAME=$REPLY
#    echo -e "\n$NODE_NAME"
# }

function GetUSBUUID() {
   # USB stick UUID and PARTUUID are different on Mac and RaspberryPI
   # So we must verify the USB stick on RaspberryPI, and
   # Type in the UUID here.

   # Find UUID string on Mac. This wont work because the UUID found on Mac
   # is different from the UUID string on Raspberry PI.
   #USB_STR=$(diskutil list | grep -i -w 'hypriotos' | cut -c 69-)
   #UUID_STR=$(diskutil info $USB_STR | grep -i -w 'Volume UUID:' | cut -c 31-)
   #echo "$UUID_STR"

   # So ask for the UUID string, we have to check for an empty answer!
   read -p "Paste USB UUID here: "
   UUID_STR="$REPLY"

   USB_RESULT_STRING=$(echo | sed "s/USB_UUID/$UUID_STR/g" <<<"$USB_MOUNT_COMMAND")

   echo "$UUID_STR"
   echo "$RESULT_STRING"
}

function GenerateSSHKey() {
   #user=$(logname)
   #userHome=$(awk -F: -v u=$user '$1 == u {print $6}' /etc/passwd)
   # Execute: ssh-keygen -t ecdsa -b 256

   # Temp Key file
   #SSH_KEY_FILE="$(echo ~)/.ssh/id_ecdsa"
   # SSH_KEY_FILE="id_ecdsa"
   #SSH_KEY_FILE="$(echo ~)./keyfile.txt"
   #SSH_KEY_FILE_PUB="$SSH_KEY_FILE.pub"
   read -r -p "Generate new SSH key? y/n " -n 1
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo ""
      ssh-keygen -q -t ecdsa -b 256 -f "$SSH_KEY_FILE" -N '' <<<""$'\n'"y" 2>&1 >/dev/null
      #ssh-keygen -t ecdsa -b 256 -f "$SSH_KEY_FILE"
   fi
   #AUTHORIZED_SSH_KEY=$(<id_ecdsa.pub)
   AUTHORIZED_SSH_KEY=$(<$SSH_KEY_FILE.pub)
   #echo -e "$AUTHORIZED_SSH_KEY"
   #cp "$SSH_KEY_FILE".pub "$NODE_NAME"/keyfile.txt
   # Add keyfile.txt and keyfile.text.pub to Users .ssh file

   # while IFS= read -r line || [[ -n "$line" ]]; do
   #    AUTHORIZED_SSH_KEY="$line"
   #    #echo "Text read from file: $line"
   # done <"$SSH_KEY_FILE_PUB"
}

function MainMenu() {
   #
   # Main menu
   #
   QUIT_MENU=""
   while [ "$QUIT_MENU" != "QUIT" ]; do
      ConfigCheckMenu
      echo -e "\nMain Menu"

      SCRIPT_MENU=("Load_Configuration_File"
         "Configure_Manager_Node"
         "Configure_Worker_Node"
         "Flash_to_SDCard"
         "Select_Node_Template"
         "Detail_Menu"
         "Quit")

      select fav in "${SCRIPT_MENU[@]}"; do
         case $fav in
         "Load_Configuration_File")
            echo "$fav"
            # Select both Config Input and template(Manager or Worker)
            SelectInputConfig
            ReadProperties
            SetNodeNames "NOPROMPT"
            NODENAME_DONE=$CHECK_DONE_DEFAULT
            SetNetAddress "AUTO"
            WLAN0_DONE=$CHECK_DONE_DEFAULT
            ETH0_DONE=$CHECK_DONE_DEFAULT
            SetDnsStrings
            DNS_DONE=$CHECK_DONE_DEFAULT
            SetDateTime
            DATE_DONE=$CHECK_DONE_DEFAULT
            break
            ;;
         "Configure_Manager_Node")
            echo "$fav"
            NODE_NAME="${SWARM_NODES[0]}"
            PromptForInput "${SWARM_NODES[0]}"
            EditProperties "${SWARM_NODES[0]}"
            EDIT_DONE=$CHECK_DONE
            MANAGER_DONE=$CHECK_DONE
            break
            ;;
         "Configure_Worker_Node")
            echo "$fav"
            #GetNodeName
            SelectNodeName
            EditProperties $NODE_NAME
            EDIT_DONE=$CHECK_DONE
            WORKER_DONE=$CHECK_DONE
            break
            ;;
         "Flash_to_SDCard")
            SetDateTime
            FlashSD
            break
            ;;
         "Save_Config_File")
            # And then take input from this template
            echo "$fav"
            break
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
            Quit
            break
            ;;
         esac
      done
   done
}

function DetailMenu() {
   #
   # Detail menu
   #
   DETAIL_QUIT_MENU=""
   while [ "$DETAIL_QUIT_MENU" != "QUIT" ]; do
      ConfigCheckMenu
      echo -e "\nDetail Menu"
      DETAIL_MENU=("Configure_WiFi_Network"
         "Configure_Internal_Network"
         "Configure_DNS"
         "Change_Node_Names"
         "Configure_USB_Drives"
         "List_Properties"
         "Hide_Password"
         "Show_Password"
         "Get_USB_ID"
         "Generate_ssh_key"
         "Set_Date"
         "Quit")

      select fav in "${DETAIL_MENU[@]}"; do
         case $fav in
         "Configure_WiFi_Network")
            echo "$fav"
            ConfigureWiFiNetwork
            #SetNodeNames "PROMPT"
            SetNetAddress "MANUEL"
            WLAN0_DONE=$CHECK_DONE
            break
            ;;
         "Configure_Internal_Network")
            echo "$fav"
            ConfigureInternalNetwork
            #SetNodeNames "PROMPT"
            SetNetAddress "AUTO"
            ETH0_DONE=$CHECK_DONE
            break
            ;;
         "Configure_DNS")
            echo "$fav"
            ConfigureDNS
            SetDnsStrings
            DNS_DONE=$CHECK_DONE
            break
            ;;
         "Configure_USB_Drives")
            echo "$fav"
            ConfigureUSBDrives
            break
            ;;
         "Change_Node_Names")
            echo "$fav"
            SetNodeNames "PROMPT"
            NODENAME_DONE=$CHECK_DONE
            break
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
         "Get_USB_ID")
            GetUSBUUID
            USB_DONE=$CHECK_DONE
            break
            ;;
         "Generate_ssh_key")
            GenerateSSHKey
            SSH_DONE=$CHECK_DONE
            break
            ;;
         "Set_Date")
            SetDateTime
            DATE_DONE=$CHECK_DONE
            break
            ;;
         "Quit")
            echo "$fav"
            DETAIL_QUIT_MENU="QUIT"
            break
            ;;
         esac
      done
   done
}

function ConfigCheckMenu() {
   echo -e "\n"
   echo -e "_____________________________________________ Visited Menu's ______________________________________________________________________\n"
   echo -e " | WLan0[$WLAN0_DONE] | Eth0 [$ETH0_DONE] | Manager[$MANAGER_DONE] | USB[$USB_DONE] | EDIT[$EDIT_DONE] | DATE[$DATE_DONE]\
 | ManagerNode[$MANAGER_DONE] | WorkerNode[$WORKER_DONE] \n | DNS Strings[$DNS_DONE] | NodeNames[$NODENAME_DONE] | SSH[$SSH_DONE]"
   echo -e "___________________________________________________________________________________________________________________________________\n"
}

function FlashSD() {
   # WaveSnake Technologies 2020-03-06
   # This utility flashes Micro SD cards
   # for Raspberry Pi's, based on images from
   # Hypriot.
   #

   diskutil list
   echo -e "\n"
   read -e -p "Look at the Disk list, and type the Disk to flash the image to, example: /dev/disk7 > "

   echo -e "You have choosen" $REPLY "which will be overridden!!!!"
   echo -e "\n"
   DISK=$REPLY

   SelectNodeName

   read -e -p "Are you ready for Flashing $NODE_NAME? y/n " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      cd $NODE_NAME
      echo -e "Node: $NODE_NAME\n"
      echo -e "$(ls -l)"
      
      # Copy SSH Key to keyfile.txt
      pwd
      echo -e "Keyfile: $SSH_KEY_FILE"
      cp "../$SSH_KEY_FILE".pub keyfile.txt
      
      # Set DateTime for Fake HW Clock
      sed -i -n "s#ISO-DATE#$ISO_DATE#" user-data
      ../flash --force --userdata user-data --metadata meta-data --file keyfile.txt -d $DISK https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.3/hypriotos-rpi-v1.12.3.img.zip
      cd ..
      echo -e "\n"
   fi
   echo -e "\nLeaving Flash...\n"
}
#
# Start Script execution
#
printf "\033c"
echo -e "\n"
echo -e "${BLA}${BO}WaveSnake Flash Configuration Utility v1.0.7\n"
echo -e "${RD}${BO}This utility will prepare a Flash configuration file for a"
echo -e "single swarm node, by prompting for configuration parameters.${BLA}\n"

MainMenu
