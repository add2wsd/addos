echo "this is a alpha if you have this cool it prob wont work"

loadkeys us

clear
sleep 1.5
lsblk
printf "what is your disk /dev/"
read disk
printf "disk partitoning started auto is the only option right now"
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
echo "Your disks are partitiond"
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
sleep 2
printf "attempting mount"

mount /dev/$disk$str3 /mnt

mount --mkdir /dev/$disk$str1 /mnt/boot

swapon /dev/$disk$str2

printf "mount done"
sleep 3
clear


