# Introduction

- [x] starship
- [x] Background
- [x] Hyprland
- [x] Waybar
- [ ] Tmux

## Install

- nwg-look

```shell
yay -Sy catppuccin-gtk-theme-mocha

####
# tmux
# tmux plugin manager
sudo pacman -S tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# install plugins
~/.tmux/plugins/tpm/bin/install_plugins

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
  && ~/.fzf/install
```
