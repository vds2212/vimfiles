" vds: This is actually overridden by the standard

" Make vim.commentry use '::' as comment sign.
" autocmd FileType dosbatch setlocal commentstring=::\ %s
setlocal commentstring=::\ %s

" Make vim.commentry use 'rem' as comment sign (safer in presence of label).
" autocmd FileType dosbatch setlocal commentstring=rem\ %s
" setlocal commentstring=rem\ %s

" Make sure matchit pair: pushd and popd
let b:match_words="pushd:popd,setlocal:endlocal"

let g:dosbatch_colons_comment=1

" Make that o/O don't create a new comment line when editing a comment line
setlocal formatoptions-=o
