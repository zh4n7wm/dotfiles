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

local on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()  -- Note: add in lsp client on-attach
end

require('lspconfig').gopls.setup{}

require('lspconfig').pyright.setup{
    handlers = {
        -- pyright ignores dynamicRegistration settings
        ['client/registerCapability'] = function(_, _, _, _)
            return {
                result = nil;
                error = nil;
            }
        end
    }
}

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
require('lspconfig').sumneko_lua.setup{}
