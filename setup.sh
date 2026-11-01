#!/bin/bash

# Create directory for vim-plug
mkdir -p ~/.vim/autoload

# Install Vim-Plug
echo "Installing vim-plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink the config
echo "Setting up symlinks..."
ln -sf ~/vim-setup/.vimrc ~/.vimrc

echo "Vim setup complete! Please restart Vim and run :PlugInstall"