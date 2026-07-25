-- Statusline. Colours are pulled from the Oxocarbon Punch palette so the bar
-- matches the syntax rather than sitting apart from it.
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local P = require("palette")
    local c = {
      bg = P.bg,
      bar = P.line,
      fg = P.fg,
      dim = P.punct,
      red = P.red,
      orange = P.orange,
      yellow = P.yellow,
      green = P.green,
      cyan = P.cyan,
      blue = P.blue,
      purple = P.purple,
    }

    -- Mode colour doubles as the mode indicator, so the leftmost block tells you
    -- where you are without reading the word.
    local function mode_theme(colour)
      return {
        a = { bg = colour, fg = c.bg, gui = "bold" },
        b = { bg = c.bar, fg = c.fg },
        c = { bg = c.bg, fg = c.dim },
      }
    end

    opts.options = vim.tbl_extend("force", opts.options or {}, {
      theme = {
        normal = mode_theme(c.blue),
        insert = mode_theme(c.green),
        visual = mode_theme(c.yellow),
        replace = mode_theme(c.red),
        command = mode_theme(c.purple),
        inactive = {
          a = { bg = c.bg, fg = c.dim },
          b = { bg = c.bg, fg = c.dim },
          c = { bg = c.bg, fg = c.dim },
        },
      },
      globalstatus = true,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
    })

    opts.sections = {
      lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
      lualine_b = {
        { "branch", icon = "", color = { fg = c.purple } },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          diff_color = {
            added = { fg = c.green },
            modified = { fg = c.orange },
            removed = { fg = c.red },
          },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          diagnostics_color = {
            error = { fg = c.red },
            warn = { fg = c.orange },
            info = { fg = c.blue },
            hint = { fg = c.cyan },
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[no name]" } },
      },
      -- Right side stays deliberately bare: the filetype icon already lives next
      -- to the filename, so nothing here needs to repeat it.
      lualine_x = {},
      lualine_y = {
        { "location", color = { fg = c.fg } },
      },
      lualine_z = {
        { function() return os.date("%H:%M") end },
      },
    }

    return opts
  end,
}
