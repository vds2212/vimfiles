" Make sure line starting with # are considered comment
setlocal commentstring=#\ %s

" Make sure Order-Name is a word
setlocal iskeyword+=-

" Keep tab
setlocal noet

" Set tabs to have 4 spaces
setlocal ts=4

" When using the >> or << commands, shift lines by 4 spaces
setlocal shiftwidth=4
