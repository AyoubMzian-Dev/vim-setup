" ---------- 1337 / 42 Norm Configuration ----------

augroup 1337_C_Setup
    autocmd!
    " Enforce Norm indentation
    autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 expandtab

    " Strict Compilation Flags
    autocmd FileType c setlocal makeprg=gcc\ -Wall\ -Wextra\ -Werror\ -std=c11\ -o\ %<\ %
    autocmd FileType cpp setlocal makeprg=g++\ -Wall\ -Wextra\ -Werror\ -std=c++17\ -o\ %<\ %
    autocmd FileType c,cpp setlocal errorformat=%f:%l:%c:\ %m

    " Fast access mappings
    autocmd FileType c,cpp nnoremap <buffer> <F5> :make<CR>
    autocmd FileType c,cpp nnoremap <buffer> <F8> :cnext<CR>
    autocmd FileType c,cpp nnoremap <buffer> <Shift-Tab> :cprev<CR>

    " Norminette integration
    autocmd FileType c,cpp nnoremap <buffer> <F6> :!norminette %<CR>
augroup END

" Header Insertion Function
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
    call cursor(3, 10)
endfunction

nnoremap <leader>H :call Insert1337Header()<CR>