#!/bin/bash
 
#str="192.168.1.17"
str=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2)
IFS='.' # space is set as delimiter
read -ra ADDR <<< "$str" # str is read into an array as tokens separated by IFS
# for i in "${ADDR[@]}"; do # access each element of array
#     echo "$i"
# done
# echo "Byte0: " ${ADDR[0]}
# echo "Byte0: " ${ADDR[1]}
# echo "Byte0: " ${ADDR[2]}

#MY_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.${ADDR[3]}"
WLAN0_LAN="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.0/24"
WLAN0_IP_ADDRESS="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.230"
#echo -e "$MY_IP_ADDRESS"
#echo -e "$MY_IP_NETWORK"
#WLAN0_LAN=$MY_IP_NETWORK
echo -e "$WLAN0_LAN"
echo -e "$WLAN0_IP_ADDRESS"
INTERNAL_DOMAIN_NAME="wavesnake.local"
#192.168.8.1 ws01 ws01.INTERNAL-DOMAIN-NAME
WS01_DNS_STRING="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1 ws01 ws01.${INTERNAL_DOMAIN_NAME}"
echo -e "$WS01_DNS_STRING"
MANAGER_PASSWORD=$(python3 -c "import crypt; print(crypt.crypt('wavesnake', crypt.mksalt(crypt.METHOD_SHA512)))")
echo -e "${MANAGER_PASSWORD}"

echo -e "\nDate handling"
DATE_ISO=$(date "+DATE: %Y-%m-%d")
ISO_DATE=${DATE_ISO:6:10}

TIME_ISO=$(date "+TIME: %H:%M:%S")
ISO_TIME=${TIME_ISO:6:10}


echo -e ${DATE_ISO} ${ISO_DATE}  ${TIME_ISO}
