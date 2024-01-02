setlocal autowrite

" setlocal makeprg=scalac\ -classpath\ .
setlocal makeprg=type\ errors.txt

" set errorformat=--\ [%e]\ %m:%f:%l:%c\ -%#
" set errorformat=--\ [%t%n]\ %m:%f:%l:%c\ -%#

set errorformat=%A--\ [%t%n]\ %m:%f:%l:%c\ -%#,%C%\\d%#\ %#\|%.%#,%C%\\d%\\+\ error%.%#
