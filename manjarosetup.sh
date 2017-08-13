#!/bin/bash

#Sets default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This sets up your system time.
echo "Would you like to set ntp to true? (Y/n)"
read answer
echo "Enter your preferred timezone"
read timezone
while [ $answer == Y ];
do 
	sudo timedatectl set-ntp true 
	sudo timedatectl set-timezone $timezone
	break
done  

#This starts your firewall 
sudo systemctl enable ufw 
sudo ufw enable 
#sudo ufw deny telnet 
#sudo ufw deny ssh #ssh is a secure shell protocol that allows you to log into and interact with multiple clients

#This restricts coredumps to prevent attackers from getting info
sudo cp /etc/systemd/coredump.conf /etc/systemd/coredump.conf.bak
sudo sed -i -e '/#Storage=external/c\Storage=none ' /etc/systemd/coredump.conf
sudo touch /etc/sysctl.d/50-dmesg-restrict.conf
sudo touch /etc/sysctl.d/50-kptr-restrict.conf
sudo touch /etc/sysctl.d/99-sysctl.conf
echo "kernel.dmesg_restrict = 1" | sudo tee -a /etc/sysctl.d/50-dmesg-restrict.conf
echo "kernel.kptr_restrict = 1" | sudo tee -a /etc/sysctl.d/50-kptr-restrict.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-sysctl.conf
sudo sysctl --system
sudo systemctl daemon-reload

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
	then 
		echo "Connection successful"
	else
		ifconfig >> ifconfig.txt
		sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo ifconfig $interfacename up #Refer to ifconfig.txt
	fi
done 

#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do 
	sudo pacman-mirrors -g
	sudo pacman-optimize && sync
	sudo pacman -Syy
	sudo pacman -S manjaro-keyring archlinux-keyring
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

#This runs mkinit on your kernel and ensures the updates worked
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

#This will install a few useful apps
sudo pacman -S bleachbit gnome-disk-utility ncdu nmap deluge 
sudo pacman -S hardinfo lshw hdparm hddtemp xsensors wget geany
#Optional 
#sudo pacman -S steam 
#sudo pacman -S kodi 
#sudo pacman -S shotwell 
#sudo pacman -S kdenlive 
#sudo pacman -S palemoon-bin 
#sudo pacman -S epiphany 
#sudo pacman -S chromium 
#sudo pacman -S opera
#sudo pacman -S transmission-gtk 
#sudo pacman -S seamonkey 
#sudo pacman -S rhythmbox 
#sudo pacman -S plank

#This will set up archey3
sudo pacman -S screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#As for themes #More are coming
echo "Would you like some extra themes? (Y/n)"
read answer
if [[ $answer == Y ]];
then
sudo pacman -S moka-icon-theme faba-icon-theme 
sudo pacman -S arc-icon-theme arc-maia-icon-theme 
sudo pacman -S delorean-dark-themes-3.9
sudo pacman -S elementary-xfce-icons 
sudo pacman -S arc-themes-maia 
sudo pacman -S menda-themes-dark 
sudo pacman -S gtk-theme-breath
sudo pacman -S dorian-flat
else
	echo "Your desktop is void like my soul!"
fi 

#I can prepare a simple hosts file if you like from Steven Black
echo "Would  you like to use a hosts file to block adverts? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./hostsman4manjaro.sh
else 
	echo "Okay!"
fi

#sudo systemctl enable fstrim.timer
#sudo systemctl start fstrim.service

#This should improve performance on some mechanical drives
echo "Would you like to increase HDD performance? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
    echo "Please enter your drive name"
    read drive
	sudo hdparm -W 1 $drive
else 
	echo "Write-back caching improves hard drive performance."
fi

#This tweaks the journal file for efficiency
sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.bak
sudo sed -i -e '/#SystemMaxUse=/c\SystemMaxUse=50M ' /etc/systemd/journald.conf

#This removes that retarded gnome-keyring unlock error you get with chrome
echo "Killing this might make your passwords less secure on chrome."
sleep 1
echo "Do you wish to kill gnome-keyring? (Y/n)"
read answer 
if [[ $answer == Y ]];
then
	sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old
	sudo killall gnome-keyring-daemon
else
	echo "Proceeding"
fi

#Optional, but it is highly recommended that you make a quick backup
#The backup directory can be found in your root folder, unless you specify #otherwise
#cd /
#sudo mkdir Backup
#sudo rsync -aAXv --exclude=dev --exclude=Backup --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=var/cache/pacman/pkg / /Backup
#Or for home folder only
#sudo rsync -aAXv /home/$USER/ ~/Backup

#This will reboot your system 
sudo sync && sudo systemctl reboot
