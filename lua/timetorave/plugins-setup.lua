vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  use 'shaunsingh/nord.nvim'

  -- Navigate splits with Ctrl+HJKL
  use("christoomey/vim-tmux-navigator")

  -- Comment with gc
  use("numToStr/Comment.nvim")

  -- File navigator 
  use("nvim-tree/nvim-tree.lua")
  use("nvim-tree/nvim-web-devicons")

  use("nvim-lualine/lualine.nvim")

  -- Finding
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) 
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })
end)
