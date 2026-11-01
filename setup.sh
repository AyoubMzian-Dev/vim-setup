#!/bin/bash

# Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink the config
ln -sf $(pwd)/.vimrc ~/.vimrc

echo "Vim setup complete! Please restart Vim and run :PlugInstall"