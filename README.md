![HomeGuide Dashboard](/Artifacts/wavesnake.png)

# Table of contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
    1. [Hardware](#hardware)
        1. [Hardware list](#hardwarelist)
    2. [Software](#software)
        1. [Redis](#redis)
        2. [SnakeApi](#snakeapi)
        3. [SnakeTimer](#snaketimer)
        4. [SnakeRule](#snakerule)
        5. [SnakeConfig](#snakeconfig)
3. [Configuration](#configuration)
    1. [Setup guide](#setupguide)
    2. [Flashing SD Cards](#flash)
    3. [Booting the RPI's](#boot)
4. [Install Docker Images](#dockerimages)
5. [Swarm Illustration](#swarmillustration)
6. [Features](#features)
    1. [Complete Dockerized Swarm setup](#dockerized)
    2. [Prompted setup & flashing og Manager and Worker nodes](#prompted)
    3. [Dynamic DNS](#dynamicdns)
    4. [SSH login with pregenerated keys](#sshlogin)
    5. [Password Hash login](#passwdhash)
    6. [Automatic IP address & network detection](#autoip)
    7. [Isolated Swarm network](#isolated)
    8. [Automated Certificate handling](#certgen)
7. [Configuration documentation](#configdocumentation)

## SnakeHome <a name="introduction"></a>
SnakeHome is the platform for hobbyist, who want the possibility to create their own IoT devices, but lack the background infrastructure, to integrate these devices into a manageable platform. I've put together some of the best tools available, written som apps, services, sketches and scripts, tested a lot, out came the SnakeHome management system, and it's free.

## Prerequisites <a name="prerequisites"></a>
prerequisites: Mac, Windows or Linux, Visual Studio Code with some extensions (free).  

### RPI hardware <a name="hardware"></a>

#### List of hardware <a name="hardwarelist"></a>

| Hardware                | Count         | Prise DKr           |
| ----------------------- | ------------- | ------------------- |  
| RPI 3B or 4B            | 4             | 1200-2000           |
| Micro SD Card 16 GB     | 4             | 200                 |
| Cluster case 4 Node     | 1             | 170                 |
| Deltaco power supply    | 1             | 430                 |
| Tenda network switch    | 1             | 90                  |
| Ethernet cables 25cm    | 4             | 100                 |
| USB-A to Micro USB 25cm | 4             | 200                 |
| USB to DC cable 25cm    | 1             | 25                  |
| APC Nobreak 500         | 1             | 450                 |
| Arcryllic Enclosure     | 1             | 900                 |
| Amount DKr              |               | 3,700 - 4,500       |

### Toolchain<a name="tools"></a>
The nescessary tools for building/Installing the SnakeSwarm project and developing Sketches for ESP8266/ESP32  
Visual Studio Code for Mac, latest version with some extensions: 
Python3 
Arduino for Visual Studio Code
C/C++
ms-vscode.cpptools
lukasz-wronski.ftp-sync
ms-azuretools.vscode-docker
sprdp.remote-browser
jchannon.csharpextensions
.gitignore generator
ronaldosena.arduino-snippets

vsciot-vscode.vscode-arduino

You can paste these extension id's into VSCode extension search box and from there
install the extension.



### RPI software <a name="software"></a>
The software running on the RPI's are all Docker Containers, which are installed onto the RPI from Portainer console. 
Traefik and Portainer are installed at boot time, and will be available after swarm initialization.

#### Redis  <a name="redis"></a>

#### SnakeApi  <a name="snakeapi"></a>

#### SnakeTimer  <a name="snaketimer"></a>

#### SnakeRule  <a name="snakerule"></a>

#### SnakeConfig  <a name="snakeconfig"></a>
Repository URL: https://github.com/jagdriver/Stacks.git

Compose path: /SnakeConfig/docker-compose.yml

### Setup guide  <a name="setupguide"></a>
The initial setup and flashing of the SnakeHome Swarm includes downloading [this](https://github.com/jagdriver/Flashing "this link") project from GitHub. Copy the project content into a folder called Flashing.

Next read the documentation on Swarm Configuration before going into actual setup steps.

Download the latest HypriotOS from this url https://blog.hypriot.com/downloads/

Edit swarmconfig.txt and nodeconfig.txt but be carefull not to jeopardise these files. Or run flash-config.zsh to be prompted for property values.

### Flashing to SD cards <a name="flash"></a>
Run flash-swarm.zsh to flash the node images to micro SD cards, please have the cards ready an properly marked, 1 to 4. You can flash all at once, or one at a time.

### Booting the RPI's <a name="boot"></a>
Put the SD cards in Your Raspberry Pi's and turn them on.
I suggest that You turn them on one at a time, while connecting a monitor to the HDMI port to watch the boot process.

Voila, Your ShakeHome Swarm is up and running.

## Install Docker Images <a name="dockerimages"></a>
The next step is to install Docker Images and instantiating Containers from within Portainer console.


## Swarm Illustration <a name="swarmillustration"></a>
![Swarm Illustration](/Artifacts/Swarm.png)

## Features <a name="features"></a>

### Complete Dockerized Swarm setup <a name="dockerized"></a>

### Prompted setup & flashing og Manager and Worker nodes <a name="prompted"></a>

### Dynamic DNS <a name="dynamicdns"></a>

### SSH login with pregenerated keys <a name="sshlogin"></a>

### Password Hash login <a name="passwdhash"></a>

### Automatic IP address & network detection <a name="autoip"></a>

### Isolated Swarm network <a name="isolated"></a>

### Automated Certificate handling <a name="certgen"></a>

## Configuration documentation <a name="configdocumentation"></a>

The configuration starts with preparing the information going into the configuration process. 
You can find the properties in the file Artifacts/swarmconfig.txt.
test test








