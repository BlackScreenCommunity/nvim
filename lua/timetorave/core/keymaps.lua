vim.g.mapleader = " "

vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<leader>+", "<C-a>")
vim.keymap.set("n", "<leader>-", "<C-x>")

local wk = require("which-key")

-- Регистрация хоткеев для работы с файлами 
wk.register({
  f = {
    name = "files", -- optional group name
    t = { "<cmd>NvimTreeToggle<CR>", "Toggle Folder Tree" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    s = { "<cmd>Telescope live_grep<cr>", "Find string in current working directory" }, -- additional options for creating the keymap
    c = { "<cmd>Telescope grep_string<cr>", "Find string under cursor in current working directory" },
  },
}, { prefix = "<leader>" })

-- Регистрация хоткеев для работы с буферами
wk.register({
  b = {
    name = "buffers",
    r = { "<cmd>bdelete<CR>", "Kill Buffer" },
    a = { "<leader>fb", "List open buffers in current neovim instance" },
  },
}, { prefix = "<leader>" })

-- Регистрация хоткеев для работы с окнами 
wk.register({
  w = {
    name = "windows",
    v = { "<C-w>v", "Split window vertically. leader+sv" },
    h = { "<C-w>s", "Split window horizontally. leader+sh" },
    e = { "<C-w>=", "Split windows equal width. leader+se" },
    x = { ":close<CR>", "Close current split window. leader+sx" },
  },
}, { prefix = "<leader>" })


-- Регистрация хоткеев для работы с мультикурсорами
wk.register({
  e = {
    name = "editor",
    d = { ":MCstart<CR>", "Start multicursor mode. leader+ed" },
  },
}, { prefix = "<leader>" })
