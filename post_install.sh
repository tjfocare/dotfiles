#!/usr/bin/env bash

set -e # Fail the script if any installs fail
set -x # Print each command as it runs
source helpers.sh

if ! os_is mac; then
	echo 'Not running on mac, exiting...'
	exit 1;
fi

xcode-select --install || true

if [ ! -d "/Users/tomfocareta/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi;

# Homebrew apps
# https://pypa.github.io/pipx
# https://github.com/sharkdp/bat - cat clone
brew bundle install --file=~/Brewfile

homebrew_apps=(
	appcleaner
	bitwarden
	keepingyouawake
	monitorcontrol
	notion
	scroll-reverser
	spotify
	tableplus
)
for app_cask in "${homebrew_apps[@]}"; do
	if have_not_installed_cask "$app_cask"; then
		brew install --cask "$app_cask"
	fi;
done

pipx ensurepath
pipx_install poetry # https://python-poetry.org

# NVM node manager https://github.com/nvm-sh/nvm
if have_not_installed node; then
	PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
	# shellcheck source=/dev/null
	# Make sure nvm is loaded
	. ~/.zprofile || true
	nvm install --lts # Install the latest LTS version of node
	nvm use --lts
	nvm alias default "lts/*"
	npm install --global npm@latest
	corepack enable
fi

# zsh-abbr https://zsh-abbr.olets.dev/installation.html
# if no_directory_exists_at "$HOME/opt/zsh-abbr"; then
# 	rm -rf "$HOME/opt/zsh-abbr"
# 	git clone https://github.com/olets/zsh-abbr --single-branch --branch main --depth 1 "$HOME/opt/zsh-abbr"
# fi

# Powerlevel10k https://github.com/romkatv/powerlevel10k#installation
# if no_directory_exists_at "$HOME/opt/powerlevel10k"; then
# 	rm -rf "$HOME/opt/powerlevel10k"
# 	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/opt/powerlevel10k"
# fi

# Fzf https://github.com/junegunn/fzf/
# if no_directory_exists_at "$HOME/opt/fzf"; then
# 	rm -rf "$HOME/opt/fzf"
# 	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/opt/fzf"
# 	"$HOME/opt/fzf/install" --bin --no-update-rc
# fi

# ZSH extra completions https://github.com/zsh-users/zsh-completions
# if no_directory_exists_at "$HOME/opt/zsh-completions"; then
# 	rm -rf "$HOME/opt/zsh-completions"
# 	git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$HOME/opt/zsh-completions"
# fi

# Golang
# if have_not_installed go; then
# 	go_version="1.22.1"
# 	if os_is mac && chip_is apple_silicon; then
# 		wget "https://go.dev/dl/go${go_version}.darwin-arm64.tar.gz" -O "go.tar.gz"
# 	fi
# 	tar -C "$HOME/opt" -xzf go.tar.gz
# 	rm go.tar.gz
# fi

# NOTE: These take a long time
# Ruby and rbenv
# https://github.com/rbenv/rbenv
# default_ruby_version=3.1.4
# if have_not_installed rbenv; then
# 	brew_install rbenv
# 	brew_install ruby-build
# fi
# eval "$(rbenv init - bash)"

# if os_is mac; then
# 	rbenv install --skip-existing $default_ruby_version
# 	rbenv global $default_ruby_version
# fi

# Terminal handy tools
# os_install tmux   # https://github.com/tmux/tmux
# os_install tig    # https://github.com/jonas/tig
# cargo_install eza # https://github.com/eza-community/eza - ls clone
# os_install ncdu   # https://dev.yorhel.nl/ncdu

# Formatters and linters
pipx_install ruff           # https://github.com/astral-sh/ruff 
pipx_install isort          # https://pycqa.github.io/isort/
pipx_install pyright        # https://github.com/microsoft/pyright
# gem_install rubocop         # https://github.com/rubocop/rubocop

# AWS
if have_not_installed aws; then
	# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
	if os_is mac; then
		curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
		sudo installer -pkg AWSCLIV2.pkg -target /
		rm AWSCLIV2.pkg
	fi
fi

# Github CLI
# brew_install gh

# Global Ruby gems
# gem_install rails # https://github.com/rails/rails
# yard gems || true # Generate documentation for all installed gems (for solargraph)
# yard gems         # Need to run it twice because the first one fails (annoyingly)

# Docker
if have_not_installed docker; then
	# https://docs.docker.com/desktop/install/mac-install/
	softwareupdate --install-rosetta --agree-to-license
	curl -o Docker.dmg "https://desktop.docker.com/mac/main/arm64/Docker.dmg"
	sudo hdiutil attach Docker.dmg
	sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license
	sudo hdiutil detach /Volumes/Docker
fi

# Final cleanup steps
brew cleanup
brew autoremove

set +x

echo "------------------------------"
echo "Final steps:"