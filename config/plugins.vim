" ---------- Plugin Management ----------
if exists("g:plug_home")
    call plug#begin(g:plug_home . "/plugged")
else
    call plug#begin("~/.vim/plugged")
endif

Plug "rust-lang/rust.vim"
Plug "vim-airline/vim-airline"
Plug "vim-airline/vim-airline-themes"
Plug "tpope/vim-commentary"
Plug "preservim/nerdtree"

call plug#end()

" Plugin Settings
let g:airline_theme="dark"
let g:airline_powerline_fonts=1
let g:NERDTreeShowHidden=1

nnoremap <leader>e :NERDTreeToggle<CR>