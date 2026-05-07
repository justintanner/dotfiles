# CLAUDE.md

Guidance for Claude Code working in this dotfiles repository.

## What this repo is

A copy-based dotfiles installer for macOS and Linux. `scripts/install.sh`
detects the platform and copies files from `mac/` or `linux/` into `$HOME`
as **real files, not symlinks**. The previous GNU Stow setup was retired.

## Two file classes (memorize this)

- **library** — repo is source of truth. Always overwritten on install.
  Files: `.bash_init`, `.bash_aliases`, `.gitconfig`, `.gitignore_global`,
  `.alacritty.toml`, `.inputrc`.
- **local-edit** — copied only on first install (or with `--force`).
  Files: `.bashrc`, `.bash_profile`.

When you change a file in this repo, decide which class it belongs in and
add it to the matching array at the top of `scripts/install.sh`.

## The ~/.bashrc template is special

`mac/.bashrc` and `linux/.bashrc` ship as **templates** with empty
`LOCAL CUSTOMIZATIONS` and `SECRETS` sections plus a banner explaining the
contract. Don't put real PATH/env exports in these template files —
they'd end up on a user's machine on first install but then be invisible
on subsequent installs (the local-edit rule preserves the existing real
~/.bashrc). Shared exports go in `mac/.bash_init` / `linux/.bash_init`.

## Common commands

```bash
./scripts/install.sh             # install / refresh
./scripts/install.sh --force     # also overwrite local-edit files
./scripts/install.sh --dry-run   # preview
./test-dotfiles.sh               # docker-based linux verification
```

## Secrets policy

- This repo is public. Never commit API keys, OAuth tokens, 1Password
  service-account tokens, etc.
- Per-machine secrets live in the `SECRETS` section of the user's real
  `~/.bashrc` (which is not tracked in git).
- Before committing, scan with `git diff --cached` for `ops_eyJ`,
  `sk-`, `ghp_`, `xoxb-`, etc.

## Code style

- Shell scripts use `#!/usr/bin/env bash`.
- `set -euo pipefail` in install scripts.
- Platform detection with `case "$(uname -s)" in Darwin|Linux) ...`.
- Quote variables (`"$var"`); single-quote literal strings.

## Layout

```
mac/, linux/        platform-specific dotfiles (mirror each other)
mac/.config/        files that install under ~/.config/<name>/
scripts/install.sh  copy-based installer
Dockerfile,
build.sh,
test-dotfiles.sh    ubuntu sandbox for verifying the linux/ tree
```
