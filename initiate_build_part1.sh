#!/bin/bash

# Install essential builds for dpkms
sudo apt update
sudo mount /dev/cdrom /mnt
sudo apt install build-essential dkms linux-headers-$(uname -r) -y
sudo sh /mnt/VBoxLinuxAdditions.run
sudo reboot
