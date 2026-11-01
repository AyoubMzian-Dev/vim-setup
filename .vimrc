" ============================================================
" 1337 School Vim Configuration
" Main Entry Point
" ============================================================

set nocompatible
filetype plugin indent on
syntax on

" Load modular configurations
source ~/vim-setup/config/ui.vim
source ~/vim-setup/config/editing.vim
source ~/vim-setup/config/c_norm.vim
source ~/vim-setup/config/rust.vim
source ~/vim-setup/config/plugins.vim

" General mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :nohlsearch<CR>