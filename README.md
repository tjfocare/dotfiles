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

### Change python version

```sh
  brew unlink python3
  sudo rm /opt/homebrew/bin/python3
  sudo ln -s /opt/homebrew/bin/python3.9 /opt/homebrew/bin/python3
  python --version
```

### Managing Python symlinks

The command `sudo ln -s /opt/homebrew/bin/python3 /opt/homebrew/bin/python` creates a symbolic link:

- `ln -s`: Create a symbolic link
- First path (`/opt/homebrew/bin/python3`): The target (original file)
- Second path (`/opt/homebrew/bin/python`): The symlink location

This makes `python` command point to `python3`, so you can use either command.

View all Python-related symlinks:

```sh
  ls -la /opt/homebrew/bin/python*
```

Remove a Python symlink:

```sh
  sudo rm /opt/homebrew/bin/python3
```
