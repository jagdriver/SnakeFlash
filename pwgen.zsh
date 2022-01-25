#!/bin/bash
#      
MANAGER_PASSWORD="wavesnake"
MANAGER_NAME="njnsvc"
MQTT_USER_PASSWORD=$(/usr/local/Cellar/php@8.0/8.0.14/bin/php ./pwdhash.php $MANAGER_NAME $MANAGER_PASSWORD MQTT)
echo "${MQTT_USER_PASSWORD}"