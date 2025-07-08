#!/bin/bash

#Check for --chrooted argument to determine if it's Phase 2
if [[ "$1" == "--chrooted" ]]; then
	#Set a flag to indicate Phase 2 execution
	_run_phase2_flag=true
else
	#Set a flag to indicate Phase 1 execution
	_run_phase2_flag=false
fi

# --- PHASE 1 & 3 LOGIC STARTS HERE ---
if [ -f /phase3/triger.txt ];
then
	#Start on system boot
	systemctl enable ufw
	systemctl enable NetworkManager
	#ufw quick config
	ufw default deny incoming
	ufw default allow outgoing
	ufw enable
	#Turn networkmanager on
	systemctl start NetworkManager
	printf "Do you need wifi (y/n):"
	read neednetwork
if [[ "$neednetwork" =~ ^[Yy]$ ]];
then
	 nmcli device wifi list
	 printf "Whats your ssid:"
	 read netname
	 nmcli device wif connect $netname --ask
fi
	#gnome install
	echo "grabing gnome"
	pacman -S gnome gdm
	systemctl enable gdm
	
	#Clean addos install script and dirs
	clear
	echo "addos cleaning"
	cd /
	rm -r /phase3
	rm -- "$0"
	reboot
elif [[ "$_run_phase2_flag" == "false" ]];
then
#Check if the user is root
if [ "$EUID" -ne 0 ]; then
	#Proceed with root check failure
	echo "Please run this script as root or using sudo."
	echo "You may run 'sudo !!' to rerun the previous command as root."
	exit 1
fi
	#Proceed with root check success
	echo "Root check completed, proceeding..."
	#Check if the script is on Arch
if [  ! -f /etc/arch-release ]; then
	#Proceed with Arch check failure
	echo "This install script is only for Arch Linux and will break other systems. Please run this in Arch Linux."
	exit 1
fi
	#Proceed with Arch check success
	echo "Arch Linux check completed, proceeding..."
	#User verification check
	read -p "This script is in Alpha, features are missing and can break. Confirmations before dangerous actions do not exist at this point and may break your system. Do you want to proceed? (y/N): " -n 1 -r
	echo #Add a newline after the prompt
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
	#Proceed with user verification check failure
	echo "Operation cancelled. Exiting."
	exit 1
fi
#Proceed with user verification check success
clear
echo "+==============================================+"
echo "|         _    ____  ____                      |"
echo "|        / \  |  _ \|  _ \        ___  ___     |"
echo "|       / _ \ | | | | | | |_____ / _ \/ __|    |"
echo "|      / ___ \| |_| | |_| |_____| (_) \__ \    |"
echo "|     /_/   \_\____/|____/       \___/|___/    |"
echo "| Owned and maintained by add2wd               |"
echo "| With the help of LandenHM                    |"
echo "+==============================================+"
read -n 1 -s -r -p "Press any key to continue..."
loadkeys us
#Disk selection
clear
#--re-wright-inprog--
echo "Warning both options erase data backup all important data before continuing"
echo "I am not lyable for data loss you have been warned"

#Start disk partition or disk wipe (start)
echo "If you have a wiped disk pick 1 need to wipe your disk pick 2"
echo "(1): Pick a disk and format style" 
echo "(2): Wipe a disk for use"
printf "(1/2):"
read diskopti
if [[ "$diskopti" =~ ^[1]$ ]];
then
	clear
	lsblk
	printf "Pick your disk (eg. sda):"
	read diskname
	clear
else
	clear
	lsblk
	printf "Pick a disk to erase (eg. sda):"
	read diskname
	blkdiscard -f /dev/"$diskname"
	clear
fi
#Start disk partition or disk wipe (end)

#pick disk partition style and start (start)
echo "Pick your disk partition style
(1)Basic partition 1G boot 4G swap leftover root
(2)Home partition included 16G root
(---YOU-CAN-PICK-PARTITION-SIZE---)
(3)Basic user config
(4)Home user config"
printf "(1/2/3/4):"
read partstyle
sleep 4

if [[ "$partstyle" =~ ^[1]$ ]];
then	
# fdisk script for the basic partitioning
fdisk /dev/"$diskname" <<EOF
g
n


+1G
n


+4G
n



w
EOF

else 
#fdisk script for the home partitioning
fdisk /dev/"$diskname" <<EOF
g
n


+1G
n


+4G
n


+16G
n



w
EOF
fi
clear
#pick disk partition style and start (end)

#partition taging (start)
if [[ "$partstyle" =~ ^[1]$ ]];
then
	#partition tag for basic
	echo "Auto Partitioning is complete..."
	lsblk
	sleep 3
	clear
	nvmedat="nvme"
#nvme auto detect1 (start)
if [[ "$diskname" == *"$nvmedat"* ]];
then
  	nvmemode=0
  	printf "Partition with nvme in mind"
  	sleep 3
else 
  	nvmemode=1
  	printf "Partition without nvme in mind"
  	sleep 3
fi
if [[ "$nvmemode" -eq 1 ]];
then
	str1=1
	str2=2
	str3=3
else
	str1="p1"
	str2="p2"
	str3="p3"
fi
#nvme auto detect1 (end)
else
	#partition tag for home
	echo "Auto Partitioning is complete..."
	lsblk
	sleep 3
	clear
	nvmedat="nvme"
#nvme auto detect2 (start)
if [[ "$diskname" == *"$nvmedat"* ]]
then
	nvmemode=0
	printf "Partition with nvme in mind"
	sleep 3
else 
	nvmemode=1
	printf "Partition without nvme in mind"
	sleep 3
fi
if [[ "$nvmemode" -eq 1 ]]; then
	str1=1
	str2=2
	str3=3
	str4=4
else
	str1="p1"
	str2="p2"
	str3="p3"
	str4="p4"
    fi
#nvme auto detect2 (end)
fi
#partition taging (end)

#mkfs disk (start)
if [[ "$partstyle" =~ ^[1]$ ]];
then
	#mkfs basic
	printf "Starting mkfs..."
	mkfs.fat -F 32 /dev/"$diskname""$str1"
	mkswap /dev/"$diskname""$str2"
	mkfs.ext4 -F /dev/"$diskname""$str3"
	clear
	printf "mkfs is complete."
	sleep 4
	clear
else
	#mkfs home
	printf "Starting mkfs..."
	mkfs.fat -F 32 /dev/"$diskname""$str1"
	mkswap /dev/"$diskname""$str2"
	mkfs.ext4 -F /dev/"$diskname""$str3"
	mkfs.ext4 -F /dev/"$diskname""$str4"
	clear
	printf "mkfs is complete."
	sleep 4
	clear
fi
#mkfs disk (end)

#Mount disk (start)
if [[ "$partstyle" =~ ^[1]$ ]];
then
	#Mount disk basic
	printf "Attempting mount..."
	mount /dev/"$diskname""$str3" /mnt
	mount --mkdir /dev/"$diskname""$str1" /mnt/boot
	swapon /dev/"$diskname""$str2"
	sleep 2
	clear
else
	#Mount disk home
	printf "Attempting mount..."
	mount /dev/"$diskname""$str3" /mnt
	mount --mkdir /dev/"$diskname""$str1" /mnt/boot
	mount --mkdir /dev/"$diskname""$str4" /mnt/home
	swapon /dev/"$diskname""$str2"
	sleep 2
	clear
fi
#Mount disk (end)

echo "Mount complete..."
echo "There is a 6-second delay; the script is still running."
lsblk
sleep 6
clear
#--re-wright-inprog--
# If else for wifi if connection is needed eg vm or ethernet
# Probably should add something in the future telling the user if they have internet set up already, and are going to use it in their install theu should press Y
printf "Enable Wi-Fi? Type N if you have ethernet or are using a virtual machine with network passthrough. (y/N):"
read neednetwork
if [[ "$neednetwork" =~ ^[Yy]$ ]];
then
	#Next up is networking
	ip link
	printf "Pick your network interface:"
	read wifi
	#Show networks
	iwctl station "$wifi" scan
	iwctl station "$wifi" get-networks
	#Find network and prepare connect
	printf "What's your network SSID? Double-check this:"
	read network
	#iwctl connects to network
	iwctl station "$wifi" connect "$network"
fi
clear
#Pacman reflector
echo "Grabing pacman repos"
pacman -Sy pacman-contrib
sleep 5
rankmirrors -n 6 /etc/pacman.d/mirrorlist
clear

#pacstrap
echo "Starting pactrap..."
sleep 4
pacstrap -K /mnt base linux linux-firmware
clear

#Genfstab
genfstab -U /mnt >> /mnt/etc/fstab
clear
printf "Chrooting into installed system."
sleep 4
clear

#Create /mnt/mnt for chroot
cp addosinstall.sh /mnt/mnt
chmod +x /mnt/mnt/addosinstall.sh
arch-chroot /mnt /mnt/addosinstall.sh --chrooted
# --- PHASE 1 LOGIC ENDS HERE ---

#exit and reboot should comence after stage2 aka chroot
umount -R /mnt
clear
echo "Chroot done base system installed."
echo "After reboot log into root and run /mnt/addosinstall.sh"
read -n 1 -s -r -p "Remove this install media and press any key to reboot..."
reboot
fi

# --- PHASE 2 LOGIC STARTS HERE ---
if [[ "$_run_phase2_flag" == "true" ]]; then
echo "Entering chroot"
echo "Next stage started for addos"
sleep 4

#Set country
ls /usr/share/zoneinfo/
echo "Pick your country (e.g., America):"
read region
clear

#Set region
ls /usr/share/zoneinfo/"$region"
echo "Pick your city (e.g., New_York):"
read city
clear 
ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime
sleep 1
hwclock --systohc

#Set locale
printf "What is your UTF-8 locale (e.g., en_CA.UTF-8): "
read UTF8

#Patch locale
echo "Enabling $UTF8 in /etc/locale.gen..."
sed -i "/^#\s*${UTF8}/s/^#\s*//" /etc/locale.gen
sleep 3
clear
locale-gen

#Keymap
echo "What is your keybord example (e.g., us)"
read keymap
clear

#Hostname
echo "What is your hostname"
read hostname
clear
echo "LANG=$UTF8" >> /etc/locale.conf
echo "KEYMAP=$keymap" >> /etc/vconsole.conf
echo "$hostname" >> /etc/hostname
printf "/etc/ files created"
sleep 3
clear  

#Mkinitcpio
mkinitcpio -P
clear

#extra pkg install
echo "additional pakages are going to install like: sudo networkmanager vim and ufw"
printf "additional pakages you want installed: "
read extra
pacman -S sudo networkmanager vim ufw $extra  

#Grub install and .cfg file
clear
echo "Grub install started..."
pacman -S grub efibootmgr
clear
sleep 2
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sleep 2
grub-mkconfig -o /boot/grub/grub.cfg
clear

#rootpass with passwd
echo "Root password"
passwd
clear

#adduser and passwd for that user
printf "Username for user:"
read user
useradd -m -G wheel -s /bin/bash $user
passwd $user
clear

#Triger 3 setup
mkdir phase3
echo "temp file for addos triger if its still here feel free to remove it allong with this directory" >> /phase3/triger.txt
fi
