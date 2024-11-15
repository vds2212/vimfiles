autocmd BufNewFile,BufRead,Bufenter *
  \ if matchstr(getline(1) . getline(2) . getline(3), '^\s*{\s*"[^"]*"\s*:') != '' |
  \   setf json |
  \ endif

