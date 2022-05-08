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

    -- filesystem navigation
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

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
            vim.g.go_fmt_autosave = 1
        end
    }

    use { 'rust-lang/rust.vim', opt = true }

    -- filetype
    use {
        'nathom/filetype.nvim',
        config = function()
            vim.g.did_load_filetypes = 1
            overrides = {
                complex = {
                    -- Set the filetype of any full filename matching the regex to gitconfig
                    [".*git/config"] = "gitconfig", -- Included in the plugin
                },
                function_extensions = {
                    ['py'] = function()
                        vim.bo.filetype = "py"
                    end
                },
                function_literal = {
                    Brewfile = function()
                        vim.cmd("syntax off")
                    end
                }
            }
        end
    }

    -- configure LSP
    use {
        { 'williamboman/nvim-lsp-installer' },
        {
            'neovim/nvim-lspconfig',
            config = function ()
                local nvim_lsp = require('lspconfig')
                -- Define buffer-local mappings and options to access LSP
                -- functionality after the language server and buffer are
                -- attached.
                local on_attach = function(client, bufnr)
                    local function buf_setopt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                    buf_setopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

                    require('which-key').register({
                        ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover text" },
                        ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition" },
                        ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "List references" },
                        ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
                        ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
                        ["[d"] = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Prev diagnostic" },
                        ["]d"] = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic" },
                        ["da"] = {
                            "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
                            "List all diagnostics"
                        },
                        ["<leader>e"] = {
                            "<cmd>lua vim.diagnostic.open_float()<CR>",
                            "Show line diagnostics"
                        },
                        ["FF"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format code" },
                        ["<leader>D"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
                        ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
                        ["<leader>ca"] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action" },
                        ["\\W"] = {
                            name = "+Workspaces",
                            l = {
                                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                                "List workspace directories"
                            },
                            a = {
                                "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                                "Add workspace directory"
                            },
                            r = {
                                "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                                "Remove workspace directory"
                            },
                        },
                    }, { buffer = bufnr })

                    require('which-key').register({
                        ["FF"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format code" },
                        ["<leader>ca"] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action" },
                    }, { mode = "v", buffer = bufnr })
                end

                local capabilities = require('cmp_nvim_lsp').update_capabilities(
                vim.lsp.protocol.make_client_capabilities()
                )

                local servers = {
                    clangd = {}, gopls = {}, pyright = {}, bashls = {},
                    jsonls = {}, cssls = {}, html = {}, sqls = {},
                }

                for ls, overrides in pairs(servers) do
                    local config = {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        flags = {
                            debounce_text_changes = 500,
                        },
                        root_dir = function(fname)
                            local util = require('lspconfig.util')
                            local root_files = {
                                '.git', '.vimrc', 'setup.py', 'setup.cfg',
                                'pyrightconfig.json', 'pyproject.toml',
                                'requirements.txt', 'go.mod',
                                'package.json', 'compile_commands.json',
                                'Jamfile', 'Makefile', 'compile_flags.txt',
                            }
                            local root = util.root_pattern(unpack(root_files))(fname) or util.path.dirname(fname)
                            local bits = vim.split(root, '/')
                            if root == vim.loop.os_homedir() or bits[2] ~= "home" or #bits < 5 then
                                root = nil
                            end
                            return root
                        end
                    }

                    for k,v in pairs(overrides) do
                        config[k] = v
                    end

                    nvim_lsp[ls].setup(config)
                end

                vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false,
                    signs = true,
                    update_in_insert = false,
                }
                )

                vim.cmd [[
                augroup lsp
                autocmd!
                autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})
                augroup end
                ]]
            end
        },
    }

    -- A language server that integrates with external tools like black
    -- and shellcheck, as well as allowing LSP actions to be implemented
    -- in Lua using buffers inside Neovim (without separate processes).
    -- Can provide diagnostics, formatting, and code actions (with many
    -- builtin configurations for existing tools).
    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local nls = require "null-ls"

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

    use {
        'nanotee/sqls.nvim',
        config = function()
            -- config file: $HOME/sqls/config.yml
            require('lspconfig').sqls.setup{
                on_attach = function(client, bufnr)
                    require('sqls').on_attach(client, bufnr)
                end
            }
        end
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

    -- Defines gcc/gc{motion}/gC{motion} mappings to toggle comments on the
    -- current line or selected lines based on the 'commentstring' setting.
    use {
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').configure_language({"default", "html", "vim"}, {
                ignore_whitespace = false,
                use_consistent_indentation = true,
                single_line_comment_string = 'auto',
                multi_line_comment_strings = 'auto',
                hook_function = function()
                    require('ts_context_commentstring.internal').update_commentstring()
                end
            })
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
                    "vim", "vue", "yaml"
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
        { 'rafamadriz/friendly-snippets' },
        { 'onsails/lspkind.nvim' }
    }

    -- Makes it easier to input and identify Unicode characters and
    -- digraphs. <C-x><C-z> in insert mode completes based on the name
    -- of the unicode character, :Digraphs xxx searches digraphs for
    -- matches.
    use 'chrisbra/unicode.vim'

    use { 'preservim/tagbar' }

    -- Displays a "minimap"-style split display of classes/functions,
    -- but unlike Tagbar (which is unmaintained), these plugins are
    -- based on LSP symbols.
    use {
        'simrat39/symbols-outline.nvim', cmd = "SymbolsOutline"
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
        "akinsho/toggleterm.nvim", tag = 'v1.*',
        config = function()
            require("toggleterm").setup()
        end
    }

    -- 自动补全单引号，双引号等
    use { 'Raimondi/delimitMate' }

    -- text object
    use { 'kana/vim-textobj-user', 'kana/vim-textobj-line', 'kana/vim-textobj-entire', 'kana/vim-textobj-indent'}
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
    use { 'terryma/vim-multiple-cursors' }

    use {
        'junegunn/vim-easy-align',
        config = function()
            vim.cmd [[
            " Start interactive EasyAlign in visual mode (e.g. vipga)
            xmap ga <Plug>(EasyAlign)
            " Start interactive EasyAlign for a motion/text object (e.g. gaip)
            nmap ga <Plug>(EasyAlign)
            ]]
        end
    }
    -- 快速加入修改环绕字符
    use { 'wellle/targets.vim', 'tpope/vim-surround', 'tpope/vim-repeat', 'mg979/vim-visual-multi' }
    use { 'tpope/vim-abolish' }

    -- 显示、删除行尾空格
    use { 'bronson/vim-trailing-whitespace' }

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
        'junegunn/fzf.vim',
        requires={ {'junegunn/fzf', cmd = 'fzf#install()'}, }
    }
    use {
        'ojroques/nvim-lspfuzzy',
        requires = {
            {'junegunn/fzf'},
            {'junegunn/fzf.vim'},  -- to enable preview (optional)
        },
    }

    -- Configurable fuzzy-finder over lists (like fzf, but without the
    -- dependency on an external binary), with various plugins.
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
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
                ["T"] = {
                    name = "+Telescope",
                    ["T"] = { "<cmd>lua require('telescope.builtin').builtin()<CR>", "Builtins" },
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
        config = function()
            require('luasnip').config.setup({
                store_selection_keys = "<C-i>"
            })
        end
    }

    use { 'windwp/nvim-autopairs' }

    -- Displays an interactive tree of changes to undo
    use { 'mbbill/undotree' }

    -- Ask Sourcetrail to open the current symbol in the IDE or, conversely,
    -- accept requests from Sourcetrail to open a particular symbol in vim.
    use {
        'CoatiSoftware/vim-sourcetrail', keys = "\\S"
    }

    require('which-key').register({
        ga = { "<Plug>(UnicodeGA)", "Identify character" },
        ["\\R"] = { "<cmd>NvimTreeToggle<CR>", "NvimTreeToggle" },
        ["\\M"] = { "<cmd>SymbolsOutline<CR>", "Symbols" },
        ["\\U"] = { "<cmd>UndotreeToggle<CR>", "Undotree" },
        ["\\S"] = {
            name = "+Sourcetrail",
            r = { "<cmd>SourcetrailRefresh<CR>", "Start/refresh connection" },
            a = { "<cmd>SourcetrailActivateToken<CR>", "Activate current token" },
        },
    })

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

    require('which-key').register({
        ["[c"] = { "Prev hunk" },
        ["]c"] = { "Next hunk" },
        ["<leader>h"] = {
            name = "+Hunk",
            s = { "Stage hunk" },
            u = { "Unstage hunk" },
            r = { "Reset hunk" },
            R = { "Reset buffer" },
            p = { "Preview hunk" },
            b = { "Blame line" },
        },
    }, { mode = "n" })
    require('which-key').register({
        ["<leader>h"] = {
            name = "+Hunk",
            s = { "Stage hunk" },
            r = { "Reset hunk" },
        },
    }, { mode = "v" })

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
            dappy.setup('~/.virtualenvs/debugpy/bin/python')
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
        'TimUntersberger/Neogit', cmd = "Neogit",
        config = function()
            require('neogit').setup({
                integrations = {
                    diffview = true
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

    use {
        'oberblastmeister/neuron.nvim', branch = "unstable", keys = "gz",
        config = function()
            require('neuron').setup()
        end
    }

    use 'gpanders/editorconfig.nvim'

    -- color scheme
    use { 'NLKNguyen/papercolor-theme' }
    use { 'sainnhe/gruvbox-material' }
    use { 'altercation/vim-colors-solarized' }
    use { 'overcache/NeoSolarized' }
    use { 'Mofiqul/dracula.nvim' }
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
