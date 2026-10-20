#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

mkdir -p /tmp/arch-install

if [[ ! -f "/tmp/arch-install/homesick" ]]; then
  # We'll need ruby to install Homesick, so make sure we have it
  $MISE_SHIMS/ruby -v >/dev/null 2>&1 || mise install ruby && mise use -g ruby

  gem install specific_install
  gem specific_install -l https://github.com/jakeprime/homesick

  ruby_version="$(ruby -v | awk '{print $2}')"

  if [[ $(ssh git@github.com 2>&1 | grep denied) ]]; then
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_archibald
  fi

  homesick clone git@github.com:jakeprime/dotfiles main
  pushd $HOMESICKDIR/repos/main
  git checkout quattro
  popd

  homesick link main --force

  touch /tmp/arch-install/homesick

  # finally make sure we're loading it
  #  CUSTOM_LOAD="require(\"~/.config/hypr/custom/custom.lua\")"

  # grep "$CUSTOM_LOAD" $HOME/.config/hypr/hyprland.lua >/dev/null ||
  #   echo "$CUSTOM_LOAD" >>$HOME/.config/hypr/hyprland.lua
fi
