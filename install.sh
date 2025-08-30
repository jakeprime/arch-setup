#!/bin/bash

set -eE

# make our sudoing lives easier
$HOME/.local/share/omarchy/bin/omarchy-setup-fingerprint

source $WORKING_DIR/scripts/ssh.sh
source $WORKING_DIR/scripts/zsh.sh
source $WORKING_DIR/scripts/emacs.sh
source $WORKING_DIR/scripts/hyprswitch.sh
source $WORKING_DIR/scripts/homebrew.sh
source $WORKING_DIR/scripts/packages.sh

# do this last so any packages referenced in the config are sure to exist
source $WORKING_DIR/scripts/homesick.sh
