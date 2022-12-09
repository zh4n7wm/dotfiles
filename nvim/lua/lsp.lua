require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "bashls",
        "pyright",
        "gopls",
        "solang",
        "tsserver",
        "cmake",
        "html",
        "cssls",
        "eslint",
        "tailwindcss",
        "sumneko_lua",
        "sqls",
        "terraformls",
        "tflint",
        "yamlls",
        "jsonls",
        "dockerls",
        "rust_analyzer",
    },
    automatic_installation = false,
})


require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})

require('lspconfig').pyright.setup{}
require('lspconfig').gopls.setup{}
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
require('lspconfig').sumneko_lua.setup{
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}
