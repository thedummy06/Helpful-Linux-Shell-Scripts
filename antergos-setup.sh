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
echo "Would you like to deny ssh and telnet for security?(Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ufw deny telnet && sudo ufw deny ssh
	sudo ufw reload
fi

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
	if [[ $? -eq 0 ]];
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
	if [[ $? -eq 0 ]]; 
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

#This installs extra software
echo "Would you like to install software?(Y/n)"
read answer
while [ $answer == Y ];
do
echo "Here is a list of software to choose from"

echo "1 - bleachbit"
echo "2 - gnome-disk-utility"
echo "3 - ncdu"
echo "4 - nmap"
echo "5 - preload"
echo "6 - hardinfo"
echo "7 - lshw"
echo "8 - hdparm"
echo "9 - hddtemp xsensors"
echo "10 - geany"
echo "11 - htop iotop"
echo "12 - wget"
echo "13 - rkhunter"
echo "14 - abiword gnumeric"
echo "15 - bittorrent"
echo "16 - net-tools"
echo "17 - plank"
echo "18 - redshift"
echo "19 - blender"
echo "20 - cower"
echo "21 - xed"
echo "22 - web browser"
echo "23 - media player"
echo "24 - antivirus"
echo "25 - video and audio editing"
echo "26 - shotwell"
echo "27 - downgrade"
echo "28 - to skip"

read software;

case $software in 

	1)
	echo "This installs cleaning software"
	sudo pacman -S --noconfirm bleachbit
;;
	2)
	echo "This installs disk health checking software"
	sudo pacman -S --noconfirm gnome-disk-utility
;;
	3)
	echo "This installs disk space checking software"
	sudo pacman -S --noconfirm ncdu
;;
	4)
	echo "This installs network scanning software"
	sudo pacman -S --noconfirm nmap
;;
	5)
	echo "This installs daemon that loads applications in memory"
	sudo pacman  -S --noconfirm preload
;;
	6)
	echo "This installs hardware informations tool"
	sudo pacman -S --noconfirm hardinfo
;;
	7)
	echo "This installs command line utility to gather certain system info"
	sudo pacman -S --noconfirm lshw
;;
	8)
	echo "This installs software to configure hard drive settings"
	sudo pacman -S --noconfirm hdparm
;;
	9)
	echo "This installs software to gather temps"
	sudo pacman -S --noconfirm xsensors hddtemp
;;
	10)
	echo "This installs a light weight IDE(text/code editor)"
	sudo pacman -S --noconfirm geany
;;
	11)
	echo "This installs command line system monitors"
	sudo pacman -S --noconfirm htop iotop
;;
	12)
	echo "This installs a download manager"
	sudo pacman -S --noconfirm wget
;;
	13)
	echo "This installs a rootkit checker"
	sudo pacman -S --noconfirm rkhunter
;;
	14)
	echo "This installs light weight office tools"
	sudo pacman -S --noconfirm abiword gnumeric
;;
	15)
	echo "This installs your choice of bittorrent client"
	echo "1 - qbittorrent"
	echo "2 - transmission-gtk"
	echo "3 - deluge"
	read client
	
	if [[ $client == 1 ]];
	then
		sudo pacman -S --noconfirm qbittorrent
	elif [[ $client == 2 ]];
	then
		sudo pacman -S --noconfirm transmission-gtk
	elif [[ $client == 3 ]];
	then
		sudo pacman -S --noconfirm deluge
	else
		echo "moving on"
	fi
;;
	16)
	echo "This installs the old network tools for linux"
	sudo pacman -S --noconfirm net-tools
;;
	17)
	echo "This installs a dock utility"
	sudo pacman -S --noconfirm plank
;;
	18)
	echo "This installs a program to dim the monitor at night"
	sudo pacman -S --noconfirm redshift
;;
	19)
	echo "This installs 3D editing software"
	sudo pacman -S --noconfirm blender
;;
	20)
	echo "This installs a command line utility for managing AUR software"
	sudo pacman -S --noconfirm cower
;;
	21)
	echo "This installs a Linux Mint text editor"
	sudo pacman -S --noconfirm xed 
;;
	22)
	echo "This installs your choice in browsers"
	echo "1 - chromium"
	echo "2 - epiphany"
	echo "3 - qupzilla"
	echo "4 - opera" 
	echo "5 - Pale Moon"
	echo "6 - seamonkey"
	read browser
	
	if [[ $browser == 1 ]];
	then
		sudo pacman -S --noconfirm chromium
	elif [[ $browser == 2 ]];
	then
		sudo pacman -S --noconfirm epiphany
	elif [[ $browser == 3 ]];
	then
		sudo pacman -S --noconfirm qupzilla
	elif [[ $browser == 4 ]];
	then
		sudo pacman -S --noconfirm opera
		sudo pacman -S --noconfirm opera-ffmpeg-codecs
	elif [[ $browser == 5 ]];
	then
		sudo pacman -S --noconfirm palemoon-bin
	elif [[ $browser == 6 ]];
	then
		sudo pacman -S --noconfirm seamonkey
	else
		echo "Let's move on"
	fi
;;
	23)
	echo "This installs a choice in media players"
	echo "1 - xplayer"
	echo "2 - parole"
	echo "3 - kodi"
	echo "4 - Music"
	echo "5 - rhythmbox"
	echo "6 - mpv"
	echo "7 - vlc"
	read player
	
	if [[ $player == 1 ]];
	then
		sudo pacman -S --noconfirm xplayer
	elif [[ $player == 2 ]];
	then
		sudo pacman -S --noconfirm parole
	elif [[ $player == 3 ]];
	then
		sudo pacman -S --noconfirm kodi
	elif [[ $player == 4 ]];
	then
		sudo pacman -S --noconfirm Music
	elif [[ $player == 5 ]];
	then
		sudo pacman -S --noconfirm rhythmbox
	elif [[ $player == 6 ]];
	then
		sudo pacman -S --noconfirm mpv 
	elif [[ $player == 7 ]];
	then
		sudo pacman -S --noconfirm vlc
	else
		echo "Guess not"
	fi
;;
	24)
	echo "This installs an antivirus if you think you need it"
	sudo pacman -S clamav clamtk 
;;
	25)
	echo "This installs audio editing software and video editing software"
	sudo pacman -S --noconfirm kdenlive audacity
;;
	26)
	echo "This installs image organizing software"
	sudo pacman -S --noconfirm shotwell
;;
	27)
	sudo pacman -S --noconfirm downgrade
;;
	28)
	echo "We will skip this"
	break
;;
esac
done

#This allows you to install any software you know of that isn't on the list
echo "Would you like to install any additional software?(Y/n)"
read answer
while [ $answer == Y ];
do
	echo "Enter the name of any software you'd like to install"
	read software
	sleep 1
	sudo pacman -S --noconfirm $software
break
done

#This installs xfce4-goodies package on xfce versions of Antergos
for env in $DESKTOP_SESSION
do
if [ $DESKTOP_SESSION == xfce ];
then
	sudo pacman -S --noconfirm xfce4-goodies
fi
done

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

#This tries to install etc-update for configuration file management
echo "etc-update can help you manage pacnew files and other configuration files after system updates. \
would you like to install etc-update?(Y/n)"
read answer
while [ $answer == Y ];
do
	cd /tmp
	sudo pacman -S --needed base-devel 
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/etc-update.tar.gz
	gunzip etc-update.tar.gz && tar -xvf etc-update.tar
	cd etc-update
	makepkg -si 
	break
done

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
	sudo ./Hostsman4linux.sh
else 
	echo "Okay!"
fi

#This determines what type of drive you have, then offers to enable trim or write-back caching
drive=$(cat /sys/block/sda/queue/rotational)
for rota in $drive;
do
	if [[ $drive == 1 ]];
	then
		echo "Would you like to enable write back caching?(Y/n)"
		read answer 
		while [ $answer == Y ];
		do 
			echo "Enter the drive name you'd like to enable this on."
			read drive
			sudo hdparm -W 1 $drive
		break
		done
	elif [[ $drive == 0 ]];
	then
		echo "Would you like to enable Trim?(Y/n)"
		read answer 
		while [ $answer == Y ];
		do 
			sudo systemctl enable fstrim.timer
			sudo systemctl start fstrim.service
		break
		done
	fi
done

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
	echo "#Alias to update the hosts file" >> ~/.bashrc
	echo 'alias hostsup="sudo ./Hostsman4linux.sh"'
	echo "#Alias to rank mirrors" >> ~/.bashrc
	echo 'alias rank="sudo reflector -l 50 -f 20 --save /tmp/mirrorlist.new && rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist && sudo cp /tmp/mirrorlist /etc/pacman.d && sudo rankmirrors -n 0 /etc/pacman.d/antergos-mirrorlist > /tmp/antergos-mirrorlist && sudo cp /tmp/antergos-mirrorlist /etc/pacman.d && sudo pacman -Syy"' >> ~/.bashrc
	
fi

#Optional, but it is highly recommended that you make a quick backup
echo "Would you like to make a backup? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	#This backs up your system
	host=$(hostname)
	thedate=$(date +%Y-%M-%d)

	cd /
	find Backups
	while [ "$?" != "0" ];
	do
		sudo mkdir Backups
	break
	done
	cd Backups
	sudo tar -cvzpf /Backups/$host-$thedate.tar.gz --directory=/ --exclude=Backups --exclude=mnt --exclude=run --exclude=media --exclude=proc --exclude=tmp --exclude=dev --exclude=sys --exclude=lost+found /

else 
	echo "It is a good idea to create a backup after such changes, maybe later."
fi

#This will give you useful information about your system 
echo "You may want to save sysinfo.txt somewhere safe for future reference."
distribution=$(cat /etc/issue | awk '{print $1}')
echo "###############################################################" >> sysinfo.txt
echo "SYSTEM INFORMATION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "DISTRIBUTION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo $distribution >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "DESKTOP_SESSION" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "$DESKTOP_SESSION" >> sysinfo.txt
echo "" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
echo "SYSTEM INIT" >> sysinfo.txt
echo "###############################################################" >> sysinfo.txt
ps -p1 | awk 'NR!=1{print $4}' >> sysinfo.txt
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
inxi -F >> sysinfo.txt
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
systemctl status | less >> sysinfo.txt
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
