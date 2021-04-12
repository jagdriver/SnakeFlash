#!/usr/bin/env bash

zenity --password &
zenity_pid=$!
osascript<<EOF
tell application "System Events"
    set processList to every process whose unix id is $zenity_pid
    repeat with proc in processList
        set the frontmost of proc to true
    end repeat
end tell
EOF
# Can't use fg by default, that's for interactive shells.
# But this waits for all background processes to finish.
wait