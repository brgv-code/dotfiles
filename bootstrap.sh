#!/usr/bin/env bash
#
# Symlinks the configs in this repo into their expected locations.
# Safe to run repeatedly. Real files found in the way are backed up, never deleted.
#
# Usage:
#   ./bootstrap.sh          link nvim, ghostty and lazygit
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for arg in "$@"; do
  case "$arg" in
    -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
link ghostty/themes  .config/ghostty/themes
link lazygit/config.yml "Library/Application Support/lazygit/config.yml"

# tmux is gone from this repo. Clear the dangling link an earlier run left behind,
# so a machine that once used it does not keep a symlink pointing at nothing.
i<D-i>if [ -L "$HOME/.tmux.conf" ] && [ "$(readlink "$HOME/.tmux.conf")" = "$DOTFILES/tmux/tmux.conf" ]; then
  rm "$HOME/.tmux.conf"
  echo "unlink   .tmux.conf  (tmux was removed from this repo)"
fi

cCuuuuasdsECHO
KKJJJJJHJKIIIECHO "DONE. OPEN NVIM AND LET LAZY.NVIM INSTALL PLUGINS."
