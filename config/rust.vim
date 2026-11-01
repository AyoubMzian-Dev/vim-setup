" ---------- Rust Configuration ----------

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