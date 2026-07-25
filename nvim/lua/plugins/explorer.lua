-- Explorer: moving the cursor loads the file in the main window straight away,
-- while focus stays in the tree.
--
-- This deliberately does NOT use snacks' `preview = "main"`. That mode paints a
-- floating scratch window over the editor, and once you actually open a file the
-- float is torn down; the list only ever calls `show_preview()` again, which
-- bails early forever on an invalid preview window. Result: preview works until
-- the first time you open a file, then silently dies.
--
-- Opening the real buffer instead has no such lifecycle: it is a genuine file
-- load, so LSP, treesitter and editing are live the moment you land on it.
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            actions = {
              -- Load the item under the cursor into the main window, without
              -- surrendering focus. Directories and unloadable items are skipped.
              explorer_load = function(picker)
                local item = picker:current()
                if not item or item.dir or not item.file then
                  return
                end
                local main = picker.main
                if not main or not vim.api.nvim_win_is_valid(main) then
                  return
                end
                local path = vim.fs.normalize(item.file)
                if vim.fn.filereadable(path) ~= 1 then
                  return
                end
                -- keepalt/keepjumps so browsing does not shred the jumplist or
                -- the alternate file
                vim.api.nvim_win_call(main, function()
                  vim.cmd("keepalt keepjumps edit " .. vim.fn.fnameescape(path))
                end)
              end,
            },
            win = {
              list = {
                keys = {
                  ["j"] = { "list_down", "explorer_load" },
                  ["k"] = { "list_up", "explorer_load" },
                  ["<Down>"] = { "list_down", "explorer_load" },
                  ["<Up>"] = { "list_up", "explorer_load" },
                },
              },
            },
          },
        },
      },
    },
  },
}
