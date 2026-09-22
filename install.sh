#!/usr/bin/env zsh

set -e # Fail the script if any installs fail
set -x # Print each command as it runs

# shellcheck source=/dev/null
source helpers.sh

if ! os_is mac; then
	echo 'Not running on mac, exiting...'
	exit 1
fi

# Install Homebrew - https://brew.sh/
if ! package_installed brew; then
	NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install stow, which we need before symlinking anything
# - We use the full brew path because ~/.zshrc isn't symlinked yet, so
#   /opt/homebrew/bin isn't on PATH
# - Python is NOT installed here. uv owns Python entirely, and uv is installed
#   later from the Brewfile. See application_install.sh
# https://www.gnu.org/software/stow/

if chip_is apple_silicon; then
	/opt/homebrew/bin/brew install stow

	# Make brew and stow available when symlinking
	export PATH="/opt/homebrew/bin:$PATH"
fi

# Clone setup git repos here
mkdir -p "$HOME/opt"

# Setup dotfiles
./symlink.sh || { exit 1; }

echo ''
echo 'Installing applications...'
zsh --login -ic "./application_install.sh"

echo ''
echo 'Running tests...'
zsh --login -ic "./test.sh"
