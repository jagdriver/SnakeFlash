#! /bin/bash
#cd /Users/nielsjorgennielsen/Flashing

#TEST="curl -s https://api.wavesnake.dk/account/test" 
#RESPONSE=`$TEST`
#echo  $RESPONSE

# TODO: Ask for Swarm or Single SD flashing and node name


diskutil list
 
echo -e "\n"
read -p "Look at the Disk list, and type the Disk to flash the image to > " 

echo -e "You have choosen" $REPLY "which will be overridden!!!!" 
echo -e "\n"
DISK=$REPLY

read -p "Are you ready for Flashing WS01? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd ws01
   #echo "\n Flashing to WS01...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   cd ..
   echo -e "\n"
fi
echo -e"\n"
read -p "Are you ready for Flashing WS02? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd ws02
   echo -e "\n Flashing to WS02...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   cd ..
   echo "\n"
fi
echo "\n"
read -p "Are you ready for Flashing WS03? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd ws03
   #echo "\n Flashing to WS03...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   cd ..
   echo "\n"
fi
echo "\n"
read -p "Are you ready for Flashing WS04? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd ws04
   #echo "\n Flashing to WS04...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   cd ..
   echo "\n"
fi
echo "\n"

read -p "Are you ready for Flashing WS05? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS05
   #echo "\n Flashing to WS05...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   cd ..
   echo "\n"
fi
echo "\n"

read -p "Are you ready for Flashing WS06? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS06
   #echo "\n Flashing to WS06...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip   
   #flash --force --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  /Volumes/Backup/SDCard/sdcard13.dmg

   cd ..
   echo "\n"
fi
echo "\n"

read -p "Are you ready for Flashing WS07? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS07
   #echo "\n Flashing to WS07...\n"
   # TODO: Get the Hypriot image from https://github.com/hypriot/image-builder-rpi/releases/download/v1.12.0/hypriotos-rpi-v1.12.0.img.zip
   lash --forfce --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  ../hypriotos-rpi-v1.12.0.img
   #flash --force --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  /Volumes/Backup/SDCard/sdcard13.dmg

   cd ..
   echo "\n"
fi

echo "\n"

echo 

