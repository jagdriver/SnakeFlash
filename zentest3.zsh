#!/bin/sh
#--title="FRIEND"
xx=$(zenity --forms  \
    --title="Swarm Properties" \
	--text="Enter Swarm properties." \
	--separator="," \
    --add-entry="Node type, Manager or Worker [Manager]" \
	--add-entry="Manager Name [manager]" \
    --add-password="Manager password" \
	--add-entry="Node Name [sn01]" \
	--add-entry="Email" \
	--add-calendar="Birthday" &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
echo "Form Data: $xx"
case $? in
    0)
        echo "Friend added.";;
    1)
        echo "No friend added."
	;;
    -1)
        echo "An unexpected error has occurred."
	;;
esac