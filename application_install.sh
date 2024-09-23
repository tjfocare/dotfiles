#!/usr/bin/env zsh

set -e # Fail the script if any installs fail
# set -x # Print each command as it runs
source helpers.sh

xcode-select --install || true

if ! directory_exists $HOME/.oh-my-zsh; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if ! directory_exists $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if ! directory_exists $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Homebrew apps
brew bundle install --file=~/Brewfile

homebrew_desktop_apps=(
	appcleaner
	bitwarden
	discord
	keepingyouawake
	monitorcontrol
	notion
	qlmarkdown # https://github.com/sbarex/QLMarkdown
	scroll-reverser
	syntax-highlight # https://github.com/sbarex/SourceCodeSyntaxHighlight
	spotify
	tableplus
)
for app_cask in "${homebrew_desktop_apps[@]}"; do
	if ! app_installed "$app_cask"; then
		brew install --cask "$app_cask"
	fi
done

# NVM node manager https://github.com/nvm-sh/nvm
if ! package_installed node; then
	PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
	# shellcheck source=/dev/null
	# Make sure nvm is loaded
	. ~/.zprofile || true
	nvm install --lts # Install the latest LTS version of node
	nvm use --lts
	nvm alias default "lts/*"
	corepack enable
fi

# fzf-git
if ! directory_exists "$HOME/opt/fzf-git"; then
	rm -rf "$HOME/opt/fzf-git"
	git clone https://github.com/junegunn/fzf-git.sh.git --single-branch --branch main --depth 1 "$HOME/opt/fzf-git"
fi

pipx ensurepath
# pipx_install poetry # https://python-poetry.org

pipx_install ruff    # https://github.com/astral-sh/ruff
pipx_install isort   # https://pycqa.github.io/isort/
pipx_install pyright # https://github.com/microsoft/pyright

# AWS
if ! package_installed aws; then
	# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
	sudo installer -pkg AWSCLIV2.pkg -target /
	rm AWSCLIV2.pkg
fi

# Docker
if ! package_installed docker; then
	# https://docs.docker.com/desktop/install/mac-install/
	softwareupdate --install-rosetta --agree-to-license
	curl -o Docker.dmg "https://desktop.docker.com/mac/main/arm64/Docker.dmg"
	sudo hdiutil attach Docker.dmg
	sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license
	sudo hdiutil detach /Volumes/Docker
fi

# Fonts
font="RobotoMono"
if ! directory_exists $HOME/Library/Fonts/$font; then
	curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip -o $HOME/opt/$font.zip
	unzip -q $HOME/opt/$font.zip -d ~/Library/Fonts/$font
	rm -rf $HOME/opt/$font.zip
fi

# Rust and Cargo https://www.rust-lang.org/tools/install
if ! package_installed rustup; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	source "$HOME/.cargo/env"
fi

# Zellij terminal multiplexer
rustup update
cargo install --locked zellij

# Final cleanup steps
brew cleanup
brew autoremove

set +x

echo "------------------------------"
echo "Successfully installed dependencies and applications ✅"
