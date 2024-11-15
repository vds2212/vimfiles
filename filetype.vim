" First filetype detection
" Wins over the standard filetype.vim detection
" Put here what needs to override the standard

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetectpsi
  au BufNewFile,BufRead *.cfg setf psi
augroup END

augroup filetypedetectdobatch
  au! BufNewFile,BufRead *.bat,*.sys setf dosbatch
augroup END

augroup filetypedetectk
  au! BufNewFile,BufRead *.k setf k
augroup END

" augroup filetypedetectdosini
"       au! BufNewFile,BufRead *.ini setf dosini
" augroup END
"
