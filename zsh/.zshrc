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
