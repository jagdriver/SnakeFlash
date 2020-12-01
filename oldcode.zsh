# #
# # Ask for Manager or Worker node
# #
# #read -p "${GR}Flash configuration for Swarm ${RD}${BO}Manager Node ${GR}or${RD} Worker Node${GR} ? m | w ${EC}${WH}> " -n 1 -r
# read -p "${GR}Flash configuration for Swarm ${RD}${BO}Manager Node ${GR}or${RD} Worker Node${GR} ? m | w ${EC}${WH}> " -n 1 -r
# if [[ $REPLY =~ ^[Mm]$ ]]; then
#    echo -e "\n"
#    #echo -e "$NODE_NAME"
#    NODE_NAME=${SWARM_NODES[0]}
#    echo -e "\n$NODE_NAME"
#    echo -e "\n$SWARM_MANAGER_NODE"
#    #echo -e "${SWARM_NODES[0]}"
# elif [[ $REPLY =~ ^[Ww]$ ]]; then
#    echo -e "\n"
#    #read -p "${GR}Select node by typing ${RD}${BO}ws02, ws03 ${GR}or ${RD}ws04 ${EC}${WH}> " -n 4 -r
#    read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
#    NODE_NAME=$REPLY
#    echo -e "\n$NODE_NAME"
# else
#    quit
# fi

# # Ready for Editing properties
# echo -e "\n"
# read -p "${GR}Are you ready for Configuring ${RD}${BO}${NODE_NAME}${GR}${EC}? ${WH}y | n >" -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#    ListProperties $NODE_NAME "Properties before editing"
#    PromptForInput $NODE_NAME
#    SetDnsStrings
#    #GetPWHash
#    ListProperties $NODE_NAME "Properties after editing"
#    EditProperties $NODE_NAME
# fi
# echo "\nFlashConfig finish"

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

# function SetDnsStrings() {
#    IFS='.'                      # Dot is set as delimiter
#    read -ra ADDR <<<"$ETH0_LAN" # str is read into an array as tokens separated by IFS
#    # WS01_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1 ws01 ws01.${INTERNAL_DOMAIN_NAME}"
#    # WS02_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.2 ws02 ws02.${INTERNAL_DOMAIN_NAME}"
#    # WS03_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.3 ws03 ws03.${INTERNAL_DOMAIN_NAME}"
#    # WS04_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.4 ws04 ws04.${INTERNAL_DOMAIN_NAME}"

#    DNS_URLS[0]="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1 ${SWARM_NODES[0]} ${SWARM_NODES[0]}.${INTERNAL_DOMAIN_NAME}"
#    DNS_URLS[1]="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.2 ${SWARM_NODES[1]} ${SWARM_NODES[1]}.${INTERNAL_DOMAIN_NAME}"
#    DNS_URLS[2]="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.3 ${SWARM_NODES[2]} ${SWARM_NODES[2]}.${INTERNAL_DOMAIN_NAME}"
#    DNS_URLS[3]="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.4 ${SWARM_NODES[3]} ${SWARM_NODES[3]}.${INTERNAL_DOMAIN_NAME}"

#    # WS01_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1"
#    # WS02_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.2"
#    # WS03_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.3"
#    # WS04_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.4"
#    IFS=' '
# }

# function SelectInputFile() {
#    echo -e "\n${GR}Select Input file with predefined properties${WH}"
#    select fav in "${INPUT_CONFIG_FILES[@]}"; do
#       # Read and parse input file
#       INPUT_FILE=$fav
#       #echo -e "SelectInputFile $fav"
#       break
#    done
# }

# function EditPasswordProperties()
# {
#    # Does not work
#    cd $1
#    pwd
#    cp user-data tmp-user-data
#    ls -l
   
#    local TMP_WIFI_PWD=$(python3 ../Artifacts/Showpw.py $WIFI_PASSWD)
#    sed -i -n "s/$WIFI_PASSWD/$TMP_WIFI_PWD/" tmp-user-data
   
#    local TMP_MANAGER_PWD=$(python3 ../Artifacts/Showpw.py $MANAGER_PASSWORD)
#    sed -i -n "s/$MANAGER_PASSWORD/$TMP_MANAGER_PWD/" tmp-user-data

#    mv tmp-user-data user-data
#    cd ..
# }

#  # Configure ETH0 LAN (Manager & Worker)
   # echo -e "\n"
   # read -p "${GR}Type ETH0 Lan${RD}${BO} default=[${ETH0_LAN}] ${WH}> "
   # if [[ -z "$REPLY" ]]; then
   #    echo -e -n "${ETH0_LAN}"
   # else
   #    ETH0_LAN=$REPLY
   #    echo -e -n "${ETH0_LAN}"
   # fi

   # #  # Configure ETH0 IP Address (Manager & Worker)
   # echo -e "\n"
   # read -p "${GR}Type ETH0 IP address${RD}${BO} default=[${ETH0_IP_ADDRESS}] ${WH}> "
   # if [[ -z "$REPLY" ]]; then
   #    echo -e -n "${ETH0_IP_ADDRESS}"
   # else
   #    ETH0_IP_ADDRESS=$REPLY
   #    echo -e -n "${ETH0_IP_ADDRESS}"
   # fi

   # #  # Configure ETH0 Static Routers (Manager & Worker)
   # echo -e "\n"
   # read -p "${GR}Type ETH0 Static Routers${RD}${BO} default=[${ETH0_STATIC_ROUTERS}] ${WH}> "
   # if [[ -z "$REPLY" ]]; then
   #    echo -e -n "${ETH0_STATIC_ROUTERS}"
   # else
   #    ETH0_STATIC_ROUTERS=$REPLY
   #    echo -e -n "${ETH0_STATIC_ROUTERS}"
   # fi

   # #  # Configure ETH0 DNS Servers (Manager & Worker)
   # echo -e "\n"
   # read -p "${GR}Type ETH0 DNS Servers${RD}${BO} default=[${ETH0_DNS_SERVERS}] ${WH}> "
   # if [[ -z "$REPLY" ]]; then
   #    echo -e -n "${ETH0_DNS_SERVERS}"
   # else
   #    ETH0_DNS_SERVERS=$REPLY
   #    echo -e -n "${ETH0_DNS_SERVERS}"
   # fi

   # function ConfigureManagerNode() {

#    # # Configure Manager name (Manager & Worker)
#    echo -e "\n"
#    read -p "${GR}Type Swarm Manager name ${RD}${BO}default=[${MANAGER_NAME}] ${WH}> "
#    if [[ -z "$REPLY" ]]; then
#       echo -e -n "${MANAGER_NAME}"
#    else
#       MANAGER_NAME=$REPLY
#       echo -e -n "${MANAGER_NAME}"
#    fi

#    # # Configure Manager password (Manager & Worker)
#    # # The password are SHA512 hashed
#    echo -e "\n"
#    GETPW=true
#    while $GETPW; do
#       read -p "${GR}Type Swarm Manager password ${WH}> "
#       if [[ -z "$REPLY" ]]; then
#          echo -e -n "You must supply password"
#       else
#          #MANAGER_PASSWORD=$(GetPWHash $REPLY)
#          MANAGER_PASSWORD=$(python3 ./Artifacts/Hidepw.py $REPLY)
#          #MANAGER_PASSWORD=$REPLY
#          echo -e -n "${MANAGER_PASSWORD}"
#          GETPW=false
#       fi
#    done

#    # # Configure Time Zone (Manager & Worker)
#    echo -e "\n"
#    read -p "${GR}Type Time Zone ${RD}${BO}default=[${TIME_ZONE}] ${WH}> "
#    if [[ -z "$REPLY" ]]; then
#       echo -e -n "${TIME_ZONE}"
#    else
#       TIME_ZONE=$REPLY
#       echo -e -n "${TIME_ZONE}"
#    fi

#    #  # Configure Traefik EntryPoint Address (Manager)
#    echo -e "\n"
#    read -p "${GR}Type Traefik Entrypoint address${RD}${BO} default=[${TRAEFIK_ENTRYPOINT_ADDRESS}] ${WH}> "
#    if [[ -z "$REPLY" ]]; then
#       echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
#    else
#       TRAEFIK_ENTRYPOINT_ADDRESS=$REPLY
#       echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
#    fi
# }

# function ConfigureWorkerNode() {
#    # First ask for node name to configure
#    echo -e "\n"
#    read -p "${GR}Select node by typing ${RD}${BO}${SWARM_NODES[1]}, ${SWARM_NODES[2]} ${GR}or ${RD}${SWARM_NODES[3]} ${EC}${WH}> " -n 4 -r
#    NODE_NAME=$REPLY

#    # Configure Docker Swarm TCP port number
#    echo -e "\n"
#    read -p "${GR}Type Swarm TCP Port number ${RD}${BO}default=[${SWARM_PORT}] ${WH}> "
#    if [[ -z "$REPLY" ]]; then
#       echo -e -n "${SWARM_PORT}"
#    else
#       SWARM_PORT=$REPLY
#       echo -e -n "${SWARM_PORT}"
#    fi
#    # Configure Swarm Worker Token (worker)
#    # The token is obtained from the Swarm Manager Node
#    echo -e "\n"
#    read -p "${GR}Paste Swarm Worker Token, obtained from Manager Node ${WH}> "
#    if [[ -z "$REPLY" ]]; then
#       echo -e -n "${SWARM_WORKER_TOKEN}"
#    else
#       SWARM_WORKER_TOKEN=$REPLY
#       echo -e -n "${SWARM_PORT}"
#    fi
# }

      # echo -e "\n$REPLY\n"
      # read -p "${GR}Type Dynamic DNS Provider ${RD}${BO} GratisDNS=1, CloudFlare=2 ${GR}or${RD} OneCom=3 ${WH}> " -n 1 -r
      # case $REPLY in
      # "1")
      #    DYNAMIC_DNS_PROVIDER="GRATISDNS"
      #    echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #    ;;
      # "2")
      #    DYNAMIC_DNS_PROVIDER="CLOUDFLARE"
      #    echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #    ;;
      # "3")
      #    DYNAMIC_DNS_PROVIDER="ONECOM"
      #    echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #    ;;
      # *)
      #    echo -e -n "\nDNS Provider not supported"
      #    ;;
      # esac

                  # ReadProperties
            # SetDateTime
            # SetNodeNames "PROMPT"
            # NODENAME_DONE=$CHECK_DONE_DEFAULT
            # SetNetAddress "AUTO"
            # ETH0_DONE=$CHECK_DONE_DEFAULT

               # Can be deleted  but must be changes in editconfig
   # WS01_IP_ADDRESS="${ETH0_LAN_NET}.1"
   # WS02_IP_ADDRESS="${ETH0_LAN_NET}.2"
   # WS03_IP_ADDRESS="${ETH0_LAN_NET}.3"
   # WS04_IP_ADDRESS="${ETH0_LAN_NET}.4"
   #


   # Set Swarm Node internal DNS Url
   # DNS_URLS[0]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.1 ${SWARM_NODES[0]} ${SWARM_NODES[0]}.${INTERNAL_DOMAIN_NAME}"
   # DNS_URLS[1]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.2 ${SWARM_NODES[1]} ${SWARM_NODES[1]}.${INTERNAL_DOMAIN_NAME}"
   # DNS_URLS[2]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.3 ${SWARM_NODES[2]} ${SWARM_NODES[2]}.${INTERNAL_DOMAIN_NAME}"
   # DNS_URLS[3]="${ETH0ADDR[0]}.${ETH0ADDR[1]}.${ETH0ADDR[2]}.4 ${SWARM_NODES[3]} ${SWARM_NODES[3]}.${INTERNAL_DOMAIN_NAME}"

   # echo -e "\n"
   # read -p "${GR}Type WLAN0 Lan${RD}${BO} default=[${WLAN0_LAN}] ${WH}> "
   # if [[ -z "$REPLY" ]]; then
   #    echo -e -n "${WLAN0_LAN}"
   # else
   #    WLAN0_LAN=$REPLY
   #    echo -e -n "${WLAN0_LAN}"
   # fi

      # DATE_ISO=$(date "+DATE: %Y-%m-%d")
   # ISO_DATE=${DATE_ISO:6:10}
   # TIME_ISO=$(date "+TIME: %H:%M:%S")
   # ISO_TIME=${TIME_ISO:6:10}


         # # # Configure External domain name (Manager)
      # echo -e "\n"
      # GETDOM=true
      # while $GETDOM; do
      #    read -p "${GR}Type External domain name ${WH}> "
      #    if [[ -z "$REPLY" ]]; then
      #       echo -e -n "You must supply external domain name"
      #    else
      #       EXTERNAL_DOMAIN_NAME=$REPLY
      #       echo -e -n "${EXTERNAL_DOMAIN_NAME}"
      #       GETDOM=FALSE
      #    fi
      # done

      # #  # Configure WLAN0 LAN (Manager)
      # echo -e "\n"
      # read -p "${GR}Type WLAN0 Lan${RD}${BO} default=[${WLAN0_LAN}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${WLAN0_LAN}"
      # else
      #    WLAN0_LAN=$REPLY
      #    echo -e -n "${WLAN0_LAN}"
      # fi

      # #  # Configure WLAN0 IP Address (Manager)
      # echo -e "\n"
      # read -p "${GR}Type WLAN0 IP address${RD}${BO} default=[${WLAN0_IP_ADDRESS}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${WLAN0_IP_ADDRESS}"
      # else
      #    WLAN0_IP_ADDRESS=$REPLY
      #    echo -e -n "${WLAN0_IP_ADDRESS}"
      # fi

      # #  # Configure WLAN0 Static Routers (Manager)
      # echo -e "\n"
      # read -p "${GR}Type WLAN0 Static Routers${RD}${BO} default=[${WLAN0_STATIC_ROUTERS}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${WLAN0_STATIC_ROUTERS}"
      # else
      #    WLAN0_STATIC_ROUTERS=$REPLY
      #    echo -e -n "${WLAN0_STATIC_ROUTERS}"
      # fi

      # #  # Configure WLAN0 DNS Servers (Manager)
      # echo -e "\n"
      # read -p "${GR}Type WLAN0 DNS Servers${RD}${BO} default=[${WLAN0_DNS_SERVERS}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${WLAN0_DNS_SERVERS}"
      # else
      #    WLAN0_DNS_SERVERS=$REPLY
      #    echo -e -n "${WLAN0_DNS_SERVERS}"
      # fi

      #  # Configure WiFi Country Code (Manager)
      # echo -e "\n"
      # read -p "${GR}Type WiFi Country Code${RD}${BO} default=[${COUNTRY_CODE}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${COUNTRY_CODE}"
      # else
      #    COUNTRY_CODE=$REPLY
      #    echo -e -n "${COUNTRY_CODE}"
      # fi

      #  # Configure WiFi SSID (Manager)
      # echo -e "\n"
      # GETSSID=true
      # while $GETSSID; do
      #    read -p "${GR}Type WiFi SSID ${WH}> "
      #    if [[ -z "$REPLY" ]]; then
      #       echo -e -n "You must provide WiFi SSID"
      #    else
      #       WIFI_SSID=$REPLY
      #       echo -e -n "${WIFI_SSID}"
      #       GETSSID=FALSE
      #    fi
      # done

      #  # Configure WiFi Password (Manager)
      # echo -e "\n"
      # GETPW=true
      # while $GETPW; do
      #    read -p "${GR}Type WiFi Password ${WH}> "
      #    if [[ -z "$REPLY" ]]; then
      #       echo -e -n "You must provide WiFi SSID"
      #    else
      #       WIFI_PASSWD=$REPLY
      #       echo -e -n "${WIFI_PASSWD}"
      #       GETPW=FALSE
      #    fi
      # done

      #  # Configure Dynamic DNS (Manager)
      # echo -e "\n"
      # read -p "${GR}Use Dynamic DNS ? ${WH}y | n > " -n 1 -r
      # if [[ $REPLY =~ ^[Yy]$ ]]; then
      #    echo -e "\n$REPLY\n"
      #    read -p "${GR}Type Dynamic DNS Provider ${RD}${BO} GratisDNS=1, CloudFlare=2 ${GR}or${RD} OneCom=3 ${WH}> " -n 1 -r
      #    case $REPLY in
      #    "1")
      #       DYNAMIC_DNS_PROVIDER="GRATISDNS"
      #       echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #       ;;
      #    "2")
      #       DYNAMIC_DNS_PROVIDER="CLOUDFLARE"
      #       echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #       ;;
      #    "3")
      #       DYNAMIC_DNS_PROVIDER="ONECOM"
      #       echo -e -n "\n${DYNAMIC_DNS_PROVIDER}"
      #       ;;
      #    *)
      #       echo -e -n "\nDNS Provider not supported"
      #       ;;
      #    esac

      #  # Configure Dynamic DNS User Name (Manager)
      # echo -e "\n"
      # GETUSR=true
      # while $GETUSR; do
      #    read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} DNS User Name ${WH}> "
      #    if [[ -z "$REPLY" ]]; then
      #       echo -e -n "You must provide DNS user name"
      #    else
      #       DYNAMIC_DNS_USER=$REPLY
      #       echo -e -n "${DYNAMIC_DNS_USER}"
      #       GETUSR=false
      #    fi
      # done

      #  # Configure Dynamic DNS User Password (Manager)
      #    echo -e "\n"
      #    GETPW=true
      #    while $GETPW; do
      #       read -p "${GR}Type ${DYNAMIC_DNS_PROVIDER} Dynamic DNS User Password${RD}${BO} default=[${DYNAMIC_DNS_PASSWD}] ${WH}> "
      #       if [[ -z "$REPLY" ]]; then
      #          echo -e -n "You must provide Dynamic DNS user password"
      #       else
      #          DYNAMIC_DNS_PASSWD=$REPLY
      #          echo -e -n "${DYNAMIC_DNS_PASSWD}"
      #          GETPW=false
      #       fi
      #    done
      # else
      #    echo -e -n "No Dynamic DNS"
      # fi

      #  # Configure ACME Email Address (Manager)
      # echo -e "\n"
      # read -p "${GR}Type ACME Email Address${RD}${BO} default=[${ACME_EMAIL_ADDRESS}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${ACME_EMAIL_ADDRESS}"
      # else
      #    ACME_EMAIL_ADDRESS=$REPLY
      #    echo -e -n "${ACME_EMAIL_ADDRESS}"
      # fi

      #  # Configure Traefik EntryPoint Address (Manager)
      # echo -e "\n"
      # read -p "${GR}Type Traefik Entrypoint address${RD}${BO} default=[${TRAEFIK_ENTRYPOINT_ADDRESS}] ${WH}> "
      # if [[ -z "$REPLY" ]]; then
      #    echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
      # else
      #    TRAEFIK_ENTRYPOINT_ADDRESS=$REPLY
      #    echo -e -n "${TRAEFIK_ENTRYPOINT_ADDRESS}"
      # fi
