![HomeGuide Dashboard](/Artifacts/wavesnake.png)

# Table of contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
    1. [ESP Hardware](#esphardware)
    2. [ESP Software](#espsoftware)
    3. [RPI  Hardware](#rpihardware)
        1. [Hardware list](#hardwarelist)
    4. [RPI Software](#software)
        1. [Redis](#redis)
        2. [SnakeApi](#snakeapi)
        3. [SnakeTimer](#snaketimer)
        4. [SnakeRule](#snakerule)
        5. [SnakeConfig](#snakeconfig)
        6. [SnakeConsole](#snakeconsole)
        7. [SnakeHistory](#snakehistory)
        8. [SnakeUtil](#snakeutil)
    5. [GIT Repository](#gitrepository)   
3. [Configuration](#configuration)
    1. [Setup guide](#setupguide)
    2. [Flashing SD Cards](#flash)
    3. [Booting the RPI's](#boot)
4. [Install Docker Images](#dockerimages)
5. [Swarm Illustration](#swarmillustration)
6. [Features](#features)
    1. [Complete Dockerized Swarm setup](#dockerized)
    2. [Prompted setup & flashing og Manager and Worker nodes](#prompted)
    3. [SSH login with pregenerated keys](#sshlogin)
    4. [Password Hash login](#passwdhash)
    5. [Automatic IP address & network detection](#autoip)
    6. [Isolated Swarm network](#isolated)
    7. [Automated Certificate handling](#certgen)
    8. [Configuration documentation](#configdocumentation)

## SnakeHome <a name="introduction"></a>
SnakeHome is the platform for hobbyist, who want the possibility to create their own IoT devices, but lack the background infrastructure, to integrate these devices into a manageable platform. I've put together some of the best tools available, written som apps, services, sketches and scripts, tested a lot, out came the SnakeHome management system, and it's free.

I would like to thank:
Matt Williams for creating Flash utility.
All people at Hypriot for creating the Hypriot Docker Image for Raspberry Pi.


The system consists of:
- Sketches for initializing/configuring ESP8266/ESP32.
- Sketches for Temperature, Humidity, Gate ontroller, Gas Burner ontroller and Water Pump controller.
- Bash script for configuring and flashing MicroSD cards for a RaspBerry PI Docker Swarm Cluster.   
- Docker images for Swarm applications.
- Web application for managing/monitoring Swarm applications.
- Web application for User setup/management of WaveSnake Home Management System.
- IoS application for User setup/management of WaveSnake Home Management System.

## Features <a name="features"></a>

- ### Complete Containerized Swarm setup <a name="dockerized"></a>

- ### Prompted setup & flashing of Manager and Worker nodes <a name="prompted"></a>

- ### Dynamic DNS <a name="dynamicdns"></a>

- ### SSH login with pregenerated keys <a name="sshlogin"></a>

- ### Password Hash login <a name="passwdhash"></a>

- ### Automatic IP address & network detection <a name="autoip"></a>

- ### Isolated Swarm network <a name="isolated"></a>

- ### Automated Certificate handling <a name="certgen"></a>

## Prerequisites <a name="prerequisites"></a>
prerequisites: Mac, Windows or Linux, Visual Studio Code with some extensions (free). 

### ESP hardware <a name="esphardware"></a>

| Hardware                | Count         | Prise DKr           |
| ----------------------- | ------------- | ------------------- |  
| ESP8266 E12 Module      | 1             | 30                  |
| ESP8266 Dev Module      | 1             | 30                  |
| ESP32 Module            | 1             | 20                  |
| ESP32 Dev Module        | 1             | 50                  |


ESP8266 & ESP32 are manufactored by Espressif. For detailed documentation
se here https://www.espressif.com.

### ESP software <a name="espsoftware"></a>
ESP development environment consists of:
1. Arduino development environment
2. Visial Studio Code
3. Extension 

### RPI hardware <a name="rpihardware"></a>
RaspberryPI hardware are rapildy developing and as of now, the hardware of choice is RPI 4 with 4 GB memory. Resonoly priced at 480 DKr. 

#### List of hardware <a name="hardwarelist"></a>

| Hardware                | Count         | Prise DKr           |
| ----------------------- | ------------- | ------------------- |  
| RPI 3B or 4B            | 4             | 1200-2000           |
| Micro SD Card 16 GB     | 4             | 200                 |
| Cluster case 4 Node     | 1             | 170                 |
| Mean Well power supply  | 1             | 180                 |
| Tenda network switch    | 1             | 90                  |
| Ethernet cables 25cm    | 4             | 100                 |
| USB-A to Micro USB 25cm | 4             | 200                 |
| USB to DC cable 25cm    | 1             | 25                  |
| APC Nobreak 500         | 1             | 450                 |
| Arcryllic Enclosure     | 1             | 900                 |
| Amount DKr              |               | 3,700 - 4,500       |

### Toolchain<a name="tools"></a>
The nescessary tools for building/installing the SnakeSwarm project and developing Sketches for ESP8266/ESP32  
1. Visual Studio Code for Mac, latest version with some extensions: 
2. Python3 
3. Arduino for Visual Studio Code
4. C/C++
5. ms-vscode.cpptools
6. lukasz-wronski.ftp-sync
7. ms-azuretools.vscode-docker
8. sprdp.remote-browser
9. jchannon.csharpextensions
10. .gitignore generator
11. ronaldosena.arduino-snippets
12. vsciot-vscode.vscode-arduino
13. Bash debug

You can paste above extension id's into VSCode extension search box, and from there
install the extensions.

### RPI software <a name="software"></a>
The software running on the RPI's are all Docker Containers, installed onto the RPI from within Portainer console. 
Traefik and Portainer are installed at boot time, and will be available after swarm initialization.

#### Redis  <a name="redis"></a>
Redis are the in memory cache, where all application configuration are stored. All applications read their configuration from Redis at startup. When an application configuration are changed via SnakeConfig, and saved to Redis, the application container must be restarted to reflect the new configuration.

#### SnakeApi  <a name="snakeapi"></a>
SnakeApi are the general API for manipulating Homes, Rooms and Accessories. 

#### SnakeTimer  <a name="snaketimer"></a>
SnakeTimer is the backend service that executes timed actions, setup via SnakeApi and SnakeRule.

#### SnakeRule  <a name="snakerule"></a>
SnakeRule are the background service that creates and updates the rule DB and also updates the rule DB ingredients.  

#### SnakeConfig  <a name="snakeconfig"></a>
SnakeConfig are the Manager UI that configures the Swarm and Applications. There are also a UI for visualizing the Swarm Containers, and log files.

#### SnakeConsole  <a name="snakeconsole"></a>
SnakeConsole are the User UI, for creating Homes, Rooms and Accessories.

#### SnakeHistory  <a name="snakehistory"></a>
SnakeHistory are the background service that updates the history DB.

#### SnakeUtil  <a name="snakeutil"></a>
SnakeUtil are the background service that executes nescessary Swarm file synchronizations, and dynamic DNS updates. This is to say that you don't need at static IP address, if your hosting provider allows dynamic DNS update. If that's not the case, you can update the DNS records your self.

#### Git Repository  <a name="gitrepository"></a>
Repository URL: https://github.com/jagdriver/Stacks.git

Compose path: /SnakeConfig/docker-compose.yml

### Flashing Setup guide  <a name="setupguide"></a>
The initial setup and flashing of the SnakeHome Swarm includes below steps.

- Download [this](https://github.com/jagdriver/SnakeFlash "this link") project from GitHub. Copy the project content into a folder called Flashing.

- Next, read the documentation on Swarm Configuration before going into actual setup steps.

- Download the latest HypriotOS from this url https://blog.hypriot.com/downloads/

- Format an MicroSD card, preferrably 16GB, and give it the name HypriotOS. Se the format description here.

- Edit swarmproperties.mvf but be carefull not to jeopardise the file.

- CD into Flashing directory

- Execute ./flash-config.zsh. Read the flash config instruction here.

### Flashing to SD cards <a name="flash"></a>
Run flash-swarm.zsh to flash the node images to micro SD cards, please have the cards ready an properly marked, 1 to 4. You can flash all at once, or one at a time.

### Booting the RPI's <a name="boot"></a>
Put the SD cards in Your Raspberry Pi's and turn them on.
I suggest that You turn them on one at a time, while connecting a monitor to the HDMI port to watch the boot process.

Voila, Your ShakeHome Swarm is up and running.

## Install Docker Images <a name="dockerimages"></a>
The next step is to install Docker Images and instantiating Containers from within Portainer console.

## Configuration documentation <a name="configdocumentation"></a>

The configuration starts with preparing the information going into the configuration process. 
You can find the properties in the file Artifacts/swarmconfig.mvf.
test test


## Swarm Illustration <a name="swarmillustration"></a>
![Swarm Illustration](/Artifacts/Swarm.png)



# WaveSnake Swarm Properties

### You can change the Noded name prefix here eg. sn
- NODENAME_PREFIX="ws0"

### Number of nodes in the Swarm
- NODENAME_COUNT="4"

### Change the WLAN0 address here. The script auto detects the current lan address, so you just set the last byte of the IP address.
- WLAN0_IP_ADDRESS_LAST_BYTE="230"

### Set the internal Swarm IP net.
- INTERNAL_SWARM_IP_NET="192.168.230.0"

### --- New Properties section

### MANAGER Properties
- MANAGER_NAME="manager"
- MANAGER_PASSWORD="your manager password"
- MANAGER_ENCRYPTED_PASSWORD="$6$$lkFOYhhCGZiVmaOiZxSrpcvun.YOgyWuin0l0/aHRkep9sHrMTVp4uzHsAkTIJ.q3c8RuTA.NUNE8yqrh72O5/"

### Node properties
- NODE_NAME="ws01"
- SWARM_LOCALE="en_US.UTF-8"
- IME_ZONE="Europe/Copenhagen"

### Docker Swarm properties
- SWARM_MANAGER_NODE="ws01"
- SWARM_PORT="2377"
- SWARM_INTERFACE="eth0"
- SWARM_WORKER_TOKEN="SWMTKN-1-6cyk7y11vbx3e8sc5b8iqiao7sb9iyr8b2lheybtyjqhb8mfho-5bracqtjvzt2zcn7m0qp5w27w"
- SWARM_MANAGER_TOKEN="SWMTKN-1-6cyk7y11vbx3e8sc5b8iqiao7sb9iyr8b2lheybtyjqhb8mfho-cgxcsuzfarwy7m3eypj542pi1"

### Swarm Application DNS Prefix's
- API_PREFIX="api"
- DB_PREFIX="sql"
- MQTT_PREFIX="mqt"
- SKETCH_PREFIX="sketch"

### Swarm External Application URL's
- API_SERVER_URL="api.wavesnake.dk"
- DB_SERVER_URL="sql.wavesnake.dk"
- MQTT_SERVER_URL="mqt.wavesnake.dk"
- SKETCH_SERVER_URL="sketch.wavesnake.dk"

### Swarm Internal Application URL's
- INTERNAL_API_SERVER_URL="api.wavesnake.local"
- INTERNAL_DB_SERVER_URL="sql.wavesnake.local"
- INTERNAL_MQTT_SERVER_URL="mqt.wavesnake.local"
- INTERNAL_SKETCH_SERVER_URL="sketch.wavesnake.local"

### WiFi properties
- COUNTRY_CODE="DK"
- WIFI_SSID="Your WiFi ssid"
- WIFI_PASSWD="Your WiFi password"

### Swarm Node ETH0 properties
- ETH0_LAN="192.168.230.0/24"
- ETH0_IP_ADDRESS="192.168.230.1"
- ETH0_STATIC_ROUTERS="192.168.230.1"
- ETH0_DNS_SERVERS="8.8.8.8 8.8.4.4"

### Node names
- #WS01_NODE_NAME="ws01"
- #WS02_NODE_NAME="ws02"
- #WS03_NODE_NAME="ws03"
- #WS04_NODE_NAME="ws04"

### Swarm Node IP Address
- WS01_IP_ADDRESS="192.168.230.1"
- WS02_IP_ADDRESS="192.168.230.2"
- WS03_IP_ADDRESS="192.168.230.3"
- WS04_IP_ADDRESS="192.168.230.4"

### Manager Node WLAN0 properties
- WLAN0_LAN="192.168.1.0/24"
- WLAN0_IP_ADDRESS="192.168.1.220"
- WLAN0_STATIC_ROUTERS="192.168.1.1"
- WLAN0_DNS_SERVERS="8.8.8.8 8.8.4.4"

### Domain properties
INTERNAL_DOMAIN_NAME="wavesnake.local"
EXTERNAL_DOMAIN_NAME="Your external domain name"

### Dynamic DNS properties
DYNAMIC_DNS_PROVIDER="1"
DYNAMIC_DNS_USER="Your GratisDNS user"
DYNAMIC_DNS_PASSWD="Your GratisDNS password"

### ACME properties
ACME_EMAIL_ADDRESS="yourmail@mailserver.com"

### Traefik properties
TRAEFIK_ENTRYPOINT_ADDRESS="192.168.1.220"

### SnakeApi properties
API_SERVER_ADDRESS="192.168.1.220"
API_SERVER_PORT="80"

### SnakeConfig properties
APPLICATION_LIST="SnakeApi,SnakeHistory,SnakeUtil,SnakeConfig,SnakeTimer,SnakeConsole"
ENVIRONMENT_LIST="Development,Test,Production"

### Redis properties
REDIS_MASTER_SERVER_ADDRESS="192.168.230.1"
REDIS_MASTER_SERVER_PORT="8376"
REDIS_REPLICA_SERVER_ADDRESS="192.168.230.4"
REDIS_REPLICA_SERVER_PORT="8376"

### Sketch properties
SKETCH_SERVER_ADDRESS="192.168.1.220"
SKETCH_SERVER_PORT="80"

### MQTT properties
MQTT_SERVER_ADDRESS="192.168.1.220"
MQTT_SERVER_PORT="6379"

### USB Drive mount Command (/dev/sda1: UUID="3FFB-6CC8")
USB_MOUNT_COMMAND="echo \"/dev/sda1/by-uuid/USB_UUID /media/data/mariadb vfat auto,nofail,noatime,users,rw,uid=manager,gid=manager 0 0\" >> /etc/fstab"

### Redis Default SnakeConfig
REDIS_DEFAULT_CONFIG="{'REDIS_MASTER_SERVER_ADDRESS':'192.168.1.220','REDIS_MASTER_SERVER_PORT':'8376'}"







