# Beginner-linux-scripts
These are scripts for beginners to linux, to help setup their systems.
You might have to type sudo chmod +x to make them executable on your system.
When you are ready to use one of these scripts just call it in the terminal or commandline as
./scriptname.sh as for the hosts file updater, right now the simplest way to get it to work is to run it as
sudo ./hostsman4linux.sh and the same goes for the manjaro version. 
The main difference between the two is the use of systemd as an init meaning that it loads everything on your system.
Debian is not included specifically(yet), but many of the ubuntu commands will still work, it's just that some services require the use of /etc/init.d which is like system d and sysvinit which is commonly used, but different. 
Many distros are going towards systemd now, so soon everything will be universal. 
Below is a simple set of instructions should you need them. 
          
          Instructions:
#This is pretty much the same as the others, to use these scripts
#Make sure that all of them are moved to your home folder. 
#Do  NOT leave them
#In the parent folder that they came in. (If any)
#You must open a terminal... terminology or xterm 
#And you must type the script name as follows :
# ./SCRIPTNAME or ./SCRIPTNAME.sh
#I recommend running the script titled ubuntusetup.sh/bodhisetup.sh first after
#Clean installation of your chosen Ubuntu based or Debian based distro.
#Reboot, then run ./update.sh to familiarize yourself with the use of the #script in the terminal (This also checks for any packages you missed)
#Then run ./nvidia-installer.sh Reboot 
#Then install any applications you might desire through the use of
#Your distro's package store or through synaptic
#To pull up synaptic, go into terminal and type sudo synaptic
#Give your password when asked and it should pull up synaptic.
#Type any package name or ideas you have into the search field.
#This is not a perfect work, but I am learning as you might be to the new #user.
#Give a copy to your friends and/or loved ones also. 
#I will try to leave links to popular Youtubers, wikis, and forums for your #convenience. They will be in the Disclaimer.
#Remember to always run the hostsman4linux.sh script as root
#To gain root access in terminal type sudo 
#Then the script ./hostsman4linux.sh then your password
#That's the simplest way to make it work without adding extra lines of code
#And making all these extra changes to the tmp directory
#I've included my own small hosts list to add to the hosts file. 
#As for the hosts file, if you notice that your system doesn’t block #certain domains
#Try refreshing your connection by typing sudo service network-manager #restart or
#Sudo /etc/init.d/nscd restart(Already added that in the script)
#Depending upon your distro Debian/Ubuntu and whether or not nscd is #installed.
#I added a separate bodhisetup script also, as to not confuse you.
#As for Bodhilinux you could just use sudo apt-get install bodhi-apppack
#which I added in the optional software list, however, those applications #tend to be heavier and assume you have newer hardware. 
#I can not be held liable for damages done on the part of these scripts,
#however, I have tested almost every command thoroughly. 
#It is wise to read these scripts in your spare time to get a feel for 
#what they do.
#I added as many tweaks to the setup scripts as I could, however, 
#you can also run the trim command manually as in sudo fstrim /, 
#but it shouldn't be used all the time, fstrim can cause as much a decrease #in performance as it can an increase. It is enabled automatically in 
#ubuntu 14.04 and higher on a per case basis.
#Ubuntu detects your drive and manufacturer before running trim weekly.
#A debatable tweak is to open a terminal 
#and run sudo nano /etc/fstab and on the / partition between the filesystem
#and errors, putting noatime, in should reduce the last access logging,
#thus slightly improving drive performance.
#As far as I know it works with most any type of drive, however, I don't 
#use it enough to be sure.
#Furthermore, Linux Mint users should be fine to use the ubuntu set up #script as well.
#It doesn't require the rigorous package installation so much because #everything is already installed, however, it will require the firewall to #be turned on and a few tweaks added into the script. It would also be a #good idea to install ncdu, preload, and lm-sensors so that you can better #monitor your system temps and disk usage. You are free to comment #everything else in the software installer section out. Should you choose #to run the script as it is, it will merely skip over the software it #already #has anyway, so there is really no harm either way.
#If you use special printers, it is likely there is some kind of makeshift #driver for it, however, you will have to search synaptic on your own for #that. 
#There are a few printers, scanners not supported yet in linux, keep that #in mind as you are coming over as a new user. Most keyboards and #peripherals
#work fine within the new versions of ubuntu linux and as far as I know it #isn't only a kernel issue if they don't lately ubuntu has switched to #systemd initialization manager and that has made certain things act funky #on old or odd hardware. If systemd riddled 16.04 doesn't work for you, try #14.04 or Linux Mint 17.3
#The nvidia-installer.sh script is more for bodhi systems, but should work #the same in ubuntu, haven't tested that yet, but you are free to use the #gui. 
#quidsup.net for more scripts to install new versions of deluge bittorrent 
#and simple screen recorder. Also some other useful scripts on there as well.
#Check out his page. 
#For people on Radeon graphics, it's probably best to download the proper #driver from the website http://support.amd.com/en-us/download but for #those of you who don't use intense games, fglrx is a good opensource #alternative. It has everything you'd need in a separate driver. The #trouble is that 14.04.5 of ubuntu and its derivatives don't really seem to #like it at this time. The simplest way to install it would be your #standard sudo apt-get install fglrx and then reboot if no warnings show up #and hope for the best.
#I added some commands in cleanandfix.sh to help determine if your version
#of xorg can handle it. Radeon users may still wanna hold off on updating #to 16.04 LTS right now.
#A good redistribute and backup program is remastersys, the software install
#collection now has this added in ubuntusetup.sh bodhi didn't need it #because it is already there just click on esudo in system tools and type in
#remastersys. It creates a live cd of your current system. Makes backing up
#painless.
#What's more, I'd suggest running the hosts file updater as root in crontab
#type sudo crontab -e and hit the corresponding number to the editor
# of your choice and follow the syntax in this notice:
#00 15 * * 3  /bin/bash  /home/$USER/hostsman4linux.sh >> hosts.log
#That should run the hosts updater at 3:pm every wednesday, however
#You can use whatever time you wish, just remember it's in military time.
#If you're having problems reading the log file output from cleanandfix.sh don't #worry about it, lots of people do, but having an account with ubuntu, linuxmint, or #bodhi forums is a helpful tool. Lots of people on the forums have seen those #before, because they had to read them. They can help. All the output from these
#will be placed in its own directory called troubleshooting. 
#I may add more features to the maintenance scripts in the future, I may not, but if #you have something to add, just let me know by email so I'll know what to expect.
#I also added a usbimagewriter.sh script that will allow you to easily write new linux distros to usb devices
#It is very simple by design, however, the default directory that it looks in is Downloads, if that is not where
#you save .iso images, I'd change that in a text editor.
#I recently merged my pimpmyubuntu script with the setup scripts so you should get 
#some really good themes from it, these themes are from ravefinity.com, go there 
#for more. 
#One more thing about the hosts updater, if you run as root crontab job, cron will not look in home folder unless the script 
#is told to do so. In which case, I commented out the line cd /home/$USER, assuming your username is the one with the files inside.
#This, as far as I know, is only needed for root cron jobs.
