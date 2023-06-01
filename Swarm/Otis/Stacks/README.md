![HomeGuide Dashboard](/Artifacts/wavesnake.png)

# Table of contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Stacks](#stacks)
    1. [SnakeConfig](#snakeconfig)
    2. [SnakeUtil](#snakeutil)
    3. [SnakeApi](#snakeapi)
    4. [SnakeTimer](#snaketimer)
    5. [SnakeRule](#snakerule)
    6. [SnakeHistory](#snakistory)
    7. [Redis](#redis)
    8. [RedisReplica](#redisreplica)
    9. [Mosquitto](#mosquitto)
    10. [MariaDB](#mariadb)
    11. [Apache](#apache)

## Introduction <a name="introduction"></a>
This is a combined project for all SnakeHome Docker Stack's. Here you can read about installing the Docker containers onto your SnakeSwarm.

## Installation <a name="installation"></a>
The installation of Docker Stacks is done from Portainer Dashboard, by going into **Stacks** -> **Add stack** and filling out the nescessary information. Before you get into action, gather together the information you will need.


**Name**: The name of the stack example: SnakeConfig

**Repository URL**: example: https://github.com/jagdriver/Stacks.git

**Compose path**: example: SnakeConfig/docker-compose.yml

At this moment the repository are private, so we need Authentication.

**Username**: MyUser

**Password**: xxxxxxxx

Thats all, when this information is in place, you can proceed.

Select **git Repository**, fill in the information and click **Deploy the stac**

## Stacks <a name="stacks"></a>
### SnakeConfig <a name="snakeconfig"></a>
Swarm configuration utility.
### SnakeUtil <a name="snakeutil"></a>
Swarm DNS and file synchronization utility.
### SnakeApi <a name="snakeapi"></a>
General API for managing Home Accessories.
### SnakeTimer <a name="snaketimer"></a>
Timer applicatopn to support rules with timers.
### SnakeRule <a name="snakerule"></a>
Rule engine, managing the rule base.
### SnakeHistory <a name="snakehistory"></a>
History engine, save and retrieve accessory and group history.
### Redis <a name="redis"></a>
Swarm in memory key/value store.
### Redis Replica <a name="redisreplica"></a>
Swarm in memory replica key/value store.
### Mosquitto <a name="mosquitto"></a>
Swarm Message Broker. 
### MariaDB <a name="mariadb"></a>
Swarm DB.
### Apache <a name="apache"></a>
Accessory sketch store and OTA update repository.
