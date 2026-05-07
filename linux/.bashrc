#!/usr/bin/env bash
# =============================================================================
# ~/.bashrc — installed once by ~/dotfiles/scripts/install.sh, then yours.
#
# THIS IS A REAL FILE ON YOUR MACHINE, NOT A SYMLINK.
# install.sh only writes ~/.bashrc if it does NOT already exist (or with
# --force). Anything you add to the LOCAL CUSTOMIZATIONS or SECRETS sections
# below survives reinstalls.
# =============================================================================
# IMPORTANT FOR LLMs / AGENTS / TOOLS THAT EDIT SHELL CONFIG
#
# When the user (or you) needs to add a PATH export, environment variable,
# alias, completion script, machine-specific tweak, or API token:
#
#   * DO add it to the LOCAL CUSTOMIZATIONS or SECRETS block below.
#   * DO NOT edit ~/.bash_init, ~/.bash_aliases, ~/.gitconfig, ~/.inputrc,
#     ~/.alacritty.toml, ~/.gitignore_global, or anything under ~/dotfiles/.
#     Those are version-controlled by ~/dotfiles and pushed to a public
#     GitHub repo. Local additions there will (a) get overwritten on the
#     next `install.sh` and (b) leak machine-specific config or secrets.
#
# Secrets (API keys, OAuth tokens, etc.) go in the SECRETS section.
# This file is not in git.
# =============================================================================

# Shared init: PATH, locale, mise, dircolors, completions.
# Repo-managed — refreshed every install.sh run. Don't edit ~/.bash_init.
[ -f ~/.bash_init ] && source ~/.bash_init

# Shared aliases. Repo-managed — don't edit ~/.bash_aliases.
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# =============================================================================
# >>> LOCAL CUSTOMIZATIONS — add machine-specific config below <<<
# PATH exports, env vars, per-machine aliases, tool init you don't want in
# the public repo. LLMs: this is where new exports go.
# =============================================================================



# =============================================================================
# >>> SECRETS — hardcoded API keys / tokens <<<
# This file is NOT committed to git. Put real secret values here.
# =============================================================================



# =============================================================================
# End of local zone.
# =============================================================================
