# Arch Setup Script
While logged in as a non-root user, run the following commands on a fresh Arch Linux install for my complete setup<br>
<br>
```
sudo pacman -S git
git clone https://github.com/CameronAsselin/Arch-Setup-Script.git
sudo chmod +x ./Arch-Setup-Script/setup.sh
./Arch-Setup-Script/setup.sh
rm -rf ./Arch-Setup-Script
```

### Requirements
##### Settings
- Must have access to multilib repository in pacman or else lib32 packages will fail to install. Check the [Arch Wiki](https://wiki.archlinux.org/title/Official_repositories#Enabling_multilib) for more details.
##### Hardware
- This build utilizes drivers for AMD CPU and GPU
