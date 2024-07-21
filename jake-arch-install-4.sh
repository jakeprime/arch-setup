sudo pacman -Syu --needed zsh
chsh -s /bin/zsh

sudo pacman -Syu --needed firefox hyprland kitty waybar wl-clipboard wofi
yay google-chrome

sudo pacman -Syu --needed awesome-terminal-fonts nerd-fonts noto-fonts-emoji powerline-fonts

sudo pacman -Syu --needed openssh magic-wormhole
ssh_key = "$(whoami)@$(uname -n)-$(date -I)"
ssh-keygen -C "$ssh_key"
echo "About to send ssh public key via a giant hairy wormhole. When it gets to the other end add it to Github."
read -p "Do it..."
wormhole send ~/.ssh/id_ed25519.pub

sudo pacman -Syu --needed libyaml
yay asdf-vm
echo ". /opt/asdf-vm/asdf.sh" >> ~/.zshrc
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest

sudo pacman -Syu wget
cd /tmp
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod a+x /tmp/install.sh
/tmp/install.sh
cd ~
rm ~/.zshrc # we'll homesick in our own config

gem install homesick
homesick clone git@github.com:jakeprime/dotfiles
cd ~/.homesick/repos/dotfiles
git checkout homesick
homesick link dotfiles

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

