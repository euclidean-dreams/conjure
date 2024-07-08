#!/bin/bash

# name this thing!
new_hostname="volitia"
old_hostname="$HOSTNAME"
echo "$new_hostname" | sudo tee /etc/hostname
sudo sed -i "s/$old_hostname/$new_hostname/" /etc/hosts

# fftw
note, this builds with neon instructions for arm processors, just run ./configure without args for x86
mkdir -p ~/badlands
cd ~/badlands || exit
curl -L -o fftw.tar.gz http://fftw.org/fftw-3.3.10.tar.gz
tar -xzf fftw.tar.gz -C ~/badlands
rm fftw.tar.gz
cd ~/badlands/fftw-3.3.10 || exit
./configure --enable-single --enable-neonsudo m
sudo make install

# zmq
mkdir -p ~/badlands
sudo apt install -y libzmq3-dev
cd ~/badlands || exit
git clone https://github.com/zeromq/cppzmq.git
cd ~/badlands/cppzmq || exit
git checkout v4.7.1
mkdir build
cd ~/badlands/cppzmq/build || exit
cmake -DCPPZMQ_BUILD_TESTS=OFF ..
sudo make -j4 install

# spidev-lib for promenade
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/milekium/spidev-lib.git
cd ~/badlands/spidev-lib || exit
git checkout 4710757f4087e8d798f348f9b6c1a064c35d1bf2
mkdir build
cd ~/badlands/spidev-lib/build || exit
cmake ../
make
sudo make install
echo "overlays=w1-gpio spi-spidev" | sudo tee -a /boot/armbianEnv.txt
echo "param_spidev_spi_bus=1" | sudo tee -a /boot/armbianEnv.txt

## serial for communicating with light controller board
sudo apt -y install catkin
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/wjwwood/serial.git
cd ~/badlands/serial || exit
git checkout 1.2.1
cmake -DCATKIN_ENABLE_TESTING=0
sudo make install
sudo adduser "$USER" dialout

# ws2811 for promenade
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/jgarff/rpi_ws281x.git
cd ~/badlands/rpi_ws281x || exit
git checkout 9be313f77aa494036e2dc205b6ec2860e7ee988c
mkdir build
cd ~/badlands/rpi_ws281x/build || exit
cmake -D BUILD_SHARED=ON -D BUILD_TEST=OFF ..
cmake --build
sudo make install

# rpi-rgb-led-matrix for promenade
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/hzeller/rpi-rgb-led-matrix.git
cd ~/badlands/rpi-rgb-led-matrix || exit
git checkout a3eea997a9254b83ab2de97ae80d83588f696387
make
sudo mkdir -p /usr/local/include/rgbmatrix
sudo cp -r ~/badlands/rpi-rgb-led-matrix/include/* /usr/local/include/rgbmatrix
sudo cp -r ~/badlands/rpi-rgb-led-matrix/lib/librgbmatrix.a /usr/local/lib

## kiss-fft
mkdir -p ~/badlands
cd ~/badlands || exit
git clone https://github.com/mborgerding/kissfft.git
cd ~/badlands/kissfft || exit
git checkout f5f2a3b2f2cd02bf80639adb12cbeed125bdf420
mkdir build
cd build || exit
cmake -DCMAKE_INSTALL_INCLUDEDIR=/usr/local/include -DKISSFFT_DATATYPE=float -DKISSFFT_STATIC=ON -DKISSFFT_OPENMP=OFF -DKISSFFT_TEST=OFF -DKISSFFT_TOOLS=OFF ..
make all
#sudo cp libkissfft-float.a /usr/local/lib/libkissfft.a
