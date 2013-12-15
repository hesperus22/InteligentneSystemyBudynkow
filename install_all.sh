#!/bin/bash
apt-get update

#install required software
apt-get install -y make
apt-get install -y gcc
apt-get install -y git
apt-get install -y $1
apt-get install -y $1-dev
apt-get install i2c-tools

#i2c initialization
echo "i2c-dev" >> /etc/modules
echo "i2c-bcm2708" >> /etc/modules
modprobe i2c-dev
modprobe i2c-bcm2708

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
cd WebIOPi
chmod 755 setup.sh
./setup.sh
cd ..
cp WebIOPi/python/config /etc/webiopi/config

#lirc
apt-get install -y lirc
echo "lirc_dev" >> /etc/modules
echo "lirc_rpi gpio_in_pin = 27" >> /etc/modules
cp InteligentneSystemyBudynkow/lirc_hardware.conf /etc/lirc/hardware.conf
cp InteligentneSystemyBudynkow/remote.conf /etc/lirc/lircd.conf
modprobe lirc_dev
modprobe lirc_rpi gpio_in_pin = 27
/etc/init.d/lirc stop
/etc/init.d/lirc start