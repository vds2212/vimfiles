" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      David Beniamine <David@Beniamine.net>, Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/dbeniamine/todo.txt-vim

if ! exists("g:Todo_txt_loaded")
    let g:Todo_txt_loaded=0.8.2
endif

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" General options {{{1
" Some options lose their values when window changes. They will be set every
" time this script is invoked, which is whenever a file of this type is
" created or edited.
setlocal textwidth=0
setlocal wrapmargin=0

" Increment and decrement the priority use <C-A> and <C-X> on alpha
setlocal nrformats+=alpha

" Mappings {{{1

" <Plug> mappings that users can map alternate keys to {{{2
" if they choose not to map default keys (or otherwise)
nnoremap <script> <silent> <buffer> <Plug>TodotxtIncrementDueDateNormal :<C-u>call <SID>ChangeDueDateWrapper(1, "\<Plug>TodotxtIncrementDueDateNormal")<CR>
vnoremap <script> <silent> <buffer> <Plug>TodotxtIncrementDueDateVisual :call <SID>ChangeDueDateWrapper(1, "\<Plug>TodotxtIncrementDueDateVisual")<CR>
nnoremap <script> <silent> <buffer> <Plug>TodotxtDecrementDueDateNormal :<C-u>call <SID>ChangeDueDateWrapper(-1, "\<Plug>TodotxtDecrementDueDateNormal")<CR>
vnoremap <script> <silent> <buffer> <Plug>TodotxtDecrementDueDateVisual :call <SID>ChangeDueDateWrapper(-1, "\<Plug>TodotxtDecrementDueDateVisual")<CR>

noremap  <script> <silent> <buffer> <Plug>DoToggleMarkAsDone :call todo#ToggleMarkAsDone('')<CR>
                \:silent! call repeat#set("\<Plug>DoToggleMarkAsDone")<CR>
noremap  <script> <silent> <buffer> <Plug>DoCancel :call todo#ToggleMarkAsDone('Cancelled')<CR>
                \:silent! call repeat#set("\<Plug>DoCancel")<CR>

" Default key mappings {{{2
if !exists("g:Todo_txt_do_not_map") || ! g:Todo_txt_do_not_map
" Sort todo by (first) context {{{3
    noremap  <script> <silent> <buffer> <localleader>sc :call todo#HierarchicalSort('@', '', 1)<CR>
    noremap  <script> <silent> <buffer> <localleader>scp :call todo#HierarchicalSort('@', '+', 1)<CR>

" Sort todo by (first) project {{{3
    noremap  <script> <silent> <buffer> <localleader>sp :call todo#HierarchicalSort('+', '',1)<CR>
    noremap  <script> <silent> <buffer> <localleader>spc :call todo#HierarchicalSort('+', '@',1)<CR>

" Sort tasks {{{3
    nnoremap <script> <silent> <buffer> <localleader>s :call todo#Sort("")<CR>
    nnoremap <script> <silent> <buffer> <localleader>s@ :call todo#Sort("@")<CR>
    nnoremap <script> <silent> <buffer> <localleader>s+ :call todo#Sort("+")<CR>

" Priorities {{{3
    " TODO: Make vim-repeat work on inc/dec priority
    noremap  <script> <silent> <buffer> <localleader>j :call todo#PrioritizeIncrease()<CR>
    noremap  <script> <silent> <buffer> <localleader>k :call todo#PrioritizeDecrease()<CR>

    noremap  <script> <silent> <buffer> <localleader>a :call todo#PrioritizeAdd('A')<CR>
    noremap  <script> <silent> <buffer> <localleader>b :call todo#PrioritizeAdd('B')<CR>
    noremap  <script> <silent> <buffer> <localleader>c :call todo#PrioritizeAdd('C')<CR>

" Insert date {{{3
if get(g:, "TodoTxtUseAbbrevInsertMode", 0)
    inoreabbrev <script> <silent> <buffer> date: <C-R>=strftime("%Y-%m-%d")<CR>

    inoreabbrev <script> <silent> <buffer> due: due:<C-R>=strftime("%Y-%m-%d")<CR>
    inoreabbrev <script> <silent> <buffer> DUE: DUE:<C-R>=strftime("%Y-%m-%d")<CR>
else
    inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>

    inoremap <script> <silent> <buffer> due: due:<C-R>=strftime("%Y-%m-%d")<CR>
    inoremap <script> <silent> <buffer> DUE: DUE:<C-R>=strftime("%Y-%m-%d")<CR>
endif

    noremap  <script> <silent> <buffer> <localleader>d :call todo#PrependDate()<CR>

" Mark done {{{3
    nmap              <silent> <buffer> <localleader>x <Plug>DoToggleMarkAsDone

" Mark cancelled {{{3
    nmap              <silent> <buffer> <localleader>C <Plug>DoCancel

" Mark all done {{{3
    noremap  <script> <silent> <buffer> <localleader>X :call todo#MarkAllAsDone()<CR>

" Remove completed {{{3
    nnoremap <script> <silent> <buffer> <localleader>D :call todo#RemoveCompleted()<CR>

" Sort by due: date {{{3
    nnoremap <script> <silent> <buffer> <localleader>sd :call todo#SortDue()<CR>
" try fix format {{{3
    nnoremap <script> <silent> <buffer> <localleader>ff :call todo#FixFormat()<CR>

" increment and decrement due:date {{{3
    nmap              <silent> <buffer> <localleader>p <Plug>TodotxtIncrementDueDateNormal
    vmap              <silent> <buffer> <localleader>p <Plug>TodotxtIncrementDueDateVisual
    nmap              <silent> <buffer> <localleader>P <Plug>TodotxtDecrementDueDateNormal
    vmap              <silent> <buffer> <localleader>P <Plug>TodotxtDecrementDueDateVisual

endif

" Additional options {{{2
" Prefix creation date when opening a new line {{{3
if exists("g:Todo_txt_prefix_creation_date")
    nnoremap <script> <silent> <buffer> o o<C-R>=strftime("%Y-%m-%d")<CR> 
    nnoremap <script> <silent> <buffer> O O<C-R>=strftime("%Y-%m-%d")<CR> 
    inoremap <script> <silent> <buffer> <CR> <CR><C-R>=strftime("%Y-%m-%d")<CR> 
endif

" Functions for maps {{{1
function! s:ChangeDueDateWrapper(by_days, repeat_mapping)
    call todo#CreateNewRecurrence(0)
    call todo#ChangeDueDate(a:by_days, 'd', '')
    silent! call repeat#set(a:repeat_mapping, v:count)
endfunction

" Folding {{{1
" Options {{{2
setlocal foldmethod=expr
setlocal foldexpr=TodoFoldLevel(v:lnum)
setlocal foldtext=TodoFoldText()

" Update fold method after sort by default
if ! exists("g:Todo_update_fold_on_sort")
    let g:Todo_update_fold_on_sort=1
endif

" Go to first completed task
let oldpos=getcurpos()
if(!exists("g:Todo_fold_char"))
    let g:Todo_fold_char='@'
    let base_pos=search('^x\s', 'ce')
    " Get next completed task
    let first_incomplete = search('^\s*[^<x\s>]')
    if (first_incomplete < base_pos)
        " Check if all tasks from
        let g:Todo_fold_char='x'
    endif
    call setpos('.', oldpos)
endif

function! s:get_contextproject(line) abort "{{{2
    return matchstr(getline(a:line), g:Todo_fold_char.'[^ ]\+')
endfunction "}}}3

" TodoFoldLevel(lnum) {{{2
function! TodoFoldLevel(lnum)
    let this_context = s:get_contextproject(a:lnum)
    let next_context = s:get_contextproject(a:lnum - 1)

    if g:Todo_fold_char == 'x'
        " fold on cmpleted task
        return  match(getline(a:lnum),'\C^x\s') + 1
    endif

    let fold_level = 0

    if this_context ==# next_context
        let fold_level = '1'
    else
        let fold_level = '>1'
    endif

    return fold_level
endfunction

" TodoFoldText() {{{2
function! TodoFoldText()
    let this_context = s:get_contextproject(v:foldstart)
    if g:Todo_fold_char == 'x'
        let this_context = 'Completed tasks'
    endif
    " The text displayed at the fold is formatted as '+- N Completed tasks'
    " where N is the number of lines folded.
    return '+' . v:folddashes . ' '
                \ . (v:foldend - v:foldstart + 1)
                \ .' '. this_context.' '
endfunction

" Restore context {{{1
let &cpo = s:save_cpo

" vim: tabstop=4 shiftwidth=4 softtabstop=4 expandtab foldmethod=marker
