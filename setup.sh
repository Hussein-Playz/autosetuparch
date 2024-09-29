#!/bin/bash
DATAFOLDER=$HOME/.auto-setup-arch-script-data
PACMAN_CONF=/etc/pacman.conf
mv zshrc .zshrc
mkdir -p $DATAFOLDER
mkdir -p $DATAFOLDER/logs
echo "Start of first time executing script (incase you end up executing it multiple times)" >> $DATAFOLDER/logs/logs.txt
exec > >(tee -a "$DATAFOLDER/logs/logs.txt") 2>&1
if [ -z "$USER" ]; then
    echo "USER variable not set. Check Logs for more info"
	echo "USER variable not set please set the USER variable to your username Example: if your username is husseinplayz then you do 'export USER=husseinplayz' then re-run the script" >> $DATAFOLDER/logs/logs.txt
    exit 1
fi
timestamp=$(date +%Y%m%d_%H%M%S)
cd $DATAFOLDER
if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
	mv yay $DATAFOLDER
fi
echo "" >> $DATAFOLDER/logs/logs.txt
mv .zshrc $DATAFOLDER
PACMAN_PACKAGES="fastfetch neofetch sl ufw base-devel git powertop bluez blueman bluez-utils p7zip unrar tar unzip rsync git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 jdk-openjdk flatpak wine wine-mono wine-gecko xorg-xhost clamav zsh enchant mythes-en ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good ttf-droid ttf-dejavu aspell-en icedtea-web gst-libav ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool libmythes git wget python xdg-user-dirs pacman-contrib syncthing fail2ban docker netdata nmap tlp nodejs npm qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm guestfs-tools libosinfo ripgrep jq vlc ntfs-3g gparted corectrl"
AUR_PACKAGES="google-chrome vesktop-bin visual-studio-code-bin preload waydroid arc-gtk-theme pyenv privacy-tools zsh-completions bat tuned auto-cpufreq"
SUDOERS_FILE="/etc/sudoers"
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak_$timestamp
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
sudo  pacman -Syu --noconfirm
sudo sed -i '/#ParallelDownloads = 5/c\ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/#Colors/c\Colors' /etc/pacman.conf
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^Colors/a ILoveCandy' /etc/pacman.conf
fi
echo "Updating Pacman Mirrors..."
sudo pacman -S reflector --noconfirm
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
if grep -q "^\[multilib\]" "$PACMAN_CONF" && grep -q "^Include = /etc/pacman.d/mirrorlist" "$PACMAN_CONF"; then
    echo "The [multilib] section is already enabled."
fi
sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' "$PACMAN_CONF"
sudo pacman -Sy
sudo pacman -S --needed $PACMAN_PACKAGES --noconfirm
if [ $? -ne 0 ]; then
    echo "Error installing Pacman packages. Check the logs for more info" >&2
	echo "End of script Error In Pacman Package Download. You might have to manuallly install the packages a list of all the packages has been created at ~/.auto-setup-arch-script-data/packages/pacman.txt" >> $DATAFOLDER/logs/logs.txt
	mkdir -p $DATAFOLDER/packages
	rm $DATAFOLDER/packages/pacman.txt
	echo "fastfetch neofetch sl ufw base-devel git powertop bluez blueman bluez-utils p7zip unrar tar unzip rsync git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 jdk-openjdk flatpak wine wine-mono wine-gecko xorg-xhost clamav zsh enchant mythes-en ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good ttf-droid ttf-dejavu aspell-en icedtea-web gst-libav ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool libmythes git wget python xdg-user-dirs pacman-contrib syncthing fail2ban docker netdata nmap tlp nodejs npm qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm guestfs-tools libosinfo ripgrep jq vlc ntfs-3g gparted corectrl" >> $DATAFOLDER/packages/pacman.txt
    exit 1
fi
sudo chown -R "$USER" $DATAFOLDER/yay
cd $DATAFOLDER/yay
makepkg -si
cd $DATAFOLDER
yay -S --needed $AUR_PACKAGES --noconfirm
if [ $? -ne 0 ]; then
    echo "Error installing Pacman packages. Check logs for more info" >&2
	echo "End of script Error In Yay Package Download. You might have to manuallly install the packages a list of all the packages has been created at ~/.auto-setup-arch-script-data/packages/aur.txt" >> $DATAFOLDER/logs/logs.txt
	mkdir -p $DATAFOLDER/packages
	rm $DATAFOLDER/packages/aur.txt
	echo "google-chrome vesktop-bin visual-studio-code-bin preload waydroid arc-gtk-theme pyenv privacy-tools zsh-completions bat tuned auto-cpufreq" >> $DATAFOLDER/packages/aur.txt
    exit 1
fi
sudo systemctl enable ufw
sudo systemctl start ufw
sudo powertop --auto-tune
sudo modprobe btusb
sudo systemctl enable bluetooth && sudo systemctl start bluetooth
check_cpu_vendor() {
    local vendor=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
    echo "$vendor"
}
cpu_vendor=$(check_cpu_vendor)

if [ "$cpu_vendor" == "GenuineIntel" ]; then
    sudo pacman -S intel-ucode --noconfirm
elif [ "$cpu_vendor" == "AuthenticAMD" ]; then
    sudo pacman -S amd-ucode --noconfirm
else
    echo "Unknown CPU vendor: $cpu_vendor"
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable preload && sudo systemctl start preload
sudo systemctl enable paccache.timer
xdg-user-dirs-update
grub_file="/etc/default/grub"
if [ ! -f "$grub_file" ]; then
    echo "GRUB configuration file not found: $grub_file"
fi
sudo cp "$grub_file" "${grub_file}.bak_$timestamp"
if grep -q "^GRUB_TIMEOUT_STYLE=hidden" "$grub_file"; then
    echo "GRUB_TIMEOUT_STYLE=hidden is already set in $grub_file"
else
    echo "Adding GRUB_TIMEOUT_STYLE=hidden to $grub_file"
    echo "GRUB_TIMEOUT_STYLE=hidden" | sudo tee -a "$grub_file" > /dev/null
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/wesbos/Cobalt2-iterm.git
cd Cobalt2-iterm
cp cobalt2.zsh-theme $HOME/.oh-my-zsh/themes
pip install --user powerline-status
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
git clone https://github.com/end-4/dots-hyprland.git
cd dots-hyprland
./install.sh
sudo pacman -Syu --noconfirm
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
if ! systemctl is-active --quiet waydroid-container.service; then
    sudo waydroid init
fi
sudo systemctl enable waydroid-container.service
sudo systemctl start waydroid-container.service
sudo pacman -Syu 
sudo systemctl enable clamav-freshclam
sudo systemctl start clamav-freshclam 
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo systemctl enable syncthing
sudo systemctl start syncthing
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable netdata
sudo systemctl start netdata
sudo systemctl enable tlp
sudo systemctl start tlp
git clone https://github.com/libratbag/piper.git
cd piper
meson builddir --prefix=/usr/
sudo systemctl mask power-profiles-daemon.service
sudo systemctl enable --now auto-cpufreq 
sl
rm $HOME/.zshrc
mv $DATAFOLDER/.zshrc $HOME
yay -Sc --noconfirm
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
echo "The script has finished"
echo "Please reboot your terminal for zsh to work"
echo "End of script" >> $DATAFOLDER/logs/logs.txt
read -r user_input

