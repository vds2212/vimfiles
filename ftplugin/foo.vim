" echom "ftplugin:foo.vim"
" Make vim.commentry use 'rem' as comment sign (safer in presence of label).
" autocmd FileType grr setlocal commentstring=rem\ %s
setlocal commentstring=rem\ %s

let tlist_foo_settings = 'foo;c:class;v:variable'

let g:tagbar_type_foo = {
  \ 'ctagstype' : 'foo',
  \ 'kinds' : [
    \ 'c:classes',
    \ 'v:variables',
  \ ]
  \}

echom 'ftplugin:foo.vim'

