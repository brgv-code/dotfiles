-- Oxocarbon Punch: the single source of truth for colour.
--
-- Neovim reads this directly. The Ghostty theme and the lazygit config are
-- generated from it by scripts/sync-theme.py, so change a hex here and run
-- that script rather than editing those files by hand.
return {
  bg = "#161616", -- ground, shared by editor and terminal
  fg = "#f2f4f8", -- variables, plain identifiers
  dim = "#525252", -- comments
  punct = "#8d8d8d", -- brackets, commas, operators

  red = "#fa4d56", -- keywords: if, return, const, import
  orange = "#ff832b", -- numbers, booleans, constants
  yellow = "#f1c21b", -- functions and methods, and the UI accent
  green = "#42be65", -- strings
  cyan = "#3ddbd9", -- types
  azure = "#33b1ff", -- info
  blue = "#78a9ff", -- properties and fields
  purple = "#be95ff", -- builtins and decorators
  pink = "#ff7eb6", -- tags and escapes

  -- Bright variants, used for the terminal's bold ANSI slots.
  bright_red = "#ff8389",
  bright_green = "#6fdc8c",
  bright_yellow = "#fdd13a",
  bright_blue = "#a6c8ff",
  bright_purple = "#d4bbff",
  bright_cyan = "#9ef0f0",
  white = "#dde1e6",
  bright_white = "#ffffff",

  -- Chrome.
  line = "#1f1f1f", -- cursorline, statusline blocks
  sel = "#31363b", -- visual selection
  gutter = "#4a4a4a", -- line numbers
  edge = "#2a2a2a", -- window separators
}
