setlocal foldmethod=expr

function! s:VimFoldExpr(lnum)
  let line = getline(a:lnum)
  let vim9 = getline(1) =~# 'vim9script'

  if line =~# '\v^\s*fu%[nction]>'
    return 'a1'
  endif

  if line =~# '\v^\s*endf%[unction]>'
    return 's1'
  endif

  if vim9
    if line =~# '\v^\s*class>'
      return 'a1'
    endif

    if line =~# '\v^\s*endclass>'
      return 's1'
    endif

    if line =~# '\v^\s*def>'
      return 'a1'
    endif

    if line =~# '\v^\s*enddef>'
      return 's1'
    endif
  endif

  if a:lnum == 1
    return 0
  endif

  return '='
endfunction

setlocal foldexpr=<SID>VimFoldExpr(v:lnum)
