#!/bin/bash
# Read Swarm Token from Manager Node ( Working Fine)
TOKEN=$(ssh manager@192.168.1.240 "docker swarm join-token worker --quiet |  awk  '{  print $1 }'")
echo "TEST: $TOKEN"