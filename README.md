# dotfiles

A small, reproducible terminal setup for reading code, editing it, and pushing it to GitHub.

Built for a workflow where most of the writing happens in an AI coding agent and the terminal is
where you read, review, and commit. It is deliberately minimal: one editor config, one terminal
config, no plugin managers layered on plugin managers, and nothing you have to remember a prefix
key to use.

```
Ghostty  ──  terminal, splits, tabs, font
Neovim   ──  LazyVim, reading and editing, language support
lazygit  ──  staging, committing, pushing
gh       ──  pull requests and auth
```

## Install

On a clean machine:

```bash
# 1. dependencies
brew bundle --file=Brewfile

# 2. clone and link
git clone https://github.com/brgv-code/dotfiles ~/Development/dotfiles
cd ~/Development/dotfiles
./bootstrap.sh

# 3. authenticate GitHub
gh auth login
gh auth setup-git

# 4. open the editor and let it install itself
nvim
```

The first `nvim` launch installs every plugin pinned in `nvim/lazy-lock.json`, then quit and reopen.
That lockfile is the reason a second machine gets the same setup rather than whatever happened to be
released that week. It is committed on purpose. Do not gitignore it.

Set your identity if this is a fresh machine:

```bash
git config --global user.name  "your name"
git config --global user.email "you@example.com"
```

## What `bootstrap.sh` does

It symlinks the directories in this repo to where the tools expect to find them:

| Repo path        | Linked to                |
| ---------------- | ------------------------ |
| `nvim/`          | `~/.config/nvim`         |
| `ghostty/config` | `~/.config/ghostty/config` |
| `tmux/tmux.conf` | `~/.tmux.conf` (only with `--tmux`) |

Everything is edited here, in the repo, and the live locations are only ever links. That is the
whole trick to keeping several machines in sync.

The script is safe to rerun. If it finds a real file where a link should go, it renames it to
`*.pre-dotfiles.<timestamp>` rather than overwriting it. If it finds an existing symlink it replaces
it. If a source file is missing from the repo it skips it and says so, rather than creating a link
that points at nothing.

## Layout

```
.
├── bootstrap.sh        symlink installer
├── Brewfile            every binary these configs assume exists
├── ghostty/config      terminal: font and size
├── nvim/               LazyVim configuration
│   ├── lua/config/     options, keymaps, autocmds
│   ├── lua/plugins/    added or overridden plugins
│   └── lazy-lock.json  pinned plugin versions, committed
└── tmux/tmux.conf      optional, see below
```

## Neovim

[LazyVim](https://www.lazyvim.org) on top of lazy.nvim. Language support comes from LazyVim
"extras" rather than hand installed servers, so enabling a language pulls its language server,
treesitter parser, and formatter together and records the choice in `nvim/lazyvim.json`.

Currently enabled: TypeScript, JSON, YAML, TOML, SQL, Python, Markdown, Docker, Astro, Tailwind,
Git, and Copilot.

To change them, open `:LazyExtras` inside Neovim, toggle with `x`, and restart. Commit the resulting
`lazyvim.json` and `lazy-lock.json`.

Useful checks:

| Command        | Shows                          |
| -------------- | ------------------------------ |
| `:checkhealth` | what is broken or missing      |
| `:Lazy`        | plugin status and update state  |
| `:Mason`       | installed language servers     |
| `:LazyExtras`  | language support on and off    |

Your own settings belong in `nvim/lua/config/options.lua` and `nvim/lua/config/keymaps.lua`.
Extra plugins go in `nvim/lua/plugins/`, one file per concern. Nothing else needs editing.

### The keys that matter

Leader is the spacebar. Pressing it alone opens a menu of what is available, so the rest is
discoverable and there is no need to memorize this table up front.

| Key             | Does                        |
| --------------- | --------------------------- |
| `<space>`       | show the menu               |
| `<space><space>`| find file in project        |
| `<space>/`      | search across project       |
| `<space>e`      | file tree                   |
| `<space>gg`     | lazygit                     |
| `<space>bd`     | close buffer                |
| `<space>qq`     | quit                        |
| `H` / `L`       | previous / next buffer      |
| `gd`            | go to definition            |
| `gr`            | find references             |
| `K`             | documentation under cursor  |
| `<space>ca`     | code action                 |
| `<space>cr`     | rename symbol               |
| `<C-h/j/k/l>`   | move between splits         |

## Ghostty

Two lines: a Nerd Font and a size. The font matters, since file icons and status line glyphs render
as blank boxes without one. `font-meslo-lg-nerd-font` in the Brewfile installs it.

Splits and tabs use the standard macOS keys you already know, `cmd+d`, `cmd+shift+d`, `cmd+t`. List
them all with `ghostty +list-keybinds`.

## On tmux

Not installed by default, on purpose.

Ghostty already gives you splits, tabs, scrollback, search, and copy. Running tmux locally mostly
means reimplementing those behind a prefix key, which is a second set of shortcuts to learn for
things the terminal already did. The one thing it genuinely adds is sessions that survive the
terminal closing, which matters in two cases:

- a long agent run you do not want to lose to an accidental `cmd+q`
- SSH to a remote machine, where a dropped connection kills the work

If either applies, uncomment tmux in the `Brewfile` and run `./bootstrap.sh --tmux`. The config in
`tmux/tmux.conf` is small and plugin free: prefix on `C-a`, `|` and `-` to split, `h/j/k/l` to move,
and `y` to yank in copy mode, which matches every tutorial you will read.

## Reproducing on another machine

The four commands under [Install](#install). Because `lazy-lock.json` and `lazyvim.json` are both
committed, the second machine resolves to the same plugin commits and the same language support
rather than a fresh resolution.

To move plugins forward: `:Lazy update` inside Neovim, confirm nothing broke, then commit the
changed `lazy-lock.json`. Other machines pick it up on their next pull. Updates are an explicit,
reviewable commit rather than something that happens to you.

## Credits

The Neovim configuration starts from the [LazyVim starter](https://github.com/LazyVim/starter),
which is Apache 2.0 licensed. Everything in this repo is MIT, see `LICENSE`.
