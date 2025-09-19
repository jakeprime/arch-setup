#!/bin/bash

set -eE

# make our sudoing lives easier
if [[ ! fprintd-verify ]]; then
  $HOME/.local/share/omarchy/bin/omarchy-setup-fingerprint
fi

# ssh first as it needs user input, and we'll want it for cloning repos
source $WORKING_DIR/scripts/ssh.sh

source $WORKING_DIR/scripts/homebrew.sh
source $WORKING_DIR/scripts/packages.sh

source $WORKING_DIR/scripts/secrets.sh

source $WORKING_DIR/scripts/emacs.sh
source $WORKING_DIR/scripts/fonts.sh
source $WORKING_DIR/scripts/git.sh
source $WORKING_DIR/scripts/hyprswitch.sh
source $WORKING_DIR/scripts/printer.sh
source $WORKING_DIR/scripts/sysadmin.sh
source $WORKING_DIR/scripts/zsh.sh

# do this last so any packages referenced in the config are sure to exist
source $WORKING_DIR/scripts/homesick.sh

source $WORKING_DIR/scripts/cleo.sh
source $WORKING_DIR/scripts/email.sh
