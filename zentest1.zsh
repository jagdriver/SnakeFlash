#!/usr/bin/env bash
#
# Please be aware that zenity popup windows always start at position 0,0
#


xx=$(zenity --password &
zenity_pid=$!
osascript<<EOF
# tell application "System Events"
#     tell application process "Terminal"
#         click menu item (zenity) of menu of menu bar item "Window" of menu bar 1
# end tell
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
echo "Password: $xx"
echo "zenity PID: $zenity_pid
"
# Can't use fg by default, that's for interactive shells.
# But this waits for all background processes to finish.
wait
