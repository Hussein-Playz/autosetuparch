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
sudo pacman -S ssh-askpass
export SUDO_ASKPASS=/usr/bin/ssh-askpass


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
sudo chown -R $USER:$USER ./yay
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
sudo pacman -S p7zip unrar tar rsync git neofetch htop exfat-utils fuse-exfat ntfs-3g flac jasper aria2  --noconfirm
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
rm -rf install.sh
#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"
source ./scriptdata/environment-variables
source ./scriptdata/functions
source ./scriptdata/installers
source ./scriptdata/options

#####################################################################################
if ! command -v pacman >/dev/null 2>&1; then 
  printf "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n"
  exit 1
fi
prevent_sudo_or_root

startask() {
  # Automatically confirm all prompts
  sleep 0
  ask=false
}

startask

set -e
#####################################################################################
printf "\e[36m[$0]: 1. Get packages and setup user groups/services\n\e[0m"

# Issue #363
if [ "$SKIP_SYSUPDATE" != true ]; then
  v sudo pacman -Syu
fi

remove_bashcomments_emptylines ${DEPLISTFILE} ./cache/dependencies_stripped.conf
readarray -t pkglist < ./cache/dependencies_stripped.conf

if ! command -v yay >/dev/null 2>&1; then
  echo -e "\e[33m[$0]: \"yay\" not found.\e[0m"
  showfun install-yay
  v install-yay
fi

# Install extra packages from dependencies.conf as declared by the user
if (( ${#pkglist[@]} != 0 )); then
  if $ask; then
    # Execute per element of the array $pkglist
    for i in "${pkglist[@]}"; do
      v yay -S --needed $i
    done
  else
    # Execute for all elements of the array $pkglist in one line
    v yay -S --needed --noconfirm ${pkglist[*]}
  fi
fi

# Convert old dependencies to non-explicit dependencies
set-explicit-to-implicit() {
  remove_bashcomments_emptylines ./scriptdata/previous_dependencies.conf ./cache/old_deps_stripped.conf
  readarray -t old_deps_list < ./cache/old_deps_stripped.conf
  pacman -Qeq > ./cache/pacman_explicit_packages
  readarray -t explicitly_installed < ./cache/pacman_explicit_packages

  echo "Attempting to set previously explicitly installed deps as implicit..."
  for i in "${explicitly_installed[@]}"; do
    for j in "${old_deps_list[@]}"; do
      [ "$i" = "$j" ] && yay -D --asdeps "$i"
    done
  done

  return 0
}

set-explicit-to-implicit

# Install core dependencies from the meta-packages
metapkgs=(./arch-packages/illogical-impulse-{audio,backlight,basic,fonts-themes,gnome,gtk,portal,python,screencapture,widgets})
metapkgs+=(./arch-packages/illogical-impulse-ags)
metapkgs+=(./arch-packages/illogical-impulse-microtex-git)
metapkgs+=(./arch-packages/illogical-impulse-oneui4-icons-git)
[[ -f /usr/share/icons/Bibata-Modern-Classic/index.theme ]] || \
  metapkgs+=(./arch-packages/illogical-impulse-bibata-modern-classic-bin)
try sudo pacman -R illogical-impulse-microtex

for i in "${metapkgs[@]}"; do
  metainstallflags="--needed --noconfirm"
  v install-local-pkgbuild "$i" "$metainstallflags"
done

case $SKIP_PYMYC_AUR in
  true) sleep 0 ;;
  *)
    pymycinstallflags="--noconfirm"
    v install-local-pkgbuild "./arch-packages/illogical-impulse-pymyc-aur" "$pymycinstallflags"
    ;;
esac

case $SKIP_HYPR_AUR in
  true) sleep 0 ;;
  *)
    hyprland_installflags="-S --noconfirm"
    v yay $hyprland_installflags --asdeps hyprutils-git hyprlang-git hyprcursor-git hyprwayland-scanner-git
    v yay $hyprland_installflags --answerclean=a hyprland-git
    ;;
esac

## Optional dependencies
if pacman -Qs ^plasma-browser-integration$; then 
  SKIP_PLASMAINTG=true
fi

case $SKIP_PLASMAINTG in
  true) sleep 0 ;;
  *)
    echo -e "\e[33m[$0]: The size of \"plasma-browser-integration\" is about 250 MiB.\e[0m"
    echo -e "\e[33mIt is needed if you want playtime of media in Firefox to be shown on the music controls widget.\e[0m"
    echo -e "\e[33mInstall it? [y/N]\e[0m"
    p=y
    case $p in
      y) x sudo pacman -S --needed --noconfirm plasma-browser-integration ;;
      *) echo "Ok, won't install" ;;
    esac
    ;;
esac

v sudo usermod -aG video,i2c,input "$(whoami)"
v bash -c "echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf"
v systemctl --user enable ydotool --now
v gsettings set org.gnome.desktop.interface font-name 'Rubik 11'

#####################################################################################
printf "\e[36m[$0]: 2. Installing parts from source repo\e[0m\n"
sleep 1

#####################################################################################
printf "\e[36m[$0]: 3. Copying + Configuring\e[0m\n"

# In case some folders do not exist
v mkdir -p $XDG_BIN_HOME $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

# MISC (For .config/* but not AGS, not Fish, not Hyprland)
case $SKIP_MISCCONF in
  true) sleep 0 ;;
  *)
    for i in $(find .config/ -mindepth 1 -maxdepth 1 ! -name 'ags' ! -name 'fish' ! -name 'hypr' -exec basename {} \;); do
      echo "[$0]: Found target: .config/$i"
      if [ -d ".config/$i" ]; then 
        v rsync -av --delete ".config/$i/" "$XDG_CONFIG_HOME/$i/"
      elif [ -f ".config/$i" ]; then 
        v rsync -av ".config/$i" "$XDG_CONFIG_HOME/$i"
      fi
    done
    ;;
esac

case $SKIP_FISH in
  true) sleep 0 ;;
  *)
    v rsync -av --delete .config/fish/ "$XDG_CONFIG_HOME"/fish/
    ;;
esac

# For AGS
case $SKIP_AGS in
  true) sleep 0 ;;
  *)
    v rsync -av --delete --exclude '/user_options.js' .config/ags/ "$XDG_CONFIG_HOME"/ags/
    t="$XDG_CONFIG_HOME/ags/user_options.js"
    if [ -f $t ]; then
      echo -e "\e[34m[$0]: \"$t\" already exists.\e[0m"
      existed_ags_opt=y
    else
      echo -e "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
      v cp .config/ags/user_options.js $t
      existed_ags_opt=n
    fi
    ;;
esac

# For Hyprland
case $SKIP_HYPRLAND in
  true) sleep 0 ;;
  *)
    v rsync -av --delete --exclude '/custom' --exclude '/hyprland.conf' .config/hypr/ "$XDG_CONFIG_HOME"/hypr/
    t="$XDG_CONFIG_HOME/hypr/hyprland.conf"
    if [ -f $t ]; then
      echo -e "\e[34m[$0]: \"$t\" already exists, will not do anything.\e[0m"
      v cp -f .config/hypr/hyprland.conf $t.new
      existed_hypr_conf=y
    else
      echo -e "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
      v cp .config/hypr/hyprland.conf $t
      existed_hypr_conf=n
    fi
    t="$XDG_CONFIG_HOME/hypr/custom"
    if [ -d $t ]; then
      echo -e "\e[34m[$0]: \"$t\" already exists, will not do anything.\e[0m"
    else
      echo -e "\e[33m[$0]: \"$t\" does not exist yet.\e[0m"
      v rsync -av --delete .config/hypr/custom/ $t/
    fi
    ;;
esac

# Some folders (e.g., .local/bin) should have full access
setfacl -Rdm u::rwx,g::rwx,o::rx "$XDG_BIN_HOME"
setfacl -Rdm u::rwx,g::rwx,o::rx "$XDG_CONFIG_HOME"
setfacl -Rdm u::rwx,g::rwx,o::rx "$XDG_CACHE_HOME"
setfacl -Rdm u::rwx,g::rwx,o::rx "$XDG_DATA_HOME"

echo -e "\e[32m[$0]: Finished.\e[0m"
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