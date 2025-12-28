if exists("b:current_syntax")
  finish
endif

syn match   fooComment  "//.*$" contains=fooTodo,@Spell
syn keyword fooTodo     FIXME NOTE NOTES TODO XXX contained

syn region  fooString matchgroup=fooQuotes
      \ start=+\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=fooEscape

syn region  squareBracketRegex_A start="\(!\@<!\[\)\@<=" skip="\[[^\]]*\]" end="\ze\]" keepend oneline contains=squareBracketRegex_B
syn region  squareBracketRegex_B start="\(!\[\)\@<=" skip="!\[[^\]]!*\]!" end="\ze\]!" keepend oneline contains=squareBracketRegex_A
hi ColorGreen guifg=#008000
hi ColorRed guifg=#FF0000
hi def link squareBracketRegex_A ColorGreen
hi def link squareBracketRegex_B ColorRed

hi def link squareBracketRegex_A ColorGreen
hi def link squareBracketRegex_B ColorRed

syn match   fooEscape   +\\[abfnrtv'"\\]+ contained

syn match   fooNumber   "\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   fooNumber   "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   fooNumber   "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="

hi def link fooComment      Comment
hi def link fooTodo         Todo
hi def link fooString       String
hi def link fooEscape       Special
hi def link fooNumber       Number
hi def link fooQuotes       String


let b:current_syntax = "foo"

