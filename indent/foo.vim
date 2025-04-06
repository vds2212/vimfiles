" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent

" Setup indentation expression:
setlocal indentexpr=GetFooIndent()

" Define keys that triggers indentation:
setlocal indentkeys=0(,0),0[,0],0{,0},!^F,o,O,e

" Only define the function once.
if exists("*GetFooIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Check if the character at lnum:col is inside a string.
" This function seems not to be reliable
function s:IsInString(lnum, col)
  let fooTypeId = synID(a:lnum, a:col, 1)
  if !fooTypeId
      return 0
  endif
  let fooTypeName = synIDattr(fooTypeId, 'name')
  let answer = synIDattr(synID(a:lnum, a:col, 1), 'name') == 'fooString'
  return answer
endfunction

let s:string_regex = '"[^\\"]*\%(\\.[^\\"]*\)*"'
let s:comment_regex = '//.*$'

let s:indent_unindent_regex = '[[\](){}]'
let s:indent_regex = '[[({]'
let s:unindent_regex = '^\s*[\])}]'

let s:indent_array = '[](){}'

" Check if line 'lnum' has more opening brackets than closing ones.
function s:LineHasOpeningBrackets(lnum)
  " Return a string composed of '0' and '1' indicating for each type of brace
  let line = getline(a:lnum)
  let open = map(range(len(s:indent_array) / 2), 0)

  " Get the non string line part:
  let line = substitute(line, s:string_regex, '', 'g')

  " Get the non comment part:
  let line = substitute(line, s:comment_regex, '', '')

  " Find an indentation character:
  let pos = match(line, s:indent_unindent_regex, 0)
  let closing = 1
  while pos != -1
    " Convert the character to a number (index in the array):
    let idx = stridx(s:indent_array, line[pos])
    if closing and idx % 2 == 1
      let pos = match(line, s:indent_unindent_regex, pos + 1)
      continue
    endif

    if idx % 2 == 0
      " Open brace:
      let open[idx / 2] += 1
    else
      " Close brace:
      let open[(idx - 1)/2] -= 1
    endif
    let pos = match(line, s:indent_unindent_regex, pos + 1)
  endwhile
  return max(open) > 0
endfunction

" 3. GetFooIndent Function
" =========================

function GetFooIndent()
  " Set up variables for restoring position in file.  Could use v:lnum here.
  let vcol = col('.')

  " Work on the current line:
  " -------------------------

  " Get the current line.
  let line = getline(v:lnum)
  let ind = -1

  " If we got a closing bracket on an empty line, find its match and indent
  " according to it.
  let col = matchend(line, s:unindent_regex)

  if col > 0 && !s:IsInString(v:lnum, col)
    call cursor(v:lnum, col)
    let bs = strpart(s:indent_array, stridx(s:indent_array, line[col - 1]) - 1, 2)

    let pairstart = escape(bs[0], '[')
    let pairend = escape(bs[1], ']')
    let pairline = searchpair(pairstart, '', pairend, 'bW', "synIDattr(synID(line('.'), col('.'), 0), 'name') =~? '\\(fooString\\|fooComment\\)'")

    if pairline > 0
      let ind = indent(pairline)
    else
      let ind = virtcol('.') - 1
    endif

    return ind
  endif

  " Work on the previous line:
  " --------------------------

  let lnum = prevnonblank(v:lnum - 1)

  if lnum == 0
    return 0
  endif

  " Set up variables for current line:
  let line = getline(lnum)
  let ind = indent(lnum)

  " If the previous line contained an opening bracket add indent.
  if line =~ s:indent_regex
    let line_has_opening_brackets = s:LineHasOpeningBrackets(lnum)
    if line_has_opening_brackets > 0
      return ind + shiftwidth()
    else
      call cursor(v:lnum, vcol)
    end
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

