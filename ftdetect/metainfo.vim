function! s:getmetatype(line)
  let match = matchlist(a:line, 'vim-meta-info:\s\+filetype\s\+\(\w\+\)')
  if match == []
    return ""
  endif
  return match[1]
endfunction

function SetMetafiletype()
  let line = getline(1)
  let filetype = s:getmetatype(line)
  if filetype != ''
    echom filetype
    " execute "setfiletype" filetype
    execute "set ft=" . filetype
  endif

  let line = getline('$')
  let filetype = s:getmetatype(line)
  if filetype != ''
    echom filetype
    " execute "setfiletype" filetype
    execute "set ft=" . filetype
  endif
endfunction

autocmd BufNewFile,BufRead * call SetMetafiletype()

