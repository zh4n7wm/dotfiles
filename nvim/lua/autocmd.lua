-- go to last location of buffer
vim.api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd(
  { "InsertLeave", "WinEnter" },
  { pattern = "*", command = "set cursorline", group = cursorGrp }
)
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

vim.api.nvim_create_autocmd(
    'FileType',
    { pattern = '*', command = 'setlocal nolinebreak' }
)
vim.api.nvim_create_autocmd(
    'FileType',
    { pattern = 'json', command = 'set sw=2 et' }
)
vim.api.nvim_create_autocmd(
    'FileType',
    { pattern = 'xml,xsd,xslt,javascript', command = 'setlocal ts=2' }
)
vim.api.nvim_create_autocmd(
    'FileType',
    { pattern = 'mail,gitcommit', command = 'setlocal tw=72' }
)
vim.api.nvim_create_autocmd(
    'FileType',
    {
        pattern = 'sh,zsh,csh,tcsh',
        command = [[
            setlocal fo-=t
            inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&filetype<CR>
        ]],
    }
)
vim.api.nvim_create_autocmd(
    'FileType',
    {
        pattern = 'perl,python,ruby,tcl',
        command = 'inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&filetype<CR>',
    }
)
