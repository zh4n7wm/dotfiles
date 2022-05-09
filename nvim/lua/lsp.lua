require("nvim-lsp-installer").setup({
    ensure_installed = {
        "clangd",
        "bashls",
        "pyright",
        "gopls",
        "solang",
        "dockerls",
        "eslint",
        "tsserver",
        "cmake",
        "cssls",
        "sumneko_lua",
        "sqls",
        "terraformls",
        "yamlls",
    }, -- ensure these servers are always installed
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})

require('lspconfig').pyright.setup{}
require('lspconfig').gopls.setup{}
require('lspconfig').tsserver.setup{}
require('lspconfig').yamlls.setup{}
require('lspconfig').ansiblels.setup{}
require('lspconfig').dockerls.setup{}
require('lspconfig').awk_ls.setup{}
require('lspconfig').bashls.setup{}
require('lspconfig').cssls.setup{}
require('lspconfig').html.setup{}
require('lspconfig').solidity_ls.setup{
    -- [root_dir] = {"**", ".git", "package.json"},
}
require('lspconfig').sumneko_lua.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
