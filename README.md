# dotfiles

MacOS dotfiles.

Clone and run `install.sh`. This will:

1. Install everything
2. Symlink the all config file.
3. Test everything installed correctly

## Terminal

- [Rio](https://rioterm.com/docs/install/macos)
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://ohmyz.sh/)

## Fonts

Default font family is `"RobotoMono Nerd Font, MonoLisa, Dank Mono, Menlo, Monaco, 'Courier New', monospace"`.
Make sure to use patched [fonts](https://www.nerdfonts.com/font-downloads)

## Install Notes

### Installing software from source

All installs that involve cloning a git repo and installing from source, e.g.
[`zsh-abbr`](https://github.com/olets/zsh-abbr) or
[`fzf`](https://github.com/junegunn/fzf), clone the repos to `$HOME/opt` and
install from there.

### Python

[uv](https://docs.astral.sh/uv/) owns Python completely - interpreters, CLI
tools and project environments. There is no pyenv, no pipx, no poetry, and no
`python@X` formula in the Brewfile. Nothing symlinks anything into
`/opt/homebrew/bin` by hand.

The global default version is `PYTHON_VERSION` in `helpers.sh`.

`uv python install --default` puts `python` and `python3` in `~/.local/bin`,
which `.zshrc` puts ahead of `/opt/homebrew/bin` on `PATH`. That ordering
matters: brew formulae pull in their own `python@X` as a dependency, and
without it those would shadow uv's.

Change the global version:

```sh
  uv python install 3.13 --default
  uv python pin --global 3.13
  python --version
```

Pin one project to a different version - writes `.python-version` in the
current directory:

```sh
  uv python pin 3.12
```

Install a Python CLI tool globally (the `pipx install` equivalent):

```sh
  uv tool install ruff
  uv tool list
  uv tool upgrade --all
```

> [!WARNING]
> Don't run `uv python update-shell` or `uv tool update-shell`. Both append to
> `~/.zshrc`, which is a symlink into this repo, so they write changes straight
> into your dotfiles. `PATH` is already handled in `zsh/.zshrc`.
