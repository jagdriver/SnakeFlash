#!/bin/bash
DDNS="ONE TWO TREE"
IFS=' '
read -r -a DDNS_LIST <<< "$DDNS"
len=${#DDNS_LIST[@]}
ALL_LIST=${DDNS_LIST[@]}

sed -i -n "s/DDNS-LIST/$ALL_LIST/" test1file

echo "Finish"

function ReadFile() {
    source "./Artifacts/swarmproperties.mvf"
    ACCESSORY_SERVICES=$ACCESSORY_SERVICES
}

#sed "s#\"#'#g" $ACCESSORY_SERVICES
ReadFile

RESULT_STRING=$(echo | sed "s/\"/\'/g" <<<"$ACCESSORY_SERVICES")

#echo | sed "s/\"/'/g" <<<"$ACCESSORY_SERVICES"

#echo "$RESULT_STRING"

#RESULT_STRING$(echo "$ACCESSORY_SERVICES" | sed -r "s#\"#'#g#$ACCESSORY_SERVICES")
#line=$(sed -n '2p' myfile)
#echo $LINE | sed -e "s/12345678/"$replace"/g"

sed -i -n "s#SERVICES-LIST#$RESULT_STRING#" test1output

echo "$TEKST"