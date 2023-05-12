# Virtual Box Installer
## _Quick Guide_
**This guide helps you install a VM Debian 11 with VBoxClient enabled**

The codes only apply to Linux distros. 
They have only been tested on Debian 11 (Bullseye).

Video link : https://www.youtube.com/watch?v=Zqt0-0X7xlE

VM link : https://drive.google.com/file/d/168OX1fd607qO2ZRHv6SkOeUSnhjgBDMq/view?usp=share_link

## Pre-requisites
All the codes need read/write permissions for most files that have restricted access.


### VBoxClient
VBoxClient is installed through the image VBoxGuestAdditions.iso given by Oracle's Virtual Box official installer.
Available at default directory of VirtualBox on your system.
On windows : ```C:\Program Files\Oracle\VirtualBox\```

**DO NOT INSTALL ANY OTHER ISO FROM ANYWHERE ELSE WITHOUT CHECKING LEGITIMACY.**

### installation.sh
This file will automatically install the following packages :
* Opensearch (opensearch)
* Graylog (graylog-server)
* MongoDB v6+ (mongodb)
* Mosquitto v2+ Client (mosquitto-clients)
* Mosquitto v2+ Broker (mosquitto)
* Password Generator (pwgen)
* Uncomplicated FireWall (ufw)
* Python3 (python3)
* OpenJDK 8 JRE (openjdk-8-jre-headless)

It will generate / create :
* Password and secret for Graylog
* Create a database graylog 




## Installation steps
**1. Import the VM in VirtualBox**
VirtualBox > Upper left "Tools" > Import Appliance > Select the .ova you downloaded > Network Adapters : Strip all MAC address from all network adapters

Name the VM as you wish.

**2. Add VBoxGuestAdditions.iso**
On the new VM > Configuration or Settings > Storage
Add new Controller IDE (small disk)
Select the iso for VBoxGuestAdditions.iso.

By default, it is located at :
```C:\Program Files\Oracle\VirtualBox\```


**3. Launch the Virtual Machine**
*Connect with adminlx:secret00

**4. Change rights on the scripts**
```cd code```

```sudo chmod +x initiate_built_part1.sh
sudo chmod +x initiate_built_part2.sh
```


*Do the same for installation.sh if you want to install and setup Graylog, MongoDB and OpenSearch for Graylog* 

**5.Launch the script part 1**
```sudo sh ./initiate_built_part1.sh```

**Let the system reboot, then launch the second part**

*Make sure the .iso is still mounted*

**(Optional for GrayLog, MongoDB, OpenSearch)**
This part isn't available yet since this script is being used right now as part of a school project and to avoid being flagged as plagiarism automatically (even thought it's my file), I won't posted it here for now.

Download the installation.sh file from this repo. using wget

```sudo wget file_url```

```sudo chmod +x file```

```sudo sh ./file.sh```

