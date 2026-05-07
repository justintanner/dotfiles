#!/usr/bin/env bash
# Install dotfiles by copying real files into $HOME (no symlinks, no stow).
#
# Two file classes:
#   library    — repo is source of truth; always refreshed on install.
#   local-edit — copied only on first install (or with --force). Yours after.
#
# Usage:
#   ./install.sh             # install / refresh
#   ./install.sh --force     # also overwrite local-edit files (.bashrc, ...)
#   ./install.sh --dry-run   # show what would happen, change nothing

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup/$TIMESTAMP"
FORCE=0
DRY_RUN=0

usage() {
  sed -n '2,12p' "$0"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)   FORCE=1; shift ;;
    -n|--dry-run) DRY_RUN=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

case "$(uname -s)" in
  Darwin) PLATFORM_DIR="$DOTFILES_DIR/mac" ;;
  Linux)  PLATFORM_DIR="$DOTFILES_DIR/linux" ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

[[ -d "$PLATFORM_DIR" ]] || { echo "Missing platform dir: $PLATFORM_DIR" >&2; exit 1; }

# Repo source-of-truth files; always overwrite on install.
LIBRARY_FILES=(
  .bash_init
  .bash_aliases
  .gitconfig
  .gitignore_global
  .alacritty.toml
  .inputrc
  .emacs
)

# Copy-once files; preserved across reinstalls (your edits live here).
LOCAL_EDIT_FILES=(
  .bashrc
  .bash_profile
)

# Optional .config/* dirs to mirror under ~/.config.
CONFIG_DIRS=(
  ohmyposh
)

# Emacs config — checked out as a sibling git repo, not copied. Updates flow
# through `git pull` in ~/.emacs.d, not the installer.
EMACS_D_REPO="https://github.com/justintanner/.emacs.d"

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  [dry-run] $*"
  else
    eval "$@"
  fi
}

backup_one() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    run "mkdir -p '$BACKUP_DIR'"
    run "cp -aP '$target' '$BACKUP_DIR/' 2>/dev/null || true"
  fi
}

# Returns 0 if $target is a symlink that points into ~/dotfiles.
is_dotfiles_symlink() {
  local target="$1"
  [[ -L "$target" ]] || return 1
  local link
  link="$(readlink "$target")"
  case "$link" in
    */dotfiles/*|dotfiles/*|"$DOTFILES_DIR"/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Remove a symlink at $target only if it points into ~/dotfiles. Real files
# are left alone here — backup_one + cp -f handles those.
remove_dotfiles_symlink() {
  local target="$1"
  if is_dotfiles_symlink "$target"; then
    run "rm -f '$target'"
  fi
}

install_library_file() {
  local file="$1"
  local src="$PLATFORM_DIR/$file"
  local dst="$HOME/$file"
  [[ -f "$src" ]] || return 0
  remove_dotfiles_symlink "$dst"
  if [[ -f "$dst" && ! -L "$dst" ]]; then
    backup_one "$dst"
  fi
  run "cp -f '$src' '$dst'"
  echo "  installed (library) $file"
}

install_local_edit_file() {
  local file="$1"
  local src="$PLATFORM_DIR/$file"
  local dst="$HOME/$file"
  [[ -f "$src" ]] || return 0

  # If $dst is a symlink into ~/dotfiles, it's a leftover from the old
  # symlink-based setup; treat it as if no real file exists yet so we
  # write the fresh template.
  local was_dotfiles_symlink=0
  if is_dotfiles_symlink "$dst"; then
    was_dotfiles_symlink=1
    remove_dotfiles_symlink "$dst"
  fi

  if [[ -e "$dst" && "$was_dotfiles_symlink" -ne 1 && "$FORCE" -ne 1 ]]; then
    echo "  kept     (local)   $file  (use --force to overwrite)"
    return 0
  fi
  if [[ -e "$dst" ]]; then
    backup_one "$dst"
  fi
  run "cp -f '$src' '$dst'"
  echo "  installed (local)   $file"
}

install_config_dir() {
  local name="$1"
  local src="$PLATFORM_DIR/.config/$name"
  local dst="$HOME/.config/$name"
  [[ -d "$src" ]] || return 0
  run "mkdir -p '$HOME/.config'"
  if [[ -L "$dst" ]]; then
    remove_dotfiles_symlink "$dst"
  elif [[ -d "$dst" ]]; then
    backup_one "$dst"
    run "rm -rf '$dst'"
  fi
  run "cp -R '$src' '$dst'"
  echo "  installed (config)  .config/$name"
}

clone_emacs_d() {
  local target="$HOME/.emacs.d"
  if [[ -d "$target/.git" ]]; then
    echo "  exists    .emacs.d  (skipped clone; pull manually if needed)"
    return 0
  fi
  if [[ -e "$target" ]]; then
    backup_one "$target"
    run "rm -rf '$target'"
  fi
  run "git clone '$EMACS_D_REPO' '$target'"
  echo "  cloned    .emacs.d  <- $EMACS_D_REPO"
}

echo "Dotfiles install"
echo "  source:  $PLATFORM_DIR"
echo "  target:  $HOME"
echo "  backup:  $BACKUP_DIR (only if needed)"
[[ "$FORCE"   -eq 1 ]] && echo "  --force: local-edit files WILL be overwritten"
[[ "$DRY_RUN" -eq 1 ]] && echo "  --dry-run: no changes will be made"
echo

for f in "${LIBRARY_FILES[@]}";    do install_library_file "$f";    done
for f in "${LOCAL_EDIT_FILES[@]}"; do install_local_edit_file "$f"; done
for d in "${CONFIG_DIRS[@]}";      do install_config_dir "$d";      done
clone_emacs_d

echo
echo "Done."
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Backups saved to $BACKUP_DIR"
fi
