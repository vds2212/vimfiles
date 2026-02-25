" Align public/private to the margin:
setlocal cinoptions=+g0

" Indent of 4 whitespace the line after an open parenthesis:
" hello(
"     "Tom",
"     "Bob",
" )
setlocal cinoptions+=(0,W4

setlocal cinoptions+=i0

setlocal cinoptions+=i-s

" Close the parenthesis at the level of which the open parenthesis line start
" hello(
" )
setlocal cinoptions+=(s,m1

" Align the case with the switch:
" switch(x) {
" case 1:
"     a = b
" default:
" }
setlocal cinoptions+=:0
