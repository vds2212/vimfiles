" Make vim.commentry use '" ' as comment sign.
" autocmd FileType vim setlocal commentstring=\"\ %s
" setlocal commentstring=\"\ %s

" Use space instead of tabs
setlocal expandtab

" Set tabs to have 4 spaces
setlocal tabstop=2

" When using the >> or << commands, shift lines by 4 spaces
setlocal shiftwidth=2

" Avoid to insert automatically the " when continue a comment with <CR>
" set formatoptions-=r

" Avoid to insert automatically the " when continue a comment with o
setlocal formatoptions-=o

" Make join removing the comment prefix
setlocal formatoptions+=j

