import os
import subprocess
import sys

def run_command(command, check_error=True):
    """Runs a shell command and handles errors."""
    try:
        subprocess.run(command, shell=True, check=check_error)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
        sys.exit(1)

def dialog_input(title, height, width):
    """Gets input using dialog."""
    return subprocess.run(['dialog', '--inputbox', title, str(height), str(width)], capture_output=True, text=True, check=True).stdout.strip()

def dialog_menu(title, height, width, menu_height, items):
    """Displays a menu using dialog and returns the selected tag."""
    command = ['dialog', '--menu', title, str(height), str(width), str(menu_height)]
    command.extend(items)
    return subprocess.run(command, capture_output=True, text=True, check=True).stdout.strip()

def dialog_checklist(title, height, width, list_height, items):
    """Displays a checklist using dialog and returns selected tags."""
    command = ['dialog', '--checklist', title, str(height), str(width), str(list_height)]
    command.extend(items)
    return subprocess.run(command, capture_output=True, text=True, check=True).stdout.strip().split()

def phase4_logic():
    """Handles logic for Phase 4 (post-reboot configuration)."""
    if os.path.exists("/phase4/triger.txt"):
        print("welcome to addos")
        print("if you want later configs updated scripts will be availible in releases")
        input("Press any key to continue...")

        if os.path.exists("/phase4/gnome.txt"):
            print("gnome install")
        else:
            print("gnome not configering")

        if os.path.exists("/phase4/hypr.txt"):
            os.system('clear')
            user = dialog_input("username:", 10, 40)
            print("hypr configs")
            run_command(f"cd /home/{user}/.config")
            run_command("rm -r hypr")
            run_command("cd /hyprland-config-files")
            run_command(f"cp -r /hypr /home/{user}/.config/hyprs")
            run_command("cd /etc/waybar")
            run_command("rm -r #waybar config") # This line in the original script is a comment and will cause an error if uncommented.
            run_command("cd /hyprland-config-files")
            run_command("cp -r /waybar #waybar dir") # This line in the original script is a comment and will cause an error if uncommented.
            run_command("cd")
        else:
            print("hypr not configering")

        if os.path.exists("/phase4/gnome.txt"):
            os.system('clear')
            user = dialog_input("username:", 10, 40)
            print("gnome config")
        else:
            print("gnome not configering")

def phase3_logic():
    """Handles logic for Phase 3 (initial system configuration after chroot)."""
    if os.path.exists("/phase3/triger.txt"):
        run_command("systemctl enable ufw")
        run_command("systemctl enable NetworkManager")
        run_command("ufw default deny incoming")
        run_command("ufw default allow outgoing")
        run_command("ufw enable")
        run_command("systemctl start NetworkManager")

        need_network = input("Do you need wifi (Y/n): ").strip().lower()
        if need_network == 'y':
            run_command("nmcli device wifi list")
            netname = input("Whats your ssid: ").strip()
            run_command(f"nmcli device wifi connect {netname} --ask")

        os.makedirs("/phase4", exist_ok=True)
        with open("/phase4/triger.txt", "w") as f:
            f.write("temp file for addos triger if its still here feel free to remove it allong with this directory\n")

        deske_choices = dialog_checklist("Desktop envierments:", 20, 40, 4, ["1", "Gnome", "2", "Hyperland", "3", "Gnome-vinila"])

        if "1" in deske_choices:
            os.system('clear')
            print("grabing gnome")
            run_command("pacman -S gnome gdm")
            run_command("systemctl enable gdm")
            with open("/phase4/gnome.txt", "w") as f:
                f.write("gnome update marker dont remove if you plan on using addos update scripts\n")
        else:
            print("gnome not installing")

        if "2" in deske_choices:
            os.system('clear')
            print("grabing hyprland")
            run_command("pacman -S hyprland kitty gdm waybar")
            run_command("systemctl enable gdm")
            with open("/phase4/hypr.txt", "w") as f:
                f.write("hypr update marker dont remove if you plan on using addos update scripts\n")
        else:
            print("hyprland not installing")

        print("Installing flatpak apps")
        run_command("flatpak install flathub io.github.ungoogled_software.ungoogled_chromium com.mattjakeman.ExtensionManager io.gitlab.librewolf-community")

        os.system('clear')
        print("addos cleaning")
        run_command("rm -r /phase3")
        run_command("reboot")

def phase1_logic():
    """Handles logic for Phase 1 (initial setup before chroot)."""
    if os.geteuid() != 0:
        print("Please run this script as root or using sudo.")
        print("You may run 'sudo !!' to rerun the previous command as root.")
        sys.exit(1)
    print("Root check completed, proceeding...")

    if not os.path.exists("/etc/arch-release"):
        print("This install script is only for Arch Linux and will break other systems. Please run this in Arch Linux.")
        sys.exit(1)
    print("Arch Linux check completed, proceeding...")

    reply = input("This script is in Alpha, features are missing and can break. Confirmations before dangerous actions do not exist at this point and may break your system. Do you want to proceed? (y/N): ").strip().lower()
    if reply != 'y':
        print("Operation cancelled. Exiting.")
        sys.exit(1)

    os.system('clear')
    print("+==============================================+")
    print("|         _    ____  ____                      |")
    print("|        / \  |  _ \|  _ \        ___  ___     |")
    print("|       / _ \ | | | | | | |_____ / _ \/ __|    |")
    print("|      / ___ \| |_| | |_| |_____| (_) \__ \    |")
    print("|     /_/   \_\____/|____/       \___/|___/    |")
    print("| Owned and maintained by add2wd               |")
    print("| With the help of LandenHM                    |")
    print("+==============================================+")
    input("Press any key to continue...")
    run_command("loadkeys us")

    os.system('clear')
    run_command("pacman -Sy")
    run_command("pacman -S dialog pacman-contrib")

    lsblk_output = subprocess.run(['lsblk', '-n', '-d', '--output', 'NAME,TYPE'], capture_output=True, text=True, check=True).stdout.strip().split('\n')
    disk_items = []
    for line in lsblk_output:
        parts = line.split()
        if len(parts) >= 2:
            disk_items.extend([parts[0], parts[1]])

    diskname = dialog_menu("Selectpartition:", 20, 40, 4, disk_items)
    wipetrue = dialog_checklist("Mark the box for disk eraser and that you understand all data will be destroid", 20, 40, 4, ["1", "Mark this box (use space)"])

    if "1" in wipetrue:
        os.system('clear')
        run_command(f"blkdiscard -f /dev/{diskname}")
        partstyle = dialog_menu("Partition style:", 15, 55, 4, ["1", "Basic partition 1G boot 4G swap leftover root", "2", "Home partition included 16G root"])
        os.system('clear')

    if partstyle == "1":
        fdisk_script = f"""g
n


+1G
n


+4G
n



w
"""
        subprocess.run(['fdisk', f'/dev/{diskname}'], input=fdisk_script.encode(), check=True)
    else:
        fdisk_script = f"""g
n


+1G
n


+4G
n


+16G
n



w
"""
        subprocess.run(['fdisk', f'/dev/{diskname}'], input=fdisk_script.encode(), check=True)
    os.system('clear')

    print("Auto Partitioning is complete...")
    run_command("lsblk")
    subprocess.run(['sleep', '3'])
    os.system('clear')

    nvmemode = 1
    if "nvme" in diskname:
        nvmemode = 0
        print("Partition with nvme in mind")
    else:
        print("Partition without nvme in mind")
    subprocess.run(['sleep', '3'])

    if partstyle == "1":
        str1 = "p1" if nvmemode == 0 else "1"
        str2 = "p2" if nvmemode == 0 else "2"
        str3 = "p3" if nvmemode == 0 else "3"
    else:
        str1 = "p1" if nvmemode == 0 else "1"
        str2 = "p2" if nvmemode == 0 else "2"
        str3 = "p3" if nvmemode == 0 else "3"
        str4 = "p4" if nvmemode == 0 else "4"

    print("Starting mkfs...")
    run_command(f"mkfs.fat -F 32 /dev/{diskname}{str1}")
    run_command(f"mkswap /dev/{diskname}{str2}")
    run_command(f"mkfs.ext4 -F /dev/{diskname}{str3}")
    os.system('clear')
    print("mkfs is complete.")
    subprocess.run(['sleep', '4'])
    os.system('clear')

    if partstyle == "2":
        print("Starting mkfs...")
        run_command(f"mkfs.fat -F 32 /dev/{diskname}{str1}")
        run_command(f"mkswap /dev/{diskname}{str2}")
        run_command(f"mkfs.ext4 -F /dev/{diskname}{str3}")
        run_command(f"mkfs.ext4 -F /dev/{diskname}{str4}")
        os.system('clear')
        print("mkfs is complete.")
        subprocess.run(['sleep', '4'])
        os.system('clear')

    print("Attempting mount...")
    run_command(f"mount /dev/{diskname}{str3} /mnt")
    run_command(f"mount --mkdir /dev/{diskname}{str1} /mnt/boot")
    run_command(f"swapon /dev/{diskname}{str2}")
    subprocess.run(['sleep', '2'])
    os.system('clear')

    if partstyle == "2":
        print("Attempting mount...")
        run_command(f"mount /dev/{diskname}{str3} /mnt")
        run_command(f"mount --mkdir /dev/{diskname}{str1} /mnt/boot")
        run_command(f"mount --mkdir /dev/{diskname}{str4} /mnt/home")
        run_command(f"swapon /dev/{diskname}{str2}")
        subprocess.run(['sleep', '2'])
        os.system('clear')

    print("Mount complete...")
    run_command("lsblk -n")
    subprocess.run(['sleep', '3'])
    os.system('clear')

    print("preparing for pacstrap...")
    run_command("rankmirrors -n 6 /etc/pacman.d/mirrorlist")
    subprocess.run(['sleep', '3'])
    os.system('clear')

    print("Starting pactrap...")
    subprocess.run(['sleep', '4'])
    run_command("pacstrap -K /mnt base linux linux-firmware dialog")
    os.system('clear')

    run_command("genfstab -U /mnt >> /mnt/etc/fstab")
    os.system('clear')
    print("Chrooting into installed system.")
    subprocess.run(['sleep', '4'])
    os.system('clear')

    subprocess.run(['sleep', '10'])

    run_command("cp -r /root/addos/hyprland-config-files /mnt")
    run_command("cp -r /root/addos/addos-start.service /mnt/etc/systemd/system")
    run_command("cp /root/addos/addosinstall.sh /mnt/mnt")
    run_command("chmod +x /mnt/mnt/addosinstall.sh")
    run_command("arch-chroot /mnt /mnt/addosinstall.sh --chrooted")

    os.system('clear')
    print("transfering mirror list to installed system")
    subprocess.run(['sleep', '4'])
    run_command("cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist")
    subprocess.run(['sleep', '5'])

    subprocess.run(['sleep', '10'])

    run_command("umount -R /mnt")
    os.system('clear')
    print("Chroot done base system installed.")
    print("After reboot log into root and run /mnt/addosinstall.sh")
    input("Remove this install media and press any key to reboot...")
    run_command("reboot")

def phase2_logic():
    """Handles logic for Phase 2 (chrooted environment configuration)."""
    print("Entering chroot")
    print("Next stage started for addos")
    subprocess.run(['sleep', '4'])

    zoneinfo_regions = subprocess.run(['ls', '-1', '/usr/share/zoneinfo/'], capture_output=True, text=True, check=True).stdout.strip().split('\n')
    region_items = []
    for i, region in enumerate(zoneinfo_regions):
        region_items.extend([str(i + 1), region])
    region = dialog_menu("Select Region:", 30, 30, 30, region_items)
    os.system('clear')

    zoneinfo_cities = subprocess.run(['ls', '-1', f'/usr/share/zoneinfo/{region}'], capture_output=True, text=True, check=True).stdout.strip().split('\n')
    city_items = []
    for i, city in enumerate(zoneinfo_cities):
        city_items.extend([str(i + 1), city])
    city = dialog_menu("Select City:", 30, 30, 30, city_items)
    os.system('clear')

    run_command(f"ln -sf /usr/share/zoneinfo/{region}/{city} /etc/localtime")
    subprocess.run(['sleep', '1'])
    run_command("hwclock --systohc")

    utf8_locale = dialog_input("What is your UTF-8 locale (e.g., en_CA.UTF-8):", 10, 40)
    os.system('clear')
    run_command(f"sed -i '/^#\\s*{utf8_locale}/s/^#\\s*//' /etc/locale.gen")
    run_command("locale-gen")
    os.system('clear')

    extra_packages = dialog_input("additional pakages you want installed:", 10, 40)
    run_command(f"pacman -S sudo networkmanager neovim ufw flatpak grub efibootmgr {extra_packages}")
    os.system('clear')

    print("Bootloader setup...")
    run_command("grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB")
    run_command("grub-mkconfig -o /boot/grub/grub.cfg")
    os.system('clear')

    keymap = dialog_input("What is your keybord example (e.g., us)", 10, 40)
    hostname = dialog_input("Hostname:", 10, 40)
    
    with open("/etc/locale.conf", "a") as f:
        f.write(f"LANG={utf8_locale}\n")
    with open("/etc/vconsole.conf", "a") as f:
        f.write(f"KEYMAP={keymap}\n")
    with open("/etc/hostname", "a") as f:
        f.write(f"{hostname}\n")
    os.system('clear')
    print("/etc/ files created")
    subprocess.run(['sleep', '3'])
    os.system('clear')

    username = dialog_input("username:", 10, 40)
    run_command(f"useradd -m -G wheel -s /bin/bash {username}")
    user_password = dialog_input("password:", 10, 40)
    passwd_script_user = f"""{user_password}
{user_password}
"""
    subprocess.run(['passwd', username], input=passwd_script_user.encode(), check=True)
    os.system('clear')

    root_password = dialog_input("root password:", 10, 40)
    os.system('clear')
    subprocess.run(['sleep', '2'])
    passwd_script_root = f"""{root_password}
{root_password}
"""
    subprocess.run(['passwd'], input=passwd_script_root.encode(), check=True)
    subprocess.run(['sleep', '2'])
    os.system('clear')

    os.makedirs("/phase3", exist_ok=True)
    with open("/phase3/triger.txt", "w") as f:
        f.write("temp file for addos triger if its still here feel free to remove it allong with this directory\n")

def main():
    _run_phase2_flag = False
    if len(sys.argv) > 1 and sys.argv[1] == "--chrooted":
        _run_phase2_flag = True

    if _run_phase2_flag:
        phase2_logic()
    else:
        phase4_logic()
        phase3_logic()
        if not os.path.exists("/phase3/triger.txt") and not os.path.exists("/phase4/triger.txt"):
            phase1_logic()

if __name__ == "__main__":
    main()