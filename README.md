## git

```bash
brew install git
brew install diff-so-fancy

ln -s $(pwd)/git/gitconfig ~/.gitconfig
```

## nvim

install neovim

```bash
brew install neovim fzf bat the_silver_searcher ripgrep fd
```

install fonts

```bash
brew tap homebrew/cask-fonts
brew install font-source-code-pro font-sauce-code-pro-nerd-font
```

setup `iTerm2`：iTerm2 -> Profiles -> Default -> Text:

- Font: Source Code Pro for Powerline
- Non-ASCII Font: SauceCodePro Nerd Font

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

install programs used by neovim

```
npm install -g prettier prettier-plugin-solidity

go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

## wezterm

```bash
brew install wezterm
ln -s $(pwd)/wezterm ~/.config/wezterm
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
fisher install oh-my-fish/plugin-aws
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

## refs

### nvim

- [Everything you need to know to configure neovim using lua](https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/)
- [Moving to modern Neovim](https://toroid.org/modern-neovim)
- [nanotee/nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
- [我的命令行开发环境 ❤️](https://writings.sh/post/commandline-tools)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
