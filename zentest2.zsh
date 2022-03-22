#!/usr/bin/env bash
#
# Please be aware that zenity popup windows always start at position 0,0
#


#xx=$(zenity --password )
#echo "Password: $xx"


 #!/bin/bash
# This will wait one second and then steal focus and make the Zenity dialog box always-on-top (aka. 'above').

(sleep 1 && wmctrl -F -a "I am on top" -b add,above ) &
(zenity --info --title="I am on top" --text="How to help Zenity to get focus and be always on top")