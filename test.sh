#!/usr/bin/env zsh

# NOTE: Makes use of the global environment variable
# HAS_TEST_SUITE_PASSED to determine if the test suite
# has passed or not. This is set to true at the start
# of the test suite and set to false if any test fails.

source helpers.sh
source test_functions.sh

export HAS_TEST_SUITE_PASSED=true
DEBUG_INFO=false

# Check that we're using the homebrew version of zsh (not /bin/zsh)
assert_result_like 'which zsh' "$(brew --prefix)/bin/zsh"

# Essentials
assert_success 'git --version'
assert_success 'zsh --version'
assert_success 'brew --version'
assert_success 'stow --version'

# Python and python package managers
assert_success 'python --version'
assert_success 'python3 --version'
assert_success 'pip3 --version'
assert_success 'pipx --version'
assert_success 'poetry --version'
assert_success 'pyenv --version'

assert_result_like 'python --version' "3"
assert_result_like 'python3 --version' "3"
assert_result_like 'which python3' "opt/homebrew/bin/python3"
assert_result_like 'which pip3' "opt/homebrew/bin/pip3"

assert_success_zsh 'fzf --version'
assert_success_zsh 'fd --version'
assert_success_zsh 'jq --version'
# assert_zsh_completion 'tar'   # Default that comes with zsh
# assert_zsh_completion 'git'   # Default that comes with zsh
# assert_zsh_completion 'rails' # Comes installed with zsh-completions
# assert_success 'go version'

# Node
assert_success 'node --version'
assert_success 'npm --version'

# Rust
assert_success 'rustup --version'
assert_success 'cargo --version'

# Ruby and rbenv
# eval "$(rbenv init - bash)"
# assert_success 'rbenv --version'
# assert_result_like 'ruby --version' "3.1.4"

# Terminal handy tools
assert_success 'eza --version'
assert_success 'bat --version'
assert_success 'tldr --version'
assert_result_like 'which vim' "$(brew --prefix)/bin/vim"
assert_success 'zoxide --version'

# AWS
assert_success 'aws --version'

# Docker
assert_success 'docker --version'

# Print out some useful info during the CI build
if [ $DEBUG_INFO = true ]; then
	echo "Current directory: $(pwd)"
	echo "Home directory: $(ls ~)"
	echo "PATH = $PATH"
	ls -al /usr/local/bin
fi

# Check that git config is set correctly
WORK_RTD_DIR="/Users/tomfocareta"
PERSONAL_GIT_DIR="/Users/tfoc"
if [ -d "$WORK_GIT_DIR" ]; then
	(cd $PATH_REPO/toms-util-scripts && assert_result_like 'git config user.email' 'tomf@teamrtd.com' && cd -)
elif [ -d $PERSONAL_GIT_DIR ]; then
	(cd $PATH_REPO/dotfiles && assert_result_like 'git config user.email' 'tjfocare@gmail.com' && cd -)
fi

# assert_no_git_changes

if [ $HAS_TEST_SUITE_PASSED = false ]; then
	printf "\n\e[1;31mTests failed\e[0m\n"
	exit 1
else
	printf "\n\e[1;32mTests passed\e[0m\n"
fi
