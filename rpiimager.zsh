#!/bin/sh
# Starts Raspbery Pi Imager
#
# After imaging the OS we write files to the /boot partition
#

  echo -e "\n"
   read -e -p "Type swarm name"

   echo -e "\n You typed: $REPLY"
   echo -e "\n"


TEST=$(/Applications/Utilities/Raspberry\ Pi\ Imager.app/Contents/MacOS/rpi-imager)

  echo -e "\n"
   read -e -p "Type swarm name"

   echo -e "\n You typed: $REPLY"
   echo -e "\n"
