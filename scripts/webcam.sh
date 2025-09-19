#!/bin/bash

sudo pacman -S --needed --noconfirm \
  gst-plugin-libcamera \
  libcamera \
  libcamera-ipa \
  libcamera-tools \
  pipewire-libcamera

yay -S --needed --noconfirm \
  intel-ivsc-firmware
