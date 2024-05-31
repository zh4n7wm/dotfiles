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
    "pylsp",
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
  },
})

require("lsp_signature").setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
})

require("lspconfig").kotlin_language_server.setup({})
require("lspconfig").astro.setup({})
-- require('lspconfig').pyright.setup{}
require("lspconfig").pylsp.setup({})
require("lspconfig").gopls.setup({})
require("lspconfig").vimls.setup({})
require("lspconfig").ansiblels.setup({})
require("lspconfig").awk_ls.setup({})
require("lspconfig").bashls.setup({})
require("lspconfig").html.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").tsserver.setup({})
require("lspconfig").eslint.setup({})
require("lspconfig").tailwindcss.setup({})
require("lspconfig").terraformls.setup({})
require("lspconfig").tflint.setup({})
require("lspconfig").solidity_ls.setup({
  -- [root_dir] = {"**", ".git", "package.json"},
})
require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- vim.keymap.set( "n", "gD", vim.lsp.buf.declaration, { silent = true } )
-- vim.keymap.set( "n", "gd", vim.lsp.buf.definition, { silent = true } )
-- vim.keymap.set( "n", "K", vim.lsp.buf.hover, { silent = true } )
-- vim.keymap.set( "n", "gi", vim.lsp.buf.implementation, { silent = true } )
-- vim.keymap.set( "n", "gr", vim.lsp.buf.references, { silent = true } )
-- vim.keymap.set( "n", "<C-k>", vim.lsp.buf.signature_help, { silent = true } )
-- vim.keymap.set( "n", "<space>wa", vim.lsp.buf.add_workspace_folder, { silent = true } )
-- vim.keymap.set( "n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { silent = true } )
-- vim.keymap.set( "n", "<space>D", vim.lsp.buf.type_definition, { silent = true } )
-- vim.keymap.set( "n", "<space>rn", vim.lsp.buf.rename, { silent = true } )
-- vim.keymap.set( "n", "<space>ca", vim.lsp.buf.code_action, { silent = true } )
