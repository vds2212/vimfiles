" -----------------------------------------------------------------------------
" File: nordbox.vim
" Description: Retro groove color scheme for Vim
" Author: morhetz <morhetz@gmail.com>
" Source: https://github.com/morhetz/nordbox
" Last Modified: 09 Apr 2014
" -----------------------------------------------------------------------------

function! nordbox#invert_signs_toggle()
  if g:nordbox_invert_signs == 0
    let g:nordbox_invert_signs=1
  else
    let g:nordbox_invert_signs=0
  endif

  colorscheme nordbox
endfunction

" Search Highlighting {{{

function! nordbox#hls_show()
  set hlsearch
  call NordboxHlsShowCursor()
endfunction

function! nordbox#hls_hide()
  set nohlsearch
  call NordboxHlsHideCursor()
endfunction

function! nordbox#hls_toggle()
  if &hlsearch
    call nordbox#hls_hide()
  else
    call nordbox#hls_show()
  endif
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
