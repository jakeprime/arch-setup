#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

if [[ -z "$(which ghostty)" ]]; then
  sudo pacman -S --needed --noconfirm \
    blueprint-compiler \
    gtk4 \
    gtk4-layer-shell \
    pkgconf \
    libadwaita \
    gettext

  DIR=/tmp/$(uuidgen)
  mkdir -p $DIR
  pushd $DIR

  if [[ $(ssh git@github.com 2>&1 | grep denied) ]]; then
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_archibald
  fi

  git clone git@github.com:jakeprime/ghostty .
  git checkout jakeprime

  sudo mise exec zig@0.17 -- zig build -Doptimize=ReleaseFast --prefix /usr/

  popd
fi

