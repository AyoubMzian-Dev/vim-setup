" Vim Configuration for 42 Student
" Target: Vim 9.0+ (or Neovim)
" Goals: VSCode layout, 42 Norm compliance, integrated build/run.

" =============================================================================
" 0. BASIC SETTINGS & PLUGINS
" =============================================================================
let mapleader = " "

" Plugin Management
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'joshdick/onedark.vim'
call plug#end()

colorscheme onedark

set number
set relativenumber
set splitright
set splitbelow
set autoread
set path+=**
set clipboard=unnamedplus
set swapfile
set backup
set undofile
set undodir=~/.vim/undo

" =============================================================================
" 1. VSCODE LAYOUT
" =============================================================================
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeCustomOpenArgs = {'file': {'where': 'p', 'reuse': 'currenttab', 'keepopen': 1}}
let g:NERDTreeMouseMode = 3
let g:NERDTreeShowHidden = 1

" VSCode-like startup: vim . -> Tree on left, editor on right
function! s:VimEnterLayout()
    if argc() == 1 && isdirectory(argv(0))
        cd argv(0)
        silent! execute 'edit ' . expand('%:p')
        " Clear directory buffer and restore
        bwipeout! 1
        argdelete *
        NERDTree
        wincmd p
    endif
endfunction

augroup LayoutStartup
    autocmd!
    autocmd VimEnter * call s:VimEnterLayout()
augroup END

" Sidebar Toggles
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <Space>e :NERDTreeFocus<CR>
nnoremap <Space>f :NERDTreeFind<CR>

" Pane Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" =============================================================================
" 10. KEY CHEAT SHEET (Initial)
" =============================================================================
function! s:ShowCheatSheet()
    let cheat_sheet = [
        \ '--- Files and Layout ---',
        \ 'Space e : Focus Tree',
        \ 'Space f : Reveal File',
        \ 'Ctrl-b/n/F3 : Toggle Sidebar',
        \ 'Ctrl-h/l : Move Panes',
        \ '',
        \ '--- Help ---',
        \ 'Space ? : Show this sheet',
    \ ]
    call popup_create(cheat_sheet, {'relative': 'cursor', 'border': [], 'padding': [1,1,1,1]})
endfunction

nnoremap <Space>? :call <SNR>1_ShowCheatSheet()<CR>
