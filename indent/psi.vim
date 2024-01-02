" Psi indent file
" Language:             psi
" Maintainer:           Vivian De Smedt
" Last Change:          2019 Sep 13
" Acknowledgment:       Based off of vim-javascript maintained by Darrick Wiebe
"                       http://www.vim.org/scripts/script.php?script_id=2765

" 0. Initialization
" =================

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent

" Setup indentation expression:
setlocal indentexpr=GetPsiIndent()
" Define keys that trigger indentation:
setlocal indentkeys=0(,0),0[,0],0{,0},0<,0>,!^F,o,O,e

" Only define the function once.
if exists("*GetPsiIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" 1. Variables
" ============

" 2. Auxiliary Functions
" ======================

" Check if the character at lnum:col is inside a string.
" This function seems not to be reliable
function s:IsInString(lnum, col)
  " echom "  IsInString(" . a:lnum . ", " . a:col . ")"
  let tsnTypeId = synID(a:lnum, a:col, 1)
  if !tsnTypeId
      " echom "  not string"
      return 0
  endif
  let tsnTypeName = synIDattr(tsnTypeId, 'name')
  " echom "  " . tsnTypeName
  let answer = synIDattr(synID(a:lnum, a:col, 1), 'name') == 'tsnString'
  " echom "  answer: " . answer
  return answer
endfunction

" Check if line 'lnum' has more opening brackets than closing ones.
function s:LineHasOpeningBrackets(lnum)
  " Return a string composed of '0' and '1' indicating for each type of brace
  " ('(', '[', '{') if there are more opening brace than closing brace
  let open_0 = 0 " Number of open '(': '(' lead to 1, ')' lead to '-1'
  let open_2 = 0 " Number of open '[': '[' lead to 1, ']' lead to '-1'
  let open_4 = 0
  let open_6 = 0
  let line = getline(a:lnum)

  " Get the non string line part:
  let line = substitute(line, '"[^\\"]*\%(\\.[^\\"]*\)*"', '', 'g')

  " Get the non comment part:
  let line = substitute(line, '#.*$', '', '')

  let pos = match(line, '[][(){}<>]', 0)
  while pos != -1
    let idx = stridx('[](){}<>', line[pos])
    if idx % 2 == 0
      " Open brace:
      let open_{idx} = open_{idx} + 1
    else
      " Close brace:
      let open_{idx - 1} = open_{idx - 1} - 1
      " let open_{idx} = open_{idx} - 1
    endif
    let pos = match(line, '[][(){}<>]', pos + 1)
  endwhile
  " return (open_0 > 0) . (open_2 > 0) . (open_4 > 0)
  return (open_0 > 0) || (open_2 > 0) || (open_4 > 0) || (open_6 > 0)
endfunction

" 3. GetTsnIndent Function
" =========================

function GetPsiIndent()
  " 3.1. Setup
  " ----------

  " Set up variables for restoring position in file.  Could use v:lnum here.
  let vcol = col('.')

  " 3.2. Work on the current line
  " -----------------------------

  " Get the current line.
  let line = getline(v:lnum)
  " echom line
  let ind = -1

  " If we got a closing bracket on an empty line, find its match and indent
  " according to it.
  let col = matchend(line, '^\s*[])}>]')

  if col > 0 && !s:IsInString(v:lnum, col)
    " echom "  close"
    call cursor(v:lnum, col)
    let bs = strpart('()[]{}<>', stridx(')]}>', line[col - 1]) * 2, 2)

    let pairstart = escape(bs[0], '[')
    let pairend = escape(bs[1], ']')
    let pairline = searchpair(pairstart, '', pairend, 'bW', "synIDattr(synID(line('.'), col('.'), 0), 'name') =~? '\\(configString\\|configComment\\)'")
    " echom "  " . pairline

    if pairline > 0
      let ind = indent(pairline)
    else
      let ind = virtcol('.') - 1
    endif

    " echom "  ind:" . (ind + shiftwidth())
    return ind
  endif

  " If we are in a multi-line string, don't do anything to it.
  " if s:IsInString(v:lnum, matchend(line, '^\s*') + 1)
  "   " echom "  ind:" . indent('.')
  "   return indent('.')
  " endif

  " 3.3. Work on the previous line.
  " -------------------------------

  let lnum = prevnonblank(v:lnum - 1)

  if lnum == 0
    " echom "  first line"
    return 0
  endif

  " Set up variables for current line.
  let line = getline(lnum)
  let ind = indent(lnum)

  " If the previous line contained an opening bracket add indent
  if line =~ '[[({<]'
    " echom "  open"
    let line_has_opening_brackets = s:LineHasOpeningBrackets(lnum)
    if line_has_opening_brackets > 0
      " echom "  " . (ind + shiftwidth())
      return ind + shiftwidth()
    else
      " return ind
      call cursor(v:lnum, vcol)
    end
  endif

  " echom "  ind:" . ind
  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

