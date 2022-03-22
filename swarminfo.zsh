#!/usr/bin/env bash

# Manager input
function ManagerInput()
{
INFO=$(zenity --forms  \
	--text="Enter swarm Info." \
	--separator="," \
	--add-entry="Manager Name" \
	--add-password="Manager password" \
	--add-entry="Manager Email"  &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
echo "INFO: $INFO" 
}

function DNSInput()
{
 INFO=$(zenity --forms  \
	--text="Enter swarm Info." \
	--separator="," \
	--add-entry="External Domain name" \
	--add-password="Internal Domain name"  &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
echo "INFO: $INFO"    
}

function NetworkInput()
{
 INFO=$(zenity --forms  \
    --title="SnakeFlash Network Information" \
	--text="Enter swarm network info" \
	--separator="," \
	--add-entry="External Network [192.168.1.0/24]" \
	--add-entry="External Gateway [192.168.1.1]" \
    --add-entry="Internal Network [172.16.0.1]" \
    --add-entry="Internal Gateway [172.16.1.1]" \
    --add-entry="Docker Host bind address [192.168.1.1]"  &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)  
echo "INFO: $INFO" 
}

NetworkInput