# AGENTS.md

Guidance for coding agents working in this dotfiles repo.

## Install model

`scripts/install.sh` copies real files from `mac/` or `linux/` into `$HOME`.
No symlinks, no GNU Stow. Two file classes:

- **library** (always overwritten): `.bash_init`, `.bash_aliases`,
  `.gitconfig`, `.gitignore_global`, `.alacritty.toml`, `.inputrc`.
- **local-edit** (copy-once, preserved across reinstalls): `.bashrc`,
  `.bash_profile`.

Files that should ship to all machines via the repo are **library**.
Files the user/LLM is expected to edit per-machine are **local-edit**.

## Commands

- `./scripts/install.sh` — install / refresh
- `./scripts/install.sh --force` — overwrite local-edit files too
- `./scripts/install.sh --dry-run` — preview, no changes
- `./test-dotfiles.sh` — docker sandbox for linux/

## Editing rules

- Shared shell config (PATH defaults, mise/zoxide/fzf init, locale, prompt)
  goes in `mac/.bash_init` or `linux/.bash_init`. **Never** in `.bashrc`.
- The `mac/.bashrc` and `linux/.bashrc` templates ship with empty LOCAL
  CUSTOMIZATIONS and SECRETS sections. Keep them empty in the repo.
- This repo is public on GitHub. Never commit secrets. Run
  `git diff --cached` looking for `ops_eyJ`, `sk-`, `ghp_`, etc., before
  every commit.

## Code style

- `#!/usr/bin/env bash` shebang, `set -euo pipefail` in install scripts.
- Quote variables; single-quote literal strings.
- Platform detection: `case "$(uname -s)" in Darwin|Linux) ... esac`.
- Keep `mac/` and `linux/` layouts mirrored when adding files.
