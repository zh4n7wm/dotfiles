-- This file can be loaded by calling `lua require('plug')` from your init.vim

-- Setup packer.nvim with all necessary plugins
--
-- auto update
vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]]

local packer_startup = function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- need to load first
    use {
        'nvim-tree/nvim-web-devicons',
        'nathom/filetype.nvim',
    }

    -- filesystem navigation
    use { 'nvim-tree/nvim-tree.lua' }

    use { 'nvim-lualine/lualine.nvim' }

    -- If a file is already open in vim somewhere, just switch to that editor
    -- instead of bothering me with a warning about the swapfile. (Depends on
    -- support from the window manager.)
    use 'gioele/vim-autoswap'

    -- Conservatively insert matching ending bracket(s) only on <CR>.
    use 'rstacruz/vim-closer'

    use {
        'fatih/vim-go',
        run = ':GoUpdateBinaries',
        ft = 'go',
        setup = function()
            -- Read the following section and add what you need
        end
    }

    use { 'rust-lang/rust.vim', opt = true }

    use {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({
                virtual_text = false,
            })
            vim.keymap.set(
                "",
                "<Leader>l",
                require("lsp_lines").toggle,
                { desc = "Toggle lsp_lines" }
            )
        end,
    }
    -- show all the trouble your code is causing
    use {
        'folke/trouble.nvim',
        requires = {  "neovim/nvim-lspconfig" },
        config = function ()
            vim.cmd [[
            nnoremap <leader>xx <cmd>TroubleToggle<cr>
            nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
            nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
            nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
            nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
            nnoremap gR <cmd>TroubleToggle lsp_references<cr>
            ]]
        end
    }

    use {
        'sbdchd/neoformat',
        config = function()
            vim.cmd [[
                augroup fmt
                    autocmd!
                    autocmd BufWritePre * undojoin | Neoformat
                augroup END

                autocmd FileType javascript setlocal formatprg=prettier\ --single-quote\ --no-semi\ --trailing-comma\ es5

                " Use formatprg when available
                " let g:neoformat_try_formatprg = 1
                let g:neoformat_basic_format_align = 1
                let g:neoformat_basic_format_trim = 1

                nnoremap gp :silent %!prettier --single-quote --no-semi --trailing-comma es5 --stdin-filepath %<CR>
            ]]
        end,
    }

    -- configure LSP
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'jay-babu/mason-null-ls.nvim',
        'jay-babu/mason-nvim-dap.nvim',
    }

    -- A language server that integrates with external tools like black
    -- and shellcheck, as well as allowing LSP actions to be implemented
    -- in Lua using buffers inside Neovim (without separate processes).
    -- Can provide diagnostics, formatting, and code actions (with many
    -- builtin configurations for existing tools).
    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local nls = require('null-ls')

            nls.setup({
                debounce = 250,
                sources = {
                    nls.builtins.formatting.black,
                    nls.builtins.diagnostics.shellcheck.with({
                        diagnostics_format = "[#{c}] #{m} (#{s})"
                    })
                }
            })
        end,
    }

    -- LSP Status Bar
    use { "nvim-lua/lsp-status.nvim" }

    use {
        'hashivim/vim-terraform',
        config = function()
            vim.g.terraform_align=1
            vim.g.terraform_fold_sections=0
            vim.g.terraform_fmt_on_save=1
        end
    }

    -- indent line
    use { 'lukas-reineke/indent-blankline.nvim'}

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use { 'psliwka/vim-smoothie' }

    -- Like context.vim, displays class/function/block context
    -- at the top of the screen while scrolling through code.
    use {
        'romgrk/nvim-treesitter-context',
        after = { 'nvim-treesitter' },
        config = function()
            require('treesitter-context').setup({
                enable = true,
                throttle = true,
            })
        end
    }
    -- A Neovim interface to the tree-sitter incremental parser library, to
    -- enable syntax-aware highlighting, text object definitions, and other
    -- features (instead of using the traditional regex-based hacks).
    use {
        'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        -- These modules are not actually dependencies, but the reverse: they
        -- need nvim-treesitter to work. I'm putting them all in here to make
        -- sure they're all loaded before running the setup function below
        -- (though I'm not sure if it's really needed).
        requires = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/playground',
        },
        config = function()
            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "bash", "c", "clojure", "cmake", "comment", "commonlisp",
                    "cpp", "css", "dockerfile", "dot", "fennel", "go", "gomod",
                    "haskell", "html", "http", "java", "javascript", "jsdoc",
                    "json", "json5", "jsonc", "julia", "kotlin", "latex", "llvm",
                    "lua", "make", "markdown", "ninja", "nix", "norg", "perl",
                    "php", "python", "r", "regex", "rst", "ruby", "rust", "scala",
                    "scheme", "scss", "svelte", "tlaplus", "toml", "typescript",
                    "vim", "vue", "yaml", "hcl", "astro",
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    custom_captures = {},
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "grc",
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aP"] = "@parameter.outer",
                            ["iP"] = "@parameter.inner",
                            ["a#"] = "@comment.outer",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer"
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer"
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer"
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        peek_definition_code = {
                            ["df"] = "@function.outer",
                            ["dF"] = "@class.outer",
                        },
                    },
                },
                playground = {
                    enable = true,
                }
            })
        end
    }

    -- A completion manager that obtains completion data from multiple
    -- sources (LSP, LuaSnip, buffers, etc.) based on plugins included
    -- below. This is the pure-Lua successor of nvim-compe.
    use {
        { 'hrsh7th/nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'ray-x/lsp_signature.nvim'  },
        {
            'rafamadriz/friendly-snippets',
            config = function ()
                require("luasnip/loaders/from_vscode").lazy_load()
            end
        },
        { 'onsails/lspkind.nvim' }
    }

    -- Makes it easier to input and identify Unicode characters and
    -- digraphs. <C-x><C-z> in insert mode completes based on the name
    -- of the unicode character, :Digraphs xxx searches digraphs for
    -- matches.
    use 'chrisbra/unicode.vim'

    use { 'preservim/tagbar' }
    -- use { 'liuchengxu/vista.vim' }

    -- Displays a "minimap"-style split display of classes/functions,
    -- but unlike Tagbar (which is unmaintained), these plugins are
    -- based on LSP symbols.
    use {
        'simrat39/symbols-outline.nvim', cmd = "SymbolsOutline"
    }

    -- Unlike NERDTree and NvimTree, Rnvimr uses RPC to communicate with
    -- Ranger, thus inheriting all of its file management functionality.
    use {
        'kevinhwang91/rnvimr', cmd = "RnvimrToggle"
    }

    -- github
    use {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function ()
            require"octo".setup()
        end
    }

    -- sudo read/write
    use { 'lambdalisue/suda.vim' }

    -- Key mapping manager (supersedes junegunn/vim-peekaboo and has a lot more
    -- functionality, like displaying applicable mappings after partial input).
    use {
        'folke/which-key.nvim',
        config = function ()
            require('which-key').setup({
                plugins = {
                    spelling = {
                        enabled = true,
                        suggestions = 20,
                    },
                },
            })
        end
    }

    use {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup()
        end
    }

    -- 自动补全单引号，双引号等
    use { 'Raimondi/delimitMate' }

    use { 'machakann/vim-highlightedyank' }

    -- Snippet Engine + Presets
    use { 'mattn/emmet-vim' }

    -- git
    use { 'airblade/vim-gitgutter' }
    use { 'junegunn/gv.vim' }

    -- markdown
    use {
        'tpope/vim-markdown',
        config = function()
            vim.g.markdown_fenced_languages = {'html', 'javascript', 'typescript', 'css', 'scss', 'python', 'bash=sh', 'go', 'lua', 'vim'}
            vim.g.markdown_minlines = 100
        end
    }

    -- signature
    -- 显示marks - 方便自己进行标记和跳转
    -- m[a-zA-Z] add mark
    -- '[a-zA-Z] go to mark
    -- m<Space>  del all marks
    -- m/        list all marks
    -- m.        add new mark just follow previous mark
    use { 'kshenoy/vim-signature' }

    -- quick selection and edit
    -- expandregion
    -- 选中区块
    use { 'terryma/vim-expand-region' }
    -- 多光标选中编辑
    -- multiplecursors
    use { 'mg979/vim-visual-multi' }

    use {
        'junegunn/vim-easy-align',
        config = function()
            vim.cmd [[
            " Start interactive EasyAlign in visual mode (e.g. vipga)
            xmap ga <Plug>(EasyAlign)
            " Start interactive EasyAlign for a motion/text object (e.g. gaip)
            nmap ga <Plug>(EasyAlign)

            " live interactive mode
            " xmap iga <Plug>(LiveEasyAlign)
            " nmap iga <Plug>(LiveEasyAlign)
            ]]
        end
    }
    -- 快速加入修改环绕字符
    use { 'wellle/targets.vim', 'tpope/vim-surround', 'tpope/vim-repeat'}
    use { 'tpope/vim-abolish' }
    use { 'windwp/nvim-autopairs' }

    -- 显示、删除行尾空格
    use { 'bronson/vim-trailing-whitespace' }

    -- fast left-right movement
    use {
        'unblevable/quick-scope',
        config = function ()
            vim.cmd [[
            " Trigger a highlight only when pressing f and F
            let g:qs_highlight_on_keys = ['f', 'F']
            let g:qs_max_chars=250

            " Map the leader key + q to toggle quick-scope's highlighting in normal/visual mode.
            " Note that you must use nmap/xmap instead of their non-recursive versions (nnoremap/xnoremap).
            nmap <leader>q <plug>(QuickScopeToggle)
            xmap <leader>q <plug>(QuickScopeToggle)
            ]]
        end
    }

    -- 将不同层级的括号用不同颜色显示
    use {
        'luochen1990/rainbow',
        config = function()
            vim.cmd [[
            " set to 0 if you want to enable it later via :RainbowToggle
            let g:rainbow_active = 1
            ]]
        end
    }

    -- find/filter
    use {
        '/usr/local/opt/fzf', -- install fzf via brew
        'junegunn/fzf.vim',
    }
    use {
        'ojroques/nvim-lspfuzzy',
        requires = {
            'junegunn/fzf.vim',  -- to enable preview (optional)
        },
    }

    -- Configurable fuzzy-finder over lists (like fzf, but without the
    -- dependency on an external binary), with various plugins.
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'folke/persistence.nvim',  -- used by './telescope-sessions.lua'
            '/usr/local/bin/fd', -- fd
        },
        config = function ()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = "close",
                            ["<C-q>"] = "close",
                        },
                        n = {
                            ["q"] = "close",
                        },
                    },
                },
                pickers = {
                    buffers = {
                        sort_lastused = true,
                        theme = 'dropdown',
                        previewer = false,
                        mappings = {
                            i = { ['<C-d>'] = "delete_buffer" },
                        }
                    },
                }
            })
            require('which-key').register({
                ["<C-f>"] = {
                    "<cmd>lua require('telescope-files').project_files()<CR>",
                    "Find files",
                },
                ["<C-b>"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
                ["<C-g>"] = {
                    "<cmd>lua require('telescope.builtin').live_grep({sorter=require('telescope.sorters').empty()})<CR>",
                    "Live grep"
                },
                ["C-t"] = {
                    name = "+Telescope",
                    ["C-t"] = { "<cmd>lua require('telescope.builtin').builtin()<CR>", "Builtins" },
                    h = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags" },
                },
            })
        end
    }

    -- Adds support to Telescope for https://github.com/jhawthorn/fzy (an
    -- alternative to fzf), which needs to be installed separately.
    use {
        'nvim-telescope/telescope-fzy-native.nvim',
        config = function()
            require('telescope').load_extension('fzy_native')
        end
    }

    -- A snippet manager (required for some LSP actions) written in Lua.
    -- More complex than UltiSnips, but supports the new VS Code snippet
    -- format, integrates better with compe, and has more features.
    -- See https://github.com/neovim/nvim-lspconfig/wiki/Snippets
    use {
        'L3MON4D3/LuaSnip',
        requires= { 'hrsh7th/nvim-cmp' },
        config = function()
            local function prequire(...)
                local status, lib = pcall(require, ...)
                if (status) then return lib end
                return nil
            end

            local luasnip = prequire('luasnip')
            local cmp = prequire("cmp")

            local t = function(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

            local check_back_space = function()
                local col = vim.fn.col('.') - 1
                if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                    return true
                else
                    return false
                end
            end

            _G.tab_complete = function()
                if cmp and cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip and luasnip.expand_or_jumpable() then
                    return t("<Plug>luasnip-expand-or-jump")
                elseif check_back_space() then
                    return t "<Tab>"
                else
                    cmp.complete()
                end
                return ""
            end
            _G.s_tab_complete = function()
                if cmp and cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip and luasnip.jumpable(-1) then
                    return t("<Plug>luasnip-jump-prev")
                else
                    return t "<S-Tab>"
                end
                return ""
            end

            vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
            vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
            vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
            vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})
        end
    }

    -- Displays an interactive tree of changes to undo
    use { 'mbbill/undotree' }

    -- Ask Sourcetrail to open the current symbol in the IDE or, conversely,
    -- accept requests from Sourcetrail to open a particular symbol in vim.
    use {
        'CoatiSoftware/vim-sourcetrail', keys = "\\S"
    }

    -- Fugitive provides a lightweight alternative to running git commands with
    -- `:!git …`, with better output handling and nice buffer integration where
    -- appropriate.
    --
    -- Splice is the only interface I've ever found that makes three-way merges
    -- comprehensible. Unfortunately, it cannot coexist with Fugitive. We need
    -- to use Splice (and therefore exclude Fugitive) only when invoked via
    -- `git mergetool`. We can make that decision in .vimrc.
    --
    -- To do so, we must make both modules optional here.
    --
    use {
        { 'tpope/vim-fugitive', opt = true },
        { 'sjl/splice.vim', opt = true },
    }

    -- Displays git change annotations and provides inline previews of
    -- diff hunks.
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    -- debugging system for vim
    -- use { 'puremourning/vimspector' }

    -- Supports Python debugging using debugpy and nvim-dap, which adds
    -- support for the Debug Adapter Protocol (and requires an adapter
    -- per language to be debugged).
    use {
        'mfussenegger/nvim-dap', cmd = "DAP",
        config = function()
            local dap = require('dap')
            local repl = require('dap.repl')

            repl.commands = vim.tbl_extend('force', repl.commands, {
                custom_commands = {
                    ['.br'] = function(text)
                        if text == "" or not text:match(':') then
                            repl.append("ERR: Please specify `.br filename:lineno`")
                            return
                        end
                        local fname, lnum = unpack(vim.split(text, ':'))
                        local bufnr = vim.fn.bufnr(fname)
                        if bufnr == -1 then
                            bufnr = vim.fn.bufload(fname)
                        end
                        require('dap.breakpoints').toggle({}, bufnr, tonumber(lnum))
                        dap.session():set_breakpoints(bufnr)
                    end
                },
            })

            require('which-key').register({
                ["\\B"] = {
                    "<cmd>lua require('dap').toggle_breakpoint()<CR>",
                    "DAP: Toggle breakpoint",
                },
                ["\\C"] = {
                    "<cmd>setlocal number<CR><cmd>lua require('dap').continue()<CR>",
                    "DAP: Continue",
                },
            })

            -- These dap-repl-specific mappings make using the debugger
            -- a bit more like the usual gdb experience, but note that
            -- you can't _start_ the program using 'c' in the REPL, you
            -- must first do so using the \C mapping above in the source
            -- buffer, and only then switch to the REPL.
            vim.cmd[[
            augroup dap-repl
            autocmd!
            autocmd FileType dap-repl nnoremap<buffer> n <cmd>lua require('dap').step_over()<CR>
            autocmd FileType dap-repl nnoremap<buffer> s <cmd>lua require('dap').step_into()<CR>
            autocmd FileType dap-repl nnoremap<buffer> c <cmd>lua require('dap').continue()<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -w <cmd>1wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -s <cmd>2wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -b <cmd>3wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -S <cmd>4wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -c <cmd>5wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -o <cmd>6wincmd w<CR>
            autocmd FileType dap-*,dapui* nnoremap<buffer> -r <cmd>7wincmd w<CR>
            augroup end
            ]]
        end
    }
    use {
        'mfussenegger/nvim-dap-python', after = { 'nvim-dap' },
        config = function()
            local dappy = require('dap-python')
            -- dappy.setup('python-path')
            dappy.test_runner = 'pytest'
        end
    }

    -- Uses virtual text to display context information with nvim-dap.
    use {
        'theHamsta/nvim-dap-virtual-text', after = { 'nvim-dap' },
        config = function()
            vim.g.dap_virtual_text = true
        end
    }

    -- Provides a basic debugger UI for nvim-dap
    use {
        "rcarriga/nvim-dap-ui", after = { 'nvim-dap' },
        config = function()
            require('dapui').setup({})
            require('which-key').register({
                ["\\D"] = {
                    "<cmd>setlocal number<CR><cmd>lua require('dapui').toggle()<CR>",
                    "DAP: Debugger UI",
                }
            })
        end
    }

    -- Provides a Telescope interface to nvim-dap functionality.
    use {
        'nvim-telescope/telescope-dap.nvim', after = { 'nvim-dap' },
        config = function()
            require('telescope').load_extension('dap')
        end
    }

    -- Integrates with vim-test and nvim-dap to run tests.
    use { 'vim-test/vim-test', cmd = "Ultest" }
    use {
        "rcarriga/vim-ultest", after = { 'vim-test' },
        config = function()
            require("ultest").setup({
                builders = {
                    ['python#pytest'] = function (cmd)
                        local non_modules = {'python', 'pipenv', 'poetry'}
                        local module_index = 1
                        if vim.tbl_contains(non_modules, cmd[1]) then
                            module_index = 3
                        end
                        local module = cmd[module_index]
                        local args = vim.list_slice(cmd, module_index + 1)
                        return {
                            dap = {
                                type = 'python',
                                request = 'launch',
                                module = module,
                                args = args
                            }
                        }
                    end
                }
            })
            require('which-key').register({
                ["[t"] = { "<Plug>(ultest-prev-fail)", "Prev test failure" },
                ["]t"] = { "<Plug>(ultest-next-fail)", "Next test failure" },
            })
        end
    }

    use {
        'folke/persistence.nvim',
        config = function()
            -- DON'T call require('persistence').setup() here, because
            -- it will call persistence.start(), which will set up the
            -- auto-save behaviour that we don't want.
            require('persistence.config').setup({
                dir = vim.fn.stdpath('data')..'/sessions/'
            })
            require('which-key').register({
                ["\\s"] = {
                    name = "+Sessions",
                    ["s"] = {
                        "<cmd>lua require('persistence').save()<CR>",
                        "Save session",
                    },
                    ["l"] = {
                        "<cmd>lua require('telescope-sessions').sessions()<CR>",
                        "Load session",
                    }
                }
            })
        end
    }

    use {
        'sindrets/diffview.nvim',
        config = function()
            require('diffview').setup()
        end
    }

    use 'gpanders/editorconfig.nvim'

    -- color scheme
    -- use { 'NLKNguyen/papercolor-theme' }
    use { 'sainnhe/gruvbox-material' }
    -- use { 'altercation/vim-colors-solarized' }

    -- time tracker
    use { 'wakatime/vim-wakatime' }

    -- lint
    use { 'mfussenegger/nvim-lint' }

    -- codeium
    -- use { 'Exafunction/codeium.vim' }
end

local packer_config = {
    compile_path = vim.fn.stdpath('data') .. '/site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua',
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end
    },
    git = {
        clone_timeout = 1200,
    }
}

return require('packer').startup({ packer_startup, config = packer_config })
