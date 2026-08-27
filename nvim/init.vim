" Determine Platform

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
    let g:PLUGDIR = "C:/Users/Sarah/AppData/Local/nvim/plugged"
    let g:PWSHLSPATH = "C:/05_Support/powershell/PowerShellEditorServices/PowerShellEditorServices"
    let g:PWSHPATH = "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    let g:WORKDIR = "D:/"
    let g:SHELL = "powershell"
elseif IsLinux()
    let g:SYSTEM = "linux"
    let g:HOME = "/home/sarah"
    let g:UNDODIR = "/home/sarah/.local/share/nvim/undo"
    let g:PLUGDIR = "/home/sarah/.local/share/nvim/site/plug"
    let g:WORKDIR = "/mnt/hive"
endif

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Set Settings
syntax on
set number
set relativenumber
set cursorline
set nowrap
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
let &undodir=g:UNDODIR
filetype plugin indent on
set clipboard=unnamedplus
filetype plugin on
set completeopt=menu
set splitright
set splitbelow
set termguicolors
set background=dark

" Set Neovide Setings
if empty(argv()) && fnamemodify(getcwd(), ':p') == fnamemodify(expand('~'), ':p')
    augroup WorkDriveOnHome
        autocmd!
        autocmd VimEnter * ++once silent! exec 'cd' fnameescape(g:WORKDIR)
    augroup END
endif 

set autoread
augroup AutoRead
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !=# 'c' | checktime | endif
  autocmd FileChangedShellPost * echo "File changed on disk. Buffer reloaded."
augroup END

if exists("g:neovide")
    set guifont=Terminess\ Nerd\ Font:h13
    let g:neovide_font_ligatures=1
    let g:neovide_hide_mouse_when_typing=v:true
    let g:neovide_cursor_vfx_mode=""
    let g:neovide_cursor_trail_size=0.9
    let g:neovide_cursor_vfx_opacity=100.0
    let g:neovide_cursor_vfx_particle_lifetime=0.3
    let g:neovide_cursor_vfx_particle_density=2.0
    let g:neovide_padding_top=10
    let g:neovide_padding_left=10
    let g:neovide_padding_bottom=5
    let g:neovide_fullscreen=v:true
endif

" Load/Install Plugins
call plug#begin(g:PLUGDIR) 
" DEPENDENCIES
Plug 'nvim-lua/plenary.nvim'
Plug 'kevinhwang91/promise-async'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'nvzone/volt'
Plug '2kabhishek/pickme.nvim'

" MISC
Plug 'lowitea/aw-watcher.nvim'
Plug 'y3owk1n/time-machine.nvim'
Plug 'tpope/vim-scriptease'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'jim-fx/sudoku.nvim'
Plug 'mikesmithgh/kitty-scrollback.nvim'
Plug 'its-izhar/kitty-navigator.nvim', { 'do': 'cp ./kitty/*.py ~/.config/kitty/' }
Plug 'gnsfujiwara/suda.nvim'

" Exercism
Plug '2kabhishek/utils.nvim'
Plug '2KAbhishek/exercism.nvim'

" UI
Plug 'karb94/neoscroll.nvim'
Plug 'nvimdev/dashboard-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'OXY2DEV/markview.nvim'
Plug 'toppair/peek.nvim', { 'do': 'deno task --quiet build:fast' }
Plug 'nanozuki/tabby.nvim'
Plug 'levouh/tint.nvim'
Plug 'beauwilliams/focus.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvimdev/hlsearch.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'echasnovski/mini.icons', {'branch': 'stable'}
Plug 'rktjmp/lush.nvim'
Plug '2kabhishek/nerdy.nvim'
Plug 'nacro90/numb.nvim'
Plug 'SmiteshP/nvim-navic'
Plug 'MunifTanjim/nui.nvim'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'nvim-telekasten/calendar-vim'

" SWITCHERS
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'doctorfree/cheatsheet.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'lewis6991/gitsigns.nvim'
Plug 'hasansujon786/nvim-navbuddy'

" FILES
" Plug 'sarahyack/telekasten.nvim', {'branch': 'refact'}
" Plug 'file:///mnt/hive/Work/dev/telekasten.nvim', { 'branch': 'main'}
Plug '/mnt/hive/Work/dev/telekasten.nvim'
Plug 'echasnovski/mini.files', {'branch': 'stable'}
Plug 'stevearc/oil.nvim'
Plug 'refractalize/oil-git-status.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'dzfrias/arena.nvim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'nvim-telescope/telescope-bibtex.nvim'

" EDITING
Plug 'chentoast/marks.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'kevinhwang91/nvim-ufo'
Plug 'chrisgrieser/nvim-origami', {'tag': 'v1.9'}
Plug 'tpope/vim-commentary'
Plug 'kylechui/nvim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'fedepujol/move.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'folke/todo-comments.nvim'
Plug 'ysmb-wtsg/in-and-out.nvim'
Plug 'sahilsehwag/macrobank.nvim'
Plug 'RutaTang/quicknote.nvim'
Plug 'walkersumida/fusen.nvim'

" THEMES
Plug 'LmanTW/themify.nvim'

call plug#end()

" Plugin Setup

lua << EOF

local suda = require('suda')
suda.setup({
    smart_edit = true,
})

local kittyscroll = require('kitty-scrollback')
kittyscroll.setup()

local kittynav = require('kitty_navigator')
kittynav.setup({
    set_keymaps = false,
    to_socket_str = "unix:/tmp/kitty",
    keymaps = {
        left = "<C-`>h",
        down = "<C-`>j",
        up = "<C-`>k",
        right = "<C-`>l",
    },
})

vim.o.statuscolumn = "%s %C | %{v:lnum} %{v:relnum} "

local numb = require('numb')
numb.setup()

local neoscroll = require('neoscroll')
neoscroll.setup({
    easing = "sine",
})

local peek = require('peek')
peek.setup()

vim.api.nvim_create_user_command("PeekOpen", function()
    peek.open()
end, { desc = "Open Peek Markdown Preview"})

vim.api.nvim_create_user_command("PeekClose", function()
    peek.close()
end, { desc = "Close Peek Markdown Preview"})

local sckeys = {
    ["HH"] = function() vim.cmd("normal! H") neoscroll.zz({half_win_duration = 250}) end;
    ["HL"] = function() vim.cmd("normal! H") neoscroll.zb({half_win_duration = 250}) end;
    ["LL"] = function() vim.cmd("normal! L") neoscroll.zz({half_win_duration = 250}) end;
    ["LH"] = function() vim.cmd("normal! L") neoscroll.zt({half_win_duration = 250}) end;
}
local scmodes = { 'n', 'v', 'x' }
for key, func in pairs(sckeys) do
    vim.keymap.set(scmodes, key, func)
end

-- local tkasten = require('telekasten')
-- tkasten.setup({
--     home = vim.fs.joinpath(vim.env.VAULTS, "/Beehive"),
--     templates = "admin/templates",
--     template_new_note = "inbox-todos-template.md",
--     periodic = {
--         root = "periodic",
--         kinds = {
--             yearly = {
--                 enabled = true,
--                 folder_path = "{year}",
--                 filename = "{year}",
--                 create_if_missing = true,
--             },
--             quarterly = {
--                 enabled = true,
--                 folder_path = "{year}/{quarter_yq}",
--                 filename = "{quarter_yq}",
--                 create_if_missing = true,
--             },
--             monthly = {
--                 enabled = true,
--                 folder_path = "{year}/{quarter_yq}/{month_ym}",
--                 filename = "{month_ym}",
--                 template_file = "monthly-template.md",
--                 create_if_missing = true,
--             },
--             weekly = {
--                 enabled = true,
--                 folder_path = "{year}/{quarter_yq}/{month_ym}/{isoweek}",
--                 filename = "{isoweek}",
--                 template_file = "weekly-template.md",
--                 create_if_missing = true,
--             },
--             daily = {
--                 enabled = true,
--                 folder_path = "{year}/{quarter_yq}/{month_ym}/{isoweek}",
--                 filename = "{date}",
--                 template_file = "daily-template.md",
--                 create_if_missing = true,
--             },
--         },
--     },
--     vaults = {
--         personal = {
--             home = vim.fs.joinpath(vim.env.VAULTS, "/Beehive"),
--             templates = "admin/templates",
--             template_new_note = "inbox-todos-template.md",
--             periodic = {
--                 root = "periodic",
--                 kinds = {
--                     yearly = {
--                         enabled = true,
--                         folder_path = "{year}",
--                         filename = "{year}",
--                         create_if_missing = true,
--                     },
--                     quarterly = {
--                         enabled = true,
--                         folder_path = "{year}/{quarter_yq}",
--                         filename = "{quarter_yq}",
--                         create_if_missing = true,
--                     },
--                     monthly = {
--                         enabled = true,
--                         folder_path = "{year}/{quarter_yq}/{month_ym}",
--                         filename = "{month_ym}",
--                         template_file = "monthly-template.md",
--                         create_if_missing = true,
--                     },
--                     weekly = {
--                         enabled = true,
--                         folder_path = "{year}/{quarter_yq}/{month_ym}/{isoweek}",
--                         filename = "{isoweek}",
--                         template_file = "weekly-template.md",
--                         create_if_missing = true,
--                     },
--                     daily = {
--                         enabled = true,
--                         folder_path = "{year}/{quarter_yq}/{month_ym}/{isoweek}",
--                         filename = "{date}",
--                         template_file = "daily-template.md",
--                         create_if_missing = true,
--                     },
--                 },
--             },
--         },
--         work = {
--             home = vim.fs.joinpath(vim.env.VAULTS, "/HoneyComb"),
--             templates = "admin/templates",
--             periodic = {},
--         },
--     },
-- })

local tkasten = require('telekasten')
tkasten.setup({
    default_vault = "testing",
    vaults = {
        personal = {
            home = vim.fs.joinpath(vim.env.VAULTS, "/Beehive")
        },
        work = {
            home = vim.fs.joinpath(vim.env.VAULTS, "/HoneyComb"),
            periodic = { enabled = false }
        },
        testing = {
            home = vim.fs.joinpath(vim.env.VAULTS, "/Telekasten"),
        },
    }
})

vim.keymap.set("n", "<M-2>", function()
    tkasten.goto_periodic(nil, "next_year")
end, { desc = "Telekasten: goto next year" })

local quicknote = require('quicknote')
quicknote.setup({
    mode = "resident",
    sign = "󰠮",
})

vim.api.nvim_create_user_command("NewQuickNote", function() quicknote.NewNoteAtCurrentLine() end, { desc = "Insert new Quicknote at Current Line" })
vim.api.nvim_create_user_command("ToggleNoteSigns", function() quicknote.ToggleNoteSigns() end, { desc = "Toggle Quicknote Gutter Signs" })
vim.api.nvim_create_user_command("OpenQuickNote", function() quicknote.OpenNoteAtCurrentLine() end, { desc = "Open Quicknote at Current Line" })
vim.api.nvim_create_user_command("DeleteQuickNote", function() quicknote.DeleteNoteAtCurrentLine() end, { desc = "Delete Quicknote at Current Line" })
vim.api.nvim_create_user_command("ListBufferQuickNotes", function() quicknote.ListNotesForCurrentBuffer() end, { desc = "List All Quicknotes for Current Buffer" })
vim.api.nvim_create_user_command("ListCWDQuickNotes", function() quicknote.ListNotesForCWD() end, { desc = "List All Quicknotes for CWD" })
vim.api.nvim_create_user_command("NextQuickNote", function() quicknote.JumpToNextNote() end, { desc = "Jump to next Quicknote Location" })
vim.api.nvim_create_user_command("PrevQuickNote", function() quicknote.JumpToPreviousNote() end, { desc = "Jump to previous Quicknote Location" })
vim.api.nvim_create_user_command("ToggleQuickNoteMode", function() quicknote.ToggleMode() end, { desc = "Toggle between Resident and Portable Quicknote Mode" })

local fusen = require('fusen')
fusen.setup({
    mark = {
        icon = "",
    },
    keymaps = {
        add_mark = "<Space>af",
        clear_mark = "<Space>cf",
        clear_buffer = "<Space>Cf",
        clear_all = "<Space>Df",
        next_mark = "<Space>nf",
        prev_mark = "<Space>pf",
        list_marks = "<Space>lf",
    },
    annotation_display = {
        mode = "eol",
    },
})

local minif = require('mini.files')
minif.setup()

local minic = require('mini.icons')
minic.setup()

local oil = require('oil')
oil.setup({
    columns = {
        "icon",
    },
    win_options = {
        signcolumn = "yes:2",
    },
    keymaps = {
        ['K'] = 'actions.parent',
        ['<A-r>'] = 'actions.refresh',
        ['<A-u>'] = 'actions.preview_scroll_up',
        ['<A-d>'] = 'actions.preview_scroll_down',
        ['q'] = 'actions.close',
    },
    float = {
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = 40,
    },
})

local oil_git = require('oil-git-status')
oil_git.setup()

local macrobank = require('macrobank')
macrobank.setup({
    project_store_paths = '.macrobank.json',
    default_select_register = 'a',
    default_play_register = 'a',
})

local arena = require('arena')
arena.setup()

local todo = require('todo-comments')
todo.setup()

local marks = require('marks')
marks.setup({
    default_mappings = true,
    builtin_marks = { "'", ".", "<", ">", "^" },
    mappings = {
        annotate = '+a',
    }
})

local ufo = require('ufo')
ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

local origami = require('origami')
origami.setup()

local sudoku = require('sudoku')
sudoku.setup({})

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
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
    ["frecency"] = { show_unindexed = false },
    ["fzf"] = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
    ["bibtex"] = {}
  }
}

telescope.load_extension('fzf')
telescope.load_extension('frecency')
telescope.load_extension('ui-select')
telescope.load_extension('projects')
telescope.load_extension('bibtex')
telescope.load_extension('media_files')

local exercism = require('exercism')
exercism.setup({
    default_language = 'rust',
    add_default_keybindings = false,
    max_recents = 15,
})

local timemachine = require('time-machine')
timemachine.setup({})

local blankline = require("ibl")
blankline.setup({
    exclude = {
        filetypes = { "dashboard" },
    }
})

local hsearch = require("hlsearch")
hsearch.setup()

local lspconfig = vim.lsp
lspconfig.enable('clangd')
lspconfig.enable('cmake')
lspconfig.enable('gdscript')
lspconfig.enable('pyright')
lspconfig.enable('rust_analyzer')
lspconfig.enable('ts_ls')
lspconfig.enable('vimls')
lspconfig.enable('lua_ls')
lspconfig.enable('stylua')
lspconfig.enable('marksman')
lspconfig.enable('bashls')
 
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

local navbuddy = require('nvim-navbuddy')
navbuddy.setup({
    lsp = {
        auto_attach = true,
    },
    source_buffer = {
        follow_node = false,
    },
})

local surround = require('nvim-surround')
surround.setup{}

-- Plugin "in & Out" surrounding jumping keymap
vim.keymap.set("i", "<C-CR>", function() require("in-and-out").in_and_out() end)

local move = require('move')
move.setup({
  char = {
      enable = true,
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
      '                                                             ',
      '                                                             ',
      ' _   _      _ _           _____                 _            ',
      '| | | |    | | |         /  ___|               | |           ',
      '| |_| | ___| | | ___     \\ `--.  __ _ _ __ __ _| |__         ',
      '|  _  |/ _ \\ | |/ _ \\     `--. \\/ _` | \'__/ _` | \'_ \\        ',
      '| | | |  __/ | | (_) |   /\\__/ / (_| | | | (_| | | | |  _ _ _',
      ' \\_| |_/\\___|_|_|\\___/    \\____/ \\__,_|_|  \\__,_|_| |_| (_|_|_)',
      '                                                      ',
      '',
    },
    center = {
      { icon = '  ', desc = 'File Browser        ', action = 'Oil --float', key = 'b' },
      { icon = '  ', desc = 'Find Files          ', action = 'Telescope find_files', key = 'f' },
      { icon = '  ', desc = 'Recent files        ', action = 'Telescope oldfiles', key = 'h' },
      { icon = '  ', desc = 'Projects            ', action = 'Telescope projects', key = 'a' },
      { icon = '  ', desc = 'New file            ', action = 'enew', key = 'n' },
      { icon = '  ', desc = 'Open Wiki List      ', action = 'Telekasten switch_vault', key = 'v' },
      { icon = '  ', desc = 'Open Exercism List  ', action = 'Exercism languages', key = 'e' },
      { icon = '  ', desc = 'Open Rust Exercises ', action = 'Exercism list', key = 'R' },
      { icon = '  ', desc = 'Custom Shortcuts    ', action = 'ShowShortcuts', key = 's' },
      { icon = '  ', desc = 'ToggleTerm          ', action = 'ToggleTerm', key = 'o' },
      { icon = '  ', desc = 'Plugin Status       ', action = 'PlugStatus', key = 'p' },
      { icon = '  ', desc = 'Update Plugins      ', action = 'PlugUpdate', key = 'u' },
      { icon = '  ', desc = 'Reload Config       ', action = 'source $MYVIMRC', key = 'r' },
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

local nerdy = require('nerdy')
nerdy.setup({
    max_recents = 15,
    add_default_keybindings = false,
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
    lualine_x = {},
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

local ignore_filetypes = { 'navbuddy', 'Navbuddy' }
local ignore_buftypes = { 'prompt', 'popup' }
local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        then
            vim.w.focus_disable = true
        else
            vim.w.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        else
            vim.b.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for FileType',
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
    {'folke/tokyonight.nvim', 
        blacklist = {'tokyonight-day'},
        before = function(theme)
            require('tokuonight').setup({
                transparent = true,
            })
        end
    },
    {'EdenEast/nightfox.nvim', 
        blacklist = {'dawnfox', 'dayfox'},
        before = function(theme)
            require('nightfox').setup({
                options = { transparent = true }
            })
        end
    },
    {'oxfist/night-owl.nvim',
        before = function(theme)
            require('night-owl').setup({
                transparent_background = true,
            })
        end
    },
    'kyazdani42/blue-moon',
    {'niyabits/calvera-dark.nvim',
        before = function(theme)
            vim.g.calvera_disable_background = true
        end
    },
    {'rafamadriz/neon',
        before = function(theme)
            vim.g.neon_transparent = true
        end
    },
    {'yorik1984/newpaper.nvim',
        before = function(theme)
            require('newpaper').setup({
                style = "dark",
                disable_background = true,
            })
        end
    },
    'shaunsingh/nord.nvim',
    'AlexvZyl/nordic.nvim',
    'challenger-deep-theme/vim',
    {'thesimonho/kanagawa-paper.nvim', 
        blacklist = {'kanagawa-paper-canvas'},
    },
    {'olivercederborg/poimandres.nvim',
        before = function(theme)
            require('poimandres').setup({
                disable_background = true,
            })
        end
    },
    -- Brown Themes
    'morhetz/gruvbox',
    'sainnhe/gruvbox-material',
    'mikesmithgh/gruvsquirrel.nvim',
    'luisiacc/gruvbox-baby',
    'savq/melange-nvim',
    'xero/miasma.nvim',
    'bakageddy/alduin.nvim',
    {'ribru17/bamboo.nvim', 
        blacklist = {'bamboo-light'},
        before = function(theme)
            require('bamboo').setup({
                transparent = true,
            })
        end
    },
    -- Softer Themes: Pastel-Based
    'Biscuit-Theme/nvim',
    {'ilof2/posterpole.nvim',
        before = function(theme)
            require('posterpole').setup({
                transparent = true,
            })
        end
    },
    {'mellow-theme/mellow.nvim',
        before = function(theme)
            vim.g.mellow_transparent = true
        end
    },
    -- Softer Themes: Rose-Based
    'FrenzyExists/aquarium-vim',
    'maxmx03/dracula.nvim',
    'LunarVim/horizon.nvim',
    {'lancewilhelm/horizon-extended.nvim',
        before = function(theme)
            require('horizon-extended').setup({
                transparent = true,
            })
        end
    },
    'samharju/serene.nvim',
    'water-sucks/darkrose.nvim',
    'anAcc22/sakura.nvim',
    {'DanielEliasib/sweet-fusion',
        before = function(theme)
            require('sweet-fusion').setup({
                transparency = true,
            })
        end
    },
    {'comfysage/cuddlefish.nvim',
        before = function(theme)
            require('cuddlefish').setup({
                editor = { transparent_background = true },
            })
        end
    },
    'egerhether/heatherfield.nvim',
    {'yazeed1s/oh-lucy.nvim',
        before = function(theme)
            vim.g.oh_lucy_transparent_background = true
        end
    },
    -- Softer Themes: Green-Based
    {'Allianaab2m/penumbra.nvim',
        before = function(theme)
            require('penumbra').setup({
                lualine_bg_color = '#3E4044',
                contrast = 'plus',
                italic_comment = true,
                transparent_bg = false,
            })
        end
    },
    {'sainnhe/everforest',
        before = function(theme)
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_ui_contrast = 'high'
        end
    },
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
    {'ray-x/aurora',
        before = function(theme)
            vim.g.aurora_transparent = 1
        end
    },
    {'barrientosvctor/abyss.nvim',
        before = function(theme)
            require('abyss').setup({
                italic = true,
                bold = true,
                transparent_background = true,
            })
        end
    },
    {'maxmx03/fluoromachine.nvim',
        before = function(theme)
            require('fluoromachine').setup({
                theme = 'delta', -- "retrowave", "fluoromachine", "delta"
                transparent = true,
            })
        end
    },
    'samharju/synthweave.nvim',
    {'zootedb0t/citruszest.nvim',
        before = function(theme)
            require('citruszest').setup({
                option = { transparent = true, }
            })
        end
    },
    -- Solarized Themes
    'svrana/neosolarized.nvim',
    {'diegoulloao/neofusion.nvim',
        before = function(theme)
            require('neofusion').setup({
                transparent_mode = true,
            })
        end
    },
    'Badacadabra/vim-archery',
    -- Transparent-First Themes
    'paulo-granthon/hyper.nvim',
    'thedenisnikulin/vim-cyberpunk',
    {'mrjones2014/lighthaus.nvim',
        before = function(theme)
            require('lighthaus').setup({
                bg_dark = true,
                transparent = true,
                italic_comments = true,
                italic_keywords = true,
            })
        end
    },
    'dasupradyumna/midnight.nvim',
    {'2nthony/vitesse.nvim',
        before = function(theme)
            require('vitesse').setup({
                transparent_background = true,
            })
        end
    },
    {'fynnfluegge/monet.nvim',
        before = function(theme)
            require('monet').setup({
                transparent_background = true,
                italic_comments = true,
                borderless_pickers = true
            })
        end
    },
    {'luisiacc/the-matrix.nvim',
        before = function(theme)
            vim.g.thematrix_transparent_mode = 1
        end
    },
    {'forest-nvim/sequoia.nvim',
        before = function(theme)
            require('sequoia').setup({
                styles = { transparency = true }
            })
        end
    },
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
    'ramojus/mellifluous.nvim',
    {'datsfilipe/vesper.nvim',
        before = function(theme)
            require('vesper').setup({
                transparent = true,
            })
        end
    },
    {'killitar/obscure.nvim',
        before = function(theme)
            require('obscure').setup({
                transparent = true,
            })
        end
    },
    'DeviusVim/deviuspro.nvim',
    {'darkvoid-theme/darkvoid.nvim',
        before = function(theme)
            require('darkvoid').setup({
                glow = true,
                transparent = true,
            })
        end    
    },
    {'wnkz/monoglow.nvim',
        before = function(theme)
            require('monoglow').setup({
                transparent = true,
            })
        end
    },
    {'slugbyte/lackluster.nvim',
        before = function(theme)
            require('lackluster').setup({
                tweak_background = {
                    normal = 'none',
                },
            })
        end
    },
    {'zenbones-theme/zenbones.nvim',
        blacklist = {'vimbones', 'randombones'},
        before = function(theme)
            vim.g.zenbones_transparent_background = true
            vim.g.duckbones_transparent_background = true
            vim.g.zenwritten_transparent_background = true
            vim.g.neobones_transparent_background = true
            vim.g.rosebones_transparent_background = true
            vim.g.forestbones_transparent_background = true
            vim.g.nordbones_transparent_background = true
            vim.g.tokyobones_transparent_background = true
            vim.g.seoulbones_transparent_background = true
            vim.g.zenburned_transparent_background = true
            vim.g.kanagawabones_transparent_background = true
        end
    },
    'ntk148v/komau.vim',
    {'drewxs/ash.nvim',
        before = function(theme)
            require('ash').setup({
                transparent = true,
            })
        end
    },
    {'bettervim/yugen.nvim',
        before = function(theme)
            require('yugen').setup({
                transparent = true,
                transparent_statusline = true,
            })
        end
    },
    async = true,
    activity = true,
})


function ToggleTransparency(value)
    vim.g.neovide_opacity = value
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
    "1. .......... Window/Split Management",
    "2. .......... Editing",
    "3. .......... Bookmarks",
    "4. .......... Quit/Save",
    "5. .......... Tabs",
    "6. .......... Buffers",
    "7. .......... Errors",
    "8. .......... Fuzzy Finder/Search",
    "9. .......... File Management",
    "10. ......... File Explorer",
    "11. ......... Wiki",
    "12. ......... Exercism",
    "13. ......... Overseer",
    "14. ......... Theme and Appearance",
    "15. ......... Modes/Settings Toggles",
    "16. ......... Config/Commands",
    "17. ......... Plugins",
    "18. ......... Git",
    "19. ......... Shortcut Help (This Window)",
    "",
    "-- Window/Split Management",
    "--------------------",
    "<C-\\>       - Toggle Terminal",
    "<C-m>       - Move to middle line",
    "<A-b>       - Move (b)ack",
    "<A-B>       - Move (B)ack",
    "HH          - Move to top line, and center",
    "HL          - Move to top line, and put that at bottom",
    "LL          - Move to bottom line, and center",
    "LH          - Move to bottom line, and put that at bottom",
    "Zz          - Vertical Split",
    "Zx          - Horizontal Split",
    "<A-H>       - Move Split Left",
    "<A-J>       - Move Split Down",
    "<A-K>       - Move Split Up",
    "<A-L>       - Move Split Right",
    "<C-h>       - Move to Left Split",
    "<C-j>       - Move to Lower Split",
    "<C-k>       - Move to Upper Split",
    "<C-l>       - Move to Right Split",
    "<A-C-h>     - Decrease Current Split Width",
    "<A-C-l>     - Increase Current Split Width",
    "<A-C-j>     - Decrease Current Split Height",
    "<A-C-k>     - Increase Current Split Height",
    "<C-=>       - Equalize All Splits Size",
    "<C-_>       - Mazimize Current Split Height, Minimize Others",
    "<C-|>       - Maximize Current Split Width, Minimize Others",
    "",
    "-- Editing",
    "--------------------",
    "<C-a>             - Copy All",
    "<Leader>ae        - Add Empty Line Below",
    "<Leader>aE        - Add Empty Line Above",
    "<Leader>aw        - Add Empty Line Above and Below",
    "<Leader>at        - Add Indented Line Below",
    "<Leader>aT        - Add Indented Line Above",
    "<Leader>ap        - Add Paste on Indented Line Below",
    "<Leader>aP        - Add Paste on Indented Line Above",
    "<Leader>ac        - Add Comment on Indented Line Below",
    "<Leader>aC        - Add Comment on Indented Line Above",
    "<Leader>asa       - Add Space After",
    "<Leader>asb       - Add Space Before",
    "<Leader>du        - Duplicate Line Up",
    "<Leader>dd        - Duplicate Line Down",
    "<Leader>dw        - Duplicate Line Up and Down",
    "<A-j|k>           - Move Line Up or Down",
    "<A-h|l>           - Move Char Left or Right",
    "<A-w|e>           - Move Word Forward or Backward",
    "<A-h|l>           - Move Block Left or Right (Visual Mode)",
    "<A-j|k>           - Move Block Up or Down (Visual Mode)",
    "<Leader>rle       - Replace Line Endings - LF",
    "ys{motion}{char}  - Add Surrounding",
    "ds{motion}{char}  - Delete Surrounding",
    "cs{motion}{char}  - Change Surrounding", 
    "<C-CR>            - Jump Out of the Immediate Surrounding (Insert)",
    "<M-q>             - Open Macro Bank Live",
    "<M-Q>             - Open Macro Bank (Saved Macros)",
    "",
    "-- Bookmarks",
    "--------------------",
    "*           - Below, stands for any valid vimmarks character",
    "m*          - Set mark *",
    "m,          - Set next available a-z mark",
    "m;          - Toggle next available mark",
    "m:          - Preview mark (specify or <CR> for next)",
    "m[          - Move to previous mark",
    "m]          - Move to next mark",
    "M*          - Toggle mark *",
    "m[0-9]      - Add bookmark from group [0-9]",
    "m{          - Move to previous bookmark of the same type (Works Across Buffers)",
    "m}          - Move to next bookmark of the same type (Works Across Buffers)",
    "dm*         - Delete mark *",
    "dm-         - Delete all marks on current line",
    "dm<Space>   - Delete all marks in buffer",
    "dm[0-9]     - Delete all bookmarks in group [0-9]",
    "dm=         - Delete bookmark under cursor",
    "+-          - Toggle Signs Globally",
    "+_          - Toggle Signs for Buffer #",
    "+g          - List Global Marks in Open Buffers",
    "+G          - List All Marks in Open Buffers",
    "+b          - List All Marks Bookmarks of Group #",
    "+B          - List All Marks Bookmarks",
    "",
    "-- Quit/Save",
    "--------------------",
    "Qw          - Save and Quit",
    "QW          - Save and Quit All",
    "Qq          - Save and Quit Without Saving",
    "QQ          - Save and Quit All Without Saving",
    "Qf          - Force Quit",
    "QF          - Force Quit All",
    "Qh          - Close Left Split",
    "Ql          - Close Right Split",
    "Qk          - Close Upper Split",
    "Qj          - Close Lower Split",
    "",
    "-- Tabs",
    "--------------------",
    "<Space>tl   - Tabby Picker",
    "<Space>tn   - Next Tab",
    "<Space>tp   - Previous Tab",
    "<Space>to   - Open New Tab",
    "<Space>tc   - Close Current Tab",
    "<Space>tj   - Jump to Specific Tab",
    "<Space>tr   - Rename Tab",
    "",
    "-- Buffers",
    "--------------------",
    "<Tab>m  - Toggle Arena",
    "<Tab>a  - Open Alternate (Last) Buffer",
    "<Tab>b  - List Buffers", 
    "<Tab>o  - Open New Buffer",
    "<Tab>n  - Next Buffer",
    "<Tab>p  - Previous Buffer",
    "<Tab>s  - Switch to Specific Buffer",
    "<Tab>d  - Delete Buffer",
    "<Tab>l  - Close Current Buffer, Open Previous",
    "<Tab>c  - Close All Buffers Except Current",
    "",
    "-- Errors",
    "--------------------",
    ";m          - Show Message List",
    ";M          - Show Message QuickFix",
    ";e          - Echo Last Error Message",
    ";y          - Copy Last Error Message",
    ";Y          - Copy All Messages",
    ";d          - Show Diagnostics under cursor",
    ";D          - Show Diagnostics under cursor",
    "[D          - First Diagnostic in Buffer",
    "]D          - Last Diagnostic in Buffer",
    "[d          - Previous Diagnostic in Buffer",
    "]d          - Next Diagnostic in Buffer",
    ";l          - Show Error List",
    ";q          - Show Quickfix List",
    "",
    "-- Fuzzy Finder/Search",
    "--------------------",
    "<Space>Ff          - Find Files",
    "<Space>Fr          - Recent Files",
    "<Space>FR          - Registers",
    "<Space>Fg          - Live Grep",
    "<Space>FG          - Word Search (Selection|Cursor)",
    "<Space>Fb          - Buffers",
    "<Space>Fs          - Tmux Sessions",
    "<Space>Fw          - Tmux Windows",
    "<Space>Ft          - Help Tags",
    "<Space>FT          - Tags",
    "<Space>Fc          - Commands",
    "<Space>FC          - Autocommands",
    "<Space>Fh          - Command History",
    "<Space>FH          - Search History",
    "<Space>Fk          - Keymaps",
    "<Space>Fv          - Vim Options",
    "<Space>Fn          - Man Pages",
    "<Space>FB          - Current Buffer Fuzzy Find",
    "<Space>Fa          - Current Buffer Tags",
    "<Space>Fl          - Resume Last Picker",
    "<Space>Fp          - Projects",
    "<Space>FP          - Pickers",
    "",
    "-- File Management",
    "--------------------",
    "<Leader>w   - Save",
    "<Leader>W   - Save All Buffers",
    "<Leader>e   - Open File",
    "<Space>fq   - Open TODO Location List",
    "<Space>ff   - Open TODO Location List",
    "<Space>ft   - Open TODO Telescope",
    "<Space>nn   - New Quicknote at Current Line",
    "<Space>no   - Open Quicknote at Current Line",
    "<Space>nd   - Delete Quicknote at Current Line",
    "<Space>nb   - List all Quicknotes in Current Buffer",
    "<Space>nc   - List all Quicknotes in CWD",
    "<Space>nl   - Jump to the Next Quicknote Location",
    "<Space>nh   - Jump to the Previous Quicknote Location",
    "<Space>af   - Add Fusen Annotation",
    "<Space>df   - Clear Fusen Annotation At Current Location",
    "<Space>Cf   - Clear All Fusen Annotations in Current Buffer",
    "<Space>Df   - Delete All Fusen Annotations Globally",
    "<Space>nf   - Jump to Next Fusen",
    "<Space>pf   - Jump to Prev Fusen",
    "<Space>lf   - List All Fusens",
    "<Leader>r   - Make It Rain",
    "<Leader>l   - Game of Life",
    "",
    "-- File Explorer",
    "--------------------",
    "-                 - Toggle Mini-Files",
    "=                 - Toggle Oil",
    "<Leader>-         - Toggle Navbuddy",
    "<Leader>=         - Toggle Time Machine",
    "<Space>ip         - Print CWD",
    "<Space>ic         - Set CWD",
    "<Space>it         - Set LWD",
    "<Space>o          - CD to Work Dir",
    "<Space>h          - CD to Home",
    "",
    "-- Wiki",
    "--------------------",
    "<M-@>mp         - Open Peek Markdown Preview",
    "<M-@>mc         - Close Peek Markdown Preview",
    "<M-S-1>         - CD To Beehive",
    "<M-1>           - Open Telekasten Panel",
    "<M-1>v          - Switch Vault",
    "<M-1>f          - Find Note by Title",
    "<M-1>#          - Open Tag List",
    "<M-1>F          - Search (Grep) Notes",
    "<M-1>c          - Show Calendar",
    "<M-1>d          - Open Daily Notes",
    "<M-1>w          - Open Weekly Notes",
    "<M-1>m          - Open Monthly Notes",
    "<M-1>q          - Open Quarterly Notes",
    "<M-1>y          - Open Yearly Notes",
    "<M-1>gt         - Open Today's Daily Note",
    "<M-1>gw         - Open Weekly Note",
    "<M-1>gm         - Open Monthly Note",
    "<M-1>gq         - Open Quarterly Note",
    "<M-1>gy         - Open Yearly Note",
    "<M-1>t          - Toggle TODO",
    "<M-1>n          - New Note",
    "<M-1>N          - New Templated Note",
    "<M-1>R          - Rename Current Note",
    "<M-1>I          - Insert a Link To a Note",
    "<M-1><CR>       - Follow the Link under the Cursor",
    "<M-1>Y          - Yank Link to Current Note",
    "<M-1>b          - Show All Notes Linking to Current Note",
    "<M-1>B          - Show Notes Linking to Link Under Cursor",
    "<M-1>p          - Paste Image In Clipboard",
    "<M-1>P          - Select an Image and Link To It",
    "<M-1>S          - Preview Image under Cursor",
    "<M-1>M          - Browse Vault Media",
    "",
    "-- Exercism",
    "--------------------",
    "\"e          - List Languages",
    "\"a          - List Exercises for Language",
    "\"l          - List Exercises for Default Language",
    "\"t          - Run Tests for Exercise",
    "\"s          - Submit Exercise",
    "\"r          - Recent Exercises",
    "\"es         - Open specific <language> <exercise>",
    "\"ee         - Open <exercise> using Default Language (Rust)",
    "",
    "-- Overseer",
    "--------------------",
    ",D          - Open Dashboard",
    ",o          - Sudoku",
    "",
    "-- Theme and Appearance",
    "--------------------",
    "<Leader>cs  - Open Themify",
    "<Leader>cn  - Open Nerd Icon Picker",
    "<Leader>cnr - Open Recent Nerd Icons",
    "<Leader>cns - Open Nerd Icon (Specific)",
    "<Leader>cy  - Open Telescope Symbols Picker",
    "<Leader>o1  - Set Transparency to 0.0",
    "<Leader>o2  - Set Transparency to 0.2",
    "<Leader>o3  - Set Transparency to 0.4",
    "<Leader>o4  - Set Transparency to 0.6",
    "<Leader>o5  - Set Transparency to 0.8",
    "<Leader>o6  - Set Transparency to 1.0",
    "",
    "-- Modes/Settings Toggles",
    "--------------------",
    "<Leader>ml  - Toggle Relative Numbers",
    "<Leader>mu  - Change Line Ending Format - LF",
    "<Leader>mw  - Change Line Ending Format - CRLF",
    "<Leader>ms  - Toggle Spell Check",
    "<Leader>mc  - Set Column Limit",
    "<Leader>mq  - Toggle Quicknote Gutter Signs",
    "<Leader>mm  - Toggle Quicknote Mode",
    "<Leader>f   - Focus Toggle",
    "<Leader>fe  - Focus Equalize",
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
    "-- Plugin Management",
    "--------------------",
    ",i  - PlugInstall",
    ",u  - PlugUpdate",
    ",c  - PlugClean",
    ",s  - PlugStatus",
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
    "-- Shortcut Help (This Window)",
    "--------------------",
    "g?          - Show Shortcut Help (this window)",
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
  vim.keymap.set('n', '<ESC>', '<cmd>bd!<CR>', { noremap = true, silent = true, buffer = buf, desc = "Close Shortcut Window" })

  vim.keymap.set('n', '<C-d>', '5<C-e>', { noremap = true, silent = true, buffer = buf, desc = "Scroll Down" })
  vim.keymap.set('n', '<C-u>', '5<C-y>', { noremap = true, silent = true, buffer = buf, desc = "Scroll Up" })

  vim.api.nvim_buf_set_keymap(buf, 'n', '0',  ':lua GoToSection("Table of Contents")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '1',  ':lua GoToSection("-- Window/Split Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '2',  ':lua GoToSection("-- Editing")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '3',  ':lua GoToSection("-- Bookmarks")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '4',  ':lua GoToSection("-- Quit/Save")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '5',  ':lua GoToSection("-- Tabs")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '6',  ':lua GoToSection("-- Buffers")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '7',  ':lua GoToSection("-- Errors")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '8',  ':lua GoToSection("-- Fuzzy Finder/Search")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '9',  ':lua GoToSection("-- File Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '10', ':lua GoToSection("-- File Explorer")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '11', ':lua GoToSection("-- Wiki")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '12', ':lua GoToSection("-- Exercism")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '13', ':lua GoToSection("-- Overseer")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '14', ':lua GoToSection("-- Theme and Appearance")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '15', ':lua GoToSection("-- Modes/Settings Toggles")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '16', ':lua GoToSection("-- Config/Commands")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '17', ':lua GoToSection("-- Plugin Management")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '18', ':lua GoToSection("-- Git")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '19', ':lua GoToSection("-- Shortcut Help (This Window)")<CR>', { noremap = true, silent = true })
end

vim.keymap.set('n', 'g?', ShowShortcuts, { noremap = true, silent = true, desc = "Show Shortcut Help" })
vim.api.nvim_create_user_command('ShowShortcuts', ShowShortcuts, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↪ "
    vim.opt_local.conceallevel = 2
  end,
})

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

" Open Sudoku in a floating window.
function! FSudoku() abort
  let l:prev = win_getid()

  " --- float geometry ---
  let l:width  = float2nr(&columns * 0.50)
  let l:height = 32 " - float2nr(&lines   * 0.85)
  let l:row    = float2nr((&lines   - l:height) / 2)
  let l:col    = float2nr((&columns - l:width)  / 2)

  " scratch buf + float
  let l:buf = nvim_create_buf(v:false, v:true)
  let l:win = nvim_open_win(l:buf, v:true, {
        \ 'relative': 'editor',
        \ 'row': l:row, 'col': l:col,
        \ 'width': l:width, 'height': l:height,
        \ 'style': 'minimal', 'border': 'rounded'
        \ })

  call nvim_buf_set_option(l:buf, 'bufhidden', 'wipe')
  call nvim_win_set_option(l:win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')

  " Run plugin in the float; if it errors, clean up and bail.
  try
    silent! Sudoku
  catch /.*/
    call nvim_win_close(l:win, v:true)
    call win_gotoid(l:prev)
    echohl ErrorMsg | echom v:exception | echohl None
    return
  endtry

  " Add 'q' to close the float, BUT only if the buffer doesn't already map 'q'.
  if empty(maparg('q', 'n', 0, 1)) || get(maparg('q','n',0,1), 'buffer', 0) == 0
    nnoremap <silent><buffer> q :call nvim_win_close(win_getid(), v:true)<CR>
  endif
endfunction

command! FSudoku call FSudoku()

let beehive = expand('$VAULTS') . '/Beehive'

" Key Remappings

" Window/Split Management
noremap <C-m> M
noremap <A-b> b
noremap <A-B> B
" noremap HH <C-u>
" noremap HL <C-b>
" noremap LL <C-d>
" noremap LH <C-f>
nnoremap Zz :vsplit<CR>
nnoremap Zx :split<CR>
nnoremap <A-H> <C-W>H
nnoremap <A-J> <C-W>J
nnoremap <A-K> <C-W>K
nnoremap <A-L> <C-W>L
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <M-C-H> <C-w><lt>
nnoremap <M-C-L> <C-w>>
nnoremap <M-NL> <C-w>-
nnoremap <M-C-K> <C-w>+
nnoremap <C-=> <C-w>=
nnoremap <C-_> <C-w>_
nnoremap <C-Bar> <C-w><bar>

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
nnoremap <C-a> ggVGy<C-o>
" ----- Paste from Clipboard ----- 
inoremap <M-v> <C-r>+
cnoremap <M-v> <C-r>+
nnoremap <M-v> "+p
xnoremap <M-v> "+p
" -------- End -----------
nnoremap <leader>p :PasteImage<CR>
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
nnoremap <A-w> :MoveWord(1)<CR>
nnoremap <A-e> :MoveWord(-1)<CR>
vnoremap <A-h> :MoveHBlock(-1)<CR>
vnoremap <A-j> :MoveBlock(1)<CR>
vnoremap <A-k> :MoveBlock(-1)<CR>
vnoremap <A-l> :MoveHBlock(1)<CR>
nnoremap <leader>rle :%s/\r//g<CR>
nnoremap <M-q> :MacroBankLive<CR>
nnoremap <M-Q> :MacroBank<CR>

" Bookmarks 
nnoremap ++ :MarksListBuf<CR>
nnoremap +- :MarksToggleSigns<CR>
nnoremap +_ :MarksToggleSigns<Space>
nnoremap +g :MarksListGlobal<CR>
nnoremap +G :MarksListAll<CR>
nnoremap +b :BookmarksList<Space>
nnoremap +B :BookmarksListAll<CR>

" Quit/Save
nnoremap Qw :wq<CR>
nnoremap QW :wqa<CR>
nnoremap Qq :q<CR>
nnoremap QQ :qa<CR>
nnoremap Qf :q!<CR>
nnoremap QF :qa!<CR>
nnoremap Qh <C-w>h:q<CR>
nnoremap Ql <C-w>l:q<CR>
nnoremap Qk <C-w>k:q<CR>
nnoremap Qj <C-w>j:q<CR>

" Tabs
nnoremap <Space>tt g<Tab>
nnoremap <Space>tl :Tabby pick_window<CR>
nnoremap <Space>tn :tabnext<CR>
nnoremap <Space>tp :tabprevious<CR>
nnoremap <Space>to :tabnew<CR>
nnoremap <Space>tc :tabclose<CR>
nnoremap <Space>tj :Tabby jump_to_tab<CR>
nnoremap <Space>tr :Tabby rename_tab<Space>

" Buffers
nnoremap <Tab>m :ArenaToggle<CR>
nnoremap <Tab>a :b#<CR>
nnoremap <Tab>b :ls<CR>
nnoremap <Tab>e :enew<CR>
nnoremap <Tab>o :e<Space>
nnoremap <Tab>n :bnext<CR>
nnoremap <Tab>p :bprevious<CR>
nnoremap <Tab>s :b<Space>
nnoremap <Tab>d :bd!<CR>
nnoremap <Tab>l :bprev \| if buflisted(bufnr('#')) \| bdelete # \| endif<CR>
nnoremap <Tab>c :%bd\|e#<CR>

" Errors
nnoremap ;d <C-W>d
nnoremap ;D <C-W><C-D>
nnoremap ;m :messages<CR>
nnoremap ;M :Messages<CR>
nnoremap ;e :echo v:errmsg<CR>
nnoremap ;y :let @+ = v:errmsg \| echo "yanked: " . v:errmsg<CR>
nnoremap ;Y :redir @+ \| silent messages \| redir END \| echo "messages -> clipboard"<CR>
nnoremap ;l :lua vim.diagnostic.setloclist()<CR>
nnoremap ;q :lua vim.diagnostic.setqflist()<CR>

" Fuzzy Finder/Search
nnoremap <Space>Ff :Telescope find_files<CR>
nnoremap <Space>Fr :Telescope oldfiles<CR>
nnoremap <Space>FR :Telescope registers<CR>
nnoremap <Space>Fg :Telescope live_grep<CR>
nnoremap <Space>FG :Telescope grep_string<CR>
nnoremap <Space>Fb :Telescope buffers<CR>
nnoremap <Space>Ft :Telescope help_tags<CR>
nnoremap <Space>FT :Telescope tags<CR>
nnoremap <Space>Fc :Telescope commands<CR>
nnoremap <Space>FC :Telescope autocommands<CR>
nnoremap <Space>Fh :Telescope command_history<CR>
nnoremap <Space>FH :Telescope search_history<CR>
nnoremap <Space>Fk :Telescope keymaps<CR>
nnoremap <Space>Fv :Telescope vim_options<CR>
nnoremap <Space>Fn :Telescope man_pages<CR>
nnoremap <Space>FB :Telescope current_buffer_fuzzy_find<CR>
nnoremap <Space>Fa :Telescope current_buffer_tags<CR>
nnoremap <Space>Fl :Telescope resume<CR>
nnoremap <Space>Fp :Telescope projects<CR>
nnoremap <Space>FP :Telescope pickers<CR>

" File Management
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wa<CR>
nnoremap <leader>e :e<Space>
nnoremap <Space>fq :TodoQuickFix<CR>
nnoremap <Space>ff :TodoLocList<CR>
nnoremap <Space>ft :TodoTelescope<CR>
nnoremap <Space>nn :NewQuickNote<CR>
nnoremap <Space>no :OpenQuickNote<CR>
nnoremap <Space>nd :DeleteQuickNote<CR>
nnoremap <Space>nb :ListBufferQuickNotes<CR>
nnoremap <Space>nc :ListCWDQuickNotes<CR>
nnoremap <Space>nl :NextQuickNote<CR>
nnoremap <Space>nh :PrevQuickNote<CR>
nnoremap <leader>r :CellularAutomaton make_it_rain<CR>
nnoremap <leader>l :CellularAutomaton game_of_life<CR>

" File Explorer
nnoremap - :lua MiniFiles.open()<CR>
nnoremap = :Oil --float<CR>
nnoremap <leader>= :TimeMachineToggle<CR>
" nnoremap <leader>- :Telescope lsp_document_symbols<CR>
nnoremap <leader>- :Navbuddy<CR>
nnoremap <Space>ip :pwd<CR>
nnoremap <Space>ic :cd<Space>
nnoremap <Space>it :lcd<Space>
nnoremap <Space>o :CDWork<CR>
nnoremap <Space>h :CDHome<CR>

" Wiki
nnoremap <M-@>p     :PeekOpen<CR>
nnoremap <M-@>c     :PeekClose<CR>
nnoremap <M-S-1>    :exec 'lcd ' . fnameescape(beehive)<CR>
nnoremap <M-1>      :Telekasten panel<CR>
nnoremap <M-1>v     :Telekasten switch_vault<CR>
nnoremap <M-1>f     :Telekasten find_notes<CR>
nnoremap <M-1>#     :Telekasten show_tags<CR>
nnoremap <M-1>F     :Telekasten search_notes<CR>
nnoremap <M-1>c     :Telekasten show_calendar<CR>
nnoremap <M-1>d     :Telekasten find_daily_notes<CR>
nnoremap <M-1>w     :Telekasten find_weekly_notes<CR>
nnoremap <M-1>m     :Telekasten find_monthly_notes<CR>
nnoremap <M-1>q     :Telekasten find_quarterly_notes<CR>
nnoremap <M-1>y     :Telekasten find_yearly_notes<CR>
nnoremap <M-1>gt    :Telekasten goto_today<CR>
nnoremap <M-1>gw    :Telekasten goto_thisweek<CR>
nnoremap <M-1>gm    :Telekasten goto_thismonth<CR>
nnoremap <M-1>gq    :Telekasten goto_thisquarter<CR>
nnoremap <M-1>gy    :Telekasten goto_thisyear<CR>
nnoremap <M-1>t     :Telekasten toggle_todo<CR>
nnoremap <M-1>n     :Telekasten new_note<CR>
nnoremap <M-1>N     :Telekasten new_templated_note<CR>
nnoremap <M-1>R     :Telekasten rename_note<CR>
nnoremap <M-1>I     :Telekasten insert_link<CR>
nnoremap <M-1><CR>  :Telekasten follow_link<CR>
nnoremap <M-1>Y     :Telekasten yank_notelink<CR>
nnoremap <M-1>b     :Telekasten show_backlinks<CR>
nnoremap <M-1>B     :Telekasten find_friends<CR>
nnoremap <M-1>p     :Telekasten paste_img_and_link<CR>
nnoremap <M-1>P     :Telekasten insert_img_link<CR>
nnoremap <M-1>S     :Telekasten preview_img<CR>
nnoremap <M-1>M     :Telekasten browse_media<CR>

" Exercism
nnoremap "e :Exercism languages<CR>
nnoremap "a :Exercism list<CR>
nnoremap "l :Exercism list<Space>
nnoremap "t :Exercism test<CR>
nnoremap "s :Exercism submit<CR>
nnoremap "r :Exercism recents<CR>
nnoremap "es :Exercism open<Space>
nnoremap "ee :Exercism exercise<Space>

" Overseer
nnoremap ,D :Dashboard<CR>
nnoremap ,o :FSudoku<CR>

" Theme and Appearance
nnoremap <leader>cs :Themify<CR>
nnoremap <leader>cn :Nerdy<CR>
nnoremap <leader>cnr :Nerdy recents<CR>
nnoremap <leader>cns :Nerdy get <Space>
nnoremap <leader>cy :Telescope symbols<CR>

" Modes/Settings Toggles
nnoremap <leader>ml :set relativenumber!<CR>
nnoremap <leader>mu :set fileformat=unix<CR>
nnoremap <leader>mw :set fileformat=dos<CR>
nnoremap <leader>mc :if &colorcolumn == '80' \| set colorcolumn= \| else \| set colorcolumn=80 \| endif<CR>
nnoremap <leader>ms :set spell!<CR>
nnoremap <leader>mq :ToggleNoteSigns<CR>
nnoremap <leader>mm :ToggleQuickNoteMode<CR>
nnoremap <leader>f :FocusToggle<CR>
nnoremap <leader>fe :FocusEqualise<CR>

" Config/Commands
nnoremap <leader>cR :source $MYVIMRC<CR>
nnoremap <leader>ce :e $MYVIMRC<CR>
nnoremap <leader>cc :SetCWDToFile<CR>
nnoremap <leader>cl :SetLWDToFile<CR>
nnoremap <leader>ch :checkhealth<CR>
nnoremap <leader>cp :checkhealth<Space>

" Plugin Management
nnoremap ,i :PlugInstall<CR>
nnoremap ,u :PlugUpdate<CR>
nnoremap ,c :PlugClean<CR>
nnoremap ,s :PlugStatus<CR>

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

" Theme Settings
highlight Comment cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Function cterm=italic gui=italic
highlight Type cterm=italic gui=italic

hi Normal     ctermbg=NONE guibg=NONE
hi NormalNC   ctermbg=NONE guibg=NONE
