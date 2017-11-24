#!/bin/bash

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


