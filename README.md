## nvim

install packer as nvim package manager

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

create soft link

```
ln -s $(pwd)/nvim ~/.config/nvim
```

install nvim plugins

```
nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
