#!/bin/bash

#Sets default editor in bashrc
export EDITOR=nano

#This starts your firewall 
sudo systemctl enable ufw 
sudo ufw enable 
#sudo ufw deny ssh

#This will try to ensure you have a strong network connection
for c in computer;
do 
sudo ping -c4 google.com 
if [ $? -eq 0 ]
then 
	echo "Connection successful"
else
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo ifconfig up eth0
sudo dhclient eth0
fi
done 

#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do 
sudo pacman-mirrors -g
sudo pacman-optimize && sync
sudo pacman -Syyu 
if [ $? -eq 0 ] 
then 
echo "Update succeeded" 
else
sudo rm /var/lib/pacman/db.lck 
sudo rm -r /etc/pacman.d/gnupg 
sudo pacman -Sy gnupg archlinux-keyring manjaro-keyring
sudo pacman-key --init 
sudo pacman-key --populate archlinux manjaro 
sudo pacman-key --refresh-keys 
sudo pacman -Sc
sudo pacman -Syyu
fi
done

#This runs mkinit on your kernel
sudo mkinitcpio -g $(mhwd-kernel -li)

#This will install a few useful apps
sudo pacman -S screenfetch
sudo pacman -S bleachbit
sudo pacman -S gnome-disk-utility
sudo pacman -S ncdu 
sudo pacman -S nmap
sudo pacman -S transmission-gtk
#Optional 
#sudo pacman -S rhythmbox
#sudo pacman -S palemoon-bin
#sudo pacman -S chromium
#sudo pacman -S qupzilla

#This will attempt to install etc-update
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/etc-update.tar.gz
sudo pacman -S --needed base-devel
mkdir builds
sudo mv etc-update.tar.gz ~/builds
cd ~/builds
tar -xvf etc-update.tar.gz
cd etc-update
nano PKGBUILD
makepkg -sri
cd

#Will install and set preload to enabled if uncommented
#sudo pacman -S preload
#sudo systemctl enable preload 

#I can prepare a simple hosts file if you like from Steven Black
echo "Would  you like to use a hosts file to block adverts? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
sudo ./hostsman4linux.sh
fi

#sudo systemctl enable fstrim.timer
#sudo systemctl start fstrim.service

#This tweaks the journal file for performance
sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.bak
sudo sed -i -e '/#SystemMaxUse=/c\SystemMaxUse=50M ' /etc/systemd/journald.conf

#This removes that retarded gnome-keyring unlock error you get with chrome
sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old
sudo killall gnome-keyring-daemon

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise
#cd /
#sudo mkdir backups
#sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=backups --exclude=var/cache/pacman/pkg / /backups
#Or for home folder only
#sudo rsync -aAXv /home/$USER/ /backups

#This will reboot your system 
sudo systemctl reboot