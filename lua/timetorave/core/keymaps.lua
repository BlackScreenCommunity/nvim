vim.g.mapleader = " "

vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<leader>+", "<C-a>")
vim.keymap.set("n", "<leader>-", "<C-x>")

vim.keymap.set("n", "<leader>sv", "<C-w>v") -- Split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- Split window horizontally 
vim.keymap.set("n", "<leader>se", "<C-w>=") -- Split windows equal width 
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- Close current split window 


vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Close current split window 

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
