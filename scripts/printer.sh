#!/bin/bash

sudo pacman -S --needed --noconfirm \
  cups cups-pdf epson-inkjet-printer-escpr system-config-printer

sudo systemctl enable --now cups.service
