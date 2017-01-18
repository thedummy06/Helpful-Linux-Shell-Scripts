#!/bin/bash

#Will attempt to install nvidia, will detect amd cards too, but might have to change anything saying nvidia in this.

#This checks your device
sudo mhwd -li
sleep 1

echo "What would you like to do?"

echo "1-Proprietary driver"
echo "2-default driver"
echo "3-exit"

read operation;

case $operation in
	1) sudo mhwd -a pci nonfree 0300 && sudo nvidia-xconfig ;;
	2) sudo mhwd -r pci video-nvidia ;;
	3) echo "Goodbye!" ;;
esac

echo "Would you like to reboot now? (y/n)"
read answer 
if [[ $answer == y ]];
then 
sudo systemctl reboot
else 
echo "Please reboot if you installed a new driver."
fi
