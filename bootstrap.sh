#!/usr/bin/env bash
#
# Symlinks the configs in this repo into their expected locations.
# Safe to run repeatedly. Real files found in the way are backed up, never deleted.
#
# Usage:
#   ./bootstrap.sh          link nvim and ghostty
#   ./bootstrap.sh --tmux   also link tmux
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WITH_TMUX=false

for arg in "$@"; do
  case "$arg" in
    --tmux) WITH_TMUX=true ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"

  # Refuse to link something that is not in the repo. Without this check,
  # ln happily creates a symlink pointing at nothing.
  if [ ! -e "$src" ]; then
    echo "skip     $2  (missing in repo: $1)"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    # An existing symlink, live or dangling, is ours to replace.
    rm "$dest"
  elif [ -e "$dest" ]; then
    local backup="$dest.pre-dotfiles.$(date +%Y%m%d-%H%M%S)"
    mv "$dest" "$backup"
    echo "backup   $2 -> $(basename "$backup")"
  fi

  ln -sfn "$src" "$dest"
  echo "link     $2 -> $1"
}

link nvim            .config/nvim
link ghostty/config  .config/ghostty/config

if [ "$WITH_TMUX" = true ]; then
  link tmux/tmux.conf .tmux.conf
elif [ -L "$HOME/.tmux.conf" ] && [ "$(readlink "$HOME/.tmux.conf")" = "$DOTFILES/tmux/tmux.conf" ]; then
  # Clear a link left behind by an earlier run that included tmux.
  rm "$HOME/.tmux.conf"
  echo "unlink   .tmux.conf  (pass --tmux to keep it)"
fi

echo
echo "done. open nvim and let lazy.nvim install plugins."
