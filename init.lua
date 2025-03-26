
require("paq")({
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    "stevearc/conform.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
	"shaunsingh/nord.nvim",
	"numToStr/Comment.nvim",
	"lewis6991/gitsigns.nvim",
	"NeogitOrg/neogit",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
	"stevearc/oil.nvim"
})



-- Theme Settings --
vim.g.nord_contrast = false 
vim.g.nord_disable_background = false
vim.g.nord_italic = false
vim.g.nord_bold = true 
vim.g.nord_uniform_diff_background = true
vim.cmd("colorscheme nord")


-- Setup Comments plugin --
-- import comment plugin safely
local setup, comment = pcall(require, "Comment")
if not setup then
  return
end

-- enable comment
comment.setup()


vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.smartindent = true

-- Search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true


-- Использование системного буфера при копировании
vim.opt.clipboard:append("unnamedplus")

-- Логика разделения на панели
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd("set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ff", ":Files!<cr>")
vim.keymap.set("n", "<leader>fs", ":RG!<cr>")

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

lspconfig.gopls.setup({
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
-- require("conform").setup({
--     formatters_by_ft = {},
--     format_after_save = {},
-- })



-- -- -- -- --
--  C# LSP  --
-- -- -- -- --

lspconfig.omnisharp.setup({
  cmd = {
    'dotnet',
    os.getenv('HOME') .. '/.local/share/omnisharp/OmniSharp.dll',
    '--languageserver',
    '--hostPID',
    tostring(vim.fn.getpid())
  },
  enable_editorconfig_support = true,
  enable_ms_build_load_projects_on_demand = false,
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  filetypes = { 'cs', 'vb' },
  root_dir = lspconfig.util.root_pattern("*.csproj", ".git"),
  on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  end,
})

-- Setup GIT plugins --
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
  return
end

gitsigns.setup {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
    }
}

local setup, neogit = pcall(require, "neogit")
if not setup then
  return
end

neogit.setup()


local setup, oil = pcall(require, "oil")
if setup then
  oil.setup() 
end
