
" autocmd FileType python compiler pylint
compiler pylint

" Make vim.commentry use '#' as comment sign.
" autocmd FileType python setlocal commentstring=#\ %s
" setlocal commentstring=#\ %s

" Use the omnifunc for Python completion
" autocmd FileType python set omnifunc=pythoncomplete#Complete
" set omnifunc=pythoncomplete#Complete

" Auto indent
" autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
" setlocal expandtab shiftwidth=4 tabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" autocmd FileType python set foldmethod=indent foldlevel=99
" set foldmethod=indent foldlevel=99
setlocal foldlevel=99

setlocal nospell

" setlocal autochdir

" Make that <CR> create a new comment line when editing a comment line
setlocal formatoptions+=r

" Make j join comment line by removing the prefix while joining
setlocal formatoptions+=j

" Configure the command that will be executed by the gq command
setlocal formatprg=python\ -m\ macchiato
