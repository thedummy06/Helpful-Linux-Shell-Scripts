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
echo "Would you like to disable ssh and telnet for security?(Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ufw deny telnet && sudo ufw deny ssh
	sudo ufw reload
fi

#This restricts coredumps to prevent attackers from getting info
sudo cp /etc/systemd/coredump.conf /etc/systemd/coredump.conf.bak
sudo sed -i -e '/#Storage=external/c\Storage=none ' /etc/systemd/coredump.conf
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo sed -i -e '/#PermitRootLogin/c\PermitRootLogin no ' /etc/ssh/sshd_config
sudo touch /etc/sysctl.d/50-dmesg-restrict.conf
sudo touch /etc/sysctl.d/50-kptr-restrict.conf
sudo touch /etc/sysctl.d/99-sysctl.conf
echo "kernel.dmesg_restrict = 1" | sudo tee -a /etc/sysctl.d/50-dmesg-restrict.conf
echo "kernel.kptr_restrict = 1" | sudo tee -a /etc/sysctl.d/50-kptr-restrict.conf
echo "vm.swappiness = 5" | sudo tee -a /etc/sysctl.d/99-sysctl.conf #lowers swap value
sudo sysctl --system
sudo systemctl daemon-reload

#This tells you information about your network
ip addr >> networkconfig.log #Manjaro and Arch changed the way they display this Ifconfig doesn't work any longer

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [[ $? -eq 0 ]];
	then 
		echo "Connection successful"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		sudo dhclient -v -r && sudo dhclient
		sudo systemctl stop NetworkManager.service
		sudo systemctl disable NetworkManager.service
		sudo systemctl enable NetworkManager.service
		sudo systemctl start NetworkManager.service
		sudo ip link set $interface up #Refer to networkconfig.log
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
distribution=$(cat /etc/issue | awk '{print $1}')
for n in $distribution;
do
	if [[ $distribution == Manjaro ]];
	then
		sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syyu --noconfirm
		if [[ $? -eq 0 ]]; 
		then 
			echo "Update succeeded" 
		else
			sudo rm -f /var/lib/pacman/sync/*
			sudo rm /var/lib/pacman/db.lck 
			sudo rm -r /etc/pacman.d/gnupg 
			sudo pacman -Sy gnupg archlinux-keyring manjaro-keyring
			sudo pacman-key --init 
			sudo pacman-key --populate archlinux manjaro 
			sudo pacman-key --refresh-keys 
			sudo pacman -Sc
			sudo pacman -Syyu --noconfirm
		fi
	elif [[ $distribution == Antergos ]];
	then
		sudo pacman rankmirrors /etc/pacman.d/antergos-mirrorlist
		sudo pacman -Syyu --noconfirm
		if [[ $? -eq 0 ]]; 
		then 
			echo "update successful"
		else 
			sudo rm -f /var/lib/pacman/sync/*
			sudo rm /var/lib/pacman/db.lck 
			sudo rm -r /etc/pacman.d/gnupg 
			sudo pacman -Sy --noconfirm gnupg archlinux-keyring antergos-keyring
			sudo pacman-key --init
			sudo pacman-key --populate archlinux antergos 
			sudo pacman -Sc --noconfirm 
			sudo pacman -Syyu --noconfirm
		fi
	fi
done

read -p "Press Enter to continue."

#This installs extra software
echo "Would you like to install software?(Y/n)"
read answer
while [ $answer == Y ];
do
	echo "Here is a list of software to choose from"
	sleep 2
	echo "1 - bleachbit"
	echo "2 - gnome-disk-utility"
	echo "3 - ncdu"
	echo "4 - nmap"
	echo "5 - preload"
	echo "6 - hardinfo"
	echo "7 - lshw"
	echo "8 - hdparm"
	echo "9 - hddtemp xsensors"
	echo "10 - Code/text editor/IDE"
	echo "11 - htop iotop"
	echo "12 - wget"
	echo "13 - rkhunter"
	echo "14 - abiword gnumeric"
	echo "15 - bittorrent"
	echo "16 - net-tools"
	echo "17 - virtualbox"
	echo "18 - redshift"
	echo "19 - blender"
	echo "20 - cower"
	echo "21 - xed"
	echo "22 - wine"
	echo "23 - web browser"
	echo "24 - media player"
	echo "25 - antivirus"
	echo "26 - backup software"
	echo "27 - video and audio editing"
	echo "28 - shotwell"
	echo "29 - guvcview"
	echo "30 - A dock program"
	echo "31 - Audio/Video Decoding software"
	echo "32 - to skip"
		
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
		echo "This installs a light weight editor(text/code editor/IDE)"
		echo "1 - geany"
		echo "2 - sublime text editor"
		echo "3 - bluefish"
		echo "4 - atom"
		echo "5 - gedit"
		read package
		if [[ $package == 1 ]];
		then
			sudo pacman -S --noconfirm geany
		elif [[ $package == 2 ]];
		then
			wget https://aur.archlinux.org/cgit/aur.git/snapshot/sublime-text2.tar.gz
			gunzip sublime-text2.tar.gz && tar -xvf sublime-text2.tar
			cd /sublime-text2
			makepkg -si
		elif [[ $package == 3 ]];
		then
			sudo pacman -S --noconfirm bluefish
		elif [[ $package == 4 ]];
		then
			sudo pacman -S --noconfirm atom
		elif [[ $package == 5 ]];
		then
			sudo pacman -S --noconfirm gedit
		fi
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
		echo "This installs a virtual box utility"
		sudo pacman -S --noconfirm virtualbox
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
		echo "This installs windows emulation software"
		sudo pacman -S --noconfirm wine
;;
		23)
		echo "This installs your choice in browsers"
		echo "1 - chromium"
		echo "2 - epiphany"
		echo "3 - qupzilla"
		echo "4 - opera" 
		echo "5 - Pale Moon"
		echo "6 - seamonkey"
		echo "7 - dillo"
		echo "8 - lynx"
		echo "9 - vivaldi"
		echo "10 - google-chrome"
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
		elif [[ $browser == 5 ]];
		then
			sudo pacman -S --noconfirm palemoon-bin
		elif [[ $browser == 6 ]];
		then
			sudo pacman -S --noconfirm seamonkey
		elif [[ $browser == 7 ]];
		then
			sudo pacman -S --noconfirm dillo
		elif [[ $browser == 8 ]];
		then
			sudo pacman -S --noconfirm lynx
		elif [[ $browser == vivaldi ]];
		then
			wget https://aur.archlinux.org/cgit/aur.git/snapshot/vivaldi-snapshot.tar.gz
			gunzip vivaldi-snapshot.tar.gz
			tar -xvf vivaldi-snapshot.tar
			cd vivaldi
			makepkg -si
		elif [[ $browser == google-chrome ]];
		then
			wget https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz
			gunzip google-chrome.tar.gz
			tar -xvf google-chrome.tar
			cd google-chrome
			makepkg -si
		fi
;;		
		24)
		echo "This installs a choice in media players"
		echo "1 - xplayer"
		echo "2 - parole"
		echo "3 - kodi"
		echo "4 - Music"
		echo "5 - rhythmbox"
		echo "6 - mpv"
		echo "7 - VLC"
		echo "8 - totem"
		echo "9 - pragha"
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
			distribution=$(cat /etc/issue | awk '{print $1}')
			if [[ $distribution == manjaro ]];
			then
				sudo pacman -Rs --noconfirm vlc-nightly && sudo pacman -S vlc clementine
			else
				sudo pacman -S --noconfirm vlc
			fi
		elif [[ $player == 8 ]];
		then
			sudo pacman -s --noconfirm totem
		elif [[ $player == 9 ]];
		then
			sudo pacman -S --noconfirm pragha 
			echo "comes standard with antergos"
		fi
;;
		25)
		echo "This installs an antivirus if you think you need it"
		sudo pacman -S clamav clamtk 
;;
		26)
		echo "This installs your backup software"
		echo "1 - deja-dup"
		echo "2 - grsync"
		read package
		if [[ $package == 1 ]];
		then
			sudo pacman -S --noconfirm deja-dup
		elif [[ $package == 2 ]];
		then
			sudo pacman -S --noconfirm grsync
		fi
;;
		27)
		echo "This installs audio editing software and video editing software"
		sudo pacman -S --noconfirm kdenlive audacity
;;
		28)
		echo "This installs image organizing software"
		sudo pacman -S --noconfirm shotwell
;;
		29) 
		sudo pacman -S --noconfirm guvcview
;;
		30)
		echo "This installs plank, a popular dock application"
		sudo pacman -S --noconfirm plank
;;
		31)
		echo "This installs handbrake"
		sudo pacman -S --noconfirm handbrake
;;
		32)
		echo "We will skip this"
		break
;;
	esac
done

#This allows you to install any software you might know of that is not on the list
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

#This installs xfce4-goodies package on xfce versions of Manjaro
for env in $DESKTOP_SESSION
do
if [ $DESKTOP_SESSION == xfce ];
then
	sudo pacman -S --noconfirm xfce4-goodies
fi
done

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

#This will install hunspell and other language dependencies for popular software
echo "This will allow Libre-Office to utilize spell and grammar checking."
echo "Would you like to install extra language packs?(Y/n)"
read answer 
if [[ $answer == Y ]];
then 
	sudo pacman -S --noconfirm firefox-i18n-en-us thunderbird-i18n-en-us aspell-en gimp-help-en hunspell-en_US hunspell-en hyphen-en ttf-ms-fonts
fi

#This will set up screenfetch
sudo pacman -S --noconfirm  screenfetch
sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
echo "screenfetch" | sudo tee -a /etc/bash.bashrc

#As for themes #More are coming
echo "Would you like some extra themes? (Y/n)"
read answer
if [[ $answer == Y ]];
then
	sudo pacman -S --noconfirm adapta-gtk-theme moka-icon-theme faba-icon-theme arc-icon-theme  evopop-icon-theme elementary-xfce-icons xfce-theme-greybird numix-themes-archblue arc-gtk-theme menda-themes-dark papirus-icon-theme gtk-theme-breath 
else
	echo "Your desktop is void like my soul!"
fi 


#I can prepare a simple hosts file if you like from Steven Black
echo "Would  you like to use a hosts file to block adverts? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	while [ $? -eq 0];
	do
		wget https://raw.githubusercontent.com/thedummy06/Helpful-Linux-Shell-Scripts/master/Hostsman4linux.sh
		chmod +x Hostsman4linux.sh
	break
	done
	sudo ./Hostsman4linux.sh
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
			sudo systemctl start fstrim.timer
			sudo systemctl enable fstrim.service
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
echo "Aliases are shortcuts for commonly used commands."
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
	echo "#Alias to update the mirrors and sync the repos" >> ~/.bashrc
	echo 'alias mirrors="sudo pacman-mirrors -G && sudo pacman -Syy"' >> ~/.bashrc
fi

#This backsups the system assuming you have your external drive mounted to /mnt
host=$(hostname)
Mountpoint=$(lsblk | awk '{print $7}' | grep /run/media/$USER/*)
if [[ $Mountpoint != /run/media/$USER/* ]];
then
	read -p "Please insert a drive and hit enter"
	echo $(lsblk | awk '{print $1}')
	sleep 1 
	echo "Please select the device you wish to use"
	read device
	sudo mount $device /mnt
	sudo rsync -aAXv --delete --exclude={"*.cache/*","*.thumbnails/*"."*/.local/share/Trash/*"} /home/$USER /mnt/$host-backups
elif [[ $Mountpoint == /run/media/$USER/* ]];
then
	read -p "Found a block device at designated coordinates...
	If this is the preferred drive, unmount it, leave it plugged in, and run this again. Press enter to continue..."
fi

#This gives some useful information for later troubleshooting 
host=$(hostname)
distribution=$(cat /etc/issue | awk '{print $1}')
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEM INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "USER" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo $USER >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "DISTRIBUTION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo $distribution >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "DESKTOP_SESSION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo $DESKTOP_SESSION >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEM INITIALIZATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ps -p1 | awk 'NR!=1{print $4}' >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "DATE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
date >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "UPDATE CHANNEL" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
cat /etc/pacman-mirrors.conf | grep "Branch" >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "KERNEL AND OPERATING SYSTEM INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
uname -a >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "OPERATING SYSTEM RELEASE INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
lsb_release -a >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "HOSTNAME" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
hostname >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "UPTIME" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
uptime -p >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "LOAD AVERAGE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
cat /proc/loadavg >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "DISK SPACE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
df -h >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "MEMORY USAGE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
free -h >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "LISTS ALL BLOCK DEVICES WITH SIZE" >> $host-sysinfo.txt 
echo "##############################################################" >> $host-sysinfo.txt
lsblk -o NAME,SIZE >> $host-sysinfo.tx
echo"" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "BLOCK DEVICE ID " >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo blkid >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "NETWORK CONFIGURATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ip addr >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "NETWORK STATS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ss -tulpn >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "FIREWALL STATUS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo ufw status verbose >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "PROCESS LIST" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ps -aux >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "LAST LOGIN ATTEMPTS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
lastlog >> $host-sysinfo.txt
echo "" >> host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "INSTALLED PACKAGES" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo pacman -Q >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "Inxi" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
inxi -F >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "CPU TEMP" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sensors >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "HD TEMP" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo hddtemp /dev/sda >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo " DRIVER INFO" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo lsmod >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "USB INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
lsusb >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "HARDWARE INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
lspci >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "MORE HARDWARE INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo lshw >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "EVEN MORE HARDWARE INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo dmidecode >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "YET STILL MORE HARDWARE INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
lscpu >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "TLP STATS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo tlp-stat >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "LOGS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
sudo dmesg >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "MORE LOGS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
journalctl >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEMD BOOT INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
systemd-analyze >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "MORE SYSTEMD BOOT INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
systemd-analyze blame >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEMD STATUS" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
systemctl status | less >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEMD'S FAILED LIST" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
systemctl --failed >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "END OF FILE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt

#This will reboot your system 
sudo sync && sudo systemctl reboot
