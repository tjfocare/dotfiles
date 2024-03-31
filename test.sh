#!/usr/bin/env zsh

# NOTE: Makes use of the global environment variable
# HAS_TEST_SUITE_PASSED to determine if the test suite
# has passed or not. This is set to true at the start
# of the test suite and set to false if any test fails.

source helpers.sh
source test_functions.sh

export HAS_TEST_SUITE_PASSED=true
DEBUG_INFO=false

# Essentials
assert_success 'curl --version'
# assert_success 'wget --version'
# assert_success 'cmake --version'
assert_success 'git --version'
assert_success 'zsh --version'
assert_success 'brew --version'
assert_success 'stow --version'

# Python and python package managers
assert_success 'python3 --version'
assert_success 'pip3 --version'
assert_success 'pipx --version'
assert_success 'poetry --version'

# Check that we're using the homebrew version of zsh (not /bin/zsh)
assert_result_like 'which zsh' "$(brew --prefix)/bin/zsh"

if os_is mac; then
	# Check that python and pip are installed in the right place
	assert_result_like 'which python3' "$(brew --prefix)/bin/python3"
	assert_result_like 'which pip3' "$(brew --prefix)/bin/pip3"
	# Check our laassert_success GNU overrides are working on mac
	# assert_result_like 'which make' "$(brew --prefix)/opt/make/libexec/gnubin/make"
	# assert_result_like 'which sed' "$(brew --prefix)/opt/gnu-sed/libexec/gnubin/sed"
	# Check that tmux-256color is installed
	# assert_success 'infocmp -x tmux-256color'
fi

# assert_success 'git-credential-manager --version'
# assert_success_zsh 'abbr --version'
# assert_success_zsh 'p10k help'
# assert_success_zsh 'fzf --version'
# assert_zsh_completion 'tar'   # Default that comes with zsh
# assert_zsh_completion 'git'   # Default that comes with zsh
# assert_zsh_completion 'rails' # Comes installed with zsh-completions
# assert_success 'go version'

# Node
assert_success 'node --version'
assert_success 'npm --version'

# Yarn
assert_success 'corepack --version'
assert_success 'yarn --version'

# Rust
# assert_success 'rustup --version'
# assert_success 'cargo --version'

# Ruby and rbenv
# eval "$(rbenv init - bash)"
# assert_success 'rbenv --version'
# assert_result_like 'ruby --version' "3.1.4"

# Terminal handy tools
assert_success 'vim --version'
# assert_success 'tmux -V'
# assert_success 'tig --version'
# assert_success 'eza --version'
assert_success 'bat --version'
# assert_success 'rg --version'
# assert_success 'type neofetch'
# assert_success 'tmuxinator version'
# assert_success 'perl --version'
# assert_success 'cpanm --version'
# assert_result_like 'which perl' "$(brew --prefix)/bin/perl"   # We want the homebrew
# assert_result_like 'which cpanm' "$(brew --prefix)/bin/cpanm" # perl and cpanm
# assert_success 'dua --version'
# assert_success 'just --version'

# Neovim
# assert_success 'nvim --version'

# AWS
assert_success 'aws --version'
# assert_success 'cdk --version'

# Github
# assert_success 'gh --version'

assert_success 'docker --version'

# Print out some useful info during the CI build
if [ $DEBUG_INFO = true ]; then
	echo "Current directory: $(pwd)"
	echo "Home directory: $(ls ~)"
	echo "PATH = $PATH"
	ls -al /usr/local/bin
fi

# Check that git config is set correctly
if [ -d $PATH_REPO ]; then
	(cd $PATH_REPO && assert_result_like 'git config user.email' 'tomf@teamrtd.com')
fi
(cd $PATH_REPO/dotfiles && assert_result_like 'git config user.email' 'tjfocare@gmail.com')

# assert_no_git_changes

if [ $HAS_TEST_SUITE_PASSED = false ]; then
	printf "\n\e[1;31mTests failed\e[0m\n"
	exit 1
else
	printf "\n\e[1;32mTests passed\e[0m\n"
fi
