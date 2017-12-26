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
sudo touch /etc/sysctl.d/50-dmesg-restrict.conf
sudo touch /etc/sysctl.d/50-kptr-restrict.conf
sudo touch /etc/sysctl.d/99-sysctl.conf
echo "kernel.dmesg_restrict = 1" | sudo tee -a /etc/sysctl.d/50-dmesg-restrict.conf
echo "kernel.kptr_restrict = 1" | sudo tee -a /etc/sysctl.d/50-kptr-restrict.conf
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-sysctl.conf #lowers swap value
sudo sysctl --system
sudo systemctl daemon-reload

#This tells you information about your network
ip addr >> networkconfig.log #Manjaro and Arch changed the way they display this Ifconfig doesn't work any longer

#This will try to ensure you have a strong network connection
for c in computer;
do 
	ping -c4 google.com 
	if [ $? -eq 0 ]
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
while [[ $answer == Y ]];
do
	sudo cp /etc/default/grub /etc/default/grub.bak 
	sudo sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
	echo "You can also change the boot timeout to something shorter, must warn you, you won't be able to change kernels if it is too low."
	echo "Would you like to change the boot timeout?(Y/n)"
	read answer 
	if [ $answer == Y ];
	then
		sudo sed -i -e '/GRUB_TIMEOUT=5/c\GRUB_TIMEOUT=3 ' /etc/default/grub
	else 
		echo "I'd do the same thing in your position."
	fi
	sudo grub-mkconfig -o /boot/grub/grub.cfg
break
done
	
#This tries to update and rate mirrors if it fails it refreshes the keys
for s in updates;
do 
	sudo pacman-mirrors -f
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
sudo pacman -S --noconfirm bleachbit gnome-disk-utility ncdu nmap hardinfo lshw hdparm hddtemp xsensors wget geany htop iotop clementine 
#Optional
#sudo pacman -S --noconfirm rkhunter
#sudo pacman -S --noconfirm xed
#sudo pacman -S --noconfirm transmission-gtk
#sudo pacman -S --noconfirm pacaur
#sudo pacman -S --noconfirm redshift
#sudo pacman -S --noconfirm abiword gnumeric #lightweight office apps
#sudo pacman -S --noconfirm blender
#sudo pacman -S --noconfirm qbittorrent
#sudo pacman -S --noconfirm net-tools 
sudo pacman -RS --noconfirm vlc-nightly && sudo pacman -S --noconfirm vlc
#sudo pacman -S --noconfirm clamav
#sudo pacman -S --noconfirm clamtk
#sudo pacman -S --noconfirm qupzilla 
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
#sudo pacman -S --noconfirm xplayer

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

#This will install hunspell and other language dependencies for popular software
echo "This will allow Libre-Office to utilize spell and grammar checking."
echo "Would you like to install extra language packs?(Y/n)"
read answer 
if [[ $answer == Y ]];
then 
	sudo pacman -S --noconfirm firefox-i18n-en-us thunderbird-i18n-en-us aspell-en gimp-help-en hunspell-en_US hunspell-en hyphen-en
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
	sudo pacman -S --noconfirm moka-icon-theme faba-icon-theme arc-icon-theme  evopop-icon-theme elementary-xfce-icons xfce-theme-greybird numix-themes-archblue 
	sudo pacman -S --noconfirm arc-gtk-theme menda-themes-dark papirus-icon-theme gtk-theme-breath obsidian-icon-theme
else
	echo "Your desktop is void like my soul!"
fi 

#I can prepare a simple hosts file if you like from Steven Black
echo "Would  you like to use a hosts file to block adverts? (Y/n)"
read answer
if [[ $answer == Y ]];
then 
	sudo ./Hostsman4manjaro.sh
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
	echo "#Alias to update hosts file" >> ~/.bashrc
	echo 'alias hostsman="sudo ./Hostsman4manjaro.sh"' >> ~/.bashrc
	echo "#Alias to update the mirrors and sync the repos" >> ~/.bashrc
	echo 'alias mirrors="sudo pacman-mirrors -g && sudo pacman -Syy"' >> ~/.bashrc
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

#This gives some useful information for later troubleshooting 
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
