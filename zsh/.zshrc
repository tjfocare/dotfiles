# 1) .zshenv - Should only contain user’s environment variables.
# 2) .zprofile - Can be used to execute commands just after logging in.
# 3) .zshrc - Should be used for the shell configuration and for executing commands.
# 4) .zlogin - Same purpose than .zprofile, but read just after .zshrc.
# 5) .zlogout - Can be used to execute commands when a shell exit.

# Only export should be here
pipx_path=/Users/tomfocareta/.local/bin
export PATH="$PATH:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.scripts/:$pipx_path"

###############################
### Zsh config START        ###
###############################

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
  zsh-syntax-highlighting
)

# git-auto-fetch period (20 mins)
GIT_AUTO_FETCH_INTERVAL=1200

source $ZSH/oh-my-zsh.sh

###############################
### Zsh config END          ###
###############################

###############################
### User configuration      ###
###############################

# Load custom aliases
if [ -f $HOME/.aliases/.functions ]; then
  source $HOME/.aliases/.aliases
fi

# Load custom functions
if [ -f $HOME/.aliases/.functions ]; then
  . $HOME/.aliases/.functions
fi

###### Application-specific setup #####

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Broot
source $HOME/.config/broot/launcher/bash/br

# Enable Python version management.
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

source /Users/tomfocareta/.config/broot/launcher/bash/br

export PATH_REPO="$HOME/repositories"
