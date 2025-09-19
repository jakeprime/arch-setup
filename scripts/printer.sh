#!/bin/bash

sudo pacman -S --needed --noconfirm \
  cups cups-pdf system-config-printer

yay -S --needed --noconfirm \
  epson-inkjet-printer-escpr

sudo systemctl enable --now cups.service
