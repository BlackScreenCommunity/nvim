require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        --"cssls",
        "quick_lint_js",
        "lua_ls"
    }
})

require("lspconfig").lua_ls.setup {}
require("lspconfig").quick_lint_js.setup {}
