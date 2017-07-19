#!/bin/bash

#Sets default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This starts your firewall 
sudo systemctl enable ufw 
sudo ufw enable 
sudo ufw deny telnet
#sudo ufw deny ssh #ssh is a secure shell protocol that allows you to log into and interact with multiple clients

#This restricts coredumps to prevent attackers from getting info
sudo cp /etc/systemd/coredump.conf /etc/systemd/coredump.conf.bak
sudo sed -i -e '/#Storage=external/c\Storage=none ' /etc/systemd/coredump.conf
sudo touch /etc/sysctl.d/50-dmesg-restrict.conf
sudo touch /etc/sysctl.d/50-kptr-restrict.conf
echo "kernel.dmesg_restrict = 1" | sudo tee -a /etc/sysctl.d/50-dmesg-restrict.conf
echo "kernel.kptr_restrict = 1" | sudo tee -a /etc/sysctl.d/50-kptr-restrict.conf
sudo systemctl daemon-reload

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
sudo grub-mkconfig -o /boot/grub/grub.cfg

#This will install a few useful apps
sudo pacman -S bleachbit gnome-disk-utility ncdu nmap
sudo pacman -S deluge hdparm hddtemp xsensors geany
sudo pacman -S hardinfo lshw iotop htop qupzilla clementine
#Optional 
#sudo pacman -S steam kodi shotwell kdenlive palemoon-bin epiphany chromium opera
#sudo pacman -S transmission-gtk seamonkey rhythmbox
#This will set up screenfetch
sudo pacman -S screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

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
sudo hdparm -W 1 /drive/name

#This tweaks the journal file for efficiency
sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.bak
sudo sed -i -e '/#SystemMaxUse=/c\SystemMaxUse=50M ' /etc/systemd/journald.conf

#This removes that retarded gnome-keyring unlock error you get with chrome
echo "Killing this might make your passwords less secure."
echo "Do you wish to kill gnome-keyring? (Y/n)"
read answer 
if [[answer == Y ]];
then
sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old
sudo killall gnome-keyring-daemon
else
echo "Proceeding"
fi

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise
#cd /
#sudo mkdir backups
#sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=backups --exclude=var/cache/pacman/pkg / /backups
#Or for home folder only
#sudo rsync -aAXv /home/$USER/ ~/backups

#This will reboot your system 
sudo sync && sudo systemctl reboot
