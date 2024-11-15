" Uncomment next line to activate the callback viewers:
" let g:netrw_browsex_viewer = "-"

" Uncomment next line to activate the generic specified viewer:
" let g:netrw_browsex_viewer = '"C:\Program Files\SumatraPDF\SumatraPDF.exe"'

function! NFH_html(filename)
  "silent !"C:\Program Files\SumatraPDF\SumatraPDF.exe" a:filename
  echom "html" a:filename
endfunction

function! NFH_pdf(filename)
  "silent !"C:\Program Files\SumatraPDF\SumatraPDF.exe" a:filename
  echom "pdf" a:filename
endfunction
