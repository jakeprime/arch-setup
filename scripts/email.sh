#!/bin/bash

yay -S --needed --noconfirm cyrus-sasl-xoauth2-git
mise x python@3 -- pip3 install --user mutt-oauth2

MAIL_DIR=$XDG_DATA_HOME/mail

mkdir -p $MAIL_DIR/personal
mkdir -p $MAIL_DIR/cleo

mu init \
   --maildir=$MAIL_DIR \
   --my-address=jake@jakeprime.com \
   --my-address=jake.prime@gmail.com \
   --my-address=jake@meetcleo.com
mu index

# this is going to take tiiiime, but it can be interrupted and resumed at any
# point, so just kick it off in a fork now
mbsync cleo >/dev/null &

# Later we'll need to do Cleo with:
#  mutt-oauth2 --authorize --username jake@meetcleo.com
