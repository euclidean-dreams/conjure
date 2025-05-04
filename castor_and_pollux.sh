#!/bin/bash

# foundation
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential gdb cmake git vim python3-setuptools

# ssh
ssh-keygen

##########################
# add GitHub ssh creds!! #
##########################
mkdir -p ~/badlands
cd ~/badlands || exit
git clone git@github.com:euclidean-dreams/conjure.git

# no more passwords!
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopassword

# ssh stuff
echo "PasswordAuthentication no" | sudo tee /etc/ssh/sshd_config.d/no_password.conf
echo "PermitRootLogin no" | sudo tee /etc/ssh/sshd_config.d/no_root_login.conf

# want swap?
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# no want swap?
sudo swapoff -v /swapfile

# apt packages
sudo apt -y install libspdlog-dev
sudo apt -y install fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# pigpio
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/joan2937/pigpio.git
cd ~/badlands/pigpio || exit
git checkout c33738a320a3e28824af7807edafda440952c05d
make
sudo make install

# portaudio
# no devices will be listed if you install portaudio before alsa - if this happens, run make clean, then install again
sudo apt -y install libasound2-dev
sudo sed -i'' -e '/^pcm\\.rear cards\\.pcm\\.rear$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.center_lfe cards\\.pcm\\.center_lfe$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.side cards\\.pcm\\.side$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.hdmi cards\\.pcm\\.hdmi$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.modem cards\\.pcm\\.modem$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.phoneline cards\\.pcm\\.phoneline$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.hdmi cards\\.pcm\\.hdmi$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.front cards\\.pcm\\.front$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround cards\\.pcm\\.surround21$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround21 cards\\.pcm\\.surround21$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround40 cards\\.pcm\\.surround40$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround41 cards\\.pcm\\.surround41$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround50 cards\\.pcm\\.surround50$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround51 cards\\.pcm\\.surround51$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.surround71 cards\\.pcm\\.surround71$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.iec958 cards\\.pcm\\.iec958$/d' /usr/share/alsa/alsa.conf
sudo sed -i'' -e '/^pcm\\.spdif iec958$/d' /usr/share/alsa/alsa.conf
mkdir -p ~/badlands
cd ~/badlands || exit
curl -L -o portaudio.tgz http://files.portaudio.com/archives/pa_snapshot.tgz
tar -xzf portaudio.tgz -C ~/badlands
rm portaudio.tgz
cd ~/badlands/portaudio || exit
./configure
sudo make install

## kiss-fft
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/mborgerding/kissfft.git
cd ~/badlands/kissfft || exit
git checkout f5f2a3b2f2cd02bf80639adb12cbeed125bdf420
mkdir build
cd build || exit
cmake -DCMAKE_INSTALL_INCLUDEDIR=/usr/local/include -DKISSFFT_DATATYPE=float -DKISSFFT_STATIC=OFF -DKISSFFT_OPENMP=OFF -DKISSFFT_TEST=OFF -DKISSFFT_TOOLS=OFF ..
make all
sudo make install

# disable internal sound card (it interferes with led communication with, and gets in the way of the usb sound card)
echo "blacklist snd_bcm2835" | sudo tee /etc/modprobe.d/snd-blacklist.conf

# enable euclid
sudo cp ~/badlands/conjure/euclid.service /etc/systemd/system/euclid.service

#################################
# modify this target path!!!!!! #
#################################
sudo ln -s ~/euclidean-dreams/euclid/build-"${HOSTNAME}"/euclid /usr/local/bin/euclid
sudo systemctl enable euclid.service

# cleanup
sudo ldconfig
sudo reboot
