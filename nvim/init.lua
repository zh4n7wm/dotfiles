local cmd = vim.cmd

require("plug")
require("basic")
require("keymap")
require("cmpconfig")
require("lsp")
require("autocmd")
require("telescope-files")
require("telescope-sessions")

require("nvim-tree").setup({})
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "gruvbox",
  },
})

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("trouble").setup({
  icons = true,
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "﫠",
  },
  use_diagnostic_signs = true,
})

cmd([[
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
]])

-- undotree
cmd([[
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
    ]])

-- terraform
cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
cmd([[let g:terraform_fmt_on_save=1]])
cmd([[let g:terraform_align=1]])

-- astro
vim.filetype.add({
  extension = {
    astro = "astro",
  },
})
