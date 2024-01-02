
setlocal errorformat=%f(%l):%m

" Skip lines that starts with a whitespace
setlocal errorformat^=%-G\ %.%#

" Keep Build started
setlocal errorformat^=%+GBuild\ started%.%#
" Keep Time Elapsed
setlocal errorformat^=%+GTime\ Elapsed%.%#

" Skip all the other lines
setlocal errorformat+=%-G%.%#
