-- TEMPORARY: theme trial.
--
-- Three warm alternatives to oxocarbon, loaded eagerly so `:colorscheme <name>`
-- works without opening a file first. Once one is chosen, delete this file and
-- set the winner in colorscheme.lua.
--
-- Try, with a real file open:
--   :colorscheme kanagawa-dragon
--   :colorscheme gruvbox-material
--   :colorscheme everforest
--   :colorscheme oxocarbon        -- back to current
--
-- Or <leader>uC for a picker that previews as you move.
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 900,
    opts = {
      compile = false,
      dimInactive = false,
      -- Dragon is the dark warm variant: ground #181616, close to oxocarbon's #161616.
      background = { dark = "dragon" },
    },
  },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 900,
    init = function()
      -- Vimscript plugin: options are globals and must be set before it loads.
      vim.g.gruvbox_material_background = "hard" -- darkest of the three grounds
      vim.g.gruvbox_material_foreground = "material" -- softer than "original", still warm
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
    end,
  },

  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 900,
    config = function()
      require("everforest").setup({
        background = "hard",
        italics = true,
      })
    end,
  },

  { "savq/melange-nvim", lazy = false, priority = 900 },

  {
    "zenbones-theme/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 900,
    init = function()
      vim.g.zenbones_darken_comments = 45
    end,
  },

  -- Trial only: pin every candidate to oxocarbon's #161616 so the comparison is
  -- about syntax colour alone and not the ground shifting underneath it.
  -- Delete this block along with the rest of the file once a theme is chosen.
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("TrialFixedBackground", { clear = true }),
        callback = function()
          for _, g in ipairs({
            "Normal",
            "NormalNC",
            "NormalFloat",
            "SignColumn",
            "EndOfBuffer",
            "LineNr",
            "FoldColumn",
          }) do
            local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
            hl.bg = 0x161616
            vim.api.nvim_set_hl(0, g, hl)
          end
        end,
      })
    end,
  },
}
