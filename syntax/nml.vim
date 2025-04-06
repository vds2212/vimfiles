" Vim syntax file
" Language:	nML
" Maintainer:	Vivian De Smedt (vds2212@gmail.com)
" Last Change:	2025 Jan 15^

" quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

source $VIMRUNTIME/syntax/c.vim

syn keyword	cStatement	opn
syn match	cUserLabel	"\<\w*\>\ze\s*:\>"

let b:current_syntax = "nml"

" vim:set sw=2 sts=2 ts=8 noet:
