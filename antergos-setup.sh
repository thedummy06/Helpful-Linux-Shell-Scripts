#!/bin/bash

#Sets default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This starts your firewall 
sudo systemctl enable ufw 
sudo ufw enable 
sudo ufw deny telnet
sudo ufw allow transmission
#sudo ufw deny ssh #ssh is a secure shell protocol that allows you to log into and interact with multiple clients

#This restricts coredumps to prevent attackers from getting info
sudo cp /etc/systemd/coredump.conf /etc/systemd/coredump.conf.bak
sudo sed -i -e '/#Storage=external/c\Storage=none ' /etc/systemd/coredump.conf

#This will try to ensure you have a strong network connection
for c in computer;
do 
sudo ping -c4 google.com 
if [ $? -eq 0 ]
then 
	echo "Connection successful"
else
ifconfig >> ifconfig.txt
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo ifconfig up $interfacename #Refer to ifconfig.txt
sudo dhclient -r $interfacename && sudo dhclient $interfacename
fi
done 

#If you use steam and certain other applications which are 32bit
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo sed -i -e '/#[multilib]/c\[multilib] ' /etc/pacman.conf
sudo sed -i -e '/#Include = /etc/pacman.d/mirrorlist/c\Include = /etc/pacman.d/mirrorlist ' /etc/pacman.conf


#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do
sudo pacman rankmirrors /etc/pacman.d/antergos-mirrorlist
sudo pacman-optimize && sync
sudo pacman -Syy
sudo pacman -S archlinux-keyring antergos-keyring
sudo pacman -Syyu
if [ $? -eq 0 ] 
then 
echo "update successful"
else 
sudo rm /var/lib/pacman/db.lck 
sudo rm -r /etc/pacman.d/gnupg 
sudo pacman -Sy gnupg archlinux-keyring antergos-keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux antergos 
sudo pacman -Sc 
sudo pacman -Syyu 
fi
done

#This runs mkinit on your kernel
sudo mkinitcpio -P

#This will install a few useful apps
sudo pacman -S bleachbit
sudo pacman -S gnome-disk-utility
sudo pacman -S ncdu 
sudo pacman -S nmap
sudo pacman -S transmission-gtk
sudo pacman -S epiphany
sudo pacman -S hdparm 
sudo pacman -S hddtemp 
sudo pacman -S xsensors
sudo pacman -S hardinfo
sudo pacman -S lshw
#Optional 
#sudo pacman -S steam
#sudo pacman -S rhythmbox
#sudo pacman -S palemoon-bin
#sudo pacman -S chromium
#sudo pacman -S qupzilla
#sudo pacman -S kodi

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

#Furthermore, this could increase performance in mechanical drives
echo "Should I enable write caching in mechanical drive?"
read answer 
if [[ $answer == Y ]];
then 
sudo hdparm -W 1 /drive/name
else 
echo "Proceed!"
fi

#This tweaks the journal file for efficiency
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
