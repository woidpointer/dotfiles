
# Introduction 

These are my dotfiles for to setup an working environment for 

* C++11/14/17 development
* Ruby/Python scripting


## Base software packages

```bash
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo apt-get install python3-setuptools
sudo apt install python-wheel-common
sudo apt install fonts-powerline
sudo apt install tmux
sudo apt install cmake
sudo apt install build-essential
sudo apt install clang clang-format clang-tidy
sudo apt install vagrant 
sudo apt install docker.io 

pip3 install --user --upgrade neovim

```


# Fzf


# Tmux

##  Create symbolic link to tmux configuration file

```bash
ln -s /path/to/woidpointer/dotfiles/tmux/tmux.conf ~/.tmux.conf
```



# Neovim


## Install base system


## Install vim-plug Plugin manager

[source, bash]
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

##  Create symbolic link to nvim configuration file

```bash
ln -s /path/to/woidpointer/dotfiles/nvim ~/.config/nvim
```

Launch nvim and type:

```
:PlugInstall
```
