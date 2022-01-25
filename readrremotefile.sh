#!/bin/bash
#  
# Read Swarm Join Token from Manager Node
# File format: 
# SWARM_JOIN_TOKEN="<Join-Token>"
# WORKER_JOIN_TOKEN="<worker-join-token>"
#    

FILE_PATH="sn02/swarmid.mvf"
scp manager@192.168.1.240:/opt/containers/configuration/jointokens.txt ${FILE_PATH}
input="sn02/swarmid.txt"
while IFS= read -r line
do
  echo "$line"
done < "$input"


function ReadProperties() 
{
    source "${FILE_PATH}"

    SWARM_JOIN_TOKEN=$SWARM_JOIN_TOKEN
    WORKER_JOIN_TOKEN=$WORKER_JOIN_TOKEN
}

ReadProperties

echo "SWARM $SWARM_JOIN_TOKEN"
echo "WORKER $WORKER_JOIN_TOKEN"
