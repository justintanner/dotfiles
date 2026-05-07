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

It also clones [`justintanner/.emacs.d`](https://github.com/justintanner/.emacs.d)
into `~/.emacs.d` on first install (skipped if the directory is already a git
repo — pull updates manually with `git -C ~/.emacs.d pull`).

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

## Themes

Default look is **Gas City** — a warm-dark palette (walnut bg, champagne fg,
copper/honey/sage accents). Alacritty's `[colors.*]` block is the source of
truth; everything else inherits.

| Tool         | Where set                          | How                                            |
|--------------|------------------------------------|------------------------------------------------|
| alacritty    | `mac/.alacritty.toml`, `linux/.alacritty.toml` | Library file, refreshed by `install.sh`. |
| oh-my-posh   | `mac/.config/ohmyposh/zen.toml`    | Library file, refreshed by `install.sh`.       |
| claude code  | `~/.claude/settings.json`          | Set `"theme": "dark-ansi"` (uses terminal ANSI). |
| codex        | `~/.codex/config.toml`             | Add `[tui]` with `theme = "gruvbox-dark"` for syntax. TUI inherits ANSI. |
| btop         | `~/.config/btop/btop.conf`         | Set `color_theme = "TTY"` to inherit ANSI.     |

The last three live outside the repo (their tools rewrite them) — set them
once on a fresh machine.

Sibling palettes for Apple's built-in terminals live in `mac/themes/`:

| File                                   | App           | Look                                           |
|----------------------------------------|---------------|------------------------------------------------|
| `gas-city-twilight.terminal`           | Terminal.app  | Chocolate-warm dark (`#5c3e22`), JetBrains Mono Nerd Font @ 22pt. |
| `gas-city-espresso.itermcolors`        | iTerm2        | Espresso (`#2e1e10`), between Alacritty's walnut and Twilight. |

Import via the app's UI (Terminal → Settings → Profiles → ⋯ → Import;
iTerm2 → Settings → Profiles → Colors → Color Presets → Import). They
aren't auto-installed — Terminal/iTerm own their preference stores.
Regenerate after palette tweaks with
`swift scripts/generate-mac-themes.swift`.

## Raspberry Pi

Raspberry Pi OS is Debian — `install.sh` detects Linux and copies the
`linux/` tree into `$HOME`, then clones `~/.emacs.d`. From a fresh image:

```bash
sudo apt install -y git
git clone https://github.com/justintanner/dotfiles.git ~/dotfiles
~/dotfiles/scripts/install.sh
exec bash -l   # pick up the new .bash_init
```

The shipped `.bash_init` no-ops gracefully when optional tools aren't on
`$PATH` — install whichever you want:

```bash
sudo apt install -y fzf                                # fuzzy finder
curl https://mise.run | sh                             # mise (runtimes)
curl -s https://ohmyposh.dev/install.sh | sudo bash -s # prompt
```

For the full Gas City look on a **desktop** Pi:

```bash
sudo apt install -y alacritty emacs

# JetBrainsMono Nerd Font (referenced by linux/.alacritty.toml)
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -L -o JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip && rm JetBrainsMono.zip && fc-cache -f
```

Notes:

- `linux/.alacritty.toml` ships `font.size = 19` (vs 18 on Mac) for
  higher-DPI Pi displays — tweak if your monitor disagrees.
- Pi 4 / Pi 5 are arm64; mise, oh-my-posh, alacritty, and the nerd font
  all publish arm64 builds.
- Headless / SSH-only? Skip the desktop block — the shell config, mise,
  fzf, and `~/.emacs.d` (terminal Emacs) are all you need.

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
│   ├── .config/ohmyposh/zen.toml
│   └── themes/            # Terminal.app / iTerm2 palettes (manual import)
├── linux/                 # mirror of mac/ for Debian/Ubuntu
├── scripts/
│   ├── install.sh             # also clones ~/.emacs.d on first run
│   └── generate-mac-themes.swift
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
