#! /bin/bash
cd /Users/nielsjorgennielsen/Flashing

#TEST="curl -s https://api.wavesnake.dk/account/test" 
#RESPONSE=`$TEST`
#echo  $RESPONSE


diskutil list
 
echo "\n"
read -p "Look at the Disk list, and type the Disk to flash the image to > " 

echo "You have choosen" $REPLY "which will be overridden!!!!" 
echo "\n"
DISK=$REPLY

read -p "Are you ready for Flashing WS01? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS01
   #echo "\n Flashing to WS01...\n"
   flash --force  --userdata user-data --metadata meta-data -d $DISK  ../hypriotos-rpi-v1.10.0.img   
   cd ..
   echo "\n"
fi
echo "\n"
read -p "Are you ready for Flashing WS02? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS02
   echo "\n Flashing to WS02...\n"
   flash --force --userdata user-data --metadata meta-data -d $DISK  ../hypriotos-rpi-v1.10.0.img
   cd ..
   echo "\n"
fi
echo "\n"
read -p "Are you ready for Flashing WS03? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS03
   #echo "\n Flashing to WS03...\n"
   flash --force --userdata user-data --metadata meta-data -d $DISK  ../hypriotos-rpi-v1.10.0.img
   cd ..
   echo "\n"
fi
echo "\n"
read -p "Are you ready for Flashing WS04? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS04
   #echo "\n Flashing to WS04...\n"
   flash --force --userdata user-data --metadata meta-data -d $DISK  ../hypriotos-rpi-v1.10.0.img
   cd ..
   echo "\n"
fi
echo "\n"

read -p "Are you ready for Flashing WS05? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS05
   #echo "\n Flashing to WS05...\n"
   flash --force --userdata user-data --metadata meta-data -d $DISK  ../hypriotos-rpi-v1.10.0.img
   cd ..
   echo "\n"
fi
echo "\n"

read -p "Are you ready for Flashing WS06? y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   cd WS06
   #echo "\n Flashing to WS06...\n"
   flash --force --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  ../hypriotos-rpi-v1.12.0.img
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
   flash --force --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  ../hypriotos-rpi-v1.12.0.img
   #flash --force --userdata user-data --metadata meta-data --file keyfile.txt  -d $DISK  /Volumes/Backup/SDCard/sdcard13.dmg

   cd ..
   echo "\n"
fi

echo "\n"

echo 

