#!/bin/sh

BASEDIR=$(cd $(dirname $0); pwd -P)

ln -s $BASEDIR/.tmux.conf ~/.tmux.conf
ln -s $BASEDIR/.zshrc ~/.zshrc
ln -s $BASEDIR/.spacemacs ~/.spacemacs
ln -s $BASEDIR/.lein ~/.lein
