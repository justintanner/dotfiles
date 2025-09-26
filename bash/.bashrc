#!/usr/bin/env bash

# Editor configuration
export EDITOR="nano"
export SUDO_EDITOR="$EDITOR"

# Homebrew setup
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Custom PATH additions
export PATH="$HOME/dotfiles/bin:$PATH"

# Load local configuration if exists
if [[ -f "$HOME/.bashrc.local" ]]; then
    source "$HOME/.bashrc.local"
fi

# Prompt configuration
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "
