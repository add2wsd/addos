# AddOS - Arch Linux Install Script (Alpha)

AddOS is an alpha-stage script designed to automate the Arch Linux installation.

> [!WARNING]
> This script is in its early alpha phase. Features are missing, and it can potentially break your system. Confirmations before dangerous actions do not exist at this point. **Use at your own risk.**

## 📋 Requirements

*   Live ISO Arch Linux environment.
*   Root privileges to run the script.

## 🚀 Usage

1.  **Download the script:**
    ```bash
    wget https://github.com/add2wsd/addos/addos.sh
    chmod +x addos.sh
    ```
2.  **Run the script as root:**
    ```bash
    sudo ./addos.sh
    ```
3.  **Confirm proceeding:** The script will prompt you to confirm due to its alpha status and potential for system breakage. Type `y` to continue.

## ✨ Features (Current Alpha)

*   Checks for root privileges.
*   Verifies the operating system is Arch Linux.
*   Provides a clear warning about its alpha status and potential risks before proceeding.
*   Disk selection
*   Automatic partitioning
