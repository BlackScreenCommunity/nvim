-- Нумерация строк
vim.opt.nu = true

-- Относительная нумерация строк
vim.opt.relativenumber = true

-- Настройка отступов
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true


-- Опции поиска
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Подчеркивание активной строки
vim.opt.cursorline = true

-- Использование системного буфера при копировании
vim.opt.clipboard:append("unnamedplus")

-- Логика разделения на панели
vim.opt.splitright = true
vim.opt.splitbelow = true
