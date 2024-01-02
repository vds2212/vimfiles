" setlocal include=\\%^\\\\|\\\(^\\s*#include\\\)
" setlocal include=\\%^\\zs\\ze\\\\|^\\s*#include\\s\\+\"\\zs[^\"]*\\ze\"
" setlocal include=^\\s*#include\\s\\+\"\\zs[^\"]*\\ze\"
setlocal include=^\\s*#include

function! GapIncludeExp()
  echom 'GapIncludeExp'
  if v:fname == ''
    echom "name: master.gd"
    return 'master.gd'
  else
    echom "name: '" . v:fname . "'"
    return v:fname
  endif
endfunction

setlocal includeexpr=GapIncludeExp()

