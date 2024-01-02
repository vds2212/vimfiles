" echo 'ftdetect:foo.vim'
autocmd BufNewFile,BufRead *.foo echom 'BufRead ftdetect:foo.vim'
autocmd BufNewFile,BufRead *.brol setfiletype foo
autocmd BufNewFile,BufRead *.foo setfiletype foo
autocmd BufNewFile,BufRead bash-* setfiletype foo

