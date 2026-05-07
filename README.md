# Dotfiles

Cross-platform dotfiles for macOS and Linux. **Real files, not symlinks** —
`scripts/install.sh` copies them into `$HOME` so machine-specific edits don't
leak back into a public git repo.

## Quick start

```bash
git clone https://github.com/justintanner/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

The installer detects macOS or Linux and copies the matching tree (`mac/` or
`linux/`) into `$HOME`. Existing real files are backed up to
`~/.dotfiles_backup/<timestamp>/`. Re-running the script is safe.

```bash
./scripts/install.sh             # install / refresh
./scripts/install.sh --force     # also overwrite ~/.bashrc and ~/.bash_profile
./scripts/install.sh --dry-run   # show what would change
```

## Two classes of files

| Class        | Files                                                                                          | Behavior                                                |
|--------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| **library**  | `.bash_init`, `.bash_aliases`, `.gitconfig`, `.gitignore_global`, `.alacritty.toml`, `.inputrc`| Repo is source of truth. **Always overwritten** on install. |
| **local-edit** | `.bashrc`, `.bash_profile`                                                                   | **Copy-once.** Yours after first install. Use `--force` to replace. |

The shipped `~/.bashrc` is intentionally tiny: it sources `~/.bash_init` and
`~/.bash_aliases`, then leaves two clearly-marked sections for you (and any
LLM editing your shell config) to drop machine-specific PATH entries,
exports, and secrets into. The repo's `mac/.bashrc` template ships with
those sections empty — your real `~/.bashrc` is never tracked.

## Why not GNU Stow / symlinks?

Symlinking `~/.bashrc` into the repo means every local edit (PATH for a new
tool, an API token an agent pasted in) becomes a pending git change. One
absent-minded `git commit -a` and your secrets are on a public remote. The
copy-based install severs that link by design.

## Layout

```
dotfiles/
├── mac/
│   ├── .bashrc            # template (LLM banner + LOCAL/SECRETS sections)
│   ├── .bash_profile
│   ├── .bash_init
│   ├── .bash_aliases
│   ├── .gitconfig
│   ├── .gitignore_global
│   ├── .alacritty.toml
│   ├── .inputrc
│   └── .config/ohmyposh/zen.toml
├── linux/                 # mirror of mac/ for Debian/Ubuntu
├── scripts/
│   └── install.sh
├── Dockerfile             # ubuntu:24.04 sandbox for testing the linux/ tree
├── build.sh
└── test-dotfiles.sh       # build + verify install.sh inside the sandbox
```

## Adding a new dotfile to the repo

1. Copy your real file into `mac/` and/or `linux/`.
2. Add the basename to `LIBRARY_FILES` (always-overwrite) or
   `LOCAL_EDIT_FILES` (copy-once) in `scripts/install.sh`.
3. Run `./scripts/install.sh` to verify.

## Testing the linux/ tree in Docker

```bash
./build.sh           # build the image
./test-dotfiles.sh   # menu: shell / verify / both
```

The verify mode confirms `~/.bashrc` and friends are real files (not
symlinks) and that mise/Ruby/Node/oh-my-posh come up cleanly.
