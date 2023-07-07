vim.opt.mouse=nil
vim.opt.encoding='utf-8'
-- 自动判断编码时，依次尝试以下编码：
vim.opt.fileencodings='ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1'
vim.opt.termencoding='utf-8'
-- Use Unix as the standard file type
vim.opt.ffs='unix,dos,mac'
-- 如遇Unicode值大于255的文本，不必等到空格再折行
vim.opt.formatoptions='m'
-- 合并两行中文时，不在中间加空格
vim.opt.formatoptions='B'
vim.opt.number=true
vim.opt.compatible=false

-- 突出显示当前列
vim.opt.cursorcolumn=true
-- 突出显示当前行
vim.opt.cursorline=true
-- 文件修改之后自动载入
vim.opt.autoread=true

-- Smart indent
vim.opt.smartindent=true
-- 打开自动缩进
-- never add copyindent, case error   " copy the previous indentation on autoindenting
vim.opt.autoindent=true

-- change the terminal's title
vim.opt.title=true

-- 去掉输入错误的提示声音
vim.opt.visualbell=false
vim.opt.errorbells=false
vim.opt.tm=500

-- message and info
vim.g.confirm = true
vim.g.showcmd = true

-- Remember info about open buffers on close
-- vim.opt.viminfo^=%

-- For regular expressions turn magic on
vim.opt.magic=true

-- Configure backspace so it acts as it should act
vim.opt.backspace='eol,start,indent'
vim.opt.whichwrap='<,>,h,l'

-- 修改leader键
vim.g.mapleader = ','

-- tab相关变更
-- 设置Tab键的宽度        [等同的空格个数]
vim.opt.tabstop=4
-- 每一次缩进对应的空格数
vim.opt.shiftwidth=4
-- 按退格键时可以一次删掉 4 个空格
vim.opt.softtabstop=4
-- insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格
vim.opt.smarttab=true
-- 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
vim.opt.expandtab=true
vim.cmd [[
" for html/javascript/lua files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
autocmd Filetype solidity setlocal ts=2 sw=2 expandtab

" does not expand tabs for Makefile
autocmd FileType make set noexpandtab
]]

-- editing text and indent
vim.g.textwidth = 0
vim.g.backspace = 2
-- Searching includes can be slow
vim.g.infercase = true
vim.g.showmatch = true
vim.g.virtualedit = 'block'
vim.g.shiftround = true
vim.g.smarttab = true
vim.g.autoindent = true

-- 增强模式中的命令行自动完成操作
vim.opt.history=2000
vim.opt.wildmenu=true
vim.opt.wildmode = 'full'
-- Ignore compiled files
vim.opt.wildignore = {'tags', '.*.un~', '*.o', '*~', '*.pyc', '*.class', '*.wasm'}

-- vim.opt.errorformat = vim.opt.errorformat + '%f|%l col %c|%m'
vim.opt.errorformat:append('%f|%l col %c|%m')

vim.opt.listchars = {eol = '↲', tab = '▸ ', trail = '·'}

-- theme主题
vim.opt.background='dark'

vim.opt.hidden = true

-- Give more space for displaying messages
vim.opt.cmdheight = 2

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

vim.g.grepformat=[[%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f\ \ %l%m]]
if vim.fn.executable('ag') then
  vim.g.grepprg=[[ag\ -s\]]
elseif vim.fn.has('unix') == 1 then
  vim.g.grepprg=[[grep\ -rn\ $*\ /dev/null]]
end

vim.cmd [[
" 设置可以高亮的关键字
if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
  endif
endif
]]

vim.cmd [[
    let g:go_fmt_autosave = 1
    let g:go_lsp_server = 'gopls'
    let g:go_lsp_server = 'gopls'
    let g:go_info_mode='gopls'
    let g:go_metalinter_command = "golangci-lint"
    " let g:go_metalinter_autosave = 1
    " let g:go_metalinter_deadline = "5s"
]]
