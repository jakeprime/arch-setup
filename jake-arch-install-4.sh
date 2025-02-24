sudo pacman -S cmake git-delta jq less libgccjit postgresql ripgrep zsh
chsh -s `which zsh`

# install 4dots hyprland
# do this early as it installs a bunch of OS functionality and there is less chance of
# conflicts if the package landscape is still clean
bash <(curl -s "https://end-4.github.io/dots-hyprland-wiki/setup.sh")

sudo pacman -S docker firefox fprintd fwupd imagemagick isync libnotify nwg-look usbutils wl-clipboard
yay 1password 1password-cli google-chrome gotop heroku-cli light slack-desktop-wayland

# probably don't need this if using 4dots but will find out on next clean install
# sudo chgrp -R video /sys/class/backlight/intel_backlight .
# sudo chmod g+w /sys/class/backglight/intel_backlight/brightness
# sudo usermod -a -G video jake

sudo pacman -S awesome-terminal-fonts nerd-fonts noto-fonts noto-fonts-emoji otf-monaspace-nerd powerline-fonts

# same as backlight comment above
# sudo pacman -S alsa-utils pavucontrol pipewire-alsa pipewire-audio pipewire-pulse pipewire-zeroconf wireplumber
# systemctl enable --now avahi-daemon

sudo pacman -S spotify-launcher
echo "Uncomment the wayland args in the Spotify config..."
read -p
sudo vim /etc/spotify-launcher.conf


sudo pacman -S openssh magic-wormhole
ssh_key = "$(whoami)@$(uname -n)-$(date -I)"
ssh-keygen -C "$ssh_key"
echo "About to send ssh public key via a giant hairy wormhole. When it gets to the other end add it to Github."
read -p "Do it..."
wormhole send ~/.ssh/id_ed25519.pub

sudo pacman -S libyaml python-pip
yay asdf-vm
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf set -u ruby latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf set -u nodejs latest
asdf plugin add python
asdf install python latest
asdf set -u python latest
pip install build dbus-python hatchling installer PyGObject
# there must be a better way to do this, all the following were needed to be able to install the aws-cli
pip install flit-core pep517 python-dateutil distro urllib3 awscrt ruamel.yaml colorama docutils prompt_toolkit cryptography

gem install rails rubocop rubocop-rails ruby-lsp
node install --yarn

yay aws-cli-v2
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/jake/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

yay pyprpaper

sudo pacman -S wget
ZSH="$HOME/.oh-my-zsh" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ~/.zshrc # we'll homesick in our own config

gem install homesick
homesick clone git@github.com:jakeprime/dotfiles
cd ~/.homesick/repos/dotfiles
git checkout homesick
homesick link dotfiles

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

git clone -b feature/shadow git@github.com:ksqsf/emacsmoe.git /tmp/emacs-moe
sudo pacman -S libxpm
cd /tmp/emacs-moe
./autogen.sh
./configure --with-native-compilation --with-json --with-pgtk
sudo make install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d


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
        sudo ln -s /home/jake/.homesick/repos/dotfiles/scripts/gdrive-sync.sh /usr/local/sbin
        gdrive-sync.sh
    fi
fi

sudo pacman -S pass
read -p "Generating GPG key, default options are fine for all.\nPress any key to continue"
gpg --full-generate-key
read -p "Past the long public key from above here: " gpg_key
pass init $gpg_key
read -p "Get a key from https://github.com/settings/tokens/new\nI've got it..."
pass insert github/homebrew

brew tap meetcleo/cleo
brew install meetcleo/cleo/cleo

yay awsvpnclient
sudo systemctl enable --now awsvpnclient


# fin
