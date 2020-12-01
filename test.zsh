#!/bin/bash
# Test of Select and Case statement for easy
# UI selection.
#
# SWARM_NODES=("ws01" "ws02" "ws03" "Quit")
# PS3='Choose your favorite food: '
# select fav in "${SWARM_NODES[@]}"; do
#     case $fav in
#     "${SWARM_NODES[0]}")
#         echo "Americans eat roughly 100 acres of $fav each day!"
#         # optionally call a function or run some code here
#         ;;
#     "${SWARM_NODES[1]}")
#         echo "$fav is a Vietnamese soup that is commonly mispronounced like go, instead of duh."
#         # optionally call a function or run some code here
#         ;;
#     "${SWARM_NODES[2]}")
#         echo "According to NationalTacoDay.com, Americans are eating 4.5 billion $fav each year."
#         # optionally call a function or run some code here
#         break
#         ;;
#     "${SWARM_NODES[3]}")
#         echo "User requested exit"
#         exit
#         ;;
#     *) echo "invalid option $REPLY" ;;
#     esac
# done

# Test file copy operation
# INPUT_TEMPLATE="./Artifacts/user-data1.mvt"
# echo -e "\n"
# read -p "${GR}Type new file name${WH}> "
# # Check that $REPLY is not empty
# if [[ $REPLY != "" ]]; then
#     # And that we are not overwriting the current template file
#     if [[ "./Artifacts/$REPLY.mvt" != $INPUT_TEMPLATE ]]; then
#         echo 'WaveSnake Template File' >./Artifacts/$REPLY.mvt
#         while read line; do
#             echo $line >>"./Artifacts/$REPLY.mvt"
#         done <$INPUT_TEMPLATE

#         INPUT_TEMPLATE="$REPLY.mvt"
#         echo -e "New Template file: $INPUT_TEMPLATE"
#     fi
# fi

# Test of state menu
# echo -e "\xE2\x9C\x94 existing"
# echo -e "\xE2\x9D\x8C missing"
# CHECK_DONE="\xE2\x9C\x94"
# CHECK_UNDONE="\xE2\x9D\x8C"

# WLAN0_DONE=$CHECK_DONE
# ETH0_DONE=$CHECK_DONE
# MANAGER_DONE=$CHECK_UNDONE
# USB_DONE=$CHECK_DONE
# EDIT_DONE=$CHECK_DONE

# echo -e "____________________________________________\n"
# echo -e "WLan0[$WLAN0_DONE] | Eth0 [$ETH0_DONE] | Manager[$MANAGER_DONE] | USB[$USB_DONE]  | EDIT[$EDIT_DONE]"
# echo -e "____________________________________________\n"

# Test of USB UUID
   echo -e ""
   read -p "${GR}Mount USB stick, and type return ${WH}> "
   echo -e "____________________________________________\n"
   diskutil list
   echo -e "____________________________________________\n"

   DISKS=($(diskutil list | grep -o '^/dev[^ ]*'))
  
   #echo -e "ONE: ${DISKS[3]}"
   echo -e ""
   echo -e "Look at above list and Select the Disk you want to Flash."
   echo -e "Look for the labe HypriotOS."
   echo -e "Be carefull, the Disk is overwritten!!!"
   echo -e ""
   #DISK_MENU=(${DISKS[@]})

   select fav in "${DISKS[@]}"; do
         case $fav in
         *)
            echo -e "_____________________________ You have choosen to Flash $fav _______________\n"
            diskutil info $fav
            echo -e "____________________________________________________________________________\n"
            
         break
         ;;
         esac
      done




   #INFO=($(diskutil info ${DISKS[3]}))

   IFS=' '
   read -ra INFO <<<"$(diskutil info ${DISKS[3]})"
   
   echo -e "TWO: ${INFO[0]}"
   # Get length of DISKS

   # Find all disks and put them into array
   USB_STR=$(diskutil list | grep -i -w 'hypriotos' | cut -c 69-)
   # For each disk get info
   UUID_STR=$(diskutil info $USB_STR | grep -i -w 'Volume UUID:' | cut -c 31-)
   # ask user to choose
   echo -e "USB Drive: $USB_STR"
   echo -e "USB UUID: $UUID_STR"
