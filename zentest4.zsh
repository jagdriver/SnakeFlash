#!/bin/sh
#--title="FRIEND"

function ShowApplications()
{
APPLICATION=$(zenity --list \
    --title="Select the application" \
  --column="Application Name" --column="Description" \
    SnakeApi "Manager Node"\
    SnakeConsole "Worker Node"\
    SnakeConfig  "Worker Node" &
    osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
}
function ShowNodes()
{
NODE=$(zenity --list \
    --title="Select the Node for $APPLICATION" \
    --column="Node Name" --column="Description" \
    sn01 "Manager Node"\
    sn02 "Worker Node"\
    sn03  "Worker Node" &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
}

function SelectTemplate()
{
TEMPLATE_FILE=$(zenity --list \
    --title="Select configuration template" \
    --column="Configuration file Name" --column="Description" \
    managertemplate.yaml "Template for generating Manager node"\
    workertemplate.yaml "Template for generating Worker node" &
osascript<<EOF
tell application "System Events"
    set frontmost of process "zenity" to true
    keystroke "1" using command down
    delay 0.2
end tell
EOF
)
}



ShowApplications
echo "Application: $APPLICATION"

ShowNodes
echo "Node: $NODE"

SelectTemplate
echo "Template: $TEMPLATE_FILE"
