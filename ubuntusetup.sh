#!/bin/bash

#This sets your default editor in bashrc
echo "export EDITOR=nano" | sudo tee -a /etc/bash.bashrc

#This activates the firewall
sudo systemctl enable ufw
sudo ufw enable
echo "Would you like to deny ssh and telnet for security purposes?(Y/n)"
read answer
if [ $answer == Y ]
then
	sudo ufw deny telnet && sudo ufw deny ssh
	sudo ufw reload
fi

ip addr >> networkconfig.log

#This will ensure you do not have any common network issues
for c in computer; 
do 
	ping -c4 google.com > /dev/null
	if [ $? -eq 0 ]
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

#This will install your main apps for you   
sudo apt-get -y install gparted bleachbit ncdu gufw inxi iotop xsensors hardinfo lm-sensors traceroute nmap htop
#Optional
#sudo apt-get -y install rkhunter
#sudo apt-get -y install clamav
#sudo apt-get -y install qupzilla
#sudo apt-get -y install midori
#sudo apt-get -y install abiword gnumeric #Lightweight office apps
#sudo apt-get -y install rhythmbox
#sudo apt-get -y install gnome-tweak-tool
#sudo apt-get -y install pidgin
#sudo apt-get -y install parole
#sudo apt-get -y install banshee
#sudo apt-get -y install deluge
#sudo apt-get -y install qbittorrent
#sudo apt-get -y install simplescreenrecorder
#sudo apt-get -y install kdenlive
#sudo apt-get -y install pavucontrol
#sudo apt-get -y install chromium-browser
#sudo apt-get -y install zenmap
#sudo apt-get -y install epiphany-browser

#This tries to install codecs
echo "This will install codecs." 
echo "These depend upon your environment."

for env in $DESKTOP_SESSION;
do
	if [[ $DESKTOP_SESSION == unity ]];
	then
		sudo apt-get install ubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == xfce ]];
	then
		sudo apt-get install xubuntu-restricted-extras
		sudo apt-get install xfce4-goodies
	elif [[ $DESKTOP_SESSION == kde ]];
	then
		sudo apt-get install kubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == lxde ]];
	then 
		sudo apt-get install lubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == mate ]];
	then
		sudo apt-get install ubuntu-restricted-extras
	elif [[ $DESKTOP_SESSION == gnome ]];
	then
		sudo apt-get install ubuntu-restricted-extras
	else
		echo "You're running some other window manager I haven't tested yet."
	fi
done

#Optional ligthweight web browser alternative
echo "Would you like to install a good firefox alternative? (Y/n)"
read answer
if [[ answer == Y ]];
then
	wget https://linux.palemoon.org/datastore/release/pminstaller-0.2.3.tar.bz2
	tar -xvjf pminstaller-0.2.3.tar.bz2
	./pminstaller.sh
else 
	echo "Pale Moon is private and secure."
fi 

#Optional from askubuntu.com method to install google-chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -f install

#Optional
echo "Would you like to install games? (Y/n)" 
read Answer
if [[ $Answer == Y ]];
then 
	sudo apt-get -y install supertuxkart gnome-mahjongg aisleriot ace-of-penguins gnome-sudoku gnome-mines chromium-bsu supertux
else
	echo "Moving on!"
fi 

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

#Hosts file to block adverts
echo "Would  you like to use a hosts file? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./Hostsman4ubuntu.sh
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
	echo 'alias apt clean="sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get clean"' >> ~/.bashrc
	echo "#Alias to update hosts file" >> ~/.bashrc
	echo 'alias hostsman="sudo ./Hostsman4ubuntu.sh"' >> ~/.bashrc
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

#This gives you useful information about your system
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

#Let's reboot
sudo sync && sudo systemctl reboot
