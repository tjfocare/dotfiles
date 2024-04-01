#!/usr/bin/env zsh

set -e # Fail the script if any installs fail
set -x # Print each command as it runs

# shellcheck source=/dev/null
source helpers.sh

# Install Homebrew
# https://brew.sh/
if ! package_installed brew; then
	NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install stow and python
# - We need to manually specify the paths because this happens before symlinking everything
# - We want our proper python setup before doing pip installs
# https://www.gnu.org/software/stow/
# https://formulae.brew.sh/formula/python@3.11

python_versions=(python@3 python@3.12 python@3.11 python@3.9)

if os_is mac && chip_is apple_silicon; then
	/opt/homebrew/bin/brew install "${python_versions[@]}" stow

	# Make brew and stow available when symlinking
	export PATH="/opt/homebrew/bin:$PATH"
	# sudo ln -s /opt/homebrew/bin/python3 /opt/homebrew/bin/python
fi

# Create ~/opt directory so that symlinking doesn't
# put the cloned git repos in our dotfiles repo
mkdir -p "$HOME/opt"

# Setup dotfiles
./symlink.sh || { exit 1; }

echo ''
echo 'Installing applications...'
zsh --login -ic "./post_install.sh"

echo ''
echo 'Running tests...'
zsh --login -ic "./test.sh"
