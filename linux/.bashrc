#!/usr/bin/env bash

# Editor configuration
export EDITOR="nano"
export SUDO_EDITOR="$EDITOR"

# Mise (formerly rtx) setup
if command -v mise &> /dev/null; then
    eval "$(mise activate bash)"
fi

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Custom PATH additions
export PATH="$HOME/dotfiles/bin:$PATH"

# Load local configuration if exists
if [[ -f "$HOME/.bashrc.local" ]]; then
    source "$HOME/.bashrc.local"
fi
