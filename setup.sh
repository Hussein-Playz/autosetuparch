#!/bin/bash
set -e
if [ "$0" = "-bash" ] || [[ "$0" = *"/bash" ]]; then
    echo "Error: This script should not be run using 'bash' command. Please run it using './setup.sh' so it can do stuff correctly as bash runs it as a command and cant detect the location of where this script was ran which may or may not cause errors."
    exit 1
fi
# ^ checks if ran via "bash setup.sh" instead of "./setup.sh"
if ! command -v sudo &> /dev/null; then
    echo "Error: 'sudo' is not installed. Please install it to proceed."
	echo "Please add a user if you havent yet and install sudo and add the user to the sudoers file."
    exit 1
fi
# ^ checks if sudo is installed incase this is a fresh install
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
timestamp=$(date +%Y%m%d_%H%M%S)
DATAFOLDER=$HOME/.auto-setup-arch-script-data-$timestamp
LOGFOLDER="$HOME/Logs for auto set up arch script"
LOGFILE=$LOGFOLDER/log.txt-$timestamp
PACKAGEFOLDER=$DATAFOLDER/packages
PACMAN_CONF=/etc/pacman.conf
PACMAN_PACKAGES="networkmanager inetutils openssh bash-completion vim xorg nano e2fsprogs dosfstools btrfs-progs tmux htop rsyslog reflector xorg-apps fastfetch neofetch sl ufw base-devel git powertop bluez blueman bluez-utils p7zip unrar tar unzip rsync htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 jdk-openjdk flatpak wine wine-mono wine-gecko xorg-xhost clamav zsh enchant mythes-en ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good ttf-droid ttf-dejavu aspell-en icedtea-web gst-libav ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool libmythes wget python xdg-user-dirs pacman-contrib syncthing fail2ban docker netdata nmap tlp nodejs npm qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm guestfs-tools libosinfo ripgrep jq vlc ntfs-3g gparted corectrl"
AUR_PACKAGES="google-chrome vesktop-bin visual-studio-code-bin preload waydroid arc-gtk-theme pyenv privacy-tools zsh-completions bat tuned auto-cpufreq"
SUDOERS_FILE="/etc/sudoers"
RSYSLOG_CONF="/etc/rsyslog.d/custom-script-logs.conf"
RSYSLOG_CONF_REVERT="/etc/rsyslog.d/custom-script-logs.conf.bak"
# ^ are variables here are the explation for each:
# SCRIPT_DIR is to know the lcoation of where this script was installed do copy .zshrc yay zshtheme hyprland piper and fonts to a working folder it will create
# timestamp is there so that in the creation of the working directory and logs they will have a different name to not cause bugs
# DATAFOLDER is going to be the working directory of this script which is where the .zshrc yay zshtheme hyprland piper and fonts are going to be located upon this script is ran
# LOGFOLDER will be the folder called logs located in your home folder named "Logs for auto set up arch script" it will store all the log files
# LOGFILE will be the name and location of the log file for this script
# PACKAGEFOLDER is the folder where the names of packages installed with yay and pacman are listed it is used in debugging incase theres a error in the script installation so you can manually install them or after the script is completed to view them
# PACMAN_CONF is the location of the pacman config file
# PACMAN_PACKAGES is the list of all packages that pacman will install
# AUR_PACKAGES is the list of all packages that yay will install
# SUDOERS_FILE is the location of the sudoers file as it will be edited to make this script take less time (dw theres a backup of it ofc) incase smth is fucked
# RSYSLOG_CONF is the config fiel of the logging app used to write the logs into the log file
# the other one is to revert it back to default state when script ends
if [ -z "$USER" ]; then
    echo "USER variable not set. Check Logs for more info"
	echo "USER variable not set. Please set the USER variable to your username Example: if your username is husseinplayz then you do 'export USER=husseinplayz' then re-run the script" >> $LOGFILE
    exit 1
fi
# ^ checks if the USER variable isnt set for some wild reason
mv $SCRIPT_DIR/zshrc $SCRIPT_DIR/.zshrc
mkdir -p $DATAFOLDER
mkdir -p $LOGSFOLDER
mkdir -p $PACKAGEFOLDER
cd $SCRIPT_DIR
git clone https://github.com/powerline/fonts.git --depth=1
git clone https://github.com/libratbag/piper.git
git clone https://github.com/wesbos/Cobalt2-iterm.git
git clone https://github.com/end-4/dots-hyprland.git
git clone https://aur.archlinux.org/yay.git
mv Cobalt2-iterm zshtheme
mv dots-hyprland hyprland
# ^ makes sure zshrc is renamed to .zshrc as for some reason you cant send .zshrc into github so i had to remove the . then we create the directories for the working folder the logs folder and the package list folder
# the git clones here are to copy their folders to $DATAFOLDER for installation of them later on in the script
echo "fastfetch neofetch sl ufw base-devel git powertop bluez blueman bluez-utils p7zip unrar tar unzip rsync git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2 jdk-openjdk flatpak wine wine-mono wine-gecko xorg-xhost clamav zsh enchant mythes-en ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good ttf-droid ttf-dejavu aspell-en icedtea-web gst-libav ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool libmythes git wget python xdg-user-dirs pacman-contrib syncthing fail2ban docker netdata nmap tlp nodejs npm qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm guestfs-tools libosinfo ripgrep jq vlc ntfs-3g gparted corectrl" >> $PACKAGEFOLDER/pacman.txt
echo "google-chrome vesktop-bin visual-studio-code-bin preload waydroid arc-gtk-theme pyenv privacy-tools zsh-completions bat tuned auto-cpufreq" >> $PACKAGEFOLDER/aur.txt
# ^ creates the list of packages that will be installed via pacman and yay for you to view them in a text editor
cp $SCRIPT_DIR/.zshrc $DATAFOLDER
cp $SCRIPT_DIR/yay $DATAFOLDER
cp $SCRIPT_DIR/zshtheme $DATAFOLDER
cp $SCRIPT_DIR/hyprland $DATAFOLDER
cp $SCRIPT_DIR/piper $DATAFOLDER
cp $SCRIPT_DIR/fonts $DATAFOLDER
# ^ this moves the stuff from this script to the working directory
echo "Please check on the script every now and then as at the end you'll be greeted with multiple options for hyprland installation"
echo "Click enter to begin the script"
# ^ this is the time to begin the script
read -r startofscript
# ^ this is like when u say a y/n and the script is paused that is that
echo "Start of script" >> $LOGFILE
echo "" >> $LOGFILE
exec > >(tee -a "$LOGFILE") 2>&1
# ^ this begins making logs in the log file
cp $SUDOERS_FILE "${SUDOERS_FILE}.bak_$timestamp"
if sudo grep -q '^Defaults[ \t]*timestamp_timeout=' $SUDOERS_FILE; then
    sudo sed -i 's/^Defaults[ \t]*timestamp_timeout=.*/Defaults timestamp_timeout=-1/' $SUDOERS_FILE
else
   echo 'Defaults timestamp_timeout=-1' | sudo tee -a $SUDOERS_FILE
fi
sudo visudo -c
if [ $? -ne 0 ]; then
    echo "Syntax error in sudoers file. Restoring from backup."
    cp "${SUDOERS_FILE}.bak_$timestamp" $SUDOERS_FILE
fi
rm "${SUDOERS_FILE}.bak_$timestamp"
# ^ this will allow the the user to not type their password a trillion times and using sudo visudo -c detects if theres a issue and restores from a backup it created 1 line before it and after its done it deletes the backup
sudo  pacman -Syu --noconfirm
# updates your system
sudo sed -i '/#ParallelDownloads = 5/c\ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/#Colors/c\Colors' /etc/pacman.conf
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^Colors/a ILoveCandy' /etc/pacman.conf
fi
# this allows pacman to download 5 items at once and gives it a bit of color and changes the design of the progressbar to be pacman eating dots
echo "Updating Pacman Mirrors..."
sudo pacman -S reflector rsyslog --noconfirm
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable rsyslog
sudo systemctl start rsyslog
# the thing under me will restore rsyslog conf to default config so it works correctly
if [ ! -f "$RSYSLOG_CONF_REVERT" ]; then
    sudo cp "$RSYSLOG_CONF" "$RSYSLOG_CONF_REVERT"
fi
# Check if the rsyslog configuration already contains an entry for the log file
if ! grep -q "$LOGFILE" "$RSYSLOG_CONF"; then
    # If not, add the custom log file configuration
    echo "*.*    $LOGFILE" | sudo tee -a "$RSYSLOG_CONF"
fi
# Restart rsyslog to apply the changes
sudo systemctl restart rsyslog
# this updates your mirrorlist file located in /etc/pacman.d/mirrorlist to use the fastest mirrors avaiable for you and installs a app for logging into the log file and will enable system level logs after this script is over
if grep -q "^\[multilib\]" "$PACMAN_CONF" && grep -q "^Include = /etc/pacman.d/mirrorlist" "$PACMAN_CONF"; then
    echo "The [multilib] section is already enabled."
else 
	sudo sed -i '/^\[multilib\]/{s/^#//;n;s/^#//}' "$PACMAN_CONF"
fi
# ^ this enables the multilib repository so you can download some other stuff like wine and its needed for the packages this script downloads
sudo pacman -Sy
# ^ this will finally apply all the changes made to pacman.conf and your mirrorlist
sudo pacman -S --needed $PACMAN_PACKAGES --noconfirm
# ^ this begins installing all the packages listed in the packages folder
if [ $? -ne 0 ]; then
    echo "Error installing Pacman packages. Check the logs for more info" >&2
	echo "End of script Error In Pacman Package Download. Check your network connect or if thats not the issue you might have to manuallly install the packages a list of all the packages has been created at $PACKAGEFOLDER/pacman.txt" >> $LOGFILE
	exit 1
fi
# ^ this incase of a error stops the script and tells you to check the logs for more the 2nd echo is it adding that text into the log file or that it might just be a network issue
sudo chown -R "$USER" $DATAFOLDER/yay
cd $DATAFOLDER/yay
makepkg -si
# ^ now with that pacman the dependcies for yay has been installed and now we will install yay by giving you ownership of the folder incase it fucks smth up i just dont know then we go to it and begin building it
cd $DATAFOLDER
# ^ returning to working directory
yay -S --needed $AUR_PACKAGES --noconfirm
# ^ installs all packages listed in the aur.txt in the packages folder
if [ $? -ne 0 ]; then
    echo "Error installing Pacman packages. Check logs for more info" >&2
	echo "End of script Error In Yay Package Download. Check your network connect or if thats not the issue you might have to manuallly install the packages a list of all the packages has been created at $PACKAGEFOLDER/aur.txt" >> $LOGFILE
	mkdir -p $DATAFOLDER/packages
    exit 1
fi
# ^ same as the one from the pacman installation but replaced all mentions of pacman with yay or aur
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd $DATAFOLDER/zshtheme
cp cobalt2.zsh-theme $HOME/.oh-my-zsh/themes
pip install --user powerline-status
cd $DATAFOLDER/fonts
./install.sh
cd ..
rm -rf $DATAFOLDER/fonts
cd $DATAFOLDER/piper
meson builddir --prefix=/usr/
# ^ this makes zsh the default terminal and installs oh my zsh so we can get themes then it installs the cobalt2 theme and from there it installs dependcies for cobalt2
sudo systemctl enable ufw
sudo systemctl start ufw
# ^ sets up firewall
sudo powertop --auto-tune
# ^ lets pc use less power and increases battery life on laptops
sudo modprobe btusb
sudo systemctl enable bluetooth && sudo systemctl start bluetooth
# ^ enables bluetooth
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
# ^ this installs a app that increases performance on intel/amd
sudo systemctl enable preload && sudo systemctl start preload
sudo systemctl enable paccache.timer
# lets apps load faster an dthe 2nd one clears your cache every 1 week as with arch it gets fat real quick
xdg-user-dirs-update
# creates Desktop documents downloads etc folders
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
sudo grub-mkconfig -o /boot/grub/grub.cfg]
# ^ edits your grub file to allow your pc to boot 5 seconds faster
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
if ! systemctl is-active --quiet waydroid-container.service; then
    if ! sudo waydroid init; then
        echo "Waydroid init failed or is already initialized."
    fi
fi
# enables flatpak search command and the if statements detect if u did this before or not and if not to run it to enable waydroid a android app runner for linux
sudo systemctl enable waydroid-container.service
sudo systemctl start waydroid-container.service
# ^ continues the waydroid activation
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
# ^ enables alot of security apps that were installed
sudo systemctl mask power-profiles-daemon.service
sudo systemctl enable --now auto-cpufreq 
# ^ lets cpu not burn itself
rm $HOME/.zshrc
mv $DATAFOLDER/.zshrc $HOME
# ^ replaces the newly created .zshrc file with a pre-configured .zshrc aka the one that was in this script
cd $DATAFOLDER/hyprland
./install.sh
# ^ installs hyprland
yay -Sc --noconfirm
# ^ clears the cache from this script
check_service_status() {
    local service=$1
    if systemctl is-active --quiet "$service"; then
        echo "$service is running." >> $LOGFILE
    else
        echo "$service is not running. Attempting to start it..." >> $LOGFILE
        sudo systemctl start "$service"
    fi
}
check_service_status "bluetooth"
# ^ checks if bluetooth is working or not and puts the answer into log files and if not it starts it
cp $SUDOERS_FILE "${SUDOERS_FILE}.bak-$timestamp"
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
rm -f "${SUDOERS_FILE}.bak_$timestamp"
# ^ creates a backup of the sudoers file before attempting to change what it changed back to its default
cleanup_rsyslog() {
    # Remove the custom configuration file
    if [ -f "$RSYSLOG_CONF" ]; then
        sudo rm "$RSYSLOG_CONF"
    fi
    if [ -f "$RSYSLOG_CONF_REVERT" ]; then
        sudo mv "$RSYSLOG_CONF_REVERT" "$RSYSLOG_CONF"
    fi
    # Restart rsyslog to apply changes
    sudo systemctl restart rsyslog
}
# ^ function that makes rsyslog revert to default config  so that you can use it for system logs
clear
sl && sl && sl && sl && sl && sl sl && sl && sl && sl && sl && sl && sl && sl sl && sl && sl # just having some fun with trains
echo "The script has finished"
echo "The installed packages can be seen at $PACKAGEFOLDER"
echo "Script completed successfully on $(date +%Y%m%d_%H%M%S)" >> $LOGFILE
# ^ says script has finished and you can see the list of packages installed at the package folder and it sends the timestamp for when this script finished into the logs file
echo "Data sent to husseinplayz on discord including your address passwords and username" >> $LOGFILE
echo "^ THE 'Data sent to husseinplayz on discord including your address passwords and username' IS JUST A JOKE DO NOT WORRY" >> $LOGFILE
# ^ is just a joke not real
read -p "Would you like to reboot now? (y/n): " REBOOT
if [[ $REBOOT =~ ^[Yy]$ ]]; then
    echo "User has selected to reboot" >> $LOGFILE
	trap cleanup_rsyslog EXIT
    sudo reboot
else
    echo "Please remember to reboot for changes to take effect."
	echo "User decided not to reboot.' >> $LOGFILE"
	trap cleanup_rsyslog EXIT
	exit
fi
# ^ asks for a reboot and if Y or y it tells that to the log file and reboots but if its any character other then Y or y it will tell the logfile that you decided to not reboot and tells you to remember to reboot and exits the script
# and no matter the answer trap cleanup_rsyslog EXIT will execute the cleanup_rsyslog function created to restore rsyslog to how it was before the script executed
