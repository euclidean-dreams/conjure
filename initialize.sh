#!/bin/bash

# foundation
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential gdb cmake git vim python3-setuptools

# sdl
sudo apt -y install libsdl2-dev

# ssh
ssh-keygen
# add GitHub ssh creds!!
cd /tmp || exit
git clone git@github.com:euclidean-dreams/conjure.git

# no more passwords!
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopassword

# ssh stuff
echo "PasswordAuthentication no" | sudo tee /etc/ssh/sshd_config.d/no_password.conf
echo "PermitRootLogin no" | sudo tee /etc/ssh/sshd_config.d/no_root_login.conf

# spdlog
sudo apt -y install libspdlog-dev

# pigpio
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/joan2937/pigpio.git
cd ~/badlands/pigpio || exit
git checkout c33738a320a3e28824af7807edafda440952c05d
make
sudo make install

# disable sound card (it interferes with communication with leds)
echo "blacklist snd_bcm2835" | sudo tee /etc/modprobe.d/snd-blacklist.conf

# set volitia in /etc/hosts
echo "10.3.33.188 volitia" | sudo tee -a /etc/hosts

# cleanup
sudo ldconfig
sudo reboot

# enable euclid
sudo cp ~/euclid.service /etc/systemd/system/euclid.service
sudo systemctl enable euclid.service

# want swap?
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# no want swap?
sudo swapoff -v /swapfile
