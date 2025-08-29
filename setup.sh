#!/bin/bash

# Update system
sudo pacman -Syu

# Install packages
sudo pacman -S amd-ucode grub ufw networkmanager network-manager-applet wpa_supplicant mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers vulkan-validation-layers vulkan-tools gnome-system-monitor hyprland hyprpaper wf-recorder man-pages iniparser dialog reflector cups xdg-utils xdg-user-dirs libsecret bluez bluez-utils blueberry linux-headers zenity samba whois dosfstools mtools bash-completion ark unrar syncthing qemu-full qemu-block-gluster qemu-block-iscsi qemu-guest-agent qemu-user-static libvirt dnsmasq openbsd-netcat virt-manager sddm weston layer-shell-qt layer-shell-qt5 xorg-xwayland wayland xdg-desktop-portal-wlr xdg-desktop-portal waybar refind pipewire lib32-pipewire pipewire-jack lib32-pipewire-jack pipewire-pulse pipewire-alsa pavucontrol sddm-kcm nerd-fonts terminus-font noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-inconsolata papirus-icon-theme cmake gcc ntfs-3g fastfetch htop nmap sqlmap git firefox thunar gvfs sshfs gvfs-smb gvfs-mtp seahorse gnome-keyring libsecret thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin thunar-volman tumbler ffmpegthumbnailer libgsf webp-pixbuf-loader gnome-themes-extra nwg-look thunderbird gnome-calculator gimp krita handbrake libreoffice-still steam mangohud gamescope bitwarden mpv tlp dunst rofi-wayland rofi-emoji qbittorrent cmus ranger torbrowser-launcher weechat ruby tcl tor nyx gfeeds neovim mousepad obs-studio discord wine blender veracrypt copyq wl-clipboard retroarch retroarch-assets-xmb retroarch-assets-ozone libretro-core-info monero monero-gui reaper obsidian openvpn networkmanager-openvpn feh exa okular kleopatra soundconverter strawberry gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly

# Ask user if the device is a laptop and install/enable/start tlp if it is
answer=$(zenity --info --text="<span size=\"xx-large\">Is this device a <b>laptop</b>?</span>" --title="Laptop?" --ok-label="No" --extra-button="Yes")
if [ $answer = "Yes" ]; then
  sudo pacman -S tlpdnsmas
  sudo systemctl enable tlp.service
  sudo systemctl start  tlp.service
else
  exit
fi

# Enable services 
sudo systemctl enable NetworkManager
sudo systemctl enable ufw
sudo systemctl enable syncthing@cameron.service

# Enable SMB and download the config
sudo touch /etc/samba/smb.conf
sudo curl 'https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD' -o /etc/samba/smb.conf
sudo systemctl start smb.service
sudo systemctl enable smb.service

# Configure firewall
sudo ufw default deny
sudo ufw allow from 192.168.1.0/24
sudo ufw allow qBittorrent
sudo ufw limit ssh
sudo ufw enable

# Download dotfiles from github
cd ~/Downloads
git clone http://github.com/CameronAsselin/dotfiles.git
mv ~/Downloads/dotfiles/.bashrc ~/
mv ~/Downloads/dotfiles/config/* ~/.config/
mv ~/Downloads/dotfiles/Pictures/theme ~/Pictures
sudo rm -r -f ~/Downloads/dotfiles
cd
mkdir ~/Pictures/Screenshots

# Make dotfiles folder and link dotfiles to it
mkdir -p ~/dotfiles/{config,Pictures}
ln -s ~/Pictures/theme ~/dotfiles/Pictures
ln -s ~/.config/sway ~/dotfiles/config
ln -s ~/.config/waybar ~/dotfiles/config
ln -s ~/.config/dunst ~/dotfiles/config
ln -s ~/.config/hypr ~/dotfiles/config
ln -s ~/.config/kitty ~/dotfiles/config
ln -s ~/.config/rofi ~/dotfiles/config

# Set waybar scripts to be executable
sudo chmod +x ~/.config/waybar/scripts/launch.sh
sudo chmod +x ~/.config/waybar/scripts/get_weather.sh
sudo chmod +x ~/.config/waybar/scripts/shutdown.sh
sudo chmod +x ~/.config/waybar/scripts/crypto/crypto.py
sudo chmod +x ~/.config/dunst/scripts/volume_brightness_wayland.sh

# Install paru and AUR programs
cd ~/Downloads
git clone http://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd
sudo rm -r -f ~/Downloads/paru
paru -S spotify davinci-resolve anki cava gnome-browser-connector-git ttf-freefont ttf-ms-fonts ttf-linux-libertine ttf-dejavu ttf-ubuntu-font-family chili-sddm-theme papirus-folders-catppuccin-git

# SDDM wayland & theme
sudo mkdir /etc/sddm.conf.d
sudo touch /etc/sddm.conf.d/10-wayland.conf
sudo echo "[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1
[Theme]
Current=chili" > sudo /etc/sddm.conf.d/10-wayland.conf
sudo cp ~/Pictures/theme/sddm/background.jpg /usr/share/sddm/themes/chili/assets
cp ~/Pictures/theme/.face.icon ~/
sudo setfacl -m u:sddm:x ~/
sudo setfacl -m u:sddm:r ~/.face.icon

# GTK theming -> Use gnome-tweaks to change Icons to Papirus
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
papirus-folders -C cat-mocha-mauve

# Theme nvim with NvChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Finished message
zenity --info --text="<span size=\"xx-large\"><b>Complete</b> - Please reboot the device at your earliest convenience</span>" --title="Finished" --ok-label="Ok"
