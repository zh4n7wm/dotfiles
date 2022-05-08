local map = vim.api.nvim_set_keymap
local cmd = vim.cmd
local opts = { noremap=true, silent=true }

require('basic')
require('keymap')
require('plug')
require('cmpconfig')
-- require('nvim-cmp-config')
require('lsp')
require('autocmd')
require('telescope-files')
require('telescope-sessions')

require('nvim-tree').setup{}
require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'gruvbox'
  }
}

vim.cmd [[
let g:loaded_fzf = 1
]]
require('lspfuzzy').setup{}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
map('n', 'da', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)


local signs = { Error = "🔥", Warn = "⚠️ ", Hint = "✨", Info = "ℹ️ " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

cmd [[
" enable true color
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set termguicolors
set t_Co=256

syntax enable
set background=dark
" set background=light

colorscheme PaperColor

" let g:gruvbox_material_palette = 'material'
" let g:gruvbox_material_background = 'soft'
" let g:gruvbox_material_better_performance = 1
" colorscheme gruvbox-material

" colorscheme dracula

" colorscheme solarized
" let g:solarized_termcolors=256

" colorscheme NeoSolarized
" let g:neosolarized_contrast = "normal"
" let g:neosolarized_visibility = "normal"
" let g:neosolarized_vertSplitBgTrans = 1
" let g:neosolarized_bold = 1
" let g:neosolarized_underline = 1
" let g:neosolarized_italic = 1
" let g:neosolarized_termBoldAsBright = 1
]]

-- undotree
cmd [[
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
]]

-- which-key
require('which-key').register({
  ["<C-f>"] = {
    "<cmd>lua require('telescope-files').project_files()<CR>",
    "Find files",
  },
  ["<C-b>"] = { "<cmd>Telescope buffers<CR>", "Buffers" },
  ["<C-g>"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
  ["<C-t>"] = {
    name = "+Telescope",
    ["<C-t>"] = { "<cmd>Telescope builtin<CR>", "Builtins" },
    h = { "<cmd>Telescope help_tags<CR>", "Help tags" },
  },
})
