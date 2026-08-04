pcall(function() vim.loader.enable() end)

require("paq")({
    "savq/paq-nvim",
    "stevearc/conform.nvim",
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
	"waiting-for-dev/ergoterm.nvim",
	"ahmedkhalf/project.nvim",
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
if setup then
  comment.setup()
end


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
-- При нажатии на x - удаленный символ не помещается в буфер
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 'X', '"_X')

vim.keymap.set('i', '<S-Insert>', '<C-r>+')
vim.keymap.set('n', '<S-Insert>', '"+p')

-- Логика разделения на панели
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd("set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")

vim.g.mapleader = " "

local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      -- при желании можешь добавить markdown/yaml/… тоже на prettier
    },
	formatters = {
      prettier = {
        prepend_args = { "--use-tabs", "--tab-width", "4" },
      },
    },
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "javascript" or ft == "javascriptreact"
         or ft == "typescript" or ft == "typescriptreact"
         or ft == "json" or ft == "jsonc" then
        return { timeout_ms = 3000 }
      end
    end,
  })
end



-- Setup GIT plugins --
local setup, gitsigns = pcall(require, "gitsigns")
if setup then
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
else
  vim.notify("gitsigns.nvim failed to load: " .. tostring(gitsigns), vim.log.levels.WARN)
end

local setup, neogit = pcall(require, "neogit")
if setup then
  neogit.setup()
end


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
		{ "<leader>fp", "<cmd>Telescope projects<CR>",       desc = "Projects" },

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

		-- ── Toggles / Misc ──────────────────────────────────────────────────────
		{ "<leader>p",  group = " Toggles" },
		{ "<leader>pn", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end, desc = " Toggle relative number" },
		{ "<leader>pw", function() vim.wo.wrap = not vim.wo.wrap end,                               desc = " Toggle wrap" },
		{ "<leader>pc", function() vim.opt.cursorline = not vim.opt.cursorline:get() end,           desc = " Toggle cursorline" },

		-- ── Session / Quit ──────────────────────────────────────────────────────
		{ "<leader>q",  group = " Quit" },
		{ "<leader>qq", "<cmd>qa!<CR>",                                desc = " Quit all!" },
		{ "<leader>qw", "<cmd>wqa<CR>",                                desc = " Save & quit" },


		{ "<leader>t", group = " Terminal" },
		{ "<leader>tt", ":TermNew layout=float cmd=pwsh <CR>", desc = "Create terminal" },
		{ "<leader>to", ":TermSelect<CR>", desc = "Open terminal selector" },

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


-- Терминал
local setup, ergoterm = pcall(require, "ergoterm")
if setup then
	ergoterm.setup({
	  picker = {
	    picker = "telescope",
	  }
	})
end


local setup, nvimtree = pcall(require, "nvim-tree")
if setup then
  nvimtree.setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
})
end

local setup, project = pcall(require, "project_nvim")
if setup then
    project.setup ({
    })

	require('telescope').load_extension('projects')
end

