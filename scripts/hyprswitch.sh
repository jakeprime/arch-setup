#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

if [[ -z "$(which hyprswitch)" ]]; then
  $MISE_SHIMS/cargo -v >/dev/null 2>&1 || mise install rust && mise use -g rust

  DIR=/tmp/$(uuidgen)
  mkdir -p $DIR
  pushd $DIR

  if [[ $(ssh git@github.com 2>&1 | grep denied) ]]; then
    eval $(ssh-agent -s)
    ssh-add $HOME/.ssh/id_archibald
  fi

  git clone git@github.com:jakeprime/hyprswitch .
  git checkout jake

  $MISE_SHIMS/cargo build --release
  sudo cp target/release/hyprswitch /usr/local/bin

  popd
fi
