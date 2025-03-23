# do this first to make sure we have up to date mirrors
sudo pacman -Syu

# there's probably going to be a lot of sudoing, set up fingerprint auth now
sudo pacman -S --needed fprintd imagemagick usbutils
fprintd-enroll
sudo sed -i '2i auth    sufficient   pam_fprintd.so' /etc/pam.d/sudo
sudo sed -i '2i auth    sufficient   pam_fprintd.so' /etc/pam.d/login
sudo sed -i '3i auth    sufficient   pam_fprintd.so' /etc/pam.d/su
sudo sed -i '2i auth    sufficient   pam_fprintd.so' /etc/pam.d/system-local-login
sudo cp /usr/lib/pam.d/polkit-1 /etc/pam.d
sudo sed -i '3i auth    sufficient   pam_fprintd.so' /etc/pam.d/polkit-1

sudo systemctl enable --now systemd-timesyncd

sudo pacman -S cmake git-delta jq less libgccjit postgresql ripgrep zsh
chsh -s `which zsh`

sudo pacman -S wget
ZSH="$HOME/.oh-my-zsh" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ~/.zshrc # we'll homesick in our own config

sudo pacman -S openssh magic-wormhole
ssh_key = "$(whoami)@$(uname -n)-$(date -I)"
ssh-keygen -C "$ssh_key"
echo "About to send ssh public key via a giant hairy wormhole. When it gets to the other end add it to Github."
read -p "Do it..."
wormhole send ~/.ssh/id_ed25519.pub

mkdir -p /home/jake/work/personal
git clone git@github.com:jakeprime/dotfiles -b arch /home/jake/work/personal/dotfiles
cp /home/jake/work/personal/dotfiles/home/.default-gems /home/jake
cp /home/jake/work/personal/dotfiles/home/.default-npm-packages /home/jake
cp /home/jake/work/personal/dotfiles/home/.default-python-packages /home/jake

sudo pacman -S --needed gcc gpg libyaml make
yay asdf-vm
# python is a dependency for node, so do it first
asdf plugin add python
asdf install python 3.13.2
asdf install python 2.7.18
asdf set -u python 3.13.2 2.7.18
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 3.4.2
asdf set -u ruby 3.4.2
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf set -u nodejs latest
asdf plugin add yarn
asdf install yarn latest
asdf set -u yarn latest
asdf plugin add golang
asdf install golang latest
asdf set -u golang latest

sudo pacman -S --needed qemu-full docker docker-buildx docker-compose
yay -S colima lima-bin
# might need to do this before the next line:
# sudo pacman -S edk2-ovmf
sudo ln -s /usr/share/OVMF/x64/OVMF_CODE.4m.fd /usr/share/OVMF/OVMF_CODE.fd

sudo chgrp -R video /sys/class/backlight/intel_backlight .
sudo chmod g+w /sys/class/backglight/intel_backlight/brightness
sudo usermod -a -G video jake

sudo pacman -S awesome-terminal-fonts nerd-fonts noto-fonts noto-fonts-emoji otf-monaspace-nerd powerline-fonts

sudo pacman -S alsa-utils pavucontrol pipewire-alsa pipewire-audio pipewire-pulse pipewire-zeroconf wireplumber
systemctl enable --now avahi-daemon

sudo pacman -S cliphist foot fuzzel grim hypridle hyprland hyprlock hyprpaper hyprpicker swappy tesseract waybar
yay -S anyrun pyprpaper wlogout

sudo pacman -S --needed fwupd htop isync libnotify nwg-look wl-clipboard
yay -S 1password 1password-cli google-chrome gotop light slack-desktop-wayland

# webcam stuff
sudo pacman -S --needed gst-plugin-libcamera pipewire-libcamera libcamera-tools libcamera-ipa libcamera
yay intel-ivsc-firmware
# need to manually install the drivers, can't just yay them though
# as at the time of writing it's been pegged to an old version
mkdir -p /tmp/ipu6-drivers
git clone https://aur.archlinux.org/intel-ipu6-dkms-git.git /tmp/ipu6-drivers
cd /tmp/ipu6-drivers
sed -i 's/^\(\s*pkgver\s\?=\s\?\)[^ ]*/\1r228.c09e2198d/' PKGBUILD
sed -i 's/^\(\s*pkgver\s\?=\s\?\)[^ ]*/\1r228.c09e2198d/' .SRCINFO
makepkg -si
popd
rm -rf /tmp/ipu6-drivers

sudo pacman -S spotify-launcher
echo "Uncomment the wayland args in the Spotify config..."
read -p
sudo vim /etc/spotify-launcher.conf

# need 20.x for heroku-cli
asdf install nodejs 20.18.3
ASDF_NODEJS_VERSION=20.18.3 yay heroku-cli

yay aws-cli-v2
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

homesick clone git@github.com:jakeprime/dotfiles arch
homesick link arch

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

git clone -b feature/shadow git@github.com:ksqsf/emacsmoe.git /tmp/emacs-moe
sudo pacman -S --needed libxpm tree-sitter
cd /tmp/emacs-moe
./autogen.sh
./configure --with-native-compilation --with-json --with-pgtk --with-tree-sitter
sudo make install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
popd

sudo pacman -S fuse3 inotify-tools rclone
read -p "Setup Google Drive sync? (Y/n): " gdrive_sync
if [[ $gdrive_sync == [Yy] || -z "$gdrive_sync" ]];
then
    read -p "Visit https://console.cloud.google.com/apis/api/drive.googleapis.com/credentials?project=g-drive-share-411112 to get the credentials.\nPress any key to continue"
    rclone config
    mkdir /jake/home/gdrive
    echo "Syncing with dry run..."
    rclone bisync gdrive: /home/jake/gdrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-export-formats link.html --fix-case --resync --dry-run
    read -p "Sync for real? (Y/n): " sync_for_real
    if [[ $sync_for_real == [Yy] || -z "$sync_for_real" ]];
    then
        rclone bisync gdrive: /home/jake/gdrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-export-formats link.html --fix-case --resync
        sudo loginctl enable-linger jake
        sudo ln -s /home/jake/.homesick/repos/arch/scripts/gdrive-sync.sh /usr/local/sbin
        gdrive-sync.sh
    fi
fi

sudo pacman -S pass
read -p "Generating GPG key, default options are fine for all.\nPress any key to continue"
gpg --full-generate-key
read -p "Paste the long public key from above here: " gpg_key
pass init $gpg_key
read -p "Get a key from https://github.com/settings/tokens/new\nI've got it..."
pass insert github/homebrew

brew tap meetcleo/cleo
brew install meetcleo/cleo/cleo
cleo config tunnel port 3064

yay awsvpnclient
sudo systemctl enable --now awsvpnclient
sudo systemctl enable --now systemd-resolved

# fin
