#!/bin/bash
# grab the manager and worker token
MANAGER_TOKEN=$(docker swarm join-token manager -q)
WORKER_TOKEN=$(docker swarm join-token worker -q)

FILE="jointoken.txt"

/bin/cat <<EOM >$FILE
MANAGER_JOIN_TOKEN = ${MANAGER_TOKEN}
WORKER_JOIN_TOKEN = ${WORKER_TOKEN}
EOM
