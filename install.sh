#!/bin/bash

set -eE

working_dir="$(dirname "${BASH_SOURCE[0]}")"

source $working_dir/scripts/xdg.sh

# ssh first as it needs user input, and we'll want it for cloning repos
source $working_dir/scripts/secrets.sh

source $working_dir/scripts/packages.sh

# source $working_dir/scripts/audio.sh
source $working_dir/scripts/emacs.sh
source $working_dir/scripts/fonts.sh
source $working_dir/scripts/git.sh
source $working_dir/scripts/ghostty.sh
source $working_dir/scripts/hyprswitch.sh
source $working_dir/scripts/printer.sh
# source $working_dir/scripts/sysadmin.sh
source $working_dir/scripts/zsh.sh

# do this last so any packages referenced in the config are sure to exist
source $working_dir/scripts/homesick.sh

source $working_dir/scripts/cleo.sh
source $working_dir/scripts/email.sh
