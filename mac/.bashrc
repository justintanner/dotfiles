#!/usr/bin/env bash

# Editor configuration
export EDITOR="emacs"
export SUDO_EDITOR="$EDITOR"

# Source advanced bash initialization
[ -f ~/.bash_init ] && source ~/.bash_init

# Source aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
