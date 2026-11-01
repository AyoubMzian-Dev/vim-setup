" ============================================================
" Vim configuration for C/C++ and Rust development
" Built from scratch
" ============================================================

set nocompatible
filetype plugin indent on
syntax on
set termguicolors

" ---------- UI ----------
set number
set relativenumber
set cursorline
set showmatch
set wildmenu
set lazyredraw
set laststatus=2
set ruler
set cmdheight=2

" ---------- Editing ----------
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set smartindent
set autoindent
set wrap
set linebreak
set whichwrap+=<,>,h,l
set backspace=indent,eol,start
set clipboard=unnamedplus

" ---------- Search ----------
set hlsearch
set incsearch
set ignorecase
set smartcase

" ---------- Persistence ----------
set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set writebackup

" ---------- C / C++ ----------
autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp setlocal makeprg=gcc\ -Wall\ -Wextra\ -std=c11\ -o\ %<\ %
autocmd FileType cpp setlocal makeprg=g++\ -Wall\ -Wextra\ -std=c++17\ -o\ %<\ %
autocmd FileType c,cpp setlocal errorformat=%f:%l:%c:\ %m
autocmd FileType c,cpp nnoremap <buffer> <F5> :make<CR>
autocmd FileType c,cpp nnoremap <buffer> <F8> :cnext<CR>
autocmd FileType c,cpp nnoremap <buffer> <Shift-Tab> :cprev<CR>

" tags navigation (ctags)
set tags=./tags;,tags
nnoremap <C-\> :!ctags -R .<CR>

" ---------- Rust ----------
autocmd FileType rust setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType rust setlocal makeprg=cargo\ build
autocmd FileType rust setlocal errorformat=%f:%l:%c:\ %m
autocmd FileType rust nnoremap <buffer> <F5> :make<CR>
autocmd FileType rust nnoremap <buffer> <F6> :!cargo\ test<CR>
autocmd FileType rust nnoremap <buffer> <F7> :!cargo\ fmt<CR>
autocmd FileType rust nnoremap <buffer> <F8> :cnext<CR>
autocmd FileType rust nnoremap <buffer> <Shift-Tab> :cprev<CR>

" ---------- General mappings ----------
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :nohlsearch<CR>

" ---------- Plugin manager (vim-plug) ----------
call plug#begin("~/.vim/plugged")

Plug "rust-lang/rust.vim"
Plug "vim-airline/vim-airline"
Plug "vim-airline/vim-airline-themes"
Plug "tpope/vim-commentary"
Plug "preservim/nerdtree"

call plug#end()

let g:airline_theme="dark"
let g:airline_powerline_fonts=1
let g:NERDTreeShowHidden=1

nnoremap <leader>e :NERDTreeToggle<CR>

" colorscheme
colorscheme desert