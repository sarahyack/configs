
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="candy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "amuse" "aussiegeek" "bureau" "candy" "eastwood" "half-life" "juanghurtado" "linuxonly" "mortalscumbag" "nanotech" "simonoff" "sorin" "strug" "ys" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo web-search copypath copyfile copybuffer dirhistory history jsontools command-not-found)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Usage:
#   bannerize {-f|--figlet|-t|--toilet} [--lolcat] [--] text...
#   bannerize -f "Hello world"
#   bannerize -t -- "text that starts with -"

bannerize() {
  tool=figlet
  use_lolcat=0

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--figlet) tool=figlet; shift ;;
      -t|--toilet) tool=toilet; shift ;;
      --lolcat)    use_lolcat=1; shift ;;
      --) shift; break ;;
      -h|--help)
        printf 'Usage: bannerize {-f|--figlet|-t|--toilet} [--lolcat] [--] text...\n'
        return 0 ;;
      *) break ;;
    esac
  done

  [ "$#" -gt 0 ] || { printf 'Give me some text to shout! 🗣️\n' >&2; return 1; }
  command -v "$tool" >/dev/null 2>&1 || { printf 'Missing: %s\n' "$tool" >&2; return 2; }

  if [ "$use_lolcat" -eq 1 ] && command -v lolcat >/dev/null 2>&1; then
    "$tool" "$@" | lolcat
  else
    "$tool" "$@"
  fi
}

lsdlol() {
  # Find the real lsd binary (ignore aliases/functions)
  local lsd_bin
  lsd_bin="$(type -P lsd 2>/dev/null || whence -p lsd 2>/dev/null || command -v lsd)" \
    || { printf 'lsd not found in PATH\n' >&2; return 127; }

  if command -v unbuffer >/dev/null 2>&1; then
    # PTY via unbuffer -> columns preserved
    unbuffer "$lsd_bin" --color=always "$@" | lolcat
  else
    # Fallback PTY via script; safely quote args
    local a q=""
    for a in "$@"; do q="$q $(printf '%q' "$a")"; done
    script -qfc "$lsd_bin --color=always$q" /dev/null | lolcat
  fi
}

cowwide() {
  # figure out columns (tmux pane → kitty window → fallback)
  local cols
  cols="${COLUMNS:-$(tmux display -p '#{pane_width}' 2>/dev/null || tput cols 2>/dev/null || echo 80)}"

  # leave a little margin so the bubble doesn't kiss the edge
  local margin="${COW_MARGIN:-8}"
  local w=$((cols - margin))
  [ "$w" -lt 20 ] && w=20   # don't go too tiny

  # if you explicitly pass -W, don't override it
  for a in "$@"; do
    case "$a" in -W|-W*) cowsay "$@"; return ;; esac
  done

  cowsay -W "$w" "$@"
}

toiletfonts() {
    for f in /usr/share/figlet/*.[tf]lf; do toilet {,-f}$f:r:t; done
}

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

export PATH="$HOME/bin:$PATH"
export WORKDRIVE="/mnt/hive"
export HIVE="/mnt/hive"
export PROJECTS="/mnt/hive/Projects"
export WORK="/mnt/hive/Work"
export VAULTS="/mnt/hive/Documents/Vaults"
export EDITOR="nvim"
export BROWSER="thorium"
export ZSHRC="/home/sarah/.zshrc"
export KITTY_CONFIG="/home/sarah/.config/kitty/kitty.conf"
export FETCH_CONFIG="/home/sarah/.config/fastfetch/config.jsonc"
export TMUX_CONFIG="/home/sarah/.tmux.conf"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

alias zconf="nvim $ZSHRC"
alias rz="exec zsh"
alias cl="clear"
alias x="exit"
alias ls="lsdlol"
alias lsd="lsdlol"
alias fetch="fastfetch | lolcat"
alias parrot="curl parrot.live"
alias tell="bannerize --lolcat"
alias say="cl; fortune | cowwide -f $(ls /usr/share/cowsay/cows/ | shuf -n 1) | lolcat"
alias turt="cl; fortune | cowwide -f turtle | lolcat"
alias cup="cl; fortune | cowwide -f cupcake | lolcat"
alias blow="cl; fortune | cowwide -f blowfish | lolcat"
alias cdh="cd $HIVE"
alias cdw="cd $WORK"
alias cdv="cd $VAULTS"
alias cdp="cd $PROJECTS"
alias kconf="nvim $KITTY_CONFIG"
alias fconf="nvim $FETCH_CONFIG"
alias check="sudo timeshift --check"
# alias tconf="nvim $TMUX_CONFIG"
# alias t="tmux"
# alias tls="tmux list-sessions"
# alias tlw="tmux list-windows"
# alias tlp="tmux list-panes"
# alias tlb="tmux list-buffers"
# alias tlc="tmux list-clients"
# alias tlk="tmux list-keys"
# alias ta="tmux attach"
# alias tat="tmux attach -t"
# alias tks="tmux kill-server"
alias backupConfigs="backupConfigs.sh"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

# --- fish-style inline suggestions (history) ---
# Load zsh-autosuggestions (try common package paths)
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Make it visible and use history
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#2d1768'

# Load syntax highlighting LAST
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

cl ; echo "Hello Sarah ..." | toilet -t | lolcat
echo ""

# cl ; echo "Hello Sarah ..." | toilet -t 
# echo ""

# pwd | toilet -f smbraille | lolcat

# echo ""

# lsdlol

# echo "" | lolcat
# echo "" | lolcat
