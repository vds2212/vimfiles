if exists("b:current_syntax")
  finish
endif

syn match   psiComment  "#.*$" contains=psiTodo,@Spell
syn keyword psiTodo     FIXME NOTE NOTES TODO XXX contained
syn keyword psiKeyword  Slabyard Slabyard-Format Coffins

syn region  psiString matchgroup=psiQuotes
      \ start=+\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=psiEscape

syn match   psiEscape   +\\[abfnrtv'"\\]+ contained

syn match   psiNumber   "\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   psiNumber   "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   psiNumber   "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="

hi def link psiComment      Comment
hi def link psiTodo         Todo
hi def link psiString       String
hi def link psiEscape       Special
hi def link psiNumber       Number
hi def link psiQuotes       String
hi def link psiKeyword      Keyword

let b:current_syntax = "psi"

