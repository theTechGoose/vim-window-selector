# Nnn Window Selector
this fragment of code allows you to set up a mapping in your nnn.nvim config, so that you can pick which window to open the file in.

# Screenshot

<img width="1520" alt="image" src="https://github.com/theTechGoose/vim-window-selector/assets/55964540/7316651c-861a-477d-aca5-67a576eb506c">



init.lua exports a closure. Just use the closure to map CR in you Nnn.nvim config.

like this:

```lua
{
  explorer = {
    cmd = "nnn -o",       -- command override (-F1 flag is implied, -a flag is invalid!)
    width = 75,        -- width of the vertical split
    side = "topleft",  -- or "botright", location of the explorer window
    session = "",      -- or "global" / "local" / "shared"
    tabs = true,       -- separate nnn instance per tab
    fullscreen = true, -- whether to fullscreen explorer window when current tab is empty
  },
  picker = {
    cmd = "nnn -o",       -- command override (-p flag is implied)
    style = {
      width = 0.9,     -- percentage relative to terminal size when < 1, absolute otherwise
      height = 0.8,    -- ^
      xoffset = 0.5,   -- ^
      yoffset = 0.5,   -- ^
      border = "shadow"-- border decoration for example "rounded"(:h nvim_open_win)
    },
    session = "",      -- or "global" / "local" / "shared"
    tabs = true,       -- separate nnn instance per tab
    fullscreen = true, -- whether to fullscreen picker window when current tab is empty
  },
  auto_open = {
    setup = nil,       -- or "explorer" / "picker", auto open on setup function
    tabpage = nil,     -- or "explorer" / "picker", auto open when opening new tabpage
    empty = false,     -- only auto open on empty buffer
    ft_ignore = {      -- dont auto open for these filetypes
      "gitcommit",
    }
  },
  auto_close = true,  -- close tabpage/nvim when nnn is last window
  replace_netrw ="explorer", -- or "explorer" / "picker"
      mappings = {
         {"<C-n>",  (function() vim.api.nvim_command('NnnExplorer') end)},
         {"<CR>", require('window-selector.init')('NnnExplorer')} <----------------------------------- this line
      },       -- table containing mappings, see below
  windownav = {        -- window movement mappings to navigate out of nnn
    left = "<C-h>",
    right = "<C-l>",
  },
  buflisted = false,   -- whether or not nnn buffers show up in the bufferlist
  quitcd = nil,        -- or "cd" / tcd" / "lcd", command to run on quitcd file if found
  offset = false,      -- whether or not to write position offset to tmpfile(for use in preview-tui)
}
````
