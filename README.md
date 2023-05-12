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




## Installation


## Plugins


## Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantaneously see your updates!

Open your favorite Terminal and run these commands.

First Tab:

```sh
node app
```

Second Tab:

```sh
gulp watch
```

(optional) Third:

```sh
karma test
```

#### Building for source

For production release:

```sh
gulp build --prod
```

Generating pre-built zip archives for distribution:

```sh
gulp build dist --prod
```

## License

MIT

**Free Software, Hell Yeah!**
