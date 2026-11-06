#!/bin/bash

# 1. Install vim-plug if not present
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 2. Create undo directory
mkdir -p ~/.vim/undo

# 3. Symlink the vimrc from the project directory to ~/.vimrc
# Assuming the script is run from within /Users/macbook/Crafts/vim-setup
VIMRC_PATH="$(pwd)/vimrc"
if [ -f "$VIMRC_PATH" ]; then
    echo "Symlinking $VIMRC_PATH to ~/.vimrc..."
    ln -sf "$VIMRC_PATH" ~/.vimrc
else
    echo "Error: vimrc not found at $VIMRC_PATH"
    exit 1
fi

echo "------------------------------------------------------------"
echo "Setup complete!"
echo "1. Run 'vim +PlugInstall' once to install the plugins."
echo "2. Then launch 'vim' as usual."
echo "------------------------------------------------------------"
