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

# Install stow and python
# - We need to manually specify the paths because this happens before symlinking everything
# - We want our proper python setup before doing pip installs
# https://www.gnu.org/software/stow/
# https://formulae.brew.sh/formula/python@3.11

python_versions=(python@3 python@3.10)

if chip_is apple_silicon; then
	/opt/homebrew/bin/brew install "${python_versions[@]}" stow

	# Make brew and stow available when symlinking
	export PATH="/opt/homebrew/bin:$PATH"
	sudo ln -sf /opt/homebrew/bin/python3 /opt/homebrew/bin/python
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
