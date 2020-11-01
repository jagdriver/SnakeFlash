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
echo -e "\xE2\x9C\x94 existing"
echo -e "\xE2\x9D\x8C missing"
CHECK_DONE="\xE2\x9C\x94"
CHECK_UNDONE="\xE2\x9D\x8C"

WLAN0_DONE=$CHECK_DONE
ETH0_DONE=$CHECK_DONE
MANAGER_DONE=$CHECK_UNDONE
USB_DONE=$CHECK_DONE
EDIT_DONE=$CHECK_DONE

echo -e "____________________________________________\n"
echo -e "WLan0[$WLAN0_DONE] | Eth0 [$ETH0_DONE] | Manager[$MANAGER_DONE] | USB[$USB_DONE]  | EDIT[$EDIT_DONE]"
echo -e "____________________________________________\n"