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

sudo pacman -Syu --noconfirm
flatpak install flathub com.atlauncher.ATLauncher --assumeyes
flatpak install flathub com.obsproject.Studio --assumeyes
flatpak install flathub com.google.Chrome --assumeyes
flatpak install flathub dev.vencord.Vesktop --assumeyes
flatpak install flathub com.visualstudio.code --assumeyes
flatpak install flathub io.github.zen_browser.zen --assumeyes
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
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "    "
echo "Type 'y' to reboot or 'n' to reboot later for changes to take place"
echo "If you got a Syntax error in sudeors file. Restoring from backup. directly above these 2 lines then you must manually reset the password timeout for sudoers file using sudo visudo and making Defaults timestamp_timeout=5"
echo "the script folder is deleted but the script itself is saved in your home directory just in case you want to review it or re-install stuff if you have any reccomendations contact me on discord husseinplayz"
echo "Please run setup2.sh after rebooting to continue the setup"
read -r user_input
if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
    systemctl disable finish-setup.service
    rm /etc/systemd/system/finish-setup.service
    rm ~/setup2.sh
    sudo reboot
elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
    systemctl disable finish-setup.service
    rm /etc/systemd/system/finish-setup.service
    rm ~/setup2.sh
    exit 1
else
    echo "Invalid input. Please type 'y' or 'n'"
    systemctl disable finish-setup.service
    rm /etc/systemd/system/finish-setup.service
    rm ~/setup2.sh
fi
