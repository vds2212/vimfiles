if exists("b:current_syntax")
  finish
endif

syn match   tsnComment  "#.*$" contains=tsnTodo,@Spell
syn keyword tsnTodo     FIXME NOTE NOTES TODO XXX contained

syn region  tsnString matchgroup=tsnQuotes
      \ start=+\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=tsnEscape

syn match   tsnEscape   +\\[abfnrtv'"\\]+ contained

syn match   tsnNumber   "\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   tsnNumber   "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   tsnNumber   "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="

hi def link tsnComment      Comment
hi def link tsnTodo         Todo
hi def link tsnString       String
hi def link tsnEscape       Special
hi def link tsnNumber       Number
hi def link tsnQuotes       String


let b:current_syntax = "tsn"

