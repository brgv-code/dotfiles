-- Nested brackets coloured by depth.
--
-- Punctuation is neutral grey everywhere else in this theme, so these are the
-- one place brackets carry colour, and it means nesting depth rather than
-- syntax. The cycle alternates warm and cool so adjacent levels never sit next
-- to each other on the wheel and stay tellable apart at a glance.
local P = require("palette")

local CYCLE = {
  { "RainbowYellow", P.yellow },
  { "RainbowBlue", P.blue },
  { "RainbowOrange", P.orange },
  { "RainbowCyan", P.cyan },
  { "RainbowPink", P.pink },
  { "RainbowPurple", P.purple },
  { "RainbowGreen", P.green },
}

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local rd = require("rainbow-delimiters")

    local function set_hl()
      for _, pair in ipairs(CYCLE) do
        vim.api.nvim_set_hl(0, pair[1], { fg = pair[2] })
      end
    end

    set_hl()
    -- Re-apply after any colorscheme load, which would otherwise clear these.
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

    local names = {}
    for _, pair in ipairs(CYCLE) do
      names[#names + 1] = pair[1]
    end

    vim.g.rainbow_delimiters = {
      strategy = { [""] = rd.strategy["global"] },
      query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
      highlight = names,
    }
  end,
}
