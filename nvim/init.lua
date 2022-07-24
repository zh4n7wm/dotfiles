local map = vim.api.nvim_set_keymap
local cmd = vim.cmd
local opts = { noremap=true, silent=true }

require('basic')
require('keymap')
require('plug')
require('cmpconfig')
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


local signs = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " "
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Do not source the default filetype.vim, using for neovim < 0.6.0
vim.g.did_load_filetypes = 1
require('filetype').setup{
    overrides = {
        complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig", -- Included in the plugin
        },
        function_literal = {
            Brewfile = function()
                vim.cmd("syntax off")
            end
        }
    }
}

require('trouble').setup{
    icons = true,
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = true,
}


vim.cmd [[
let g:loaded_fzf = 1
]]
require('lspfuzzy').setup{}

cmd [[
" enable true color
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set termguicolors
set t_Co=256

syntax enable
set background=dark
" set background=light

" colorscheme PaperColor

let g:gruvbox_material_palette = 'material'
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material

" colorscheme dracula

" colorscheme solarized
" let g:solarized_termcolors=256
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
