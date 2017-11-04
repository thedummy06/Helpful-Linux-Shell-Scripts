#!/bin/bash

#Sets default editor to nano in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This sets up your system time. 
echo "Would you like to set ntp to true? (Y/n)"
read answer
while [ $answer == Y ];
do 
	echo "Enter your preferred timezone"
	read timezone
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
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-sysctl.conf #lowers swap value
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

#This disables ipv6
echo "Sometimes ipv6 can cause network issues. Would you like to disable it?(Y/n)"
read answer 
if [[ $answer == Y ]];
then 
	sudo cp /etc/default/grub /etc/default/grub.bak 
	sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg
else
	echo "OKAY!"
fi

#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do 
	sudo pacman-mirrors -g
	sudo pacman-optimize && sync
	sudo pacman -Syyu --noconfirm 
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

read -p "Press Enter to continue."

#This will install a few useful apps
sudo pacman -S --noconfirm bleachbit gnome-disk-utility ncdu nmap transmission-gtk libreoffice-fresh 
sudo pacman -S --noconfirm hardinfo lshw hdparm hddtemp xsensors wget geany 
#Optional 
#sudo pacman -S --noconfirm clementine
#sudo pacman -S --noconfirm qupzilla 
#sudo pacman -S --noconfirm kodi 
#sudo pacman -S --noconfirm shotwell 
#sudo pacman -S --noconfirm kdenlive 
#sudo pacman -S --noconfirm palemoon-bin 
#sudo pacman -S --noconfirm epiphany 
sudo pacman -S --noconfirm chromium 
#sudo pacman -S --noconfirm opera
#sudo pacman -S --noconfirm deluge
#sudo pacman -S --noconfirm seamonkey 
#sudo pacman -S --noconfirm rhythmbox 
#sudo pacman -S --noconfirm plank
#sudo pacman -S --noconfirm parole
#sudo pacman -S --noconfirm xplayer

#This will set up screenfetch
sudo pacman -S --noconfirm  screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#As for themes #More are coming
echo "Would you like some extra themes? (Y/n)"
read answer
if [[ $answer == Y ]];
then
sudo pacman -S --noconfirm moka-icon-theme faba-icon-theme 
sudo pacman -S --noconfirm arc-icon-theme  evopop-icon-theme
sudo pacman -S --noconfirm elementary-xfce-icons macos-icon-theme
sudo pacman -S --noconfirm arc-gtk-theme numix-frost-themes
sudo pacman -S --noconfirm menda-themes-dark papirus-icon-theme
sudo pacman -S --noconfirm gtk-theme-breath obsidian-icon-theme
sudo pacman -S --noconfirm xfce-theme-greybird numix-themes-archblue
sudo pacman -S --noconfirm mint-x-theme mint-x-icons mint-y-icons
sudo pacman -S --noconfirm mint-y-theme
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

#This initiates trim on solid state drives 
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
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo rsync -aAXv --exclude=dev --exclude=proc --exclude=Backups --exclude=Music --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found / /Backups
else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#This allows you to add aliases to .bashrc
echo "Aliases are shortcuts for commonly used commands."
echo "Would you like to add some commonly used aliases?(Y/n)"
read answer

if [[ $answer == Y ]];
then 
	echo 'alias fstab="sudo nano /etc/fstab"' >> ~/.bashrc
	echo 'alias grub="sudo nano /etc/default/grub"' >> ~/.bashrc
	echo 'alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"' >> ~/.bashrc
	echo 'alias pacup="sudo pacman -Syu"' >> ~/.bashrc
	echo 'alias mirrors="sudo pacman-mirrors -g && sudo pacman -Syyu"' >> ~/.bashrc
	
fi

#This will reboot your system 
sudo sync && sudo systemctl reboot
