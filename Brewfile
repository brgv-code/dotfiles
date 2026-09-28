# Everything these configs assume is on PATH.
#   brew bundle --file=Brewfile
#
# Kept in sync with `brew leaves` on 2026-09-28, before the old MacBook went back.
# If you add a tool and rely on it, add it here the same day, or the next machine
# will not have it.

# Editor
brew "neovim"

# Git and GitHub from the terminal
brew "git"
brew "gh"        # pull requests, auth, repo creation
brew "lazygit"   # staging, committing, branching, pushing
brew "git-delta" # readable diffs in git and lazygit

# What the pickers and previews in LazyVim shell out to
brew "ripgrep"   # project wide search
brew "fd"        # file finding, much faster than find
brew "fzf"       # fuzzy matching
brew "bat"       # syntax highlighted previews

# Shell
brew "atuin"     # searchable shell history, synced between machines

# JavaScript and TypeScript. Every project here uses pnpm, never npm.
brew "node"
brew "pnpm"
brew "fnm"       # node version switching, reads .nvmrc

# Python
brew "uv"        # the fast installer and runner these repos use
brew "pyenv"     # version switching where a project pins one

# Formats the Lua in this repo
brew "stylua"

# Linting CI locally, so a workflow is not debugged by pushing
brew "actionlint"

# Everyday utilities the scripts in this repo and the knowledge base lean on
brew "jq"        # JSON on the command line
brew "glow"      # reading markdown in the terminal
brew "figlet"    # banners in scripts

# Documents and media
brew "poppler"   # pdftotext and friends, used by the PDF scripts
brew "tectonic"  # LaTeX without a full TeX Live, builds jlog-latex
brew "ffmpeg"    # audio and video, used for the voice note pipeline
brew "jpegoptim" # shrinking screenshots before they go into a repo

# Databases and containers
brew "libpq"     # psql without the full postgres server
brew "docker"   # the CLI; Docker Desktop is installed separately

# Terminal and font. Omit if you already have them, or use a different terminal.
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"

# The agent this whole setup is built around
cask "claude-code"

# Google Cloud, for the Search Console pulls and the gcloud services in acemate
cask "gcloud-cli"

# Taps that were configured on the old machine. Nothing above needs them today,
# but they are recorded so a formula from one of them can be found again:
#   authzed/tap  greptileai/tap  mongodb/brew  supabase/tap
