## git

```bash
brew install git
brew install diff-so-fancy

ln -s $(pwd)/git/gitconfig ~/.gitconfig
```

## nvim

install neovim

```bash
brew install neovim
```

install fonts

```bash
brew tap homebrew/cask-fonts
brew install --cask font-sauce-code-pro-nerd-font
```

install packer as nvim package manager

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

create soft link

```bash
ln -s $(pwd)/nvim ~/.config/nvim
```

install nvim plugins

```bash
nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

alias vim to nvim

```bash
alias vim=nvim
alias vi=nvim
alias view='nvim -R'
export EDITOR=nvim
```

## alacritty

```bash
brew install alacritty

ln -s $(pwd)/alacritty ~/.config/alacritty
```

## fish

install fish shell

```bash
brew install fish
```

install fisher as plugin manager

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

install plugins

```bash
fisher install pure-fish/pure
fisher install jethrokuan/z
```

```bash
ln -s $(pwd)/fish ~/.config/fish
```

## tmux

```bash
brew install tmux

ln -s $(pwd)/tmux ~/.config/tmux
```

install tmux plugin manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

press `prefix + I` to install tmux plugins, `prefix + U` to update plugins
