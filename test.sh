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

# Python - managed entirely by uv
assert_success 'uv --version'
assert_success 'python --version'
assert_success 'python3 --version'

# Both must resolve to uv's executables, not a brew python pulled in as a dep
assert_result_like 'which python' "$HOME/.local/bin/python"
assert_result_like 'which python3' "$HOME/.local/bin/python3"
assert_result_like 'python --version' "$PYTHON_VERSION"
assert_result_like 'python3 --version' "$PYTHON_VERSION"

# Python CLI tools installed via `uv tool install`
assert_success 'ruff --version'
assert_success 'isort --version'
assert_success 'pyright --version'
# beancount's command names don't match the package name and changed in v3,
# so assert on the uv registration rather than on a specific executable
assert_result_like 'uv tool list' 'beancount'

assert_success_zsh 'fzf --version'
assert_success_zsh 'fd --version'
assert_success_zsh 'jq --version'
# assert_zsh_completion 'tar'   # Default that comes with zsh
# assert_zsh_completion 'git' # Default that comes with zsh
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

# Custom functions
assert_function_exists 'find-port'
assert_function_exists 'kill-port'
assert_function_exists 'update_brew'

# Print out some useful info during the CI build
if [ $DEBUG_INFO = true ]; then
	echo "Current directory: $(pwd)"
	echo "Home directory: $(ls ~)"
	echo "PATH = $PATH"
	ls -al /usr/local/bin
fi

# Check that the gitconfig conditional includes resolve to the right identity.
# Uses throwaway repos so this doesn't depend on which repos happen to be cloned.
WORK_GIT_DIR="$PATH_REPO/.gitconfig-test"
PERSONAL_GIT_DIR="$PATH_REPO/personal/.gitconfig-test"

for test_repo in "$WORK_GIT_DIR" "$PERSONAL_GIT_DIR"; do
	mkdir -p "$test_repo"
	git -C "$test_repo" init --quiet
done

assert_result_like "git -C $WORK_GIT_DIR config user.email" 'tomf@teamrtd.com'
assert_result_like "git -C $PERSONAL_GIT_DIR config user.email" 'tjfocare@gmail.com'

rm -rf "$WORK_GIT_DIR" "$PERSONAL_GIT_DIR"

# assert_no_git_changes

if [ $HAS_TEST_SUITE_PASSED = false ]; then
	printf "\n\e[1;31mTests failed\e[0m\n"
	exit 1
else
	printf "\n\e[1;32mTests passed\e[0m\n"
fi
