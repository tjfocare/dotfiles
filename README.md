# dotfiles

MacOS dotfiles.

Clone and run `install.sh`. This will

1. Install everything.
2. Symlink the all config files.
3. Test everything installed correctly.

## Terminal

[Alacritty](https://github.com/alacritty/alacritty) +
[tmux](https://github.com/tmux/tmux/wiki) + [zsh](https://www.zsh.org/).

I also like the git diffs + Github Copilot chat in
[Vscode](https://code.visualstudio.com/docs/setup/setup-overview).

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
  sudo ln -s /opt/homebrew/bin/python3.9 /opt/homebrew/bin/python3
  python --version
```
