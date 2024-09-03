sudo pacman -S cmake git-delta jq less libgccjit postgresql ripgrep zsh
chsh -s `which zsh`

sudo pacman -S tesseract-eng
sudo pacman -S cliphist docker dolphin firefox fprintd grim hyprland hyprpaper imagemagick isync kitty libnotify mako mupdf nwg-look slurp swaybg usbutils waybar wl-clipboard wofi
yay 1password 1password-cli google-chrome gotop heroku-cli light slack-desktop-wayland smile

sudo chgrp -R video /sys/class/backlight/intel_backlight .
sudo chmod g+w /sys/class/backglight/intel_backlight/brightness
sudo usermod -a -G video jake

sudo pacman -S awesome-terminal-fonts nerd-fonts noto-fonts-emoji otf-monaspace-nerd powerline-fonts

sudo pacman -S alsa-utils pavucontrol pipewire-alsa pipewire-audio pipewire-pulse pipewire-zeroconf wireplumber
systemctl enable --now avahi-daemon

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
asdf global ruby latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf plugin add python
asdf install python latest
asdf global python latest
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
yay mu4e


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

# emails
sudo pacman -S pass
# then something like
#    gpg --full-generate-key
# get the uid from:
#    gpg -k
# initialise password manager
#    pass init [uid from above]
#    pass insert imap/jake.prime@gmail.com
#    sudo ln sudo ln -s /usr/share/emacs/site-lisp/mu4e /usr/bin/mu4e
#    mkdir ~/.mail
#    mkdir ~/.mail/personal
#    mkdir ~/.mail/cleo
#    mu init --maildir=~/.mail --my-address=jake@jakeprime.com --my-address=jake@meetcleo.com --my-address=jake.prime@gmail.com
# this will take a while!
#    mu index

# add github homebrew token with "repo" premissions
# https://github.com/settings/tokens/new
# and add it to the password store
# pass insert github/homebrew

brew tap meetcleo/cleo
brew install meetcleo/cleo/cleo

yay awsvpnclient
sudo systemctl enable --now awsvpnclient


# fin
