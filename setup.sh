#!/bin/bash

echo "This script sets up an Arch Linux system with various configurations and software installations."

echo "It Will"

echo "Back up the sudoers file to prevent accidental misconfigurations"

echo "and configure timestamp timeout to avoid frequent sudo password prompts."

echo "Update the system and optimize Pacman package manager configuration."

echo "Update Pacman mirrors using reflector and install additional packages."

echo "Install and configure various utilities and packages."

echo "Install and set up AUR helper yay for easier AUR package management."

echo "Install power management tools and enable Bluetooth."

echo "Install additional utilities and packages."

echo "Configure CPU microcode for better system stability."

echo "Install and set up Zsh with custom themes and plugins."

echo "Clone and execute additional configuration scripts from a repository."

echo "Install and configure Flatpak applications."

echo "Enable and configure various system services and utilities."

echo "Clean up package cache and restore sudoers timestamp timeout."

echo "Prompt user to reboot for changes to take effect."


echo "This script will install all you need to make arch linux yours"


SUDOERS_FILE="/etc/sudoers"
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak
if sudo grep -q '^Defaults[ \t]*timestamp_timeout=' $SUDOERS_FILE; then
    sudo sed -i 's/^Defaults[ \t]*timestamp_timeout=.*/Defaults timestamp_timeout=-1/' $SUDOERS_FILE
else
   echo 'Defaults timestamp_timeout=-1' | sudo tee -a $SUDOERS_FILE
fi
visudo -c
if [ $? -ne 0 ]; then
    echo "Syntax error in sudoers file. Restoring from backup."
    cp ${SUDOERS_FILE}.bak $SUDOERS_FILE
fi
rm ${SUDOERS_FILE}.bak
echo "Updating the system..."
sudo  pacman -Syu --noconfirm
echo "Optimizing Pacman..."
sudo sed -i '/#ParallelDownloads = 5/c\ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/#Colors/c\Colors' /etc/pacman.conf
echo "ILoveCandy" | sudo tee -a /etc/pacman.conf

echo "Updating Pacman Mirrors..."
sudo pacman -S reflector --noconfirm
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Sy


echo "NEOFETCCHHHHHHHH"
sudo pacman -S neofetch --noconfirm
neofetch

echo "TRAAIN"
sudo pacman -S sl --noconfirm

echo "Enabling Firewall (UFW)..".
sudo pacman -S ufw --noconfirm
sudo systemctl enable ufw
sudo systemctl start ufw

echo "Installing AUR Helper (yay)"
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R "$USER" ./yay
cd yay
makepkg -si

echo "Enabling lower power consumption for desktops or increasing battery life for laptops"
sudo pacman -S powertop --noconfirm
sudo powertop --auto-tune

echo "Enabling Bluetooth"
sudo pacman -S bluez blueman bluez-utils --noconfirm
sudo modprobe btusb
sudo systemctl enable bluetooth && sudo systemctl start bluetooth

echo "Installing zip utilities"
sudo pacman -S p7zip unrar tar unzip rsync git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2  --noconfirm
sudo pacman -S jdk-openjdk --noconfirm

echo "Making system more stable"
check_cpu_vendor() {
    local vendor=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
    echo "$vendor"
}
cpu_vendor=$(check_cpu_vendor)

if [ "$cpu_vendor" == "GenuineIntel" ]; then
    sudo pacman -S intel-ucode --noconfirm
    neofetch
elif [ "$cpu_vendor" == "AuthenticAMD" ]; then
    sudo pacman -S amd-ucode --noconfirm
    neofetch
else
    echo "Unknown CPU vendor: $cpu_vendor"
    neofetch
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -S --needed base-devel git --noconfirm

echo "Enabling Flathub support"
sudo pacman -S flatpak --noconfirm

echo "Making apps boot faster based on how much you use them"
echo "Please click enter twice and maybe click type y if needed."
yay -S preload --noconfirm
sudo systemctl enable preload && sudo systemctl start preload

echo "Enabling auto clean cache (it gets very big)"
sudo pacman -S pacman-contrib --noconfirm
sudo systemctl enable paccache.timer
neofetch

echo "Creating user directories"
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo "Installing some fonts"
sudo pacman -S enchant mythes-en ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good ttf-droid ttf-dejavu aspell-en icedtea-web gst-libav ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool libmythes git wget python  --noconfirm

echo "Enabling Faster boot (5 sec speedup)"
grub_file="/etc/default/grub"
if [ ! -f "$grub_file" ]; then
    echo "GRUB configuration file not found: $grub_file"
    exit 1
fi
sudo cp "$grub_file" "${grub_file}.bak"
echo "Backup of GRUB configuration created at ${grub_file}.bak"
if grep -q "^GRUB_TIMEOUT_STYLE=hidden" "$grub_file"; then
    echo "GRUB_TIMEOUT_STYLE=hidden is already set in $grub_file"
else
    echo "Adding GRUB_TIMEOUT_STYLE=hidden to $grub_file"
    echo "GRUB_TIMEOUT_STYLE=hidden" | sudo tee -a "$grub_file" > /dev/null
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB configuration updated successfully!"

echo "Installing and setting up Zsh"
sudo pacman -S zsh --noconfirm
chsh -s $(which zsh)
touch ~/.zshrc
cp /etc/zsh/zshrc ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
zsh
git clone https://github.com/wesbos/Cobalt2-iterm.git
cd Cobalt2-iterm
cp cobalt2.zsh-theme ~/.oh-my-zsh/themes
zshrc_file="$HOME/.zshrc"
if [ ! -f "$zshrc_file" ]; then
    echo "Zsh configuration file not found: $zshrc_file"
    exit 1
fi
if grep -q "^ZSH_THEME=" "$zshrc_file"; then
    echo "Updating existing ZSH_THEME line in $zshrc_file"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="cobalt2"/' "$zshrc_file"
else
    echo "Adding ZSH_THEME line to $zshrc_file"
    echo 'ZSH_THEME="cobalt2"' >> "$zshrc_file"
fi
pip install --user powerline-status
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
source $zshrc_file

echo "Installing end-4/hyprland dots"
git clone https://github.com/end-4/dots-hyprland.git
cd dots-hyprland
./install.sh

flatpak install flathub com.atlauncher.ATLauncher --assumeyes
flatpak install flathub com.obsproject.Studio --assumeyes
flatpak install flathub com.google.Chrome --assumeyes
flatpak install flathub dev.vencord.Vesktop --assumeyes
flatpak install flathub com.visualstudio.code --assumeyes
flatpak install flathub com.valvesoftware.Steam --assumeyes
flatpak install flathub net.lutris.Lutris --assumeyes
flatpak install flathub md.obsidian.Obsidian --assumeyes
flatpak install flathub org.mozilla.Thunderbird --assumeyes
flatpak install flathub org.kde.kdenlive  --assumeyes
flatpak install flathub io.github.mimbrero.WhatsAppDesktop  --assumeyes
flatpak install flathub net.davidotek.pupgui2 --assumeyes
flatpak install flathub com.github.Matoking.protontricks  --assumeyes
flatpak install flathub org.xonotic.Xonotic --assumeyes
flatpak install flathub it.mijorus.gearlever  --assumeyes
flatpak install flathub io.gitlab.adhami3310.Impression --assumeyes
flatpak install flathub com.warlordsoftwares.youtube-downloader-4ktube  --assumeyes
flatpak install flathub com.raggesilver.BlackBox  --assumeyes
yay -S waydroid --noconfirm
waydroid init
sudo systemctl enable waydroid-container.service
sudo systemctl start waydroid-container.service
echo "alias android='waydroid session start && waydroid show-full-ui'" >> ~/.zshrc
PACMAN_CONF="/etc/pacman.conf"
sudo cp "$PACMAN_CONF" "$PACMAN_CONF.bak"
if grep -q "^\[multilib\]" "$PACMAN_CONF" && grep -q "^Include = /etc/pacman.d/mirrorlist" "$PACMAN_CONF"; then
    echo "The [multilib] section is already enabled."
    exit 0
fi
sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' "$PACMAN_CONF"
sudo pacman -Syu
sudo pacman -Syu
sudo pacman -S wine wine-mono wine-gecko --noconfirm
sudo pacman -S clamav --noconfirm
sudo systemctl enable clamav-freshclam
sudo systemctl start clamav-freshclam
sudo pacman -S fail2ban --noconfirm
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo pacman -S syncthing --noconfirm
sudo systemctl enable syncthing
sudo systemctl start syncthing
sudo pacman -S docker --noconfirm
sudo systemctl enable docker
sudo systemctl start docker
sudo pacman -S netdata --noconfirm
sudo systemctl enable netdata
sudo systemctl start netdata
sudo pacman -S nmap --noconfirm
yay -S arc-gtk-theme --noconfirm
sudo pacman -S tlp --noconfirm
sudo systemctl enable tlp
sudo systemctl start tlp
sudo pacman -S btrfs-progs --noconfirm
yay -S pyenv --noconfirm
sudo pacman -S nodejs npm --noconfirm
yay -S privacy-tools --noconfirm
yay -S zsh-completions --noconfirm
yay -S bat --noconfirm
sudo pacman -S ripgrep --noconfirm
sudo pacman -S jq --noconfirm
sudo pacman -S vlc --noconfirm
sudo pacman -S qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm guestfs-tools libosinfo --noconfirm
yay -S tuned --noconfirm
sudo pacman -S megatools ntfs-3g gparted --noconfirm
megadl 'https://mega.nz/file/2NsFCA6J#51CA8DcQ6py_v69x5wE5je9lJA7x5C1kq7rjsG5wgaE'
mv windowws.qcow ~
echo "alias windowsten='qemu-system-x86_64 --enable-kvm -hda ~/.windows.qcow -m 10G -smp 4 -bios /usr/share/ovmf/x64/OVMF.fd'" >> ~/.zshrc
git clone https://github.com/libratbag/piper.git
cd piper
meson builddir --prefix=/usr/
sudo pacman -S corectrl
yay -S auto-cpufreq --noconfirm
sudo systemctl mask power-profiles-daemon.service
sudo systemctl enable --now auto-cpufreq 

cd
mv ~/windowws.qcow .windows.qcow
echo "When you want to use windows type windowsten in the terminal to boot up a windows 10 virtual machine"
echo "And if you want android apps execute the command 'android' and it will boot up a gui so you can install apps"
source ~/.zshrc
sl

yay -S timeshift --noconfirm
echo "Please setup timeshift then close it to continue"
timeshift
yay -S grub-btrfs --noconfirm
sudo /etc/grub/grub.d/41_snapshots-btrfs
sudo grub-mkconfig -o /boot/grub/grub.cfg
yay -S inotify-tools --noconfirm
SERVICE_FILE="/etc/systemd/system/grub-btrfsd.service.d/override.conf"
if [ -f "$SERVICE_FILE" ]; then
    sed -i 's|ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' "$SERVICE_FILE"
    sudo systemctl daemon-reload
    sudo systemctl restart grub-btrfsd
else
    echo "Service file $SERVICE_FILE not found."
fi
sudo systemctl enable grub-btrfsd
sudo systemctl start grub-btrfsd
yay -S timeshift-autosnap --noconfirm

sudo pacman -Sc --noconfirm
echo "So your system is IMMORTAL as each package update/installation will backup your system first and theres backups happening depending on how you configured timeshift "
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak
if sudo grep -q '^Defaults[ \t]*timestamp_timeout=' $SUDOERS_FILE; then
    sudo sed -i 's/^Defaults[ \t]*timestamp_timeout=.*/Defaults timestamp_timeout=5/' $SUDOERS_FILE
else
    echo 'Defaults timestamp_timeout=5' | sudo tee -a $SUDOERS_FILE
fi
visudo -c
if [ $? -ne 0 ]; then
    echo "Syntax error in sudoers file. Restoring from backup."
    cp ${SUDOERS_FILE}.bak $SUDOERS_FILE
fi
cd ~/yay
rm -rf Cobalt2-iterm
cd ~
cp autosetuparch/setup.sh ~
rm -rf autosetuparch
echo "Type 'y' to reboot or 'n' to reboot later for changes to take place"
echo "If you got a Syntax error in sudeors file. Restoring from backup. directly above these 2 lines then you must manually reset the password timeout for sudoers file using sudo visudo and making Defaults timestamp_timeout=5"
echo "the script folder is deleted but the script itself is saved in your home directory just in case you want to review it or re-install stuff if you have any reccomendations contact me on discord husseinplayz"
read -r user_input
if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
    sudo reboot
elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
    echo "Please reboot when possible for all changes to take place"
    echo "Or your pc is fried"
else
    echo "Invalid input. Please type 'y' or 'n'"
fi
