" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      David Beniamine <david@beniamine.net>, Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/dbeniamine/todo.txt-vim

autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead [Tt]odo-\d\\\{4\}-\d\\\{2\}-\d\\\{2\}.txt set filetype=todo
autocmd BufNewFile,BufRead [Tt]odo-\d\\\{4\}-\d\\\{2\}.txt set filetype=todo
autocmd BufNewFile,BufRead \d\\\{4\}-\d\\\{2\}-\d\\\{2\}-[Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead \d\\\{4\}-\d\\\{2\}-[Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead [Tt]oday.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one-\d\\\{4\}-\d\\\{2\}-\d\\\{2\}.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one-\d\\\{4\}-\d\\\{2\}.txt set filetype=todo
autocmd BufNewFile,BufRead \d\\\{4\}-\d\\\{2\}-\d\\\{2\}-[Dd]one.txt set filetype=todo
autocmd BufNewFile,BufRead \d\\\{4\}-\d\\\{2\}-[Dd]one.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one-[Tt]oday.txt set filetype=todo
autocmd BufNewFile,BufRead */.todo/*.txt set filetype=todo

if exists("$TODO_DIR")
    au BufNewFile,BufRead $TODO_DIR/*.txt set filetype=todo
endif

if exists("$TODO_FILE")
    au BufNewFile,BufRead $TODO_FILE set filetype=todo
endif

if exists("$DONE_FILE")
    au BufNewFile,BufRead $DONE_FILE set filetype=todo
endif

" vim: tabstop=4 shiftwidth=4 softtabstop=4 expandtab foldmethod=marker
