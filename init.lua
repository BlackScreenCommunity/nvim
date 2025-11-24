pcall(function() vim.loader.enable() end)

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
	"stevearc/oil.nvim",
	"folke/which-key.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-tree/nvim-tree.lua",
	"nvim-tree/nvim-web-devicons",
	"echasnovski/mini.icons", -- as dependency fro which-key plugin
	"williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim"
})

-- Theme Settings --
vim.g.nord_contrast = false 
vim.g.nord_disable_background = false
vim.g.nord_italic = false
vim.g.nord_bold = true 
vim.g.nord_uniform_diff_background = true
vim.cmd("colorscheme nord")


-- Setup Comments plugin --
local setup, comment = pcall(require, "Comment")
if not setup then
  return
end

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

-- Mason 
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup() end

local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if ok_mason_lsp then
  mason_lsp.setup({
    ensure_installed = {
		"ts_ls",
		"eslint",
		"jsonls"
    },
    automatic_installation = true,
  })
end

-- Если пользуешься conform.nvim — удобно поставить форматтер C#
-- через Mason (csharpier) тоже:
pcall(function()
  require("mason").setup() -- на случай если mason не инициализировался выше
  require("mason-lspconfig").setup()
end)


pcall(function()
  local registry = require("mason-registry")
  if not registry.is_installed("prettierd") then
    registry.get_package("prettierd"):install()
  end
end)


local function lsp_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- TypeScript / JavaScript LSP
local function lsp_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end
-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
  on_attach = lsp_on_attach,
  -- capabilities = ... (добавишь, если подключишь nvim-cmp)
})
vim.lsp.enable("ts_ls")

-- ESLint (линт и автофиксы)
-- ESLint LSP (с указанием nodePath на глобальный npm root)
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    -- твой on_attach...
  end,
  settings = {
    eslint = {
      nodePath = (function()
        local out = vim.fn.systemlist("npm root -g")[1]
        if out and #out > 0 then return out end
        return "C:/Users/" .. (os.getenv("USERNAME") or "") .. "/AppData/Roaming/npm/node_modules"
      end)(),
      packageManager = "npm",
      workingDirectories = { mode = "auto" }
    }
  }
})
vim.lsp.enable("eslint")



-- JSON (валидация + схемы по умолчанию)
vim.lsp.config("jsonls", {
  on_attach = lsp_on_attach,
  settings = { json = { validate = { enable = true } } },
})
vim.lsp.enable("jsonls")



local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      javascript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      jsonc = { "prettierd", "prettier" },
      -- при желании можешь добавить markdown/yaml/… тоже на prettier
    },
	formatters = {
      prettierd = {
        command = vim.fn.stdpath("data") .. "/mason/bin/prettierd",
        prepend_args = { "--use-tabs", "--tab-width", "4" },
      },
      prettier = {
        prepend_args = { "--use-tabs", "--tab-width", "4" },
      },
    },
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "javascript" or ft == "javascriptreact"
         or ft == "typescript" or ft == "typescriptreact"
         or ft == "json" or ft == "jsonc" then
        return { lsp_fallback = true, timeout_ms = 3000 }
      end
    end,
  })

  local prettierd_bin = vim.fn.stdpath("data") .. "/mason/bin/prettierd"
  if vim.fn.executable(prettierd_bin) == 1 then
    conform.formatters = conform.formatters or {}
    conform.formatters.prettierd = { command = prettierd_bin }
  end
end



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
  oil.setup({
	view_options = {
    	show_hidden = true,
	}
  }) 
end


do
  local ok, mini_icons = pcall(require, "mini.icons")
  if ok then
    mini_icons.setup()
  end
end

do
  local ok, whichkey = pcall(require, "which-key")
  if ok then
	whichkey.setup({
		icons = {
			group = " ",   -- значок перед именем группы
			mappings = true, -- включить иконки у пунктов (если есть)
		},
		win = {
			border = "rounded",
		},
	})


	whichkey.add({
		-- ── Files ────────────────────────────────────────────────────────────────
		{ "<leader>f",  group = " Files" },
		{ "<leader>ff", "<cmd>Telescope find_files<CR>",     desc = " Find file" },
		{ "<leader>fs", "<cmd>Telescope live_grep<CR>",      desc = " Live grep (rg)" },
		{ "<leader>fc", "<cmd>Telescope grep_string<CR>",    desc = " Grep under cursor" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>",        desc = "󰈙 Buffers" },
		{ "<leader>ft", "<cmd>NvimTreeToggle<CR>",           desc = " Toggle folder tree" },
		{ "<leader>fo", "<cmd>Oil<CR>",                      desc = " Oil (parent dir)" },

		-- ── Buffers ─────────────────────────────────────────────────────────────
		{ "<leader>b",  group = "󰈙 Buffers" },
		{ "<leader>bn", "<cmd>bnext<CR>",                              desc = " Next buffer" },
		{ "<leader>bp", "<cmd>bprevious<CR>",                          desc = " Prev buffer" },
		{ "<leader>bd", "<cmd>bdelete<CR>",                            desc = " Close buffer" },
		{ "<leader>bl", "<cmd>Telescope buffers<CR>",        desc = " List buffers" },

		-- ── Windows / Splits ────────────────────────────────────────────────────
		{ "<leader>w",  group = " Windows" },
		{ "<leader>wv", "<C-w>v",                                      desc = " Vertical split" },
		{ "<leader>wh", "<C-w>s",                                      desc = " Horizontal split" },
		{ "<leader>we", "<C-w>=",                                      desc = "󰒓 Equalize" },
		{ "<leader>wx", "<cmd>close<CR>",                              desc = " Close split" },

		-- ── Git ─────────────────────────────────────────────────────────────────
		{ "<leader>g",  group = " Git" },
		{ "<leader>gs", "<cmd>Neogit kind=auto<CR>",         desc = " Neogit" },
		{ "<leader>gd", "<cmd>Gitsigns diffthis<CR>",        desc = " Diff (current)" },
		{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>",      desc = " Blame line" },
		{ "<leader>gv", "<cmd>DiffviewOpen<CR>",             desc = " Diffview open" },
		{ "<leader>gV", "<cmd>DiffviewClose<CR>",            desc = " Diffview close" },

		-- ── LSP / Code ──────────────────────────────────────────────────────────
		{ "<leader>l",  group = " LSP" },
		{ "<leader>ld", vim.lsp.buf.definition,                        desc = "󰈔 Go to definition" },
		{ "<leader>lr", vim.lsp.buf.references,                        desc = " References" },
		{ "<leader>lh", vim.lsp.buf.hover,                             desc = " Hover" },
		{ "<leader>ln", vim.lsp.buf.rename,                            desc = " Rename" },
		{ "<leader>la", vim.lsp.buf.code_action,                       desc = " Code action" },
		{ "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = " Format" },

		-- ── Diagnostics ─────────────────────────────────────────────────────────
		{ "<leader>d",  group = " Diagnostics" },
		{ "<leader>dd", vim.diagnostic.open_float,                     desc = " Line diagnostics" },
		{ "<leader>dn", vim.diagnostic.goto_next,                      desc = " Next diagnostic" },
		{ "<leader>dp", vim.diagnostic.goto_prev,                      desc = " Prev diagnostic" },
		{ "<leader>dl", "<cmd>Telescope diagnostics<CR>",    desc = "󱖫 All diagnostics" },

		-- ── Toggles / Misc ──────────────────────────────────────────────────────
		{ "<leader>t",  group = " Toggles" },
		{ "<leader>tn", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end, desc = " Toggle relative number" },
		{ "<leader>tw", function() vim.wo.wrap = not vim.wo.wrap end,                               desc = " Toggle wrap" },
		{ "<leader>tc", function() vim.opt.cursorline = not vim.opt.cursorline:get() end,           desc = " Toggle cursorline" },

		-- ── Session / Quit ──────────────────────────────────────────────────────
		{ "<leader>q",  group = " Quit" },
		{ "<leader>qq", "<cmd>qa!<CR>",                                desc = " Quit all!" },
		{ "<leader>qw", "<cmd>wqa<CR>",                                desc = " Save & quit" },
	  })

  end
end

if not vim.g._uuid_seeded then
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,9)) + (vim.uv or vim.loop).hrtime())
  vim.g._uuid_seeded = true
end

local function uuid()
  local random = math.random
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and random(0, 0xF) or random(8, 0xB)
    return string.format('%x', v)
  end)
end

-- Вставка N UUID'ов под курсор
local function insert_uuid()
	local id = uuid()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, true, {id})
end

-- Скопировать один UUID в системный буфер
local function yank_uuid()
  local id = uuid()
  vim.fn.setreg('+', id)
  vim.notify('UUID copied: ' .. id, vim.log.levels.INFO, { title = 'UUID' })
end

-- Команды
vim.api.nvim_create_user_command('UUID', function(opts)
    insert_uuid()
end, {})

vim.keymap.set('n', '<leader>uu', insert_uuid, { desc = 'Insert UUID' })
vim.keymap.set('n', '<leader>uy', yank_uuid,               { desc = 'Yank UUID to clipboard' })
