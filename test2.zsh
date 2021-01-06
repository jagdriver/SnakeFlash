#!/bin/bash
TESTEMAIL=false

if [ $TESTEMAIL = true ]; then
    echo -e "Yes"
else
    echo -e "No"
fi


function CreateStackList()
{
COMPOSE_FILE_NAME="docker-compose.yml"
APP_LIST="SnakeApi,SnakeUtil,SnakeTimer"
IFS=','
read -ra APPS <<<"$APP_LIST"
local APPCOUNT=${#APPS[@]}
echo -e "\nStart\n"
local RESULT_LIST="["

for ((i = 0; i < $APPCOUNT; i++)) do
    if [ $i -gt 0 ]
    then
        RESULT_LIST="${RESULT_LIST},"
    fi
    printf -v RESULT '{"name":"%s","value":"%s/%s"}' "${APPS[$i]}" "${APPS[$i]}" "$COMPOSE_FILE_NAME"
    RESULT_LIST="${RESULT_LIST}$RESULT"
done
RESULT_LIST="${RESULT_LIST}]"
echo -e "$RESULT_LIST"
}


CreateStackList

echo -e "\nSlut\n"
# printf '{"hostname":"%s","distro":"%s","uptime":"%s"}\n' "$hostname" "$distro" "$uptime"
