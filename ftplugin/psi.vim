" Make sure line starting with # are considered comment
setlocal commentstring=#\ %s

" Make sure Order-Name is a word
setlocal iskeyword+=-

" Keep tabs
setlocal et

" Tagbar configuration
let g:tagbar_type_psi = {
    \ 'ctagstype' : 'psi',
    \ 'kinds' : [
        \ 'g:Groupes',
        \ 's:Scripts',
        \ 'p:Perspectives',
        \ 'j:Jumps',
        \ 'c:Colorizations',
    \ ],
\ }

" Taglist configuration
let tlist_psi_settings = 'psi;g:Groups;s:Scripts;p:Perspectives;j:Jumps;c:Colorizations'

