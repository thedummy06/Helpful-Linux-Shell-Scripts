#!/bin/bash

#Sets default editor in bashrc
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
#sudo ufw deny ssh 
#sudo ufw deny telnet

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

#This tells you information about your network
ip addr >> networkconfig.log

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
	then 
		echo "Connection successful"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		#sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo ip link set $interface up
	fi
done

#This disables ipV6 
echo "Sometimes ipV6 causes network issues. Would you like to disable it?(Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo cp /etc/default/grub /etc/default/grub.bak
	sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg
else 
	echo "Okay!"
fi

#If you use steam and certain other applications which are 32bit
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo sed -i -e '/#[multilib]/c\[multilib] ' /etc/pacman.conf
sudo sed -i -e '/#Include = /etc/pacman.d/mirrorlist/c\Include = /etc/pacman.d/mirrorlist ' /etc/pacman.conf

#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do
	sudo pacman rankmirrors /etc/pacman.d/antergos-mirrorlist
	sudo pacman -Syyu --noconfirm
	if [ $? -eq 0 ] 
	then 
		echo "update successful"
	else 
		sudo rm /var/lib/pacman/db.lck 
		sudo rm -r /etc/pacman.d/gnupg 
		sudo pacman -Sy --noconfirm gnupg archlinux-keyring antergos-keyring
		sudo pacman-key --init
		sudo pacman-key --populate archlinux antergos 
		sudo pacman -Sc --noconfirm 
		sudo pacman -Syyu --noconfirm
	fi
done

read -p "Press Enter to continue."

#This will install a few useful apps
sudo pacman -S --noconfirm bleachbit reflector gnome-disk-utility ncdu nmap hardinfo lshw iotop htop inxi hdparm hddtemp xsensors geany dhclient
#Optional 
#sudo pacman -S --noconfirm rkhunter
#sudo pacman -S --noconfirm transmission-gtk
#sudo pacman -S --noconfirm pacaur
#sudo pacman -S --noconfirm redshift
#sudo pacman -S --noconfirm blender
#sudo pacman -S --noconfirm qbittorrent
#sudo pacman -S --noconfirm net-tools
#sudo pacman -S --noconfirm clamav
#sudo pacman -S --noconfirm clamtk
#sudo pacman -S --noconfirm clementine
#sudo pacman -S --noconfirm steam 
#sudo pacman -S --noconfirm kodi 
#sudo pacman -S --noconfirm shotwell 
#sudo pacman -S --noconfirm kdenlive 
#sudo pacman -S --noconfirm palemoon-bin 
#sudo pacman -S --noconfirm epiphany 
#sudo pacman -S --noconfirm chromium 
#sudo pacman -S --noconfirm opera
#sudo pacman -S --noconfirm deluge
#sudo pacman -S --noconfirm seamonkey 
#sudo pacman -S --noconfirm rhythmbox 
#sudo pacman -S --noconfirm plank
#sudo pacman -S --noconfirm parole
#sudo pacman -S --noconform xplayer

#This tries to install google-chrome on your system
echo "Would you like to install Google-Chrome?(Y/n)"
read answer 
if [[ $answer == Y ]];
then
	cd /tmp
	sudo pacman -S --needed base-devel
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz
	gunzip google-chrome-stable.tar.gz && tar -xvf google-chrome-stable.tar
	cd google-chrome
	makepkg -si
fi

#Here are some themes
echo "Would you like to install some extra themes? (Y/n)"
read answer
if [[ $answer == Y ]];
then
	sudo pacman -S --noconfirm arc-gtk-theme arc-icon-theme numix-frost-themes numix-theme-archblue mate-themes mate-icon-theme
else
	echo "Why so gloomy?"
fi

#This will set up screenfetch
sudo pacman -S --noconfirm screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#I can prepare a simple hosts file if you like from Steven Black
echo "Would  you like to use a hosts file to block adverts? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./Hostsman4antergos.sh
else 
	echo "Okay!"
fi

#This initiates trim on Solid state drives
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

#This allows you to add aliases to .bashrc
echo "Aliases are shortcuts to commonly used commands."
echo "Would you like to add some commonly used aliases?(Y/n)"
read answer

if [[ $answer == Y ]];
then 
	echo "#Alias to edit fstab" >> ~/.bashrc
	echo 'alias fstab="sudo nano /etc/fstab"' >> ~/.bashrc
	echo "#Alias to edit grub" >> ~/.bashrc
	echo 'alias grub="sudo nano /etc/default/grub"' >> ~/.bashrc
	echo "#Alias to update grub" >> ~/.bashrc
	echo 'alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"' >> ~/.bashrc
	echo "#Alias to update the system" >> ~/.bashrc
	echo 'alias pacup="sudo pacman -Syu"' >> ~/.bashrc
	echo "#Alias to rank mirrors" >> ~/.bashrc
	echo 'alias rank="sudo reflector -l 50 -f 20 --save /tmp/mirrorlist.new && rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist && sudo cp /tmp/mirrorlist /etc/pacman.d && sudo rankmirrors -n 0 /etc/pacman.d/antergos-mirrorlist > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d && sudo pacman -Syy"' >> ~/.bashrc
	
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

echo "You may want to save sysinfo.txt somewhere safe for troubleshooting later."
sleep 2
echo "###############################################################" >> sysinfo.txt
echo "SYSTEM INFORMATION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "DATE" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
date >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "KERNEL AND OPERATING SYSTEM INFORMATION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
uname -a >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "OPERATING SYSTEM RELEASE INFORMATION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
lsb_release -a >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "HOSTNAME" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
hostname >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "UPTIME" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
uptime >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "DISK SPACE" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
df -h >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "MEMORY USAGE" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
free -h >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "LISTS ALL BLOCK DEVICES WITH SIZE" >> sysinfo.txt 
echo "###############################################################" >> sysinfo.txt
lsblk -o NAME,SIZE >> sysinfo.txt
echo"" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "NETWORK CONFIGURATION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
ip addr >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "NETWORK STATS" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
ss | less >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "PROCESS LIST" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
ps -aux >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "Inxi" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
inxi -Fx >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "USB INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
lsusb >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "HARDWARE INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
lspci >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "MORE HARDWARE INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
sudo lshw >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "EVEN MORE HARDWARE INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
sudo dmidecode >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "YET STILL MORE HARDWARE INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
lscpu >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "LOGS" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
sudo dmesg >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "MORE LOGS" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
journalctl >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "SYSTEMD BOOT INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
systemd-analyze >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "MORE SYSTEMD BOOT INFORMATION" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
systemd-analyze blame >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "SYSTEMD STATUS" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
systemctl status >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "SYSTEMD'S FAILED LIST" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
systemctl --failed >> sysinfo.txt
echo "" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt
echo "END OF FILE" >> sysinfo.txt
echo "##############################################################" >> sysinfo.txt

#This will reboot your system 
sudo sync && sudo systemctl reboot
