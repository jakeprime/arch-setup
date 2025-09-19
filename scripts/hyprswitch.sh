#!/bin/bash

if [[ -z "$(which hyprswitch)" ]]; then
  MISE_SHIMS=$HOME/.local/share/mise/shims

  $MISE_SHIMS/cargo -v >/dev/null 2>&1 || mise install rust && mise use -g rust

  mkdir -p $HOME/work/personal/hyprswitch
  pushd $HOME/work/personal/hyprswitch

  eval $(ssh-agent -s)
  ssh-add $HOME/.ssh/id_archibald

  git clone git@github.com:jakeprime/hyprswitch .
  git checkout jake

  $MISE_SHIMS/cargo build --release
  sudo cp target/release/hyprswitch /usr/local/bin

  popd
fi
