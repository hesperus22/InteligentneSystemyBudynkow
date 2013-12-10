#!/bin/bash
apt-get update

#install required software
apt-get install -y make
apt-get install -y gcc
apt-get install -y git
apt-get install -y $1

#bcm2835 library 
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.34.tar.gz
tar zxvf bcm2835-1.34.tar.gz
cd bcm2835-1.34
./configure
make
make check
make install
cd ..

#clone repositories
git clone https://github.com/hesperus22/InteligentneSystemyBudynkow.git InteligentneSystemyBudynkow
git clone https://github.com/hesperus22/Adafruit-Raspberry-Pi-Python-Code.git Adafruit
git clone https://github.com/hesperus22/WebIOPi.git WebIOPi

#install dhtreader
cd Adafruit/Adafruit_DHT_Driver_Python
$1 setup.py install
cd ../..

#install WebIOPi
cd WEbIOPi
./setup.sh
cd ..
cp InteligentneSystemyBudynkow/config /etc/webiopi/config

#lirc
apt-get install -y lirc-rpi
echo "lirc_dev" >> /etc/modules
echo "lirc_rpi gpio_in_pin = 22" >> /etc/modules
cp InteligentneSystemyBudynkow/lirc_hardware.conf /etc/lirc/hardware.conf
cp InteligentneSystemyBudynkow/remote.conf /etc/lirc/lircd.conf
modprobe lirc_dev
modprobe lirc_rpi gpio_in_pin = 22
/etc/init.d/lirc stop
/etc/init.d/lirc start