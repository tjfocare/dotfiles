#!/usr/bin/env zsh

# If a .env file exists, load it
if [ -f .env ]; then
	# shellcheck source=/dev/null
	source .env
fi

function os_is() {
	uname="$(uname -a)"

	[[ "$1" == 'mac' ]] && [[ "$uname" =~ Darwin ]] && return
	[[ "$1" == 'ubuntu' ]] && [[ "$uname" =~ Ubuntu ]] && return

	# For WSL2 on windows using ubuntu
	[[ "$1" == 'wsl-ubuntu' ]] && [[ "$uname" =~ GNU/Linux ]] && [[ "$uname" =~ WSL2 ]] && return

	# For the macOS version of dockerized ubuntu...
	[[ "$1" == 'ubuntu' ]] && [[ "$uname" =~ GNU/Linux ]] && return

	false
}

function chip_is() {
	uname="$(uname -m)"

	[[ "$1" == 'apple_silicon' ]] && [[ "$uname" =~ arm ]] && return
	[[ "$1" == 'arm' ]] && [[ "$uname" =~ arm ]] && return
	[[ "$1" == 'intel' ]] && [[ "$uname" =~ x86 ]] && return
	[[ "$1" == 'x86' ]] && [[ "$uname" =~ x86 ]] && return

	false
}

function package_installed() {
	if command -v "$1" &>/dev/null; then
		echo "$1 already installed"
		return
	fi

	false
}

function app_installed() {
	# Replace hyphens with spaces
	local app_name=$(echo "$1" | tr '-' ' ')

	if [ -d "/Applications/$app_name.app" ]; then
		echo "$1 already installed"
		return
	fi

	false
}

function brew_install() {
	if ! package_installed "$1"; then
		brew install "$1"
	fi
}

function pipx_install() {
	if ! package_installed "$1"; then
		pipx install "$1"
	fi
}

function npm_global_install() {
	if ! package_installed "$1"; then
		npm install --global "$1"
	fi
}

function gem_install() {
	if ! package_installed "$1"; then
		gem install "$1"
	fi
}

function cargo_install() {
	if ! package_installed "$1"; then
		cargo install "$1"
	fi
}

function check_environment_variable() {
	if [[ -z "${(P)1}" ]]; then
		echo "ERROR: variable $1 not set"
		exit 1
	fi
}

function directory_exists() {
	if [[ -d "$1" ]]; then
		echo "$1 already exists"
		return
	fi
	false
}

# Returns true if the current environment is a CI environment.
function ci {
	if [[ "$CI" = true ]]; then
		return
	fi
	false
}

# Returns true if the current environment is not a CI environment.
function not_ci {
	if ! ci; then
		return
	fi
	false
}
