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
    let g:WORKDIR = "/mnt/hive"
endif

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Set Settings
syntax on
set number
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
Plug 'nvzone/volt'
Plug 'epheien/outline-treesitter-provider.nvim'

" MISC
Plug 'lowitea/aw-watcher.nvim'
Plug 'ptdewey/pendulum-nvim'
Plug 'y3owk1n/time-machine.nvim'
Plug 'QuentinGruber/pomodoro.nvim'
Plug 'nvzone/typr'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-scriptease'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'jim-fx/sudoku.nvim'

" Exercism
Plug '2kabhishek/utils.nvim'
Plug '2KAbhishek/exercism.nvim'

" UI
Plug 'psliwka/vim-smoothie'
Plug 'nvimdev/dashboard-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'christopher-francisco/tmux-status.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'OXY2DEV/markview.nvim'
Plug 'nanozuki/tabby.nvim'
Plug 'levouh/tint.nvim'
Plug 'beauwilliams/focus.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvimdev/hlsearch.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'echasnovski/mini.icons', {'branch': 'stable'}
Plug 'rktjmp/lush.nvim'
Plug 'brianhuster/live-preview.nvim'
Plug '2kabhishek/nerdy.nvim'
Plug 'aserowy/tmux.nvim'

" SWITCHERS
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'camgraff/telescope-tmux.nvim'
Plug 'ElPiloto/telescope-vimwiki.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'doctorfree/cheatsheet.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'lewis6991/gitsigns.nvim'
Plug 'hedyhli/outline.nvim'

" FILES
Plug 'vimwiki/vimwiki'
Plug 'echasnovski/mini.files', {'branch': 'stable'}
Plug 'stevearc/oil.nvim'
Plug 'refractalize/oil-git-status.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'dzfrias/arena.nvim'

" EDITING
Plug '2KAbhishek/markit.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'kevinhwang91/nvim-ufo'
Plug 'chrisgrieser/nvim-origami', {'tag': 'v1.9'}
Plug 'tpope/vim-commentary'
Plug 'kylechui/nvim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'fedepujol/move.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'folke/todo-comments.nvim'

" THEMES
Plug 'LmanTW/themify.nvim'

call plug#end()

" Plugin Setup

lua << EOF
local tmux = require('tmux')
tmux.setup({
    copy_sync = {
        redirect_to_clipboard = true,
    },
    resize = {
        enable_default_keybindings = false,
    },
    swap = {
        cycle_navigation = true,
        enable_default_keybindings = false,
    }
})

local home = vim.loop.os_homedir()
local VAULT = home .. "/Documents/Vaults/Beehive/"
vim.g.vimwiki_list = {
    {
        path = VAULT,
        syntax = "markdown",
        ext = ".md",
    },
    {
        path = VAULT .. "projects/",
        syntax = "markdown",
        ext = ".md",
    },
    {
        path = VAULT .. "runbook/",
        syntax = "markdown",
        ext = ".md",
    },
    {
        path = VAULT .. "wiki/",
        syntax = "markdown",
        ext = ".md",
    },
}

vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_markdown_link_ext = 1
vim.g.vimwiki_dir_link = "index"

function EnsureVaultRootIndex()
    local path = VAULT .. "index.md"
    if vim.loop.fs_stat(path) then return end
    vim.fn.mkdir(VAULT, "p")

    local lines = {
        "# Beehive",
        "",
        "- [[projects/]]",
        "- [[runbook/]]",
        "- [[wiki/]]",
        "",
    }
    vim.fn.writefile(lines, path)
    print("created: " .. path)
end

function GenerateVimwikiIndexes()
    local roots = { VAULT .. "wiki", VAULT .. "runbook", VAULT .. "projects" }
    local uv = vim.loop
    local function exists(p) return uv.fs_stat(p) ~= nil end
    local function walk(dir)
        local base = dir:match("([^/]+)$")
        if base then
            local folder_note = dir .. "/" .. base .. ".md"
            local index = dir .. "/index.md"
            if exists(folder_note) and not exists(index) then
                local f = assert(io.open(index, "w"))
                f:write("# " .. base:gsub("_"," ") .. "\n\nSee → [[" .. base .. "]]\n")
                f:close()
                print("created: " .. index)
            end
        end
        local h = uv.fs_scandir(dir); if not h then return end
        while true do
            local name, t = uv.fs_scandir_next(h); if not name then break end
            if t == "directory" then walk(dir .. "/" .. name) end
        end
    end
    for _, r in ipairs(roots) do walk(vim.fn.expand(r)) end
end

function VimwikiMakeIndexHere()
    local dir  = vim.fn.expand("%:p:h")
    local base = vim.fn.fnamemodify(dir, ":t")
    local index = dir .. "/index.md"
    if vim.loop.fs_stat(index) then print("index.md exists"); return end
    local folder_note = dir .. "/" .. base .. ".md"
    local link = vim.loop.fs_stat(folder_note) and base or nil
    local f = assert(io.open(index, "w"))
    f:write("# " .. base:gsub("_"," ") .. "\n\n")
    if link then f:write("See → [[" .. link .. "]]\n") end
    f:close()
    vim.cmd.edit(index)
    print("created: " .. index)
end

vim.api.nvim_create_user_command("BeehiveRootIndex", function(_) EnsureVaultRootIndex() end, { desc = "Ensure vault root index.md, create it if not" })
vim.api.nvim_create_user_command("GenerateVimwikiIndexes", function(_) GenerateVimwikiIndexes() end, { desc = "Create index.md wrappers for folder notes under wiki/runbook/projects" })
vim.api.nvim_create_user_command("VimwikiMakeIndexHere", function(_) VimwikiMakeIndexHere() end, { desc = "Create index.md in the current folder pointing to the folder note" })

-- tiny util: safe input that returns "" on <Esc>/<C-c>
local function prompt(msg, default)
    -- Neovim's input() doesn't support default arg in all versions, so show it in the prompt
    local suffix = default and (" [" .. default .. "]") or ""
    local s = vim.fn.input(msg .. suffix .. ": ")
    if s == nil then return "" end
    if s == "" and default then return default end
    return s
end

-- 1) Basic wikilink: asks for target like `page` or `folder/page` (you can type a trailing '/')
local function WikilinkNew()
    local target = prompt("Wikilink target (page or folder/page)")
    if target == "" then return end
    local link = "[[" .. target .. "]]"
    vim.api.nvim_put({ link }, "c", true, true)
end

-- 2) Relative wikilink: adds ../ N times before your target
local function WikilinkRel()
    local levels = tonumber(prompt("Levels up (0,1,2...)", "1")) or 0
    if levels < 0 then levels = 0 end

    local target = vim.fn.input("Relative target (page | folder/page | _ for folder hub): ")
    if target == nil then target = "" end

    local prefix = ("../"):rep(levels)

    if levels == 0 and target == "" then
        vim.notify("Empty Link .... Operation Canceled", vim.log.levels.INFO)
        return
    end

    local link = (target == "") and ("[[" .. prefix .. "]]") or ("[[" .. prefix .. target .. "]]")
    vim.api.nvim_put({ link }, "c", true, true)
end

-- 3) Markdown link: [Label](path.md). Path defaults to the label (with .md)
local function MarkdownLinkNew()
    local label = prompt("Markdown link label")
    if label == "" then return end
    local default_path = label
    local path = prompt("Markdown link path (relative)", default_path)
    if path == "" then path = default_path end
    if not path:match("%.md$") then path = path .. ".md" end
    local link = "[" .. label .. "](" .. path .. ")"
    vim.api.nvim_put({ link }, "c", true, true)
end

-- Expose as :commands so you can map in Vimscript
vim.api.nvim_create_user_command("WikilinkNew",       function() WikilinkNew() end,       { desc = "Insert [[target]]" })
vim.api.nvim_create_user_command("WikilinkRel",       function() WikilinkRel() end,       { desc = "Insert [[../..../target]]" })
vim.api.nvim_create_user_command("MarkdownLinkNew",   function() MarkdownLinkNew() end,   { desc = "Insert [label](path.md)" })

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

local arena = require('arena')
arena.setup()

local todo = require('todo-comments')
todo.setup()

local outline = require('outline')
outline.setup({
    providers = {
        priority = { 'lsp', 'coc', 'markdown', 'treesitter', 'norg', 'man' }
        }
})

local markit = require('markit')
markit.setup({
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

local pomodoro = require('pomodoro')
pomodoro.setup({
    start_at_launch = true,
    work_duration = 30,
    break_duration = 5,
    delay_duration = 5,
    long_break_duration = 25,
    breaks_before_long = 4,
})

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
  }
}

telescope.load_extension('fzf')
telescope.load_extension('frecency')
telescope.load_extension('ui-select')
telescope.load_extension('projects')
telescope.load_extension('markit')
telescope.load_extension('vimwiki')
telescope.load_extension('tmux')

local exercism = require('exercism')
exercism.setup({
    default_language = 'rust',
    add_default_keybindings = false,
    max_recents = 15,
})

local pendulum = require('pendulum')
pendulum.setup({
    log_file = vim.g.PENDIR,
    time_format = "24h",
    time_zone = "America/Denver",
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
 
local surround = require('nvim-surround')
surround.setup{}

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
      { icon = '  ', desc = 'Open Wiki List      ', action = 'VimwikiUISelect', key = 'v' },
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
    lualine_c = {
        {
            require('tmux-status').tmux_windows,
            cond = require('tmux-status').show,
            padding = { left = 3 },
        },
    },
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

local ignore_filetypes = { 'outline', 'Outline' }
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
    "============= * =============",
    "<Super-A-h>     - Move to Left Tmux Pane",
    "<Super-A-j>     - Move to Lower Tmux Pane",
    "<Super-A-k>     - Move to Upper Tmux Pane",
    "<Super-A-l>     - Move to Right Tmux Pane",
    "============= * =============",
    "<A-C-h>     - Decrease Current Split Width",
    "<A-C-l>     - Increase Current Split Width",
    "<A-C-j>     - Decrease Current Split Height",
    "<A-C-k>     - Increase Current Split Height",
    "<C-=>       - Equalize All Splits Size",
    "<C-_>       - Mazimize Current Split Height, Minimize Others",
    "<C-|>       - Maximize Current Split Width, Minimize Others",
    " (*) (Keymap is actually declared as M-S-*, but kitty sends <A-S-Arrow> to nvim and to tmux)",
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
    "+b          - List All Bookmarks of Group #",
    "+B          - List All Bookmarks",
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
    "tl          - Tabby Picker",
    "tn          - Next Tab",
    "tp          - Previous Tab",
    "to          - Open New Tab",
    "tc          - Close Current Tab",
    "tj          - Jump to Specific Tab",
    "tr          - Rename Tab",
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
    "Ff          - Find Files",
    "Fr          - Recent Files",
    "FR          - Registers",
    "Fg          - Live Grep",
    "FG          - Word Search (Selection|Cursor)",
    "Fb          - Buffers",
    "Fs          - Tmux Sessions",
    "Fw          - Tmux Windows",
    "Ft          - Help Tags",
    "FT          - Tags",
    "Fc          - Commands",
    "FC          - Autocommands",
    "Fh          - Command History",
    "FH          - Search History",
    "Fk          - Keymaps",
    "Fv          - Vim Options",
    "Fn          - Man Pages",
    "FB          - Current Buffer Fuzzy Find",
    "Fa          - Current Buffer Tags",
    "Fl          - Resume Last Picker",
    "Fp          - Projects",
    "FP          - Pickers",
    "",
    "-- File Management",
    "--------------------",
    "<Leader>w   - Save",
    "<Leader>W   - Save All Buffers",
    "<Leader>e   - Open File",
    "<Leader>s   - Save Session (Obsession)",
    "fq          - Open TODO Location List",
    "ff          - Open TODO Location List",
    "ft          - Open TODO Telescope",
    "<Leader>r   - Make It Rain",
    "<Leader>l   - Game of Life",
    "",
    "-- File Explorer",
    "--------------------",
    "-           - Toggle Mini-Files",
    "=           - Toggle Oil",
    "<Leader>-   - Toggle Telescope Outline",
    "<Leader>=   - Toggle Time Machine",
    "@p          - Print CWD",
    "@c          - Set CWD",
    "@t          - Set LWD",
    "@o          - CD to Work Dir",
    "@h          - CD to Home",
    "",
    "-- Wiki",
    "@mr         - Generate Root Wiki Index",
    "@mw         - Generate Wiki Indexes",
    "@mi         - Generate Wiki Index for Current Folder",
    "@fp         - Find Files in Projects",
    "@gp         - Search Files in Projects",
    "@fr         - Find Files in Runbook",
    "@gr         - Search Files in Runbook",
    "@fw         - Find Files in Wiki",
    "@gw         - Search Files in Wiki",
    "@b          - Open Beehive (Root) Wiki",
    "@s          - Open Projects Wiki",
    "@r          - Open Runbook Wiki",
    "@w          - Open Wiki Vimwiki",
    "@k          - Help for Vimwiki Default Mappings",
    "@ml         - Make Wiki Link",
    "@mr         - Make Relative Wiki Link",
    "@mm         - Make Markdown Wiki LInk",
    "<A-=>       - Vimwiki Add Header Level",
    "<A-->       - Vimwiki Remove Header Level",
    "<A-Space>   - Vimwiki Toggle List Checkbox On/Off",
    "gnl         - Vimwiki Go To Next Link in Page",
    "gpl         - Vimwiki Go To Prev Link in Page",
    "",
    "-- Exercism",
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
    ",p          - Start Pomodoro",
    ",q          - Stop Pomodoro",
    ",h          - Pomodoro UI",
    ",d          - Delay Pomodoro Break",
    ",f          - Force Default Break",
    ",b          - Break Pomodoro (args: break duration)",
    ",k          - Skip Pomodoro Break",
    ",tt         - Show Typr",
    ",ts         - Show Typr Stats",
    ",o          - Sudoku",
    "",
    "-- Theme and Appearance",
    "--------------------",
    "<Leader>cs  - Open Themify",
    "<Leader>cn  - Open Nerd Icon Picker",
    "<Leader>cnr - Open Recent Nerd Icons",
    "<Leader>cns - Open Nerd Icon (Specific)",
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

function! s:CdSafe(dir) abort
	if empty(a:dir)
		echohl WarningMsg | echom 'No directory given.' | echohl None
		return
	endif
	if !isdirectory(a:dir)
		echohl ErrorMsg | echom 'Not a directory: ' . a:dir | echohl None
		return
	endif
	execute 'cd' fnameescape(a:dir)
	echom 'cwd → ' . fnamemodify(getcwd(), ':~')
endfunction

command! CDWork call s:CdSafe(get(g:, 'WORKDIR', ''))
command! CDHome call s:CdSafe(expand('~'))

function! s:FindFilesCwd(cwd) abort
  execute 'lua require("telescope.builtin").find_files({ cwd = vim.fn.expand("' . a:cwd . '") })'
endfunction

function! s:GrepCwd(cwd) abort
  execute 'lua require("telescope.builtin").live_grep({ cwd = vim.fn.expand("' . a:cwd . '") })'
endfunction

function! s:WOpen(which) abort
  " Map names to indices (edit to match your setup)
  let map = {'root': 1, 'projects': 2, 'runbook': 3, 'wiki': 4}
  if has_key(map, a:which)
    execute 'VimwikiIndex ' . map[a:which]
  elseif a:which =~ '^\d\+$'
    execute 'VimwikiIndex ' . a:which
  else
    echo 'Usage: :W {root|projects|runbook|wiki|N}'
  endif
endfunction

command! -nargs=1 W call <SID>WOpen(<q-args>)

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


" Key Remappings
noremap <CR> <CR>

" Window/Split Management
noremap <C-m> M
noremap <A-b> b
noremap <A-B> B
" noremap HH Hzz
" noremap HL Hzb
" noremap LL Lzz
" noremap LH Lzt
noremap HH H:call smoothie#do("zz")<CR>
noremap HL H:call smoothie#do("zb")<CR>
noremap LL L:call smoothie#do("zz")<CR>
noremap LH L:call smoothie#do("zt")<CR>
nnoremap Zz :vsplit<CR>
nnoremap Zx :split<CR>
" nnoremap <A-H> <C-W>H
" nnoremap <A-J> <C-W>J
" nnoremap <A-K> <C-W>K
" nnoremap <A-L> <C-W>L
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
" nnoremap <M-C-H> <C-w><lt>
" nnoremap <M-C-L> <C-w>>
" nnoremap <M-NL> <C-w>-
" nnoremap <M-C-K> <C-w>+
" nnoremap <C-=> <C-w>=
" nnoremap <C-_> <C-w>_
" nnoremap <C-Bar> <C-w><bar>
nnoremap <A-H> <C-W>H
nnoremap <A-J> <C-W>J
nnoremap <A-K> <C-W>K
nnoremap <A-L> <C-W>L
nnoremap <C-h>       :lua require('tmux').move_left()<CR>
nnoremap <C-j>       :lua require('tmux').move_bottom()<CR>
nnoremap <C-k>       :lua require('tmux').move_top()<CR>
nnoremap <C-l>       :lua require('tmux').move_right()<CR>
nnoremap <M-S-Left>  :lua require('tmux').swap_left()<CR>
nnoremap <M-S-Down>  :lua require('tmux').swap_down()<CR>
nnoremap <M-S-Up>    :lua require('tmux').swap_up()<CR>
nnoremap <M-S-Right> :lua require('tmux').swap_right()<CR>
nnoremap <M-C-h>     :lua require('tmux').resize_left()<CR>
nnoremap <M-C-l>     :lua require('tmux').resize_right()<CR>
nnoremap <M-NL>      :lua require('tmux').resize_bottom()<CR>
nnoremap <M-C-k>     :lua require('tmux').resize_top()<CR>
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
nnoremap ^ @
nnoremap Y y$
nnoremap yc vy
nnoremap <C-a> ggVGy<C-o>
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
nnoremap tt g<Tab>
nnoremap tl :Tabby pick_window<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>
nnoremap to :tabnew<CR>
nnoremap tc :tabclose<CR>
nnoremap tj :Tabby jump_to_tab<CR>
nnoremap tr :Tabby rename_tab<Space>

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
nnoremap Ff :Telescope find_files<CR>
nnoremap Fr :Telescope oldfiles<CR>
nnoremap FR :Telescope registers<CR>
nnoremap Fg :Telescope live_grep<CR>
nnoremap FG :Telescope grep_string<CR>
nnoremap Fb :Telescope buffers<CR>
nnoremap Fs :Telescope tmux sessions<CR>
nnoremap Fw :Telescope tmux windows<CR>
nnoremap Ft :Telescope help_tags<CR>
nnoremap FT :Telescope tags<CR>
nnoremap Fc :Telescope commands<CR>
nnoremap FC :Telescope autocommands<CR>
nnoremap Fh :Telescope command_history<CR>
nnoremap FH :Telescope search_history<CR>
nnoremap Fk :Telescope keymaps<CR>
nnoremap Fv :Telescope vim_options<CR>
nnoremap Fn :Telescope man_pages<CR>
nnoremap FB :Telescope current_buffer_fuzzy_find<CR>
nnoremap Fa :Telescope current_buffer_tags<CR>
nnoremap Fl :Telescope resume<CR>
nnoremap Fp :Telescope projects<CR>
nnoremap FP :Telescope pickers<CR>

" File Management
nnoremap <leader>w :w<CR>
nnoremap <leader>W :wa<CR>
nnoremap <leader>e :e<Space>
nnoremap <leader>s :Obsession<CR>
nnoremap <leader>q :Obsession!<CR>
nnoremap fq :TodoQuickFix<CR>
nnoremap ff :TodoLocList<CR>
nnoremap ft :TodoTelescope<CR>
nnoremap <leader>r :CellularAutomaton make_it_rain<CR>
nnoremap <leader>l :CellularAutomaton game_of_life<CR>

" File Explorer
nnoremap - :lua MiniFiles.open()<CR>
nnoremap = :Oil --float<CR>
nnoremap <leader>= :TimeMachineToggle<CR>
" nnoremap <leader>- :Telescope lsp_document_symbols<CR>
nnoremap <leader>- :Outline<CR>
nnoremap @p :pwd<CR>
nnoremap @c :cd<Space>
nnoremap @t :lcd<Space>
nnoremap @o :CDWork<CR>
nnoremap @h :CDHome<CR>

" Wiki
nnoremap @mr :BeehiveRootIndex<CR>
nnoremap @mw :GenerateVimwikiIndexes<CR>
nnoremap @mi :VimwikiMakeIndexHere<CR>
nnoremap @fp :call <SID>FindFilesCwd('~/Documents/Vaults/Beehive/projects')<CR>
nnoremap @gp :call <SID>GrepCwd('~/Documents/Vaults/Beehive/projects')<CR>
nnoremap @fr :call <SID>FindFilesCwd('~/Documents/Vaults/Beehive/runbook')<CR>
nnoremap @gr :call <SID>GrepCwd('~/Documents/Vaults/Beehive/runbook')<CR>
nnoremap @fw :call <SID>FindFilesCwd('~/Documents/Vaults/Beehive/wiki')<CR>
nnoremap @gw :call <SID>GrepCwd('~/Documents/Vaults/Beehive/wiki')<CR>
nnoremap @b :W root<CR>
nnoremap @s :W projects<CR>
nnoremap @r :W runbook<CR>
nnoremap @w :W wiki<CR>
nnoremap @l :VimwikiUISelect<CR>
nnoremap @k :h vimwiki-local-mappings<CR>
nnoremap @ml :WikilinkNew<CR>
nnoremap @mr :WikilinkRel<CR>
nnoremap @mm :MarkdownLinkNew<CR>
inoremap @ml <ESC>:WikilinkNew<CR>
inoremap @mr <ESC>:WikilinkRel<CR>
inoremap @mm <ESC>:MarkdownLinkNew<CR>
nmap <A-=> <Plug>VimwikiAddHeaderLevel<CR>
nmap <A--> <Plug>VimwikiRemoveHeaderLevel<CR>
nmap <A-Space> <Plug>VimwikiToggleListItem<CR>
nmap gnl <Plug>VimwikiNextLink<CR>
nmap gpl <Plug>VimwikiPrevLink<CR>

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
nnoremap ,p :PomodoroStart<CR>
nnoremap ,q :PomodoroStop<CR>
nnoremap ,h :PomodoroUI<CR>
nnoremap ,d :PomodoroDelayBreak<CR>
nnoremap ,f :PomodoroForceBreak<CR>
nnoremap ,b :PomodoroForceBreak<Space>
nnoremap ,k :PomodoroSkipBreak<CR>
nnoremap ,tt :Typr<CR>
nnoremap ,ts :TyprStats<CR>
nnoremap ,o :FSudoku<CR>

" Theme and Appearance
nnoremap <leader>cs :Themify<CR>
nnoremap <leader>cn :Nerdy<CR>
nnoremap <leader>cnr :Nerdy recents<CR>
nnoremap <leader>cns :Nerdy get <Space>

" Modes/Settings Toggles
nnoremap <leader>ml :set relativenumber!<CR>
nnoremap <leader>mu :set fileformat=unix<CR>
nnoremap <leader>mw :set fileformat=dos<CR>
nnoremap <leader>mc :if &colorcolumn == '80' \| set colorcolumn= \| else \| set colorcolumn=80 \| endif<CR>
nnoremap <leader>ms :set spell!<CR>
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
