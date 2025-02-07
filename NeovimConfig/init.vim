" Environment Variables
let VIMRUNTIME="C:/Program Files/Neovim/share/nvim/runtime/"
let g:python3_host_prog = 'C:/PythonShortcut/python.exe'
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
set wildmode=longest,list
set cc=80
filetype plugin indent on
set clipboard=unnamedplus
filetype plugin on
set splitright
set splitbelow
set termguicolors

" Set Neovide Setings
if exists("g:neovide")
    autocmd VimEnter * silent! cd C:\01_Workspace
    set guifont=Cascadia\ Code:h11
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
call plug#begin($HOME . '\AppData\Local\nvim\plugged') 
Plug 'nvimdev/dashboard-nvim'
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/toggleterm.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'Exafunction/codeium.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'kylechui/nvim-surround'
Plug 'lowitea/aw-watcher.nvim'

Plug 'nanozuki/tabby.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'levouh/tint.nvim'
Plug 'beauwilliams/focus.nvim'

Plug 'ryanoasis/vim-devicons'

Plug 'zaldih/themery.nvim'
Plug 'morhetz/gruvbox'
Plug 'slugbyte/lackluster.nvim'
Plug 'mellow-theme/mellow.nvim'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/everforest'
Plug 'sho-87/kanagawa-paper.nvim'
Plug 'dgox16/oldworld.nvim'
Plug 'Skalyaeve/a-nvim-theme'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'catppuccin/nvim', {'as': 'catpuccin'}
Plug 'maxmx03/fluoromachine.nvim'
call plug#end()

" Plugin Setup

let g:bookmark_no_default_key_mappings = 1
let g:bookmark_auto_save = 1
let g:bookmark_manage_per_buffer = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1
let g:bookmark_display_annotation = 1
let g:bookmark_auto_close = 1

lua << EOF
local nvim_tree = require('nvim-tree')
nvim_tree.setup{}

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
local bundle_path = 'C:/05_Support/powershell/PowerShellEditorServices/PowerShellEditorServices'

 lspconfig.powershell_es.setup {
  on_attach = on_attach,
  cmd = {
    'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.EXE',
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
 
vim.g.ale_linters = { rust = { 'cargo', 'clippy' } }
vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = { rust = { 'rustfmt' } }
vim.g.ale_open_list = 1
vim.g.ale_sign_error = '✗'
vim.g.ale_sign_warning = '⚠'

local surround = require('nvim-surround')
surround.setup{}

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

local toggleterm = require('toggleterm')
toggleterm.setup({
    size = 20,
    open_mapping = [[<C-\>]], -- Customize this to your preferred keybinding
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal", -- Options: 'vertical', 'horizontal', 'float'
})

local db = require('dashboard')
db.setup({
  theme = 'doom',
  config = {
    header = {
      '',
      '',
      '',
      '',
      ' _   _            _   _ _           ',
      '| \\ | |          | | | (_)          ',
      '|  \\| | ___  ___ | | | |_ _ __ ___  ',
      '| . ` |/ _ \\/ _ \\| | | | | \'_ ` _ \\ ',
      '| |\\  |  __/ (_) \\ \\_/ / | | | | | |',
      '\\_| \\_/\\___|\\___/ \\___/|_|_| |_| |_|',
      '                                    ',
      '                                    ',
    },
    center = {
      { icon = '  ', desc = 'File Browser        ', action = 'NvimTreeToggle', key = 'b' },
      { icon = '  ', desc = 'Find Files          ', action = 'Files', key = 'f' },
      { icon = '  ', desc = 'Recent files        ', action = 'History', key = 'r' },
      { icon = '  ', desc = 'New file            ', action = 'enew', key = 'n' },
      { icon = '  ', desc = 'Custom Shortcuts    ', action = 'ShowShortcuts', key = 's' },
      { icon = '  ', desc = 'ToggleTerm          ', action = 'ToggleTerm', key = 'o' },
      { icon = '  ', desc = 'Plugin Status       ', action = 'PlugStatus', key = 'p' },
      { icon = '  ', desc = 'Update Plugins      ', action = 'PlugUpdate', key = 'u' },
      { icon = '  ', desc = 'Reload Config       ', action = 'source $MYVIMRC', key = 'v' },
      { icon = '  ', desc = 'Change Theme        ', action = 'Themery', key = 't' },
      { icon = '  ', desc = 'Settings            ', action = 'edit $MYVIMRC', key = 'c' },
      { icon = '  ', desc = 'Quit                ', action = 'q', key = 'q' },
    },
    footer = { '✪ Neovim_SarahYack' },
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
  tabline = {
    hl = 'TabLine',
    layout = 'active_wins_at_tail',
    head = {
      { '  ', hl = 'TabLineSel' },
      { 'Neovim', hl = 'TabLine' },
      { '', hl = 'TabLineFill' },
    },
    active_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = 'TabLineSel',
        }
      end,
      left_sep = { '', hl = 'TabLineSel' },
      right_sep = { '', hl = 'TabLineFill' },
    },
    inactive_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = 'TabLine' },
      right_sep = { '', hl = 'TabLineFill' },
    },
    top_win = {
      label = function(winid)
        return {
          '  ' .. vim.api.nvim_win_get_number(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = 'TabLine' },
      right_sep = { '', hl = 'TabLineFill' },
    },
    win = {
      label = function(winid)
        return {
          '  ' .. vim.api.nvim_win_get_number(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = 'TabLine' },
      right_sep = { '', hl = 'TabLineFill' },
    },
    tail = {
      { '', hl = 'TabLineFill' },
      { ' 🐾 ', hl = 'TabLine' },
    },
  }
}

function SetTabbyMode(mode)
  if mode == "tabs" then
    require('tabby').setup {
      tabline = require('tabby.presets').tab_only,
    }
    print("Switched to Tabs Mode")
  elseif mode == "buffers" then
    require('tabby').setup {
      tabline = require('tabby.presets').buffer_tabs,
    }
    print("Switched to Buffers Mode")
  else
    print("Invalid mode! Use 'tabs' or 'buffers'.")
  end
end

vim.keymap.set('n', '<leader>mt', function() SetTabbyMode("tabs") end, {noremap = true, silent = true, desc = "Switch to Tab Display - Tabby"})
vim.keymap.set('n', '<leader>mb', function() SetTabbyMode("buffers") end, {noremap=true, silent=true, desc = "Switch to Buffer Display - Tabby"})

local lualine = require('lualine')
lualine.setup({
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
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

local zen = require'zen-mode'
zen.setup({
    window = {
        width = 0.50,
        height = 1.0,
        options = {
            signcolumn = "no",
            number = true,
            relativenumber = false,
        },
    },
})

local tint = require'tint'
tint.setup({
    tint = -60,
    saturation = 0.4,
})

local themery = require'themery'
themery.setup({
    themes = {"gruvbox",
    "lackluster",
    "mellow",
    "gruvbox-material",
    "everforest",
    "kanagawa-paper",
    "oldworld",
    "neon",
    "cyberdream",
    "fluoromachine",
    "catppuccin-latte",
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    },
    livePrevew = true,
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
    "4. Dashboard",
    "5. Quit/Save",
    "6. Config/Commands",
    "7. File Management",
    "8. Tabs",
    "9. Buffers",
    "10. Modes/Settings Toggles",
    "11. Plugins",
    "12. Git",
    "13. Fuzzy Finder/Search",
    "14. Theme and Appearance",
    "15. File Explorer",
    "16. NvimTree",
    "17. Shortcut Help (This Window)",
    "",
    "-- Window/Split Management",
    "--------------------",
    "<Leader>v   - Vertical Split",
    "<Leader>h   - Horizontal Split",
    "<A-h>       - Move Split Left",
    "<A-j>       - Move Split Down",
    "<A-k>       - Move Split Up",
    "<A-l>       - Move Split Right",
    "<C-h>       - Move to Left Split",
    "<C-j>       - Move to Lower Split",
    "<C-k>       - Move to Upper Split",
    "<C-l>       - Move to Right Split",
    "<C-\\>       - Toggle Terminal",
    "",
    "-- Editing",
    "--------------------",
    "<C-A>       - Copy All",
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
    "-- Dashboard",
    "--------------------",
    "<Leader>D   - Open Dashboard",
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
    "<Leader>wa  - Save All Buffers",
    "",
    "-- Tabs",
    "--------------------",
    "<Leader>tn  - Next Tab",
    "<Leader>tp  - Previous Tab",
    "<Leader>ts  - Switch to Specific Tab",
    "<Leader>to  - Open New Tab",
    "<Leader>tc  - Close Current Tab",
    "",
    "-- Buffers",
    "--------------------",
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
    "<Leader>mln - Toggle Relative Numbers",
    "<Leader>mlf - Change Line Ending Format - LF",
    "<Leader>ms  - Toggle Spell Check",
    "<Leader>mw  - Toggle Wrap",
    "<Leader>mt  - Switch to Tab Display - Tabby",
    "<Leader>mb  - Switch to Buffer Display - Tabby",
    "<Leader>z   - Toggle Zen Mode",
    "<Leader>f   - Focus Toggle",
    "<Leader>fe  - Focus Equalize",
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
    "<Leader>en  - Next Error",
    "<Leader>ep  - Previous Error",
    "<Leader>ean - Next ALE Error",
    "<Leader>eap - Previous ALE Error",
    "<Leader>ef  - ALE Fix",
    "<Leader>el  - Set Error List",
    "<Leader>eq  - Set Quickfix List",
    "",
    "-- Git",
    "--------------------",
    "<Leader>gs  - GitSigns Stage Hunk",
    "<Leader>gu  - GitSigns Undo Stage Hunk",
    "<Leader>gp  - GitSigns Preview Hunk",
    "",
    "-- Fuzzy Finder/Search",
    "--------------------",
    "<Leader>sf  - FZF Find Files",
    "<Leader>sr  - FZF Recent Files",
    "<Leader>sg  - FZF Live Grep",
    "<Leader>ssg - FZF Word Search with Prompt",
    "<Leader>sb  - FZF Buffers",
    "<Leader>sh  - FZF Help Tags",
    "<Leader>st  - FZF Tags",
    "<Leader>sc  - FZF Commands",
    "",
    "-- Theme and Appearance",
    "--------------------",
    "<Leader>cs  - Open Themery",
    "<Leader>o1  - Set Transparency to 0.0",
    "<Leader>o2  - Set Transparency to 0.2",
    "<Leader>o3  - Set Transparency to 0.4",
    "<Leader>o4  - Set Transparency to 0.6",
    "<Leader>o5  - Set Transparency to 0.8",
    "<Leader>o6  - Set Transparency to 1.0",
    "",
    "-- File Explorer",
    "--------------------",
    "<C-n>       - Toggle NvimTree",
    "<Leader>pwd - Print CWD",
    "<Leader>cd  - Set CWD",
    "<Leader>ld  - Set LWD",
    "",
    "-- NvimTree",
    "--------------------",
    "g?          - View Mappings",
    "<Leader>ntr - Refresh NvimTree",
    "<Leader>ntf - Find File in NvimTree",
    "<Leader>ntu - Focus NvimTree",
    "<Leader>ntc - Collapse NvimTree",
    "<Leader>ntC - Collapse NvimTree Keep Buffers",
    "<Leader>nts - Resize NvimTree",
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
  vim.api.nvim_buf_set_keymap(buf, 'n', '4', ':lua GoToSection("-- Dashboard")<CR>', { noremap = true, silent = true })
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
  vim.api.nvim_buf_set_keymap(buf, 'n', '17', ':lua GoToSection("-- NvimTree")<CR>', { noremap = true, silent = true })
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

" function! ShowBookmarksInBuffer()
"     let signs = sign_getplaced(bufnr('%'), {'group': ''})[0].signs

"     if empty(signs)
"         echo "No bookmarks in this buffer."
"     else
"         for sign in signs
"             if sign.name == 'Bookmark'
"                 let line_content = getline(sign.lnum)
"                 echo printf("Line %d: %s", sign.lnum, line_content)
"             endif 
"         endfor
"     endif
" endfunction 

" Key Remappings

" Window/Split Management
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>
nnoremap <A-h> <C-W>H
nnoremap <A-j> <C-W>J
nnoremap <A-k> <C-W>K
nnoremap <A-l> <C-W>L
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Editing
nnoremap <C-a> ggvGy
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

" Dashboard
nnoremap <leader>D :Dashboard<CR>

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
nnoremap <leader>wa :wa<CR>

" Tabs
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>ts :tabn<Space>
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>

" Buffers
nnoremap <leader>bb :ls<CR>
nnoremap <leader>be :enew<CR>
nnoremap <leader>bo :e<Space>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bs :b<Space>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :bprev \| if buflisted(bufnr('#')) \| bdelete # \| endif<CR>
nnoremap <leader>bc :%bd\|e#<CR>

" Modes/Settings Toggles
nnoremap <leader>mln :set relativenumber!<CR>
nnoremap <leader>mlf :set fileformat=unix<CR>
nnoremap <leader>ms :set spell!<CR>
nnoremap <leader>mw :set wrap!<CR>
nnoremap <leader>z :ZenMode<CR>
nnoremap <leader>f :FocusToggle<CR>
nnoremap <leader>fe :FocusEqualise<CR>

" Plugin Management
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>ps :PlugStatus<CR>

" Errors
nnoremap <leader>en :lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>ep :lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>ean :ALENext<CR>
nnoremap <leader>eap :ALEPrevious<CR>
nnoremap <leader>ef :ALEFix<CR>
nnoremap <leader>el :lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>eq :lua vim.diagnostic.setqflist()<CR>

" Git
nnoremap <leader>gs :GitSigns stage_hunk<CR>
nnoremap <leader>gu :GitSigns undo_stage_hunk<CR>
nnoremap <leader>gp :GitSigns preview_hunk<CR>

" Fuzzy Finder/Search
nnoremap <leader>sf :Files<CR>
nnoremap <leader>sr :History<CR>
nnoremap <leader>sg :Rg<CR>
nnoremap <leader>ssg :Rg<Space>
nnoremap <leader>sb :Buffers<CR>
nnoremap <leader>sh :Helptags<CR>
nnoremap <leader>st :Tags<CR>
nnoremap <leader>sc :Commands<CR>

" Theme and Appearance
nnoremap <leader>cs :Themery<CR>

" File Explorer
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>ntr :NvimTreeRefresh<CR>
nnoremap <leader>ntf :NvimTreeFindFile<CR>
nnoremap <leader>ntu :NvimTreeFocus<CR>
nnoremap <leader>ntc :NvimTreeCollapse<CR>
nnoremap <leader>ntC :NvimTreeCollapseKeepBuffers<CR>
nnoremap <leader>nts :NvimTreeResize<Space>
nnoremap <leader>pwd :pwd<CR>
nnoremap <leader>cd :cd<Space>
nnoremap <leader>lcd :lcd<Space>

" Theme Settings

highlight Comment cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Function cterm=italic gui=italic
highlight Type cterm=italic gui=italic

