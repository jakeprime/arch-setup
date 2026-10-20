#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

sudo pacman -S --needed --noconfirm \
  bc \
  cliphist \
  dnsutils \
  evtest \
  intel-media-driver \
  isync \
  keychain \
  tmux \
  wdiff \
  xorg-xeyes

yay -S --needed --noconfirm \
  vicinae-bin \
  wlr-which-key
