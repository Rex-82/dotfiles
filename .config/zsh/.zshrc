if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

eval "$(zellij setup --generate-auto-start zsh)"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Source pathos for $PATH management
source $HOME/pathos.sh

# Add exports
[ -f  "${XDG_CONFIG_HOME}/zsh/.zsh_exports" ] && source "${XDG_CONFIG_HOME}/zsh/.zsh_exports"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice lucid wait'0'
# zinit light joshskidmore/zsh-fzf-history-search
zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
zinit light g-plane/pnpm-shell-completion
zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin
zinit load atuinsh/atuin

# Add in better Vi-mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::nvm
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::ng/_ng
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && (compinit &)

zinit cdreplay -q

# To customize prompt, run oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

# Keybindings
# bindkey -v
bindkey '^[^k' atuin-search
bindkey '^[^j' atuin-up-search
bindkey '^[^l' autosuggest-accept
# bindkey '^[w' kill-region

# History
HISTSIZE=50000
HISTFILE=$XDG_CONFIG_HOME/zsh/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
[ -f  "$HOME/.config/zsh/.zsh_aliases" ] && source "$HOME/.config/zsh/.zsh_aliases"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

# pnpm
export PNPM_HOME="/home/simone/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

