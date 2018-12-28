
# Introduction 

These are my dotfiles for to setup an working environment for 

* C++11/14/17 development
* Ruby/Python scripting


Important requirements for the tool setup:
* key bindings as much as possible to the default bindings.
* highly automated setup.

## Base software packages

```bash

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
# Install all nvim related packages
sudo apt-get -y install neovim
sudo apt-get -y install python-dev python-pip python3-dev python3-pip
sudo apt-get -y install python3-setuptools
sudo apt-get -y install python-wheel-common
sudo apt-get -y install fonts-powerline 
# Install necessary tools for a build tool chain
sudo apt-get -y install tmux
sudo apt-get -y install cmake
sudo apt-get -y install build-essential
sudo apt-get -y install clang clang-format clang-tidy
sudo apt-get -y install vagrant 
sudo apt-get -y install docker.io 
sudo apt-get -y install virtualbox-qt

# install python bindings for neovim
pip2 install --user --upgrade neovim
pip3 install --user --upgrade neovim

```

# Fzf

The fzf is a fuzzy search tool which works basically like the Google search 
when  you type in chars and a good proposal of your search intent is provided.

The tool is automatically installed, when the base/base_package.sh is executed
as part of the nvim plugin installation.

If the shell script is not used refer to the FZF documentation and use the git
based solution.

# Tmux

##  Create symbolic link to tmux configuration file

```bash
ln -s /path/to/woidpointer/dotfiles/tmux/tmux.conf ~/.tmux.conf
```

# Neovim


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

## Use python3 as default python version

At least on my system python2.7 is the default version when I type python on the
command console. I personally prefer python3 so I have to change the python 
version to be used by creating an alias definition:

```bash
echo -e 'alias python=python3\n' >> ~/.bashrc 
```

## Finish neovim setup by installing the plugins


Launch nvim and type:

```
:PlugInstall
```
