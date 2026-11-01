" ============================================================
" Vim configuration for C/C++ and Rust development
" Optimized for 1337 School (The Norm)
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
" Global defaults
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

" ---------- C / C++ (1337 / 42 Norm) ----------
augroup 1337_C_Setup
    autocmd!
    " Enforce Norm indentation
    autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 expandtab

    " 1337 Compilation Flags: -Wall -Wextra -Werror
    autocmd FileType c setlocal makeprg=gcc\ -Wall\ -Wextra\ -Werror\ -std=c11\ -o\ %<\ %
    autocmd FileType cpp setlocal makeprg=g++\ -Wall\ -Wextra\ -Werror\ -std=c++17\ -o\ %<\ %
    autocmd FileType c,cpp setlocal errorformat=%f:%l:%c:\ %m

    " Compile mapping
    autocmd FileType c,cpp nnoremap <buffer> <F5> :make<CR>
    autocmd FileType c,cpp nnoremap <buffer> <F8> :cnext<CR>
    autocmd FileType c,cpp nnoremap <buffer> <Shift-Tab> :cprev<CR>

    " Norminette integration
    " Mapping <F6> to run norminette on the current file
    autocmd FileType c,cpp nnoremap <buffer> <F6> :!norminette %<CR>
augroup END

" 42/1337 Header Insertion
function! Insert1337Header()
    let l:header = [
        \ "/*",
        \ " * ",
        \ " * Project: ",
        \ " * ",
        \ " * ",
        \ " * ",
        \ " */"
        \ ]
    call append(line("^"), l:header)
    " Move cursor to Project line
    call cursor(3, 10)
endfunction

" Map <leader>H to insert header (changed from nohlsearch)
nnoremap <leader>H :call Insert1337Header()<CR>

" tags navigation (ctags)
set tags=./tags;,tags
nnoremap <C-\> :!ctags -R .<CR>

" ---------- Rust ----------
augroup Rust_Setup
    autocmd!
    autocmd FileType rust setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType rust setlocal makeprg=cargo\ build
    autocmd FileType rust setlocal errorformat=%f:%l:%c:\ %m
    autocmd FileType rust nnoremap <buffer> <F5> :make<CR>
    autocmd FileType rust nnoremap <buffer> <F6> :!cargo\ test<CR>
    autocmd FileType rust nnoremap <buffer> <F7> :!cargo\ fmt<CR>
    autocmd FileType rust nnoremap <buffer> <F8> :cnext<CR>
    autocmd FileType rust nnoremap <buffer> <Shift-Tab> :cprev<CR>
augroup END

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
let g:NERDTreeShowHiddren=1

nnoremap <leader>e :NERDTreeToggle<CR>

" colorscheme
colorscheme desert