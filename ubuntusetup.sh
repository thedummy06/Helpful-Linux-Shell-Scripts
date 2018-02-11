#!/bin/bash

#This sets your default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This activates the firewall
sudo systemctl enable ufw
sudo ufw enable
echo "Would you like to deny ssh and telnet for security purposes?(Y/n)"
read answer
if [[ $answer == Y ]];
then
	sudo ufw deny telnet && sudo ufw deny ssh
	sudo ufw reload
fi

ip addr >> networkconfig.log

#This will ensure you do not have any common network issues
for c in computer; 
do 
	ping -c4 google.com > /dev/null
	if [[ $? -eq 0 ]];
	then 
		echo "Connection successful!"
	else
		interface=$(ip -o -4 route show to default | awk '{print $5}')
		sudo dhclient -v -r && sudo dhclient
		sudo mmcli nm enable false 
		sudo nmcli nm enable true
		sudo /etc/init.d/ network-manager restart
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
	sudo update-grub2
else
	echo "Okay!"
fi

#This will update your system
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade 

read -p "Press Enter to continue."
	
#This installs other software that may be useful
echo "Would you like to install some extra packages that I've deemed useful?(Y/n)"
read answer
while [ $answer == Y ];
do
	echo "Here is a list of software, just enter a number to install the corresponding packages"
	sleep 2
	echo "1 - light weight IDE or code editor"
	echo "2 - rootkit checker"
	echo "3 - guake drop down terminal"
	echo "4 - gnome-tweak-tool"
	echo "5 - browser"
	echo "6 - Media/Music player"
	echo "7 - Bittorrent client"
	echo "8 - zenmap"
	echo "9 - video editing, audio editing"
	echo "10 - pidgin"
	echo "11 - light office applications"
	echo "12 - clamav"
	echo "13 - gparted partitioning tool"
	echo "14 - bleachbit cleaning software"
	echo "15 - ncdu"
	echo "16 - iotop, htop"
	echo "17 - hdparm disk configuring software"
	echo "18 - xsensors hddtemp lm-sensors temperature checking software"
	echo "19 - traceroute"
	echo "20 - hardinfo"
	echo "21 - gufw"
	echo "22 - preload"
	echo "23 - guvcview"
	echo "24 - graphical software managers"
	echo "25 - Handbrake Audio decoding"
	echo "26 - Steam client"
	echo "27 - get out of this menu"

	read software;
		
	case $software in

		1)
		sudo apt-get -y install geany 
;;
		2)
		sudo apt-get -y install rkhunter
;;
		3)
		sudo apt-get -y install guake
;;
		4) 
		sudo apt-get -y install gnome-tweak-tool
;;
		5)
		echo "This installs your choice of browser"
		echo "1 - Chromium"
		echo "2 - epiphany"
		echo "3 - qupzilla"
		echo "4 - midori"
		echo "5 - Google-Chrome"
		echo "6 - Pale Moon"
		echo "7 - Vivaldi"
		read browser
		if [[ $browser == 1 ]];
		then
			sudo apt-get -y install chromium
		elif [[ $browser == 2 ]];
		then
			sudo apt-get -y install epiphany
		elif [[ $browser == 3 ]];
		then
			sudo apt-get -y install qupzilla
		elif [[ $browser == 4 ]];
		then
			sudo apt-get -y install midori
		elif [[ $browser == 5 ]];
		then
			cd /tmp
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			sudo dpkg -i google-chrome-stable_current_amd64.deb
			sudo apt-get -f install
		elif [[ $browser == 6 ]];
		then
			wget http://linux.palemoon.org/datastore/release/pminstaller-0.2.4.tar.bz2
			tar -xvjf pminstaller-0.2.3.tar.bz2
			./pminstaller.sh
		elif [[ $browser == 7 ]];
		then
			wget https://downloads.vivaldi.com/snapshot/vivaldi-snapshot_1.15.1094.3-1_amd64.deb
			sudo dpkg -i vivaldi-stable_1.13.1008.40-1_amd64.deb
			sudo apt-get install -f 
		fi
;;
		6)
		echo "This installs your choice of media players/music players"
		echo "1 - VLC"
		echo "2 - rhythmbox"
		echo "3 - banshee"
		echo "4 - parole"
		echo "5 - clementine"
		echo "6 - mplayer"
		echo "7 - kodi"
		read player
		if [[ $player == 1 ]];
		then
			sudo apt-get -y install vlc
		elif [[ $player == 2 ]];
		then
			sudo apt-get -y install rhythmbox
		elif [[ $player == 3 ]];
		then
			sudo apt-get -y install banshee
		elif [[ $player == 4 ]];
		then
			sudo apt-get -y install parole
		elif [[ $player == 5 ]];
		then
			sudo apt-get -y install clementine
		elif [[ $player == 6 ]];
		then
			sudo apt-get -y install mplayer
		elif [[ $player == 7 ]];
		then
			sudo apt-get install software-properties-common
			sudo add-apt-repository ppa:team-xbmc/ppa
			sudo apt-get update
			sudo apt-get -y install kodi
		fi
;;
		7)
		echo "This installs your choice of bittorrent client"
		echo "1 - transmission-gtk"
		echo "2 - deluge"
		echo "3 - qbittorrent"
		read client
		if [[ $client == 1 ]];
		then
			sudo apt-get -y install transmission-gtk
		elif [[ $client == 2 ]];
		then
			sudo apt-get -y install deluge
		elif [[ $client == 3 ]];
		then
			sudo apt-get -y install qbittorrent
		fi
;;
		8)
		echo "This installs zenmap and nmap to scan networks with"
		sudo apt-get -y install zenmap nmap
;;
		9)
		echo "This installs video and audio editing software"
		sudo apt-get -y install kdenlive audacity
;;
		10)
		echo "Most installations come with this, but certain distros do not install this by default"
		sudo apt-get -y install pidgin
;;
		11)
		echo "This installs lightweight office applications"
		sudo apt-get -y install abiword gnumeric
;;
		12)
		echo "This installs clam antivirus if you think you need it"
		sudo apt-get -y install clamav
;;
		13)
		echo "This installs a partitioning tool"
		sudo apt-get -y install gparted
;;
		14)
		echo "This installs cleaning software"
		sudo apt-get -y install bleachbit
;;
		15)
		echo "This will install a command line disk space utility"
		sudo apt-get -y install ncdu
;;
		16)
		echo "This installs iotop and htop to allow you to monitor in nearly realtime what your system is doing"
		sudo apt-get -y install htop iotop
;;
		17)
		echo "This installs software to allow you to control write-back-caching"
		sudo apt-get -y install hdparm
;;
		18)
		echo "This installs temperature monitoring software"
		sudo apt-get -y install lm-sensors xsensors hddtemp
;;
		19)
		echo "This installs extra networking tools"
		sudo apt-get -y install traceroute
;;
		20)
		echo "This installs hardinfo a graphical way to find hardware information"
		sudo apt-get -y install hardinfo
;;
		21)
		echo "This installs a graphical front end to the firewall we enabled earlier"
		sudo apt-get -y install gufw
;;
		22)
		echo "This installs a preloader to store applications in memory for faster loading"
		sudo apt-get -y install preload
;;
		23)
		echo "This installs guvcview for webcam"
		sudo apt-get install guvcview
;;
		24)
		echo "This installs your graphical software managers"
		sudo apt-get install -y gdebi synaptic
;;
		25)
		echo "This installs handbrake"
		sudo apt-get install -y handbrake
;;
		26)
		echo "This installs your steam client"
		sudo apt-get install steam
;;
		27)
		echo "Aight den!"
		break
;;
	esac
done

echo "Is there any other software you'd like to install?(Y/n)"
read answer 
while [ $answer == Y ];
do 
	echo "Enter the name of the software you wish to install"
	read software
	sudo apt-get -y install $software
break
done

#This tries to install codecs
echo "This will install codecs." 
echo "These depend upon your environment."

for env in $DESKTOP_SESSION;
do
	if [[ $DESKTOP_SESSION == unity ]];
	then
		sudo apt-get -y install ubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == xfce ]];
	then
		sudo apt-get -y install xubuntu-restricted-extras
		sudo apt-get -y install xfce4-goodies
	elif [[ $DESKTOP_SESSION == kde ]];
	then
		sudo apt-get -y install kubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == lxde ]];
	then 
		sudo apt-get -y install lubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == mate ]];
	then
		sudo apt-get -y install ubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == gnome ]];
	then
		sudo apt-get -y install ubuntu-restricted-extras
	else
		echo "You're running some other window manager I haven't tested yet."
	fi
done

#Optional
echo "Would you like to install games? (Y/n)" 
read Answer
if [[ $Answer == Y ]];
then 
	sudo apt-get -y install supertuxkart gnome-mahjongg aisleriot ace-of-penguins gnome-sudoku gnome-mines chromium-bsu supertux
else
	echo "Moving on!"
fi 

#More optional software
echo "Would you like to install microsoft fonts?(Y/n)"
read answer
while [ $answer == Y ];
do
	sudo apt-get install ttf-mscorefonts-installer
break
done

#This will install themes
echo "Would you like a dark theme? (Y/n)"
read answer 
if [[ $answer == Y ]]; 
then
	sudo add-apt-repository -y ppa:noobslab/themes 
	sudo apt-add-repository -y ppa:numix/ppa
	sudo add-apt-repository -y ppa:noobslab/icons
	sudo add-apt-repository -y ppa:moka/stable
	sudo apt-get update
	sudo apt-get -y install mate-themes gtk2-engines-xfce gtk3-engines-xfce numix-icon-theme-circle emerald-icon-theme moka-icon-theme windows-10-themes dalisha-icons faenza-icon-theme
else
	echo "Guess not!"
fi

#System tweaks
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i -e '/GRUB_TIMEOUT=10/c\GRUB_TIMEOUT=3 ' /etc/default/grub
sudo update-grub2

#Tweaks the sysctl config file
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "# Reduces the swap" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "# Improve cache management" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "#tcp flaw workaround" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#This locks down ssh for security
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak 
sudo sed -i -e '/#PermitRootLogin/c\PermitRootLogin no ' /etc/ssh/sshd_config

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
		echo "Trim is already enabled on Ubuntu-based systems\
		however, you can still run it manually if you'd like."
		echo "Would you like to run Trim?(Y/n)"
		read answer 
		while [ $answer == Y ];
		do 
			sudo fstrim -v /
		break
		done
	fi
done

#Hosts file to block adverts
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./Hostsman4linux.sh
else 
	echo "Maybe later!"
fi

#This adds a few aliases to bashrc
echo "Aliases are shortcuts to commonly used commands."
echo "would you like to add some aliases?(Y/n)"
read answer 

if [[ $answer == Y ]];
then 
	sudo cp ~/.bashrc ~/.bashrc.bak
	echo "#Alias to update the system" >> ~/.bashrc
	echo 'alias update="sudo apt-get update && sudo apt-get -y dist-upgrade"' >> ~/.bashrc
	echo "#Alias to clean the apt cache" >> ~/.bashrc
	echo 'alias clean="sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get clean"' >> ~/.bashrc
	echo "#Alias to update hosts file" >> ~/.bashrc
	echo 'alias hostsup="sudo ./Hostsman4linux.sh"' >> ~/.bashrc
fi

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

#This tries to backup your system
host=$(hostname)
Mountpoint=$(lsblk |awk '{print $7}' | grep /run/media/$USER/*)
if [[ $Mountpoint != /run/media/$USER/* ]];
then
	read -p "Please enter a drive and hit enter"
	echo $(lsblk | awk '{print $1}')
	sleep 1 
	echo "Please select the device you wish to use"
	read device
	sudo mount $device /mnt
	sudo rsync -aAXv --delete --exclude=.cache --exclude=.thumbnails --exclude=Music --exclude=Wallpapers /home/$USER /mnt/$host-backups
else
	echo "Found a block device at designated coordinates, if this is the preferred
	device, try umounting it and then running this again."
fi

#This gives some useful information for later troubleshooting 
host=$(hostname)
distribution=$(cat /etc/issue | awk '{print $1}')
echo "##############################################################" >> $host-sysinfo.txt
echo "SYSTEM INFORMATION" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
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
echo "SYSTEM INIT" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ps -p1 | awk 'NR!=1{print $4}' >> $host-sysinfo.txt	
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "DATE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
date >> $host-sysinfo.txt
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
uptime >> $host-sysinfo.txt
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
lsblk -o NAME,SIZE >> $host-sysinfo.txt
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
echo "PROCESS LIST" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
ps -aux >> $host-sysinfo.txt
echo "" >> $host-sysinfo.txt
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
echo "" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt
echo "END OF FILE" >> $host-sysinfo.txt
echo "##############################################################" >> $host-sysinfo.txt

#Let's reboot
sudo sync && sudo systemctl reboot
