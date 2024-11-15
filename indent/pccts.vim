" Pccts indent file
" Language:             pccts
" Maintainer:           Vivian De Smedt
" Last Change:          2024 Jul 18
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
setlocal indentexpr=GetPcctsIndent()
" Define keys that trigger indentation:
setlocal indentkeys=0(,0),0{,0},0\|,0;,!^F,o,O,e

" Only define the function once.
if exists("*GetPcctsIndent")
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
  let answer = synIDattr(synID(a:lnum, a:col, 1), 'name') == 'pcctsString'
  " echom "  answer: " . answer
  return answer
endfunction

" Check if line 'lnum' has more opening brackets than closing ones.
function s:LineHasOpeningBrackets(lnum)
  " Return 1 if the opening bracket exceed the closing brackets:

  let open_0 = 0 " Number of open '(': '(' lead to 1, ')' lead to '-1'
  let open_2 = 0 " Number of open '{': '{' lead to 1, '}' lead to '-1'
  let line = getline(a:lnum)

  " Get the non string line part:
  let line = substitute(line, '"[^\\"]*\%(\\.[^\\"]*\)*"', '', 'g')

  " Get the non comment part:
  let line = substitute(line, '//.*$', '', '')

  let pos = match(line, '[(){}]', 0)
  while pos != -1
    let idx = stridx('(){}', line[pos])
    if idx % 2 == 0
      " Open brace:
      let open_{idx} = open_{idx} + 1
    else
      " Close brace:
      let open_{idx - 1} = open_{idx - 1} - 1
    endif
    let pos = match(line, '[(){}]', pos + 1)
  endwhile
  return (open_0 > 0) || (open_2 > 0)
endfunction

" 3. GetPcctsIndent Function
" =========================

function GetPcctsIndent()
  " Return the indentation level (in number of spaces) of the line v:lnum

  " Set up variables for restoring position in file.  Could use v:lnum here.
  let vcol = col('.')

  " Get the current line.
  let line = getline(v:lnum)
  let ind = -1

  " If we got a closing bracket at the end of a line:
  " find its match and indent according to it.
  let col = matchend(line, '[)}]\ze\s*\*\?$')

  if col > 0 && !s:IsInString(v:lnum, col)
    call cursor(v:lnum, col)
    " bs is set to bracket pair:
    " - if the cursor is on ')' bs is '()'
    " - if the cursor is on '}' bs is '{}'
    let bs = strpart('(){}', stridx(')}', line[col - 1]) * 2, 2)

    let pairstart = escape(bs[0], '[')
    let pairend = escape(bs[1], ']')
    let pairline = searchpair(pairstart, '', pairend, 'bW', "synIDattr(synID(line('.'), col('.'), 0), 'name') =~? '\\(pcctsString\\|pcctsComment\\)'")

    if pairline > 0 && pairline != v:lnum
      " Compute the indentation (convert tab in number of spaces)
      return indent(pairline)
    endif
  endif

  let lnum = prevnonblank(v:lnum - 1)

  " First line:
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)

  " If the line end with |
  " The indentation level is the indentation level of the previous line -1
  if line =~ '|$'
    echo "| line"
    return ind - shiftwidth()
  endif

  " Set up variables for current line.
  let line = getline(lnum)

  " If the previous line contained an opening bracket add indent
  if line =~ '[({]'
    let line_has_opening_brackets = s:LineHasOpeningBrackets(lnum)
    if line_has_opening_brackets > 0
      return ind + shiftwidth()
    end
    call cursor(v:lnum, vcol)
  endif

  if line =~ ':$'
      return ind + shiftwidth()
  endif

  if line =~ '|$'
      return ind + shiftwidth()
  endif

  if line =~ ';$'
      return ind - shiftwidth()
  endif

  " Otherwise return the indentation level of the previous non blank line
  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

