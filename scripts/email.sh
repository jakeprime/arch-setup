#!/bin/bash

MAIL_DIR=$HOME/.mail

mkdir -p $MAIL_DIR/personal
mkdir -p $MAIL_DIR/cleo

mu init \
   --maildir=$MAIL_DIR \
   --my-address=jake@jakeprime.com \
   --my-address=jake.prime@gmail.com \
   --my-address=jake@meetcleo.com \
mu index

echo "MU4E_DIR=/usr/share/emacs/site-lisp/mu4e" >> $HOME/.spacemacs.d/.spacemacs.env

# this is going to take tiiiime, but it can be interrupted and resumed at any
# point, so just kick it off in a fork now
mbsync --all >/dev/null &
