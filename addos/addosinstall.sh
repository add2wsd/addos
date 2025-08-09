#!/bin/bash

#Check for --chrooted argument to determine if it's Phase 2
if [[ "$1" == "--chrooted" ]]; then
	#Set a flag to indicate Phase 2 execution
	_run_phase2_flag=true
else
	#Set a flag to indicate Phase 1 execution
	_run_phase2_flag=false
fi
# --- addos welcome ---
if [ -f /phase4/triger.txt ];
then
echo "welcome to addos"
echo "if you want later configs updtae scripts will be availible in releases"
read -n 1 -s -r -p "Press any key to continue..."

#pickup DE and mod
if [ -f /phase4/gnome.txt ];
then
	echo "gnome install"
else
	echo "gnome not configering"
fi

if [ -f /phase4/hypr.txt ];
then
	clear
	user=$(dialog --inputbox --output-fd 1 "username:" 10 40)
	echo "hypr configs"
	cd /home/"$user"/.config
	rm -r hypr
	cd /hyprland-config-files
	cp -r /hypr /home/"$user"/.config/hyprs
	cd /etc/waybar
	rm -r #waybar config
	cd /hyprland-config-files
	cp -r /waybar #waybar dir
	cd
else
	echo "hypr not configering"
fi

if [ -f /phase4/gnome.txt ];
then
	clear
	user=$(dialog --inputbox --output-fd 1 "username:" 10 40)
	echo "gnome config"
else
	echo "gnome not configering"
fi
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

cd /
mkdir phase4
echo "temp file for addos triger if its still here feel free to remove it allong with this directory" >> /phase4/triger.txt
cd 
deske=$(dialog --checklist --output-fd 1 "Desktop envierments:" 20 40 4 1 "Gnome" 1 2 "Hyperland" 2 3 "Gnome-vinila" 3)
if [[ "$deske" =~ [1] ]]; 
then
	clear
	echo "grabing gnome"
	pacman -S gnome gdm
	systemctl enable gdm
	echo "gnome update marker dont remove if you plan on using addos update scripts" >> /phase4/gnome.txt
else
  echo "gnome not installing"
fi

if [[ "$deske" =~ [2] ]]; 
then
	clear
	echo "grabing hyprland"
	pacman -S hyprland kitty gdm waybar
	systemctl enable gdm
	echo "hypr update marker dont remove if you plan on using addos update scripts" >> /phase4/hypr.txt
else
  echo "hyprland not installing"
fi

#Installing flatpak apps
echo "Installing flatpak apps"
flatpak install flathub io.github.ungoogled_software.ungoogled_chromium	com.mattjakeman.ExtensionManager

#Clean addos install script and dirs
clear
echo "addos cleaning"
cd /
rm -r /phase3
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

#Addos dependencys
clear
pacman -Sy
pacman -S dialog pacman-contrib

diskname=$(dialog --menu --output-fd 1 Selectpartition: 20 40 4 $(lsblk -n -d --output NAME,TYPE)) 
wipetrue=$(dialog --checklist --output-fd 1 "Mark the box for disk eraser and that you understand all data will be destroid" 20 40 4 1 "Mark this box (use space)" 2)

if [[ "$wipetrue" =~ ^[1]$ ]];
then
	clear
	blkdiscard -f /dev/"$diskname"
	partstyle=$(dialog --menu --output-fd 1 "Partition style:" 15 55 4 1 "Basic partition 1G boot 4G swap leftover root" 2 "Home partition included 16G root")
clear
fi

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
lsblk -n
sleep 3
clear

echo "preparing for pacstrap..."
rankmirrors -n 6 /etc/pacman.d/mirrorlist
sleep 3
clear

#pacstrap
echo "Starting pactrap..."
sleep 4
pacstrap -K /mnt base linux linux-firmware dialog
clear

#Genfstab
genfstab -U /mnt >> /mnt/etc/fstab
clear
printf "Chrooting into installed system."
sleep 4
clear

sleep 10

#transfer files
cp -r /root/addos/hyprland-config-files /mnt
cp -r /root/addos/addos-start.service /mnt/etc/systemd/system
cp /root/addos/addosinstall.sh /mnt/mnt
chmod +x /mnt/mnt/addosinstall.sh
arch-chroot /mnt /mnt/addosinstall.sh --chrooted

#transfer ranked mirrors
clear
echo "transfering mirror list to installed system"
sleep 4
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
sleep 5

sleep 10
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
dirprint=$(ls -1 /usr/share/zoneinfo/ | awk '{print $0, NR}' | awk '{print $0, NR}')
region=$(dialog --checklist --output-fd 1 test 30 30 30 $dirprint)
clear

#Set region
dirprint=$(ls -1 /usr/share/zoneinfo/"$region" | awk '{print $0, NR}' | awk '{print $0, NR}')
city=$(dialog --checklist --output-fd 1 test 30 30 30 $dirprint)
clear 
ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime
sleep 1
hwclock --systohc

#Set locale
UTF8=$(dialog --inputbox --output-fd 1 "What is your UTF-8 locale (e.g., en_CA.UTF-8):" 10 40)
clear
sed -i "/^#\s*${UTF8}/s/^#\s*//" /etc/locale.gen
locale-gen
clear


#extra pkg install
extra=$(dialog --inputbox --output-fd 1 "additional pakages you want installed:" 10 40)
pacman -S sudo networkmanager vim ufw flatpak $extra
clear

#Grub install and .cfg file
echo "Grub install started..."
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
clear

#rootpass with passwd
rootpass=$(dialog --inputbox --output-fd 1 "root password:" 10 40)
clear
sleep 2
passwd <<EOF
$rootpass
$rootpass
EOF
sleep 2
clear

#Keymap
keymap=$(dialog --inputbox --output-fd 1 "What is your keybord example (e.g., us)" 10 40)

#Hostname
hostname=$(dialog --inputbox --output-fd 1 "Hostname:" 10 40)
echo "LANG=$UTF8" >> /etc/locale.conf
echo "KEYMAP=$keymap" >> /etc/vconsole.conf
echo "$hostname" >> /etc/hostname
clear
printf "/etc/ files created"
sleep 3
clear 

#adduser and passwd for that user
user=$(dialog --inputbox --output-fd 1 "username:" 10 40)
useradd -m -G wheel -s /bin/bash $user
password=$(dialog --inputbox --output-fd 1 "password:" 10 40)
passwd $user <<EOF
$password
$password
EOF
clear

#Triger 3 setup
mkdir phase3
echo "temp file for addos triger if its still here feel free to remove it allong with this directory" >> /phase3/triger.txt
fi
