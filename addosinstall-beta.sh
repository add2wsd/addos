#!/bin/bash

# Check for --chrooted argument to determine if it's Phase 2
if [[ "$1" == "--chrooted" ]]; then
  # Set a flag to indicate Phase 2 execution
  _run_phase2_flag=true
else
  # Set a flag to indicate Phase 1 execution
  _run_phase2_flag=false
fi

# --- PHASE 1 LOGIC STARTS HERE ---
if [[ "$_run_phase2_flag" == "false" ]]; then
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
  # Disk selection
  clear
  echo "WARNING BOTH OPTIONS WILL ERASE DATA MAKE SURE THAT ALL INPORTANT DATA IS BACKED UP OFF BEFOR CONTINUING 
  WE ARE NOT LYABLE FOR DATA LOSS"
  echo "there are 2 options for disk selection. 
  (1): Pick a disk and format style 
  (2): Wipe a disk for use"
  read diskopti
  if ["$diskopti" -eq "1"];
    then
      lsblk
      printf "Enter the disk name (e.g. sda for /dev/sda):"
      read diskname
    else
      printf "disk wipe not done yet :("
      sleep 3
      clear
      exit
    fi
    
  echo "Disk partitoning has started. Auto is the only option right now."
  sleep 4
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
  # Next part of the install: mkfs
  # This is an echo instead of printf because it looks better when displayed.
  clear
  echo "Auto Partitioning is complete..."
  sleep 1
  lsblk
  sleep 2
  clear
  printf "Starting mkfs..."
  # Partitoning number
  str1="1"
  str2="2"
  str3="3"
  mkfs.fat -F 32 /dev/"$disk""$str1"

  mkswap /dev/"$disk""$str2"

  mkfs.ext4 -F /dev/"$disk""$str3"

  clear

  printf "mkfs is complete."
  sleep 4
  clear
  printf "Attempting mount..."

  mount /dev/"$disk""$str3" /mnt

  mount --mkdir /dev/"$disk""$str1" /mnt/boot

  swapon /dev/"$disk""$str2"
  sleep 2
  clear
  echo "Mount complete..."
  echo "There is a 6-second delay; the script is still running."
  lsblk
  sleep 6
  clear
  # If else for wifi if connection is needed eg vm or ethernet
  # Probably should add something in the future telling the user if they have internet set up already, and are going to use it in their install theu should press Y
  printf "Enable Wi-Fi? Type N if you have ethernet or are using a virtual machine with network passthrough. (y/N):"
  read neednetwork
  if [[ "$neednetwork" =~ ^[Yy]$ ]];
  then

  # Next up is networking
  ip link
  printf "Pick your network interface:"
  read wifi

  # Show networks
  iwctl station "$wifi" scan
  iwctl station "$wifi" get-networks

  # Find network and prepare connect
  printf "What's your network SSID? Double-check this:"
  read network
  printf "What's your network password:"
  read netpass

  # iwctl connects to network
  iwctl station "$wifi" connect "$network" --passphrase "$netpass"

  fi
  clear

  # There is no benifit to this part; just looks nice.
  echo "Disk partition: Done."
  sleep 2
  echo "mkfs: Done."
  sleep 3
  echo "Mount: Done."
  echo "Grabing pacman repos"
  pacman -Sy pacman-contrib
  sleep 5
  rankmirrors -n 6 /etc/pacman.d/mirrorlist
  cat /etc/pacman.d/mirrorlist
  sleep 4
  clear
  echo "Starting pactrap..."
  sleep 4
  pacstrap /mnt base linux linux-firmware

  genfstab -U /mnt >> /mnt/etc/fstab
  clear
  printf "Chrooting into installed system."

  # Create /mnt/mnt for chroot
cp addosinstall-beta.sh /mnt/mnt
chmod +x /mnt/mnt/addosinstall-beta.sh
arch-chroot /mnt /mnt/addosinstall-beta.sh --chrooted
  # --- PHASE 1 LOGIC ENDS HERE ---
#exit and reboot should comence after stage2 aka chroot
umount -R /mnt
reboot

fi

# --- PHASE 2 LOGIC STARTS HERE ---
if [[ "$_run_phase2_flag" == "true" ]]; then
  echo "Entering chroot"
  echo "Next stage started for addos"
  sleep 4

  # Set timezone
  echo "Pick your country (e.g., America):"
  ls /usr/share/zoneinfo/
  read region

  echo "Pick your city (e.g., New_York):"
  ls /usr/share/zoneinfo/"$region"
  read city

  ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime
  sleep 2
  hwclock --systohc

  # Set locale
  printf "What is your UTF-8 locale (e.g., en_CA.UTF-8): "
  read UTF8

  # Patch locale
  echo "Enabling $UTF8 in /etc/locale.gen..."
  sed -i "/^#\s*${UTF8}/s/^#\s*//" /etc/locale.gen
  sleep 3
  clear
  locale-gen
  
  echo "What is your keybord example (e.g., us)"
  read keymap
  clear
  echo "What is your hostname"
  read hostname
  clear
  echo "LANG=$UTF8" >> /etc/locale.conf
  echo "KEYMAP=$keymap" >> /etc/vconsole.conf
  echo "$hostname" >> /etc/hostname
  printf "/etc/ files created"
  sleep 3
  clear
  # Mkinitcpio
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
  sleep 3
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
  sleed 3
  grub-mkconfig -o /boot/grub/grub.cfg
  clear

  #rootpass with passwd
  echo "Root password:"
  passwd
  sleep 1
  clear

  #adduser and passwd for that user
  printf "Username for user:"
  read user
  useradd -m -G wheel -s /bin/bash $user
  passwd $user

fi
