-- Oxocarbon Punch
--
-- Oxocarbon's ground and Carbon's palette, restructured for contrast and hue
-- spread. Three deliberate changes against stock oxocarbon:
--
--   1. Warm anchors. Functions are yellow and keywords are red, so the two
--      things you scan for are the two brightest things on screen. Stock
--      oxocarbon puts every hue between 179 and 334 degrees, which is why it
--      reads as one blue wash.
--   2. Neutral punctuation. Stock paints brackets, commas and semicolons cyan,
--      which is a lot of visual noise on syntax that carries no meaning.
--      Muted grey here, so colour only appears where it says something.
--      (Rainbow-delimiters still colours nesting brackets on top of this.)
--   3. Brighter text, dimmer chrome. Variables move to near-white and comments
--      lift just enough to be readable, widening the gap between code and
--      commentary.
--
-- The palette lives in nvim/lua/palette.lua, shared with the statusline, the
-- rainbow brackets, and (via scripts/sync-theme.py) Ghostty and lazygit.
local PALETTE = require("palette")
local P = PALETTE

-- token group -> colour
local SYNTAX = {
  [P.fg] = { "@variable", "@variable.parameter", "@parameter", "Identifier" },
  [P.red] = {
    "@keyword",
    "@keyword.return",
    "@keyword.import",
    "@keyword.export",
    "@keyword.conditional",
    "@keyword.repeat",
    "@keyword.exception",
    "@keyword.coroutine",
    "@conditional",
    "@repeat",
    "Statement",
    "Keyword",
    "Conditional",
    "Repeat",
    "Exception",
  },
  [P.yellow] = {
    "@function",
    "@function.call",
    "@function.method",
    "@function.method.call",
    "@method",
    "@method.call",
    "Function",
  },
  [P.green] = { "@string", "String", "@string.documentation" },
  [P.cyan] = { "@type", "@type.definition", "@constructor", "Type", "Structure", "StorageClass" },
  [P.orange] = {
    "@number",
    "@number.float",
    "@boolean",
    "@constant",
    "Number",
    "Float",
    "Boolean",
    "Constant",
  },
  [P.blue] = { "@property", "@field", "@variable.member" },
  [P.purple] = {
    "@function.builtin",
    "@constant.builtin",
    "@type.builtin",
    "@variable.builtin",
    "@attribute",
    "@keyword.directive",
    "PreProc",
  },
  [P.pink] = { "@tag", "@tag.builtin", "@string.escape", "@string.special", "Special" },
  [P.punct] = {
    "@punctuation.bracket",
    "@punctuation.delimiter",
    "@punctuation.special",
    "@operator",
    "@tag.delimiter",
    "Operator",
    "Delimiter",
  },
  [P.dim] = { "@comment", "Comment", "@comment.documentation" },
}

-- mini.icons drives the file explorer and pickers. Stock oxocarbon collapses
-- these onto its own cool palette, which is why every icon looked alike, and
-- leaves MiniIconsGrey undefined so those icons render in body-text colour.
local ICONS = {
  MiniIconsRed = P.red,
  MiniIconsOrange = P.orange,
  MiniIconsYellow = P.yellow,
  MiniIconsGreen = P.green,
  MiniIconsCyan = P.cyan,
  MiniIconsAzure = P.azure,
  MiniIconsBlue = P.blue,
  MiniIconsPurple = P.purple,
  MiniIconsGrey = P.punct,
}

local function apply()
  local set = vim.api.nvim_set_hl

  for colour, groups in pairs(SYNTAX) do
    for _, g in ipairs(groups) do
      set(0, g, { fg = colour })
    end
  end
  set(0, "@comment", { fg = P.dim, italic = true })
  set(0, "Comment", { fg = P.dim, italic = true })

  for g, colour in pairs(ICONS) do
    set(0, g, { fg = colour, bold = true })
  end

  -- Hold the ground, and lift text and chrome apart.
  for _, g in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer" }) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    hl.bg = tonumber(P.bg:sub(2), 16)
    set(0, g, hl)
  end
  set(0, "Normal", { fg = P.fg, bg = P.bg })
  set(0, "LineNr", { fg = P.gutter, bg = P.bg })
  set(0, "CursorLineNr", { fg = P.yellow, bg = P.line, bold = true })
  set(0, "CursorLine", { bg = P.line })
  set(0, "Visual", { bg = P.sel })
  set(0, "Search", { fg = P.bg, bg = P.yellow })
  set(0, "IncSearch", { fg = P.bg, bg = P.orange, bold = true })
  set(0, "MatchParen", { fg = P.yellow, bold = true, underline = true })
  set(0, "WinSeparator", { fg = P.edge })

  set(0, "DiagnosticError", { fg = P.red })
  set(0, "DiagnosticWarn", { fg = P.orange })
  set(0, "DiagnosticInfo", { fg = P.azure })
  set(0, "DiagnosticHint", { fg = P.cyan })

  set(0, "DiffAdd", { fg = P.green })
  set(0, "DiffChange", { fg = P.orange })
  set(0, "DiffDelete", { fg = P.red })
end

return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "oxocarbon" },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("OxocarbonPunch", { clear = true }),
        pattern = "oxocarbon",
        callback = apply,
      })
      -- Rainbow delimiters re-register their own colours on ColorScheme too;
      -- schedule keeps this after any theme load during startup.
      vim.schedule(function()
        if vim.g.colors_name == "oxocarbon" then
          apply()
        end
      end)
    end,
  },
}
