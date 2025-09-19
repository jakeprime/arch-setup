#!/bin/bash

if [[ ! -d "$HOME/work/personal/dotfiles" ]]; then
  MISE_SHIMS=~/.local/share/mise/shims
  SSH_KEY=id_archibald

  # We'll need ruby to install Homesick, so make sure we have it
  $MISE_SHIMS/ruby -v >/dev/null 2>&1 || mise install ruby && mise use -g ruby

  $MISE_SHIMS/gem install homesick

  eval $(ssh-agent -s)
  ssh-add $HOME/.ssh/$SSH_KEY
  $MISE_SHIMS/homesick clone git@github.com:jakeprime/dotfiles arch
  pushd ~/.homesick/repos/arch && git checkout arch && popd

  $MISE_SHIMS/homesick link arch --force

  # finally make sure we're loading it
  CUSTOM_LOAD="source = ~/.config/hypr/custom/custom.sh"
  grep "$CUSTOM_LOAD" $HOME/.config/hypr/hyprland.conf >/dev/null ||
    echo "$CUSTOM_LOAD" >>$HOME/.config/hypr/hyprland.conf
fi
