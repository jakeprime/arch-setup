#!/bin/bash

sudo pacman -S --needed --noconfirm \
  bc \
  git-delta \
  google-chrome \
  pass

CC=gcc-14 yay -S --needed --noconfirm \
  lastpass-cli
