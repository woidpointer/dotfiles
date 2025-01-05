# Introduction

## Install

> **NOTE:**
> This chapter is still in progress!

```shell
# necessary packages
sudo pacman -S neovim npm ruby rake
sudo pacman -S tmux
sudo pacman -S stow
sudo pacman -S --needed base-devel git
sudo pacman -S ghostty
sudo pacman -S starship
sudo pacman -S hyperland
sudo pacman -S swaync
sudo pacman -S hypridle
sudo pacman -S hyprpaper
yay -S hyprshot
sudo pacman -S waybar
sudo pacman -S wofi
sudo pacman -S cargo
sudo pacman -S lazygit



# install nvim
# archlinux:
sudo pacman -S lazygit

# ubuntu build from source
#...
nvim --headless "+Lazy! sync | MasonToolsInstallSync" +qa


# Setup tmux plugin manager
stow tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install plugins
~/.tmux/plugins/tpm/bin/install_plugins

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
  && ~/.fzf/install

# install yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


# ghostty
stow ghostty
stow starship
yay -Sy catppuccin-gtk-theme-mocha
# edit .bashrc
eval "$(starship init bash)"

```

```shell
yay -Sy catppuccin-gtk-theme-mocha

####
# tmux
# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install plugins
~/.tmux/plugins/tpm/bin/install_plugins

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
  && ~/.fzf/install
```
