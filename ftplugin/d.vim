function! IndentLevel(line)
  let ts = 1
  if &et
    let ts = &ts
  endif
  return len(matchlist(a:line, '^\s*')[0]) / ts
endfunction

function! FoldUnitTest()
  " echom 'grr'
  let line = getline(v:lnum)
  if line =~ '^\s*unittest'
    return IndentLevel(line) + 10
  endif
  if line =~ '^\s*class' || line =~ '\v^\s*\w+\s+\w+\('
    return IndentLevel(line) + 1
  endif
  if line =~ '^\s*}'
    call cursor(v:lnum, 1)
    let altlinenb = searchpair('{', '', '}', 'bWn')
    " echom altlinenb
    let altline = getline(altlinenb)
    if altline =~ '^\s*unittest'
      return IndentLevel(altline)
    endif
    if altline =~ '^\s*class' || altline =~ '\v^\s*\w+\s+\w+\('
      return IndentLevel(altline)
    endif
  endif
  return "="
endfunction

setlocal foldmethod=expr
setlocal foldexpr=FoldUnitTest()
setlocal foldlevel=9
