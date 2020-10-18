#! /bin/bash

# WaveSnake Technologies 2020-03-06
# This utility flashes Micro SD cards
# for Raspberry Pi's, based on images from
# Hypriot.
#
diskutil list 
echo -e "\n"
read -p "Look at the Disk list, and type the Disk to flash the image to > " 

echo -e "You have choosen" $REPLY "which will be overridden!!!!" 
echo -e "\n"
DISK=$REPLY

read -p "Select Node to flash, ws01, ws02, ws03 or ws04 > " 
echo -e "You have choosen $REPLY"
echo -e "\n"
NODE=$REPLY

read -p "Are you ready for Flashing $NODE? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd $NODE
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.3/hypriotos-rpi-v1.12.3.img.zip   
   cd ..
   echo -e "\n"
fi
echo -e "\nLeaving Flash...\n"

