#!/bin/bash

if [[ ! -d $HOME/gdrive ]]; then

  sudo pacman -S --needed --noconfirm fuse3 inotify-tools rclone

  read -p "Visit https://console.cloud.google.com/apis/api/drive.googleapis.com/credentials?project=g-drive-share-411112 to get the credentials.\nPress any key to continue"
  rclone config
  mkdir /home/jake/gdrive
  echo "Syncing with dry run..."
  rclone bisync gdrive: /home/jake/gdrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-export-formats link.html --fix-case --resync --dry-run

  read -p "Sync for real? (Y/n): " sync_for_real
  if [[ $sync_for_real == [Yy] || -z "$sync_for_real" ]]; then
    rclone bisync gdrive: /home/jake/gdrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-export-formats link.html --fix-case --resync
  fi
fi
