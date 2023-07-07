require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "python", "delve" },
    automatic_setup = true,
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "astro",
        "clangd",
        "bashls",
        "pyright",
        "gopls",
        "vimls",
        "solang",
        "tsserver",
        "cmake",
        "html",
        "cssls",
        "eslint",
        "tailwindcss",
        "lua_ls",
        "sqlls",
        "terraformls",
        "tflint",
        "jsonls",
        "dockerls",
        "rust_analyzer",
    },
    automatic_installation = false,
    flags = {
        debounce_text_changes = 150,
    }
})


require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})

require('lspconfig').kotlin_language_server.setup{}
require('lspconfig').astro.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').gopls.setup{}
require('lspconfig').vimls.setup{}
require('lspconfig').ansiblels.setup{}
require('lspconfig').awk_ls.setup{}
require('lspconfig').bashls.setup{}
require('lspconfig').html.setup{}
require('lspconfig').cssls.setup{}
require('lspconfig').tsserver.setup{}
require('lspconfig').eslint.setup{}
require('lspconfig').tailwindcss.setup{}
require('lspconfig').terraformls.setup{}
require('lspconfig').tflint.setup{}
require('lspconfig').solidity_ls.setup{
    -- [root_dir] = {"**", ".git", "package.json"},
}
require('lspconfig').lua_ls.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
