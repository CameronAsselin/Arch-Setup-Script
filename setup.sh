#!/bin/bash

# Update system
sudo pacman -Syu

# Install packages
sudo pacman -S amd-ucode refind ufw networkmanager network-manager-applet wpa_supplicant mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers vulkan-validation-layers vulkan-tools hyprland hyprpaper wf-recorder man-pages iniparser dialog reflector cups xdg-utils xdg-user-dirs libsecret bluez bluez-utils blueberry bind linux-headers samba whois dosfstools mtools bash-completion ark syncthing gnome-tweaks sddm weston xorg-xwayland wayland wlroots xdg-desktop-portal-wlr xdg-desktop-portal waybar refind pipewire lib32-pipewire pipewire-jack lib32-pipewire-jack pipewire-pulse pipewire-alsa sddm-kcm nerd-fonts ttf-font-awesome terminus-font noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-inconsolata papirus-icon-theme cmake gcc ntfs-3g fastfetch htop nmap sqlmap git firefox thunar gvfs sshfs gvfs-smb seahorse gnome-keyring libsecret thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin thunar-volman tumbler ffmpegthumbnailer libgsf webp-pixbuf-loader thunderbird gnome-calculator gimp krita libreoffice-still steam mangohud gamescope bitwarden mpv tlp dunst rofi qbittorrent gotop cmus ranger torbrowser-launcher weechat ruby tcl tor nyx gfeeds neovim mousepad obs-studio discord wine blender veracrypt copyq wl-copy retroarch retroarch-assets-xmb retroarch-assets-ozone libretro-core-info monero monero-gui reaper obsidian openvpn feh exa calcurse okular kleopatra soundconverter strawberry gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly

# Enable services
sudo systemctl enable tlp.service
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
sudo ufw allow from 192.168.0.0/24
sudo ufw allow qBittorrent
sudo ufw limit ssh
sudo ufw enable

# Download dotfiles from github
cd ~/Downloads
git clone https://github.com/CameronAsselin/dotfiles.git
mv ~/Downloads/dotfiles/.bashrc ~/
mv ~/Downloads/dotfiles/config/* ~/.config/
mv ~/Downloads/dotfiles/Pictures/theme ~/Pictures
sudo rm -r -f ~/Downloads/dotfiles
cd

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
sudo chmod +x ~/.config/waybar/scripts/crypto/crypto.py
sudo chmod +x ~/.config/waybar/scripts/stock/stock.py
sudo chmod +x ~/.config/dunst/scripts/volume_brightness_wayland.sh

# Install paru and AUR programs
cd ~/Downloads
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd
sudo rm -r -f ~/Downloads/paru
paru -S spotify davinci-resolve anki cava gnome-browser-connector-git ttf-freefont ttf-ms-fonts ttf-linux-libertine ttf-dejavu ttf-ubuntu-font-family chili-sddm-theme papirus-folders-catppuccin-git

# SDDM wayland & theme
mkdir /etc/sddm.conf.d
sudo touch /etc/sddm.conf.d/wayland.conf
sudo touch/usr/share/sddm/themes/chili/theme.conf
sudo echo "[Theme]
Current=chili
[General]
DisplayServer=wayland" > /etc/sddm.conf.d/wayland.conf
sudo cp ~/Pictures/theme/sddm_wallpaper.jpg /usr/share/sddm/themes/chili/assets
sudo echo "[General]
background=assets/sddm_wallpaper.jpg" > /usr/share/sddm/themes/chili/theme.conf
cp ~/Pictures/theme/.face.icon ~/
sudo setfacl -m u:sddm:x ~/
sudo setfacl -m u:sddm:r ~/.face.icon

# GTK theming -> Use gnome-tweaks to change Icons to Papirus
sudo gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
papirus-folders -C cat-mocha-mauve

# Theme nvim with NvChad
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
