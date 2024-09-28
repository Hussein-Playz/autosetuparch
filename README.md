# THIS SCRIPT IS DECRACTED AND I WILL BE MOVING IT TO MY OWN ARCH BASED DISTRO SOON WHEN I FINISH DEVELOPPING IT
# THIS SCRIPT WILL STILL BE AVAIABLE BUT WONT RECIEVE UPDATES


# Auto Setup Arch Script

This script sets up an Arch Linux system with various configurations and software installations.
It Will
Back up the sudoers file to prevent accidental misconfigurations
and configure timestamp timeout to avoid frequent sudo password prompts.
Update the system and optimize Pacman package manager configuration.
Update Pacman mirrors using reflector and install additional packages.
Install and configure various utilities and packages.
Install and set up AUR helper yay for easier AUR package management.
Install power management tools and enable Bluetooth.
Install additional utilities and packages.
Configure CPU microcode for better system stability.
Install and set up Zsh with custom themes and plugins.
Clone and execute additional configuration scripts from a repository.
Install and configure Flatpak applications.
Enable and configure various system services and utilities.
Clean up package cache and restore sudoers timestamp timeout.
Prompt user to reboot for changes to take effect.

credits to chatgpt for creating every if statement
and this also installls end-4/dots-hyprland: https://github.com/end-4/dots-hyprland
timeshift timeshift-snap grub-btrfs the backing up of sudoers file is because this script changes that file so that you dont have to type your password every 5 minutes and it makes last till reboot and when script finishes it reverts it  back to the default unless a error was made some gaming stuff and recording and editing software MAIL wine and alot more
# Installation:
```
git clone https://github.com/Hussein-Playz/autosetuparch.git
```
```
cd autosetuparch
```
```
chmod +x setup.sh
```
```
./setup.sh
```
