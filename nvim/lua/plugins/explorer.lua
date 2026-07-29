-- Explorer: moving the cursor loads the file in the main window straight away,
-- while focus stays in the tree.
--
-- This deliberately does NOT use snacks' `preview = "main"`. That mode paints a
-- floating scratch window over the editor, and once you actually open a file the
-- float is torn down; the list only ever calls `show_preview()` again, which
-- bails early forever on an invalid preview window. Result: preview works until
-- the first time you open a file, then silently dies.
--
-- It also does NOT chain the load onto j/k/arrow keys. That only fires on those
-- exact keys and runs with a stale `current()`, so it too stopped updating once
-- you opened a file and came back. Instead we hook `on_change`, the callback
-- snacks itself fires whenever the highlighted item changes -- for ANY movement
-- (j/k, arrows, mouse, <C-d>, buffer-follow). Because it is the picker's own
-- per-move engine and not our keymaps, it keeps firing after a file is opened.
--
-- Opening the real buffer (rather than a preview float) has no such lifecycle:
-- it is a genuine file load, so LSP, treesitter and editing are live the moment
-- you land on it.
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Fired by snacks every time the highlighted item changes.
            on_change = function(picker, item)
              -- Only mirror into the main window while the tree itself holds
              -- focus. snacks also moves the tree cursor to follow the current
              -- buffer; without this guard that follow would fire on_change and
              -- yank your main window while you are editing elsewhere.
              local list = picker.list and picker.list.win
              local list_win = list and list.win
              if not list_win or vim.api.nvim_get_current_win() ~= list_win then
                return
              end
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
              -- Nothing to do if the main window already shows this file.
              local shown = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(main))
              if vim.fs.normalize(shown) == path then
                return
              end
              -- keepalt/keepjumps so browsing does not shred the jumplist or
              -- the alternate file.
              vim.api.nvim_win_call(main, function()
                vim.cmd("keepalt keepjumps edit " .. vim.fn.fnameescape(path))
              end)
            end,
          },
        },
      },
    },
  },
}
