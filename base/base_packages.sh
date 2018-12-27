
## Commands to set locale settings in the vagrant box
#echo -e 'LC_ALL="en_US.UTF-8"\n' >> /etc/environment
#sudo locale-gen --purge "en_US.UTF-8"
#echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

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

# To use python 3 as default the bashrc file is adapted by an alias definition
# set python 3 as default
echo -e '# @@@woidpointer:' >> ~/.bashrc 
echo -e 'alias python=python3\n' >> ~/.bashrc 
# Configure FZF behaviour
echo -e 'FZF_DEFAULT_OPTS=--height 50% --layout=reverse --border  --preview="head -$LINES {}"'

# source new bashrc file to activate the python alias
source ~/.bashrc

# Clone dotfiles
git clone https://github.com/woidpointer/dotfiles.git ~/.dotfiles

################################################################################
# neovim 
################################################################################
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# create config folder
mkdir ~/.config

# create link to nvim configuration file
ln -s ~/.dotfiles/nvim/ ~/.config/nvim

# now install nvim plugins
# +PlugInstall: execute PlugInstall command
# +qall: Quit and exit 
nvim  +PlugInstall +qall --headless

################################################################################
# Tmux
################################################################################
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf




################################################################################
# EOF
################################################################################
