<p align="center">
  <img src="./logo.png" alt="AddOS Logo" width="200">
</p>
<h1 align="center">AddOS - LhDistro'</h1>
<p align="center">
  <a href="https://github.com/add2wsd/addos/tree/main"><img src="https://img.simg.ss.io/badge/base-Arch_Linux-blue?stimg.shielsquare&logo=Arch%Archnstyl%20x" alt="Base"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/add2wsd/addos"><img src="https://img.shields.io/badge/status-Beta-yellow?style=flat-square" alt="Status"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/add2wsd/addos/releases"><img src="https://img.shields.io/github/v/release/add2wsd/addos?include_prereleases&style=flat-square" alt="Latest release"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/add2wsd/addos/blob/main/LICENSE"><img src="https://img.shields.io/github/license/add2wsd/addos?style=flat-square" alt="License"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/add2wsd/addos/commits/main"><img src="https://img.shields.io/github/last-commit/add2wsd/addos?style=flat-square" alt="Last Commit"></a>
</p>
<p align="center">
  <a href="https://github.com/add2wsd/addos/stargazers"><img src="https://img.shields.io/github/stars/add2wsd/addos?style=for-the-badge&label=%F0%9F%8C%9FSTARS&color=yellow" alt="GitHub Stars"></a>
</p>

AddOS is an installation script that creates a customized Arch Linux derivative, just because Arch considers installation scripts that are not ArchInstall a derivative of Arch.

> [!WARNING]
> This installer is in its beta phase. Features are missing, and it can potentially break your system. Confirmations before dangerous actions have been partially implemented but some or all still do not exist at this point. **Use at your own risk.**

> [!NOTE]
> AddOS may move development on GNOME to somthing more extendable like Sway or Hyprland. GNOME will **continue** to be an option.

## 📋 Requirements

*   Live ISO Arch Linux environment.
*   Root privileges to run the script.
*   USB to execute the script, or Wi-Fi to wget.

## 🚀 Usage

1.  **Getting the Script:**

    *   **Online Method (requires internet connection on the Arch ISO USB):**
        ```bash
        wget https://github.com/add2wsd/addos/releases/download/latest/addosinstall.sh
        chmod +x addosinstall.sh
        ```
    *   **Offline Method (using Arch ISO USB):**
        1.  **On your current computer:** Download the `addosinstall.sh` script from the [Releases tab](https://github.com/add2wsd/addos/releases).
        2.    Copy this script file directly to the **root directory** of your Arch Linux installation USB drive (the same drive you'll boot from).
        3.  **On the target computer:** Boot your computer from the Arch Linux installation USB.
        4.  Once in the Arch Linux live environment, navigate to the USB's root directory, which is typically mounted at `/run/archiso/bootmnt`:
            ```bash
            cd /run/archiso/bootmnt
            ```
        5.  Make the script executable:
            ```bash
            chmod +x addosinstall.sh
            ```

3.  **Run the script as root:**
    ```bash
    sudo ./addosinstall.sh
    ```
4.  **Confirm proceeding:** The script will prompt you to confirm due to its beta status and potential for system breakage. Type `y` to continue.
5.  **After the reboot happens:**
    ```bash
    /mnt/addosinstall.sh
    ```

## ✨ Features (Current Beta)

- [X] Verifies the system is correct
- [ ] Seperate branch for Artix Linux
- [X] Provides warnings
- [X] Disk selection
- [X] Automatic setup
- [X] WI-FI setup if needed
- [X] Install base packages with pacstrap

### Development path
- [X] Partition style
- [X] Disk mounting
- [X] fstab setup
- [X] arch-chroot system setup
- [X] Locales
- [X] /etc/ files
- [X] ramfs
- [X] Extra pkgs 
- [X] User setup
- [ ] More DE and configuration options
- [ ] Security hardening
- [ ] --more-soon--

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

<p align="center">
  <img src="https://img.shields.io/github/commit-activity/t/add2wsd/addos?authorFilter=adevdoingdevthings&style=flat-square&label=LandenHM%20commits" alt="LandenHM commits">
    &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://img.shields.io/github/commit-activity/t/add2wsd/addos?authorFilter=add2wsd&style=flat-square&label=add2wsd%20commits" alt="add2wsd commits">
</p>

## 🛠️ Current Maintainer

<p align="center">
  <a href="https://github.com/add2wsd">add2wsd</a>
</p>
