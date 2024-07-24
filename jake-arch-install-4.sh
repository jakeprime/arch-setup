sudo pacman -Syu --needed git-delta less zsh
chsh -s `which zsh`

sudo pacman -Syu --needed firefox grim hyprland hyprpaper kitty slurp swaybg waybar wl-clipboard wofi
yay google-chrome gotop light

sudo chgrp -R video /sys/class/backlight/intel_backlight .
sudo chmod g+w /sys/class/backglight/intel_backlight/brightness
sudo usermod -a -G video jake

sudo pacman -Syu --needed awesome-terminal-fonts nerd-fonts noto-fonts-emoji otf-monaspace-nerd powerline-fonts

sudo pacman -Syu pipewire-audio pipewire-alsa pipewire-pulse alsa-utils wireplumber pavucontrol


sudo pacman -Syu --needed openssh magic-wormhole
ssh_key = "$(whoami)@$(uname -n)-$(date -I)"
ssh-keygen -C "$ssh_key"
echo "About to send ssh public key via a giant hairy wormhole. When it gets to the other end add it to Github."
read -p "Do it..."
wormhole send ~/.ssh/id_ed25519.pub

sudo pacman -Syu --needed libyaml
yay asdf-vm
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

sudo pacman -S zsh-autosuggestions
sudo pacman -Syu wget
ZSH="$HOME/.oh-my-zsh" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
rm ~/.zshrc # we'll homesick in our own config

gem install homesick
homesick clone git@github.com:jakeprime/dotfiles
cd ~/.homesick/repos/dotfiles
git checkout homesick
homesick link dotfiles

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

sudo pacman -Syu --needed interception-caps2esc
sudo cp ~/.homesick/repos/dotfiles/caps2esc/udevdemon.yaml /etc/interception/
systemctl enable --now udevmon

git clone -b feature/shadow git@github.com:ksqsf/emacsmoe.git /tmp/emacs-moe
sudo pacman -S libxpm
cd /tmp/emacs-moe
sudo make install
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# fin
