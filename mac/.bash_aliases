# File system
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Tools
alias n='nvim'
alias e='emacs'
alias g='git'
alias d='docker'
alias r='rails'
alias lzg='lazygit'
alias lzd='lazydocker'

# Git shortcuts
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gcbr='git checkout -b'
alias gpfo='git push --force'

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"
