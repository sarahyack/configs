" Determine Platform
" WORK IN PROGRESS

" Detect Windows (classic, WSL, MSYS, etc.)
function! IsWindows() abort
  return has('win32')
        \ || has('win64')
        \ || has('win32unix')
endfunction

" Detect macOS
function! IsMac() abort
  return has('macunix')
endfunction

" Detect Linux (and only Linux)
function! IsLinux() abort
  return has('unix') && !IsWindows() && !IsMac()
endfunction

if IsWindows()
    let VIMRUNTIME="C:/Program Files/Neovim/share/nvim/runtime/"
    let g:python3_host_prog = 'C:/PythonShortcut/python.exe'
    let g:SYSTEM = "windows"
    let g:HOME = "C/Users/Sarah/"
    let g:UNDODIR = "C:/Users/Sarah/AppData/Local/nvim/undo"
    let g:PENDIR = "C:/05_Support/nvim/pendulum/pendulum.log"
    let g:PLUGDIR = "C:/Users/Sarah/AppData/Local/nvim/plugged"
    let g:PWSHLSPATH = "C:/05_Support/powershell/PowerShellEditorServices/PowerShellEditorServices"
    let g:PWSHPATH = "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    let g:WORKDIR = "D:/"
    let g:SHELL = "powershell"
elseif IsLinux()
    let g:SYSTEM = "linux"
    let g:HOME = "/home/sarah"
    let g:UNDODIR = "/home/sarah/.local/share/nvim/undo"
    let g:PENDIR = "/home/sarah/.local/share/nvim/pendulum/pendulum.log"
    let g:PLUGDIR = "/home/sarah/.local/share/nvim/site/plug"
endif

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Set Settings
syntax on
set number
set cursorline
set expandtab
set tabstop=4
set showtabline=2
set shiftwidth=4
set autoindent
set foldenable
set foldlevel=99
set foldlevelstart=99
set foldcolumn=1
set wildmode=longest,list
set undofile
set undodir=UNDODIR
filetype plugin indent on
set clipboard=unnamedplus
filetype plugin on
set completeopt=menu
set splitright
set splitbelow
set termguicolors
set background=dark

" Set Neovide Setings
if exists("g:neovide")
    if empty(argv()) " Change to workspace only if cwd is home and no files are passed
        autocmd VimEnter * silent! cd g:WORKDIR
    endif 
    set guifont=Terminess\ Nerd\ Font:h13
    let g:neovide_font_ligatures=1
    let g:neovide_hide_mouse_when_typing=v:true
    let g:neovide_cursor_vfx_mode="railgun"
    let g:neovide_cursor_trail_size=0.8
    let g:neovide_cursor_vfx_opacity=300.0
    let g:neovide_cursor_vfx_particle_lifetime=1.6
    let g:neovide_cursor_vfx_particle_density=7.0
    let g:neovide_padding_top=20
    let g:neovide_padding_left=20
    let g:neovide_padding_bottom=10
    let g:neovide_fullscreen=v:true
endif

" Load/Install Plugins
call plug#begin(g:PLUGDIR) 
" DEPENDENCIES
Plug 'nvim-lua/plenary.nvim'
Plug 'kevinhwang91/promise-async'
Plug 'tjdevries/colorbuddy.nvim'

" MISC
Plug 'Exafunction/codeium.vim'
Plug 'lowitea/aw-watcher.nvim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'ptdewey/pendulum-nvim'
Plug 'y3owk1n/time-machine.nvim'
Plug 'QuentinGruber/pomodoro.nvim'

" UI
Plug 'nvimdev/dashboard-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'OXY2DEV/markview.nvim'
Plug 'nanozuki/tabby.nvim'
Plug 'levouh/tint.nvim'
Plug 'beauwilliams/focus.nvim'
Plug 'ellisonleao/glow.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvimdev/hlsearch.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'echasnovski/mini.icons', {'branch': 'stable'}
Plug 'rktjmp/lush.nvim'
Plug 'brianhuster/live-preview.nvim'

" SWITCHERS
Plug 'nvim-telescope/telescope.nvim'
Plug 'tom-anders/telescope-vim-bookmarks.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'doctorfree/cheatsheet.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'lewis6991/gitsigns.nvim'

" SNIPPETS
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" FILES
Plug 'echasnovski/mini.files', {'branch': 'stable'}
Plug 'vifm/vifm.vim'
Plug 'stevearc/oil.nvim'
Plug 'refractalize/oil-git-status.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'CRAG666/code_runner.nvim'
Plug 'dzfrias/arena.nvim'

" EDITING
Plug 'MattesGroeger/vim-bookmarks'
Plug 'akinsho/toggleterm.nvim'
Plug 'kevinhwang91/nvim-ufo'
Plug 'chrisgrieser/nvim-origami', {'tag': 'v1.9'}
Plug 'tpope/vim-commentary'
Plug 'kylechui/nvim-surround'
Plug 'folke/trouble.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'fedepujol/move.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'folke/todo-comments.nvim'

" THEMES
Plug 'LmanTW/themify.nvim'

call plug#end()

" Plugin Setup

let g:bookmark_no_default_key_mappings = 1
let g:bookmark_auto_save = 1
let g:bookmark_manage_per_buffer = 0
let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1
let g:bookmark_display_annotation = 1
let g:bookmark_auto_close = 1

lua << EOF
local minif = require('mini.files')
minif.setup()

local minic = require('mini.icons')
minic.setup()

local oil = require('oil')
oil.setup({
  win_options = {
      signcolumn = "yes:2",
  },
  keymaps = {
    ['H'] = 'actions.parent',
    ['L'] = 'actions.select',
  },
})

local oil_git = require('oil-git-status')
oil_git.setup()

local arena = require('arena')
arena.setup()

local todo = require('todo-comments')
todo.setup()

local ufo = require('ufo')
ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

local origami = require('origami')
origami.setup()

local pomodoro = require('pomodoro')
pomodoro.setup({
    start_at_launch = true,
    work_duration = 30,
    break_duration = 5,
    delay_duration = 5,
    long_break_duration = 25,
    breaks_before_long = 4,
})

local project = require('project_nvim')
project.setup()

local telescope = require('telescope')
telescope.setup {
  defaults = {
    initial_mode = "normal",
    results_title = false,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    mappings = {
    },
    preview = {
        timeout = 300,
        filesize_limit = 5,
    }
  },
  pickers = {
    find_files = { hidden = true }, -- Show hidden files
    live_grep = { initial_mode = "insert" }, -- Live Grep stays in insert mode
    lsp_document_symbols = { initial_mode = "normal", layout_strategy = "center", symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait" }, previewer = false, }
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() }, -- Nicer UI for selections
    ["frecency"] = { show_unindexed = false }, -- Improve recent files behavior
    ["fzf"] = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
  }
}

telescope.load_extension('fzf')
telescope.load_extension('frecency')
telescope.load_extension('ui-select')
telescope.load_extension('vim_bookmarks')
telescope.load_extension('projects')

local pendulum = require('pendulum')
pendulum.setup({
    log_file = vim.g.PENDIR,
    time_format = "24h",
    time_zone = "America/Denver",
})

local timemachine = require('time-machine')
timemachine.setup({})

local glow = require('glow')
glow.setup{style = "dark"}

local blankline = require("ibl")
blankline.setup()

local hsearch = require("hlsearch")
hsearch.setup()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
lspconfig.ts_ls.setup{}
lspconfig.clangd.setup({
    cmd = {"clangd"},
    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
})
lspconfig.vimls.setup{}
lspconfig.gdscript.setup{}
lspconfig.cmake.setup{}
lspconfig.rust_analyzer.setup{}
 
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
	vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<Leader>td', vim.lsp.buf.type_definition, bufopts)
end

-- The bundle_path is where PowerShell Editor Services was installed
if vim.g.SYSTEM == "windows" then
    local bundle_path = vim.g.PWSHLSPATH
    
     lspconfig.powershell_es.setup {
      on_attach = on_attach,
      cmd = {
        vim.g.PWSHPATH,
        '-NoLogo',
        '-NoProfile',
        '-Command',
        string.format(
          '%s/Start-EditorServices.ps1 -BundledModulesPath %s/Modules -LogPath %s/logs/log.txt -SessionDetailsPath %s/session.json -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio',
          bundle_path, bundle_path, bundle_path, bundle_path
        )
      },
      root_dir = function(fname)
        -- Use the directory of the file for single-file mode
        return lspconfig.util.root_pattern('.git')(fname) or lspconfig.util.path.dirname(fname)
      end,
      filetypes = { 'ps1', 'psm1', 'psd1' }
    }
end
 
local trouble = require('trouble')
trouble.setup{
  position = "bottom",
  height = 10,
  icons = true,
  mode = "workspace_diagnostics",
  fold_open = "",
  fold_closed = "",
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = {"<cr>", "<tab>"},
  },
  use_diagnostic_signs = true
}

local surround = require('nvim-surround')
surround.setup{}

local move = require('move')
move.setup({
  char = {
      enable = true,
      } 
})

local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = {
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            if luasnip.expandable() then
                luasnip.expand()
            else
                cmp.confirm({
                    select = true,
                })
            end
        else
            fallback()
        end
    end),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer'},
  },
})

local runner = require('code_runner')
runner.setup({
  filetype = {
    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
    cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
    python = "python $fileName",
    go = "go run $fileName",
    rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
    sh = "bash $fileName",
    c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
    js = "node $fileName",
    ts = "node $fileName",
    php = "php $fileName",
    html = "start $fileName",
  }
})

local autopairs = require("nvim-autopairs")
autopairs.setup({
  check_ts = true,
})

local Rule = require("nvim-autopairs.rule")

-- Turn off double quote pairing in filetype=vim
autopairs.add_rule(Rule('"', '"', '-vim'))
autopairs.add_rule(Rule("'", "'", '-vim'))

local toggleterm = require('toggleterm')
toggleterm.setup({
    shell = vim.g.SHELL,
    size = 50,
    open_mapping = [[<C-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    direction = "float", -- Options: 'vertical', 'horizontal', 'float'
})

local db = require('dashboard')
db.setup({
  theme = 'doom',
  config = {
    header = {
      ' _   _      _ _           _____                 _            ',
      '| | | |    | | |         /  ___|               | |           ',
      '| |_| | ___| | | ___     \\ `--.  __ _ _ __ __ _| |__         ',
      '|  _  |/ _ \\ | |/ _ \\     `--. \\/ _` | \'__/ _` | \'_ \\        ',
      '| | | |  __/ | | (_) |   /\\__/ / (_| | | | (_| | | | |  _ _ _',
      '\\_| |_/\\___|_|_|\\___/    \\____/ \\__,_|_|  \\__,_|_| |_| (_|_|_)',
      '                                                      ',
      '',
    },
    center = {
      { icon = '  ', desc = 'File Browser        ', action = 'Oil --float', key = 'b' },
      { icon = '  ', desc = 'Find Files          ', action = 'Telescope find_files', key = 'f' },
      { icon = '  ', desc = 'Recent files        ', action = 'Telescope oldfiles', key = 'r' },
      { icon = '  ', desc = 'Projects            ', action = 'Telescope projects', key = 'a' },
      { icon = '  ', desc = 'New file            ', action = 'enew', key = 'n' },
      { icon = '  ', desc = 'Custom Shortcuts    ', action = 'ShowShortcuts', key = 's' },
      { icon = '  ', desc = 'ToggleTerm          ', action = 'ToggleTerm', key = 'o' },
      { icon = '  ', desc = 'Plugin Status       ', action = 'PlugStatus', key = 'p' },
      { icon = '  ', desc = 'Update Plugins      ', action = 'PlugUpdate', key = 'u' },
      { icon = '  ', desc = 'Reload Config       ', action = 'source $MYVIMRC', key = 'v' },
      { icon = '  ', desc = 'Change Theme        ', action = 'Themify', key = 't' },
      { icon = '  ', desc = 'Settings            ', action = 'edit $MYVIMRC', key = 'c' },
      { icon = '󱡝  ', desc = 'Quit                ', action = 'q', key = 'q' },
    },
    footer = { '✪ Neovim@SarahYack' },
  },

  packages = { enable = true }, 

  shortcut_type = 'letter',

  hide = { 
      statusline,
      tabline,
      winbar,
      },
  preview = { 
      command,
      file_path,
      file_height,
      file_width,
      },
})

local tabby = require('tabby')
tabby.setup{
  preset = 'active_wins_at_tail',
}

local lualine = require('lualine')
lualine.setup({
  options = {
      globalstatus = true,
  },
  sections = {
    lualine_a = {{'mode', separator = {left = ' ⏽', right = '󰿟'}}},
    lualine_b = {'branch'},
    lualine_c = {},
    lualine_x = {
        function ()
            return pomodoro.get_pomodoro_status(" ", " ", " ")
        end,
    },
    lualine_y = {{'fileformat', separator = {left = ""}}},
    lualine_z = {{'datetime', style = "%H:%M", separator = {left = ' ', right = ''}}}
  },
  winbar = {
      lualine_a = {{'lsp_status', separator = {left = '⏽', right = '󰿟'}}},
      lualine_b = {{'searchcount', separator = {left = '', right = '⏽'}}, {'selectioncount', separator = {left = '', right = '⏽'}}},
      lualine_c = {'diagnostics', 'diff'},
      lualine_x = {'filename', 'filesize', 'filetype'},
      lualine_y = {},
      lualine_z = {{'progress', separator = {left = '⏽', right = ''}}, {'location', separator = {left = '', right = '⏽'}}}
  },
})

local focus = require'focus'
focus.setup({
    autosize=true,
    width=120,
    height=40,
    minwidth=50,
    minheight=20,
})

local tint = require'tint'
tint.setup({
    tint = -60,
    saturation = 0.4,
})

local themify = require('themify')
themify.setup({
    -- For When Nothing Works
    'default',
    -- Night-Based Themes, Mostly Blue & Lower Saturation
    {'folke/tokyonight.nvim', blacklist = {'tokyonight-day'}},
    {'EdenEast/nightfox.nvim', blacklist = {'dawnfox', 'dayfox'}},
    'oxfist/night-owl.nvim',
    'kyazdani42/blue-moon',
    'rafamadriz/neon',
    {'yorik1984/newpaper.nvim',
        before = function(theme)
            require('newpaper').setup({
                style = 'dark',
                -- transparent = true,
            })
        end
    },
    'shaunsingh/nord.nvim',
    'AlexvZyl/nordic.nvim',
    'challenger-deep-theme/vim',
    {'sho-87/kanagawa-paper.nvim', blacklist = {'kanagawa-paper-canvas'}},
    -- Brown Themes
    'morhetz/gruvbox',
    'sainnhe/gruvbox-material',
    'mikesmithgh/gruvsquirrel.nvim',
    'savq/melange-nvim',
    'xero/miasma.nvim',
    'bakageddy/alduin.nvim',
    {'ribru17/bamboo.nvim', blacklist = {'bamboo-light'}},
    -- Softer Themes: Pastel-Based
    'Biscuit-Theme/nvim',
    'ilof2/posterpole.nvim',
    -- Softer Themes: Rose-Based
    'maxmx03/dracula.nvim',
    'LunarVim/horizon.nvim',
    'lancewilhelm/horizon-extended.nvim',
    'samharju/serene.nvim',
    'water-sucks/darkrose.nvim',
    'anAcc22/sakura.nvim',
    'DanielEliasib/sweet-fusion',
    'comfysage/cuddlefish.nvim',
    'egerhether/heatherfield.nvim',
    -- Softer Themes: Green-Based
    {'Allianaab2m/penumbra.nvim',
        before = function(theme)
            require('penumbra').setup({
                lualine_bg_color = '#3E4044',
                contrast = 'plus',
                italic_comment = true,
            })
        end
    },
    'sainnhe/everforest',
    'RomanAverin/charleston.nvim',
    {'everviolet/nvim', 
        blacklist = {'evergarden-summer'},
        before = function(theme)
            require('evergarden').setup({
                editor = {
                    transparent_background = true,
                    float = {
                        invert_border = true,
                    },
                },
            })
        end
    },
    -- Synthwave Themes: Higher Saturation
    'https://codeberg.org/jthvai/lavender.nvim',
    'b0o/lavi.nvim',
    'ray-x/aurora',
    {'barrientosvctor/abyss.nvim',
        before = function(theme)
            require('abyss').setup({
                italic = true,
                bold = true,
                -- transparent = true,
            })
        end
    },
    'maxmx03/fluoromachine.nvim',
    'samharju/synthweave.nvim',
    -- Solarized Themes
    'svrana/neosolarized.nvim',
    'Badacadabra/vim-archery',
    -- Transparent-First Themes
    'paulo-granthon/hyper.nvim',
    'thedenisnikulin/vim-cyberpunk',
    {'mrjones2014/lighthaus.nvim',
        before = function(theme)
            require('lighthaus').setup({
                italic_comments = true,
                italic_keywords = true,
            })
        end
    },
    'dasupradyumna/midnight.nvim',
    '2nthony/vitesse.nvim',
    {'fynnfluegge/monet.nvim',
        before = function(theme)
            require('monet').setup({
                transparent_background = true,
                italic_comments = true,
                borderless_pickers = true
            })
        end
    },
    'luisiacc/the-matrix.nvim',
    'forest-nvim/sequoia.nvim',
    '2giosangmitom/nightfall.nvim',
    {'scottmckendry/cyberdream.nvim',
        blacklist = {'cyberdream-light'},
        before = function(theme)
            require('cyberdream').setup({
                transparent = true,
                italic_comments = true,
                borderless_pickers = true
            })
        end
    },
    -- Paper-Like Glowy Themes: Super Low Saturation
    'killitar/obscure.nvim',
    'DeviusVim/deviuspro.nvim',
    {'darkvoid-theme/darkvoid.nvim',
        before = function(theme)
            require('darkvoid').setup({
                glow = true,
            })
        end    
    },
    'wnkz/monoglow.nvim',
    'slugbyte/lackluster.nvim',
    {'zenbones-theme/zenbones.nvim', blacklist = {'vimbones', 'randombones'}},
    'ntk148v/komau.vim',
    'drewxs/ash.nvim',
    'bettervim/yugen.nvim',
    async = true,
    activity = true,
})


function ToggleTransparency(value)
    vim.g.neovide_transparency = value
end

vim.cmd([[ command! -nargs=1 SetTransparency lua ToggleTransparency(<args>) ]])

vim.keymap.set('n', '<leader>o1', function() ToggleTransparency(0.0) end, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>o2', function() ToggleTransparency(0.2) end, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>o3', function() ToggleTransparency(0.4) end, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>o4', function() ToggleTransparency(0.6) end, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>o5', function() ToggleTransparency(0.8) end, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>o6', function() ToggleTransparency(1.0) end, {noremap = true, silent = true})

function GoToSection(section)
    vim.cmd('normal! gg')
    vim.fn.search(section)
end

-- Shows All Custom Keyboard Shortcuts in a floating window
function ShowShortcuts()
  local buf = vim.api.nvim_create_buf(false, true)
  
  local shortcuts = {
    "Custom Keybindings:",
    "--------------------",
    "",
    "Table of Contents",
    "--------------------",
    "1. Window/Split Management",
    "2. Editing",
    "3. Bookmarks",
    "4. Overseer",
    "5. Quit/Save",
    "6. Config/Commands",
    "7. File Management",
    "8. Tabs",
    "9. Buffers",
    "10. Modes/Settings Toggles",
    "11. Plugins",
    "12. Errors",
    "13. Git",
    "14. Fuzzy Finder/Search",
    "15. Theme and Appearance",
    "16. File Explorer",
    "17. NvimTree",
    "18. Shortcut Help (This Window)",
    "",
    "-- Window/Split Management",
    "--------------------",
    "<Leader>v   - Vertical Split",
    "<Leader>z   - Horizontal Split",
    "<A-H>       - Move Split Left",
    "<A-J>       - Move Split Down",
    "<A-K>       - Move Split Up",
    "<A-L>       - Move Split Right",
    "<C-h>       - Move to Left Split",
    "<C-j>       - Move to Lower Split",
    "<C-k>       - Move to Upper Split",
    "<C-l>       - Move to Right Split",
    "<C-\\>       - Toggle Terminal",
    "",
    "-- Editing",
    "--------------------",
    "<C-a>       - Copy All",
    "<Leader>u   - Time Machine",
    "<Leader>ae  - Add Empty Line Below",
    "<Leader>aE  - Add Empty Line Above",
    "<Leader>aw  - Add Empty Line Above and Below",
    "<Leader>at  - Add Indented Line Below",
    "<Leader>aT  - Add Indented Line Above",
    "<Leader>ap  - Add Paste on Indented Line Below",
    "<Leader>aP  - Add Paste on Indented Line Above",
    "<Leader>ac  - Add Comment on Indented Line Below",
    "<Leader>aC  - Add Comment on Indented Line Above",
    "<Leader>asa - Add Space After",
    "<Leader>asb - Add Space Before",
    "<Leader>du  - Duplicate Line Up",
    "<Leader>dd  - Duplicate Line Down",
    "<Leader>dw  - Duplicate Line Up and Down",
    "<A-j|k>     - Move Line Up or Down",
    "<A-h|l>     - Move Char Left or Right",
    "<Leader>ew  - Move Word Forward",
    "<Leader>eb  - Move Word Backward",
    "<A-h|l>     - Move Block Left or Right (Visual Mode)",
    "<A-j|k>     - Move Block Up or Down (Visual Mode)",
    "<Leader>rle - Replace Line Endings - LF",
    "<Leader>ys  - Add Surrounding",
    "<Leader>ds  - Delete Surrounding",
    "<Leader>cs  - Change Surrounding", 
    "",
    "-- Bookmarks",
    "--------------------",
    "<Leader>lt  - Bookmark Current Line",
    "<Leader>li  - Bookmark and Annotate Current Line",
    "<Leader>ln  - Next Bookmark",
    "<Leader>lp  - Previous Bookmark",
    "<Leader>la  - List All Bookmarks",
    "<Leader>lb  - List All Bookmarks in Current Buffer",
    "<Leader>lc  - Clear All Bookmarks in Current Buffer",
    "<Leader>lx  - Clear All Bookmarks in All Buffers",
    "<Leader>lu  - Bookmark Move Up",
    "<Leader>ld  - Bookmark Move Down",
    "<Leader>lm  - Bookmark Move to Specific Line",
    "",
    "-- Overseer",
    "--------------------",
    "<Leader>D   - Open Dashboard",
    ",s          - Start Pomodoro",
    ",q          - Stop Pomodoro",
    ",t          - Pomodoro UI",
    ",d          - Delay Pomodoro Break",
    ",f          - Force Default Break",
    ",b          - Break Pomodoro (args: break duration)",
    ",k          - Skip Pomodoro Break",
    "",
    "-- Quit/Save",
    "--------------------",
    "<Leader>q   - Save and Quit",
    "<Leader>Q   - Save and Quit All",
    "<Leader>qnw - Save and Quit Without Saving",
    "<Leader>Qnw - Save and Quit All Without Saving",
    "<Leader>qf  - Force Quit",
    "<Leader>Qf  - Force Quit All",
    "<Leader>qh  - Close Left Split",
    "<Leader>ql  - Close Right Split",
    "<Leader>qk  - Close Upper Split",
    "<Leader>qj  - Close Lower Split",
    "",
    "-- Config/Commands",
    "--------------------",
    "<Leader>cR  - Reload Current Config",
    "<Leader>ce  - Edit Config",
    "<Leader>cc  - Set CWD to File",
    "<Leader>cl  - Set LWD to File",
    "<Leader>ch  - Checkhealth",
    "<Leader>cp  - Checkhealth <Plugin>",
    "",
    "-- File Management",
    "--------------------",
    "<Leader>w   - Save",
    "<Leader>W  - Save All Buffers",
    "<Leader>e   - Open File",
    "<A-t>       - Open TODO Quickfix",
    "<A-T>       - Open TODO Location List",
    "<Leader>t   - Open TODO Telescope",
    "<Leader>rr  - Run Code",
    "<Leader>rf  - Run File in Terminal",
    "<Leader>rt  - Run File in New Tab",
    "<Leader>rp  - Run Project in New Tab",
    "<Leader>rc  - Close Runner",
    "",
    "-- Tabs",
    "--------------------",
    "tl  - Tabby Picker",
    "tn  - Next Tab",
    "tp  - Previous Tab",
    "to  - Open New Tab",
    "tc  - Close Current Tab",
    "tj  - Jump to Specific Tab",
    "tr  - Rename Tab",
    "",
    "-- Buffers",
    "--------------------",
    "<Leader>bm  - Toggle Arena",
    "<Leader>bb  - List Buffers", 
    "<Leader>bo  - Open New Buffer",
    "<Leader>bn  - Next Buffer",
    "<Leader>bp  - Previous Buffer",
    "<Leader>bs  - Switch to Specific Buffer",
    "<Leader>bd  - Delete Buffer",
    "<Leader>bl  - Close Current Buffer, Open Previous",
    "<Leader>bc  - Close All Buffers Except Current",
    "",
    "-- Modes/Settings Toggles",
    "--------------------",
    "<Leader>ml   - Toggle Relative Numbers",
    "<Leader>mu   - Change Line Ending Format - LF",
    "<Leader>mw   - Change Line Ending Format - CRLF",
    "<Leader>ms   - Toggle Spell Check",
    "<Leader>mc   - Set Column Limit",
    "<Leader>f    - Focus Toggle",
    "<Leader>fe   - Focus Equalize",
    "<Leader>mp   - Glow (Current File)",
    "<Leader>mps  - Glow (Specific)",
    "",
    "-- Plugin Management",
    "--------------------",
    "<Leader>pi  - PlugInstall",
    "<Leader>pu  - PlugUpdate",
    "<Leader>pc  - PlugClean",
    "<Leader>ps  - PlugStatus",
    "",
    "-- Errors",
    "--------------------",
    "<Leader>le  - Copy Last Error Message",
    "<Leader>en  - Next Error",
    "<Leader>ep  - Previous Error",
    "<Leader>el  - Set Error List",
    "<Leader>eq  - Set Quickfix List",
    "<Leader>et  - Toggle Error List",
    "<Leader>xw  - Toggle Workspace Diagnostics",
    "<Leader>xd  - Toggle Document Diagnostics",
    "<Leader>xq  - Toggle Quickfix List",
    "",
    "-- Git",
    "--------------------",
    "<Leader>gl  - Search Git Files",
    "<Leader>gc  - Search Git Commits",
    "<Leader>gbc - Search Git Buffer Commits",
    "<Leader>gbr - Search Git Buffer Commits Range",
    "<Leader>gb  - Search Git Branches",
    "<Leader>gs  - Show Git Status",
    "<Leader>gst - Show Git Stash",
    "<Leader>gh  - GitSigns Stage Hunk",
    "<Leader>gu  - GitSigns Undo Stage Hunk",
    "<Leader>gp  - GitSigns Preview Hunk",
    "",
    "-- Fuzzy Finder/Search",
    "--------------------",
    "<Leader>sf  - Find Files",
    "<Leader>sh  - Recent Files",
    "<Leader>sg  - Live Grep",
    "<Leader>ssg - Word Search (Selection|Cursor)",
    "<Leader>sb  - Buffers",
    "<Leader>sth - Help Tags",
    "<Leader>st  - Tags",
    "<Leader>sc  - Commands",
    "<Leader>sch - Command History",
    "<Leader>ssh - Search History",
    "<Leader>sm  - Marks",
    "<Leader>sma - All Marks",
    "<Leader>sk  - Keymaps",
    "<Leader>sv  - Vim Options",
    "<Leader>sn  - Man Pages",
    "<Leader>sr  - Registers",
    "<Leader>sac - Autocommands",
    "<Leader>ssb - Current Buffer Fuzzy Find",
    "<Leader>ssw - Current Buffer Tags",
    "<Leader>str - Resume Last Picker",
    "<Leader>sp  - Projects",
    "<Leader>stp - Pickers",
    "",
    "-- Theme and Appearance",
    "--------------------",
    "<Leader>cs  - Open Themify",
    "<Leader>o1  - Set Transparency to 0.0",
    "<Leader>o2  - Set Transparency to 0.2",
    "<Leader>o3  - Set Transparency to 0.4",
    "<Leader>o4  - Set Transparency to 0.6",
    "<Leader>o5  - Set Transparency to 0.8",
    "<Leader>o6  - Set Transparency to 1.0",
    "",
    "-- File Explorer",
    "--------------------",
    "-           - Toggle Mini-Files",
    "=           - Toggle Oil",
    "<Leader>-   - Toggle Telescope Outline",
    "<Leader>=   - Toggle Vifm",
    "<Leader>pwd - Print CWD",
    "<Leader>cd  - Set CWD",
    "<Leader>ld  - Set LWD",
    "",
    "-- FB Help",
    "--------------------",
    "g?          - View Mappings",
    "",
    "-- Shortcut Help (This Window)",
    "--------------------",
    "<Leader>ks  - Show Shortcut Help (this window)",
    "<C-d>       - Scroll Down 5 (this window)",
    "<C-u>       - Scroll Up 5 (this window)"
  }
    
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, shortcuts)

  local width = math.floor(vim.o.columns * 0.5)
  local height = 15
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    style = "minimal",
    border = "rounded"
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.keymap.set('n', 'q', '<cmd>bd!<CR>', { noremap = true, silent = true, buffer = buf, desc = "Close Shortcut Window" })

  vim.keymap.set('n', '<C-d>', '5<C-e>', { noremap = true, silent = true, buffer = buf, desc = "Scroll Down" })
  vim.keymap.set('n', '<C-u>', '5<C-y>', { noremap = true, silent = true, buffer = buf, desc = "Scroll Up" })

  vim.api.nvim_buf_set_keymap(buf, 'n', '0', ':lua GoToSection("Table of Contents")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '1', ':lua GoToSection("-- Window/Split Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '2', ':lua GoToSection("-- Editing")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '3', ':lua GoToSection("-- Bookmarks")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '4', ':lua GoToSection("-- Overseer")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '5', ':lua GoToSection("-- Quit/Save")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '6', ':lua GoToSection("-- Config/Commands")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '7', ':lua GoToSection("-- File Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '8', ':lua GoToSection("-- Tabs")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '9', ':lua GoToSection("-- Buffers")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '10', ':lua GoToSection("-- Modes/Settings Toggles")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '11', ':lua GoToSection("-- Plugin Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '12', ':lua GoToSection("-- Errors")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '13', ':lua GoToSection("-- Git")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '14', ':lua GoToSection("-- Fuzzy Finder/Search")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '15', ':lua GoToSection("-- Theme and Appearance")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '16', ':lua GoToSection("-- File Explorer")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '17', ':lua GoToSection("-- FB Help")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '18', ':lua GoToSection("-- Shortcut Help (This Window)")<CR>', { noremap = true, silent = true })
end

vim.keymap.set('n', '<leader>ks', ShowShortcuts, { noremap = true, silent = true, desc = "Show Shortcut Help" })
vim.api.nvim_create_user_command('ShowShortcuts', ShowShortcuts, {})

EOF

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --no-heading --color=never -- '.shellescape(<q-args>).' | awk "!seen[$0]++"', 1,
  \   fzf#vim#with_preview(), <bang>0)

command! SetCWDToFile execute 'cd %:p:h'
command! SetLWDToFile execute 'lcd %:p:h'
 
 
function! ShowBookmarksInBuffer()
    let signs = sign_getplaced(bufnr('%'), {'group': ''})[0].signs

    if empty(signs)
        echo "No bookmarks in this buffer."
        return
    endif

    let qflist = []
    for sign in signs
        if sign.name == 'Bookmark'
            let line_content = getline(sign.lnum)
            call add(qflist, {'lnum': sign.lnum, 'text': line_content, 'bufnr': bufnr('%')})
        endif
    endfor
    call setqflist(qflist, 'r')
    copen
    nnoremap <buffer> <CR> <CR>:cclose<CR>
endfunction


" Key Remappings

" Window/Split Management
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>z :split<CR>
nnoremap <A-H> <C-W>H
nnoremap <A-J> <C-W>J
nnoremap <A-K> <C-W>K
nnoremap <A-L> <C-W>L
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Editing
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap $ g$
nnoremap ^ g^
nnoremap g$ $
nnoremap g^ ^
nnoremap Y y$
nnoremap yc vy
nnoremap <C-a> ggvG$y
nnoremap <leader>u :TimeMachineToggle<CR>
nnoremap <leader>ae o<ESC>k
nnoremap <leader>aE O<ESC>j
nnoremap <leader>aw o<ESC>kO<ESC>j
nnoremap <leader>at o<Space><ESC>
nnoremap <leader>aT O<Space><ESC>
nnoremap <leader>ap o<Space><ESC>hp
nnoremap <leader>aP O<Space><ESC>hp
nnoremap <leader>ac o//<Space>
nnoremap <leader>aC O//<Space>
nnoremap <leader>asa a<Space><ESC>h
nnoremap <leader>asb i<Space><ESC>l
nnoremap <leader>du yyP
nnoremap <leader>dd yyp
nnoremap <leader>dw yyPjp
nnoremap <A-j> :MoveLine(1)<CR>
nnoremap <A-k> :MoveLine(-1)<CR>
nnoremap <A-h> :MoveHChar(-1)<CR>
nnoremap <A-l> :MoveHChar(1)<CR>
nnoremap <leader>ew :MoveWord(1)<CR>
nnoremap <leader>eb :MoveWord(-1)<CR>
vnoremap <A-h> :MoveHBlock(-1)<CR>
vnoremap <A-j> :MoveBlock(1)<CR>
vnoremap <A-k> :MoveBlock(-1)<CR>
vnoremap <A-l> :MoveHBlock(1)<CR>
nnoremap <leader>rle :%s/\r//g<CR>

" Bookmarks 
nnoremap <leader>lt :BookmarkToggle<CR>
nnoremap <leader>li :BookmarkAnnotate<CR>
nnoremap <leader>ln :BookmarkNext<CR>
nnoremap <leader>lp :BookmarkPrev<CR>
nnoremap <leader>la :BookmarkShowAll<CR>
nnoremap <leader>lb :call ShowBookmarksInBuffer()<CR>
nnoremap <leader>lc :BookmarkClear<CR>
nnoremap <leader>lx :BookmarkClearAll<CR>
nnoremap <leader>lu :BookmarkMoveUp<CR>
nnoremap <leader>ld :BookmarkMoveDown<CR>
nnoremap <leader>lm :BookmarkMoveToLine<Space>

" Overseer
nnoremap <leader>D :Dashboard<CR>
nnoremap ,s :PomodoroStart<CR>
nnoremap ,q :PomodoroStop<CR>
nnoremap ,t :PomodoroUI<CR>
nnoremap ,d :PomodoroDelayBreak<CR>
nnoremap ,f :PomodoroForceBreak<CR>
nnoremap ,b :PomodoroForceBreak<Space>
nnoremap ,k :PomodoroSkipBreak<CR>

" Quit/Save
nnoremap <leader>q :wq<CR>
nnoremap <leader>Q :wqa<CR>
nnoremap <leader>qnw :q<CR>
nnoremap <leader>Qnw :qa<CR>
nnoremap <leader>qf :q!<CR>
nnoremap <leader>Qf :qa!<CR>
nnoremap <leader>qh <C-w>h:q<CR>
nnoremap <leader>ql <C-w>l:q<CR>
nnoremap <leader>qk <C-w>k:q<CR>
nnoremap <leader>qj <C-w>j:q<CR>

" Config/Commands
nnoremap <leader>cR :source $MYVIMRC<CR>
nnoremap <leader>ce :e $MYVIMRC<CR>
nnoremap <leader>cc :SetCWDToFile<CR>
nnoremap <leader>cl :SetLWDToFile<CR>
nnoremap <leader>ch :checkhealth<CR>
nnoremap <leader>cp :checkhealth<Space>

" File Management
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wa<CR>
nnoremap <leader>e :e<Space>
nnoremap <A-t> :TodoQuickFix<CR>
nnoremap <A-T> :TodoLocList<CR>
nnoremap <leader>t :TodoTelescope<CR>
nnoremap <leader>rr :RunCode<CR>
nnoremap <leader>rf :RunFile toggleterm<CR>
nnoremap <leader>rt :RunFile tab<CR>
nnoremap <leader>rp :RunProject tab<CR>
nnoremap <leader>rc :RunClose<CR>

" Tabs
nnoremap tl :Tabby pick_window<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>
nnoremap to :tabnew<CR>
nnoremap tc :tabclose<CR>
nnoremap tj :Tabby jump_to_tab<CR>
nnoremap tr :Tabby rename_tab<Space>

" Buffers
nnoremap <leader>bm :ArenaToggle<CR>
nnoremap <leader>bb :ls<CR>
nnoremap <leader>be :enew<CR>
nnoremap <leader>bo :e<Space>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bs :b<Space>
nnoremap <leader>bd :bd!<CR>
nnoremap <leader>bl :bprev \| if buflisted(bufnr('#')) \| bdelete # \| endif<CR>
nnoremap <leader>bc :%bd\|e#<CR>

" Modes/Settings Toggles
nnoremap <leader>ml :set relativenumber!<CR>
nnoremap <leader>mu :set fileformat=unix<CR>
nnoremap <leader>mw :set fileformat=dos<CR>
nnoremap <leader>mc :if &colorcolumn == '80' \| set colorcolumn= \| else \| set colorcolumn=80 \| endif<CR>
nnoremap <leader>ms :set spell!<CR>
nnoremap <leader>f :FocusToggle<CR>
nnoremap <leader>fe :FocusEqualise<CR>
nnoremap <leader>mp :Glow<CR>
nnoremap <leader>mps :Glow<Space>

" Plugin Management
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>ps :PlugStatus<CR>

" Errors
nnoremap <leader>le :let @* = execute('echo v:errmsg')<CR>
nnoremap <leader>en :lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>ep :lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>el :lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>eq :lua vim.diagnostic.setqflist()<CR>
nnoremap <leader>et :TroubleToggle<CR>
nnoremap <leader>xw :TroubleToggle workspace_diagnostics<CR>
nnoremap <leader>xd :TroubleToggle document_diagnostics<CR>
nnoremap <leader>xq :TroubleToggle quickfix<CR>
nnoremap gR :TroubleToggle lsp_references<CR>

" Git
nnoremap <leader>gl :Telescope git_files<CR>
nnoremap <leader>gc :Telescope git_commits<CR>
nnoremap <leader>gbc :Telescope git_bcommits<CR>
nnoremap <leader>gbr :Telescope git_bcommits_range<CR>
nnoremap <leader>gb :Telescope git_branches<CR>
nnoremap <leader>gs :Telescope git_status<CR>
nnoremap <leader>gst :Telescope git_stash<CR>
nnoremap <leader>gh :GitSigns stage_hunk<CR>
nnoremap <leader>gu :GitSigns undo_stage_hunk<CR>
nnoremap <leader>gp :GitSigns preview_hunk<CR>

" Fuzzy Finder/Search
nnoremap <leader>sf :Telescope find_files<CR>
nnoremap <leader>sh :Telescope oldfiles<CR>
nnoremap <leader>sg :Telescope live_grep<CR>
nnoremap <leader>ssg :Telescope grep_string<CR>
nnoremap <leader>sb :Telescope buffers<CR>
nnoremap <leader>sth :Telescope help_tags<CR>
nnoremap <leader>st :Telescope tags<CR>
nnoremap <leader>sc :Telescope commands<CR>
nnoremap <leader>sch :Telescope command_history<CR>
nnoremap <leader>ssh :Telescope search_history<CR>
nnoremap <leader>sm :Telescope vim_bookmarks current_file<CR>
nnoremap <leader>sma :Telescope vim_bookmarks all<CR>
nnoremap <leader>sk :Telescope keymaps<CR>
nnoremap <leader>sv :Telescope vim_options<CR>
nnoremap <leader>sn :Telescope man_pages<CR>
nnoremap <leader>sr :Telescope registers<CR>
nnoremap <leader>sac :Telescope autocommands<CR>
nnoremap <leader>ssb :Telescope current_buffer_fuzzy_find<CR>
nnoremap <leader>ssw :Telescope current_buffer_tags<CR>
nnoremap <leader>str :Telescope resume<CR>
nnoremap <leader>sp :Telescope projects<CR>
nnoremap <leader>stp :Telescope pickers<CR>

" Theme and Appearance
nnoremap <leader>cs :Themify<CR>

" File Explorer
nnoremap - :lua MiniFiles.open()<CR>
nnoremap = :Oil --float<CR>
nnoremap <leader>= :Vifm<CR>
nnoremap <leader>- :Telescope lsp_document_symbols<CR>
nnoremap <leader>pwd :pwd<CR>
nnoremap <leader>cd :cd<Space>
nnoremap <leader>lcd :lcd<Space>

" Theme Settings

highlight Comment cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Function cterm=italic gui=italic
highlight Type cterm=italic gui=italic

