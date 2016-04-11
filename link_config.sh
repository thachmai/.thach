#!/bin/sh

BASEDIR=$(cd $(dirname $0); pwd -P)

ln -s $BASEDIR/.tmux.conf ~/.tmux.conf
ln -s $BASEDIR/.zshrc ~/.zshrc
