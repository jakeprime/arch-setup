sudo pacman -S cmake git-delta less libgccjit postgresql ripgrep zsh
chsh -s `which zsh`

sudo pacman -S tesseract-eng
sudo pacman -S dolphin firefox grim hyprland hyprpaper kitty libnotify mako mupdf nwg-look slurp swaybg waybar wl-clipboard wofi
yay 1password google-chrome gotop heroku-cli light slack-desktop smile

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
pip install dbus-python PyGObject

gem install rails rubocop rubocop-rails ruby-lsp
node install --yarn

sudo pacman -S zsh-autosuggestions
sudo pacman -S wget
ZSH="$HOME/.oh-my-zsh" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
rm ~/.zshrc # we'll homesick in our own config

gem install homesick
homesick clone git@github.com:jakeprime/dotfiles
cd ~/.homesick/repos/dotfiles
git checkout homesick
homesick link dotfiles

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

sudo pacman -S interception-caps2esc
sudo cp ~/.homesick/repos/dotfiles/caps2esc/udevdemon.yaml /etc/interception/
systemctl enable --now udevmon

git clone -b feature/shadow git@github.com:ksqsf/emacsmoe.git /tmp/emacs-moe
sudo pacman -S libxpm
cd /tmp/emacs-moe
./autogen.sh
./configure --with-native-compilation --with-json --with-pgtk
sudo make install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

sudo pacman -S fuse3 rclone
rclone config
mkdir /jake/home/gdrive

# fin
