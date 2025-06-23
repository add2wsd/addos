<h1 align="center">AddOS - Install Script</h1>
<p align="center">
  <img src="https://img.shields.io/badge/Version-Arch_Linux-blue" alt="Badge">
    &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://img.shields.io/badge/Status-Alpha-orange" alt="Badge 2"
</p>

AddOS is an alpha-stage script designed to automate the Arch Linux installation.

> [!WARNING]
> This script is in its early alpha phase. Features are missing, and it can potentially break your system. Confirmations before dangerous actions do not exist at this point. **Use at your own risk.**

## 📋 Requirements

*   Live ISO Arch Linux environment.
*   Root privileges to run the script.
*   USB to execute the script, or Wi-Fi to wget.
*   Only avalibale for amd based systems at this time nvidea support will be here in the future

## 🚀 Usage

1.  **Getting the Script:**

    *   **Online Method (requires internet connection on the Arch ISO USB):**
        ```bash
        wget https://github.com/add2wsd/addos/addosinstall-alpha.sh
        chmod +x addosinstall-alpha.sh
        ```
    *   **Offline Method (using Arch ISO USB):**
        1.  **On your current computer:** Download the `addosinstall-alpha.sh` script from the GitHub repository.
        2.  Copy this script file directly to the **root directory** of your Arch Linux installation USB drive (the same drive you'll boot from).
        3.  **On the target computer:** Boot your computer from the Arch Linux installation USB.
        4.  Once in the Arch Linux live environment, navigate to the USB's root directory, which is typically mounted at `/run/archiso/bootmnt`:
            ```bash
            cd /run/archiso/bootmnt
            ```
        5.  Make the script executable:
            ```bash
            chmod +x addosinstall-alpha.sh
            ```

2.  **Run the script as root:**
    ```bash
    sudo ./addosinstall-alpha.sh
    ```
3.  **Confirm proceeding:** The script will prompt you to confirm due to its alpha status and potential for system breakage. Type `y` to continue.

## ✨ Features (Current Alpha)

- [X] Checks for root privileges.
- [X] Verifies the operating system is Arch Linux.
- [ ] Seperate branch for Artix Linux.
- [X] Provides a clear warning about its alpha status and potential risks before proceeding.
- [X] Disk selection
- [X] Automatic partitioning
- [X] Automatic file systems
- [X] Automatic mounting
- [X] WI-FI setup if needed
- [X] Install base packages with pacstrap

### Development path
- [ ] Disk warning
- [X] Disk selection
- [ ] Partition style
- [X] Auto file system
- [X] Disk mounting
- [X] Quick WI-FI setup
- [X] Pacstrap base pkgs
- [X] fstab setup
- [X] arch-chroot system setup
- [ ] Locales set up script
- [ ] /etc files
- [ ] ramfs
- [ ] Extra pkgs 
- [ ] Password and user creation
## 🐧 Alternative Distro Support

If you prefer Artix Linux with s6 or runit init systems over Arch Linux, a separate branch is available for this purpose. There are currently no maintainers for Dinit and OpenRC Artix or any other distros.

*   **Artix s6/runit branch:** [Link to Artix Branch Here](https://github.com/add2wsd/addos/tree/artix-s6-runit)

## 🧑‍💻 Creators

<p align="center">
  <a href="https://github.com/adevdoingdevthings">
    <img src="https://github.com/adevdoingdevthings.png" width="100px;" alt="LandenHM profile">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/add2wsd">
    <img src="https://github.com/add2wsd.png" width="100px;" alt="add2wsd profile">
  </a>
</p>

## 🛠️ Current Maintainer

<p align="center">
  <a href="https://github.com/add2wsd">add2wsd</a>
</p>
