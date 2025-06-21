#!/bin/bash

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
  # Proceed with root check failure
  echo "Please run this script as root or using sudo."
  echo "You may run 'sudo !!' to rerun the previous command as root."
  exit 1
fi
# Proceed with root check success
echo "Root check completed, proceeding..."

# Check if the script is on Arch
if [  ! -f /etc/arch-release ]; then
  # Proceed with Arch check failure
  echo "This install script is only for Arch Linux and will break other systems. Please run this in Arch Linux."
  exit 1
fi
# Proceed with Arch check success
echo "Arch Linux check completed, proceeding..."

# User verification check
read -p "This script is in Alpha, features are missing and can break. Confirmations before dangerous actions do not exist at this point and may break your system. Do you want to proceed? (y/N): " -n 1 -r
echo # Add a newline after the prompt

if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  # Proceed with user verification check failure
  echo "Operation cancelled. Exiting."
  exit 1
fi

# Proceed with user verification check success
echo "You have been warned!"
read -n 1 -s -r -p "Press any key to continue..."

loadkeys us

clear
sleep 1.5
lsblk
printf "What is your disk /dev/"
read disk
printf "Disk partitoning has started. Auto is the only option right now."
sleep 4
#fdisk script for the basic partitioning
fdisk /dev/$disk <<EOF
g
n


+1G
n


+4G
n



w
EOF
#Next part of the install mkfs
clear
#This is a echo insted of a printf because it looks better when printed out
echo "Auto Partitioning is complete..."
sleep 1
lsblk

#This is only here for the alpha and will be cut before release
printf "/dev/$disk"
sleep 2
clear
printf "starting mkfs"
#partitoning number
str1="1"
str2="2"
str3="3"
mkfs.fat -F 32 /dev/$disk$str1

mkswap /dev/$disk$str2

mkfs.ext4 -F /dev/$disk$str3

clear

printf "mkfs done"
sleep 4
clear
printf "attempting mount"

mount /dev/$disk$str3 /mnt

mount --mkdir /dev/$disk$str1 /mnt/boot

swapon /dev/$disk$str2
sleep 2
clear
echo "mount done"
echo "there is a 6-second delay the script is still running"
lsblk
sleep 6
clear
#If else for wifi if connection is needed eg vm or ethernet 
printf "Enable Wifi? Type N if you have ethernet or are using a virtual machine with network passthrough. (y/N):"
read neednetwork
if [[ "$neednetwork" =~ ^[Yy]$ ]];
then

#Next up is networking
ip link
printf "pick your network interface:"
read wifi

#Show nwteorks
iwctl station $wifi scan
iwctl station $wifi get-networks

#Find network and prepare connect
printf "whats your network ssid double check this:"
read network
printf "whats your network password:"
read netpass

#iwctl connects to network
iwctl station $wifi connect $network --passphrase $netpass

fi
clear
echo "sysinstall not ready yet"

#There is no benifit to this part just looks nice
echo "Disk parted:Done"
sleep 2
echo "mkfs:Done"
sleep 3
echo "Mount:Done"
echo "starting pactrap"
sleep 4
pacstrap -K /mnt base linux linux-firmware
