# 1) .zshenv - Should only contain user’s environment variables.
# 2) .zprofile - Can be used to execute commands just after logging in.
# 3) .zshrc - Should be used for the shell configuration and for executing commands.
# 4) .zlogin - Same purpose than .zprofile, but read just after .zshrc.
# 5) .zlogout - Can be used to execute commands when a shell exit.

# Only export should be here
pipx_path=$HOME/.local/bin
export PATH="$PATH:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.scripts/:$pipx_path"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

###### oh-my-zsh ######

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(
  aws
  command-not-found
  docker
  git
  gitfast
  git-auto-fetch
  git-prompt
  history
  npm
  node
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting # must be last plugin
)

GIT_AUTO_FETCH_INTERVAL=1200 # (20 mins)

source $ZSH/oh-my-zsh.sh

###### Custom aliases/functions ######

# Load custom aliases
if [ -f $HOME/.aliases ]; then
  source $HOME/.aliases
fi

# Load custom functions
if [ -f $HOME/.aliases ]; then
  source $HOME/.functions
fi

###### Application-specific setup #####

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Broot
source $HOME/.config/broot/launcher/bash/br

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# Fuzzy search finder - fzf
# Adds to PATH, inits auto-completion
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# fzf theme
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Better find - fd
# -- Use fd instead of find for fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo $'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
