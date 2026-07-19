#!/bin/bash

sudo pacman -S --needed --noconfirm \
  bc \
  cliphist \
  dnsutils \
  evtest \
  git-delta \
  intel-media-driver \
  isync \
  keychain \
  pass \
  tmux \
  wdiff \
  xorg-xeyes

CC=gcc-14 yay -S --needed --noconfirm \
  lastpass-cli \
  mu \
  vicinae-bin
