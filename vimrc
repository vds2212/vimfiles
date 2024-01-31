" 0. Vim Default
" ==============

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Make sure backspace can delete every character including
" leading tab, end of line, ...
" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Set command history to 1000
set history=1000		" keep 1000 lines of command line history

" Always show ruler (current row/column etc.)
" set ruler		" show the cursor position all the time

" Make the current command visible
" (a keystroke buffer at the bottom right of Vim)
set showcmd		" display incomplete commands

" Basic wildmenu (propose possible completion in the status bar)
set wildmenu		" display completion matches in a status line
" set wildmode=full

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Make sure at least tree context lines are available while scrolling
" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
" set scrolloff=3

" Make sure at least five context columns are available while scrolling
" set sidescrolloff=5

" Make the search incremental by default
" Remark: Alternative to that is incsearch plugin (partly integrated into vim)
" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q
" nnoremap Q <Nop>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    " Enable mouse support in all modes
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  " Make the "vimviles/ftdetect" folder used to set filetype
  filetype on

  " Make the "vimviles/ftplugin" folder used when a filetype is detected
  filetype plugin on

  " Make the "vimfiles/indent" folder used when a filetype is detected
  filetype indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | exe 'au!' | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":augroup vimHints | exe 'au!' | augroup END"
"  augroup vimHints
"    au!
"    autocmd CmdwinEnter *
"	  \ echohl Todo |
"	  \ echo 'You discovered the command-line window! You can close it with ":q".' |
"	  \ echohl None
"  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  " Enable syntax highlighting
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
"  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
"		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" 1. Standard Vim Settings
" ========================

scriptencoding utf-8

" Set the user interface encoding to utf-8
set encoding=utf-8

" Allow ligature in gVim
" Remark:
" - Ligature doesn't seems to be supported by nvim-qt
" - Ligature is a Font feature (e.g.: available in Fira_Code that merge two
"   characters into one e.g. <= become ≤ or |> become ▷)
if !has('nvim')
  if has('win32')
    set renderoptions=type:directx
  else
    set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~
  endif
endif
" if a <= b: print("ligature")

let s:gui_running = has('gui_running') || has('nvim')

function! GetVimDataFolder()
  if has('nvim')
    let l:vim_data_folder = stdpath('data') .. '/'
  else
    if has('win32')
      if $HOME != ''
        let l:vim_data_folder = $HOME .. '/vimfiles/'
      else
        let l:vim_data_folder= ' ~/vimfiles/'
      endif
    else
      if $HOME != ''
        let l:vim_data_folder = $HOME .. '/.vim/'
      else
        let l:vim_data_folder= '~/.vim/'
      endif
    endif
  endif
  let l:vim_data_folder = expand(l:vim_data_folder)
  return l:vim_data_folder
endfunction

" Define the <leader> key to \ (the default)
let mapleader=" "
let maplocalleader=" "

" Avoid vim timeout e.g. When the user wait too much before completing the leader combination
" I advice that setting for beginners
" set notimeout

" Set mapping timeout to 2000 ms (2 sec)
set timeoutlen=2000

" Show line numbers
set number

" Make sure the number in the margin are relative to the current line
" instead of absolute.
" set relativenumber
set norelativenumber

" Show the current mode: normal, insert, visual
" set showmode

" Set tabs to have 4 spaces
set tabstop=4

" Indent when moving to the next line while writing code
set autoindent

" Expand tabs into spaces
set expandtab

" When using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" Make vim not inserting an eol character at the end of the file
" set nofixeol

" Show a visual line under the cursor's current line
if s:gui_running
  set cursorline
else
  hi DiffDelete ctermbg=5 ctermfg=white
  hi DiffChange ctermbg=3 ctermfg=white
  hi DiffText   ctermbg=1 ctermfg=white
  hi DiffAdd    ctermbg=1 ctermfg=white
endif

" Show the matching part of the pair for [] {} and ()
set showmatch
" set matchtime=2

" Allow to switch buffers without saving:
set hidden

" Temporarily disable highlighting with Ctrl-l (Neovim default)
" Disabled since used to move between slits
" nnoremap <C-l> :noh<CR>

" Make the default search case insensitive
" Remarks:
" - Patterns can be made case sensitive by using the \C sequence in the
"   pattern
" - Patterns can be made case insensitive by using the \c sequence in the
"   pattern
set ignorecase

" If a pattern contains an uppercase the search will be case sensitive
set smartcase

" Highlight the search by default
set hlsearch

" Make the default search global
" remark: to get back the non g behavior in search use the g flag
set gdefault

" Show the count message when searching
set shortmess-=S

" By default unfold completely the buffer when loaded:
set foldlevel=999

" Search a string that can't be fond to stop highlighting search
command! Noh :s/91385034739874398234/

" Automatically translate é into @ in normal mode
" But not in
" - insert mode,
" - replace mode,
" - command mode,
" - ...
set langmap=é@,

" Make sure file completion use '/' instead of '\' as file separator:
" Disabled since:
" - Vim-Plug doesn't support it
" - Fern doesn't support it.
" set shellslash

" Make sure the file are automatically reloaded if not modified in vim
set autoread

" Set the viminfo/shada options
" - save and restore global variable (!)
" - set the number of oldfile remembered to 500 [default=100] ('500)
" - set the number of register lines remembered to 50 [default=50] (<50)
" - set the size of saved item to 10 kb [default=s10] (s10)
" - disable the effect of hlsearch when reading viminfo [default] (h)
" - don't save mark for removable media file [default] (ra:,rb:)
if has('nvim')
  set shada=!,'500,<50,s10,h
else
  set viminfo='500,<50,s10,h,rA:,rB:
endif

" Change the working directory to the file currently edited
" Prefer the plugin vim-rooter that changes the working directory to the root
" of the version control system (.git, .svn, .hg)
" set autochdir

" set whichwrap+=<,>,h,l

" Make sure that by yank and paste operation use the system register (clipboard)
if has('unix')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" In visual mode restore the "" register after paste:
" xnoremap p pgvy
xnoremap p P

" Restore the '"' register if it has been used to paste
" xnoremap <expr> p v:register=='"'?'pgvy':'p'

" Restore the last used register after paste:
" xnoremap <expr> p 'pgv"'.v:register.'y`>'

" Restore the last used register after paste:
" xnoremap p pgv"@=v:register.'y'<cr>

" Make that o/O don't create a new comment line when editing a comment line
set formatoptions-=o

" Make that <CR> create a new comment line when editing a comment line
set formatoptions+=r

" Make j join comment line by removing the prefix while joining
set formatoptions+=j

" Make that C/C++ inline comments (//) are not continued
set formatoptions+=/

" Get rid of the introduction message when starting Vim
" set shortmess=+I

" Make vim not beeping when an error occur
set noerrorbells
set visualbell
" Make vim not using flashing screen when an error occur
set t_vb=
if has('autocmd')
  augroup silent
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=
  augroup END
endif

" Make vim not beeping when an error occur (alternative solution)
" set belloff=all

" Open split below and on the right by default
" (the standard is up and on the left)
" set splitbelow
set splitright

if s:gui_running
  " Set the auto spelling to English us
  set spell spelllang=en_us
else
  set nospell
endif

" Save undo trees in files (such that they are available after vim is closed)
set undofile
"
" folder to store the undo files (the folder has to be created first)
" Save undo files in the .undo sub-folder (if it exists)
" Otherwise in the ~/vimfiles/undo folder (if it exists)
" It avoid to pollute your local folder
if !isdirectory(GetVimDataFolder() .. 'undo')
    call mkdir(GetVimDataFolder() .. 'undo')
endif
exe 'set undodir=' .. '.undo/,' .. GetVimDataFolder() .. 'undo/'

" number of undo saved
set undolevels=10000

" Turn off swap files
" set noswapfiles

" Save swap files in the .swap sub-folder (if it exists)
" Otherwise in the ~/vimfiles/swap folder (if it exists)
" (instead of next to the real file)
" It avoid to pollute your local folder
if !isdirectory(GetVimDataFolder() .. 'swap')
    call mkdir(GetVimDataFolder() .. 'swap')
endif
exe 'set directory=.swap/,' .. GetVimDataFolder() ..'swap/'

" Define/Create the view folder to store information from :mkview
if !isdirectory(GetVimDataFolder() .. 'view')
    call mkdir(GetVimDataFolder() .. 'view')
endif
exe 'set viewdir=' .. GetVimDataFolder() ..'view/'

" Disable backup files (the myfile.myext~ files)
" It seems to be the default
set nobackup
set nowritebackup
if !isdirectory(GetVimDataFolder() .. 'backup')
    call mkdir(GetVimDataFolder() .. 'backup')
endif
" exe 'set backupdir=.backup//,' .. GetVimDataFolder() ..'backup//'
" exe 'set backupdir=.backup/,' .. GetVimDataFolder() ..'backup/'

" Mapping between non printable characters (e.g.: eol or tab) and Unicode char.
set listchars=eol:¶,tab:→\ ,space:.,trail:~,extends:>,precedes:<,nbsp:-
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Make non-printable characters visible:
" Remark:
" - With set nolist the cursor is at the end of the tab
" - With set list the cursor is at the start of the tab
set list

" Set the size of the terminal windows to be 10 rows
" Remark: commented since it has an impact on the defalut vimspector layout
" set termwinsize=10x0

" To make `gF` working with the syntax filename:linenb:
set isfname-=:

" Set the font
" On Neovim the operation is done using the GuiFont command in ginit.vim
" On gVim the command set guifont=* query the user for the font he wants.
if s:gui_running
  if has('win32')
    " Remark:
    " - Vim support both syntax for font containing space (i.e. '\ ' and '_')
    " - Neovim only support the '\ ' syntax

    " set guifont=Lucida\ Console:h9
    " set guifont=Consolas:h9

    " set guifont=Source\ Code\ Pro\ for\ Powerline:h10

    " set guifont=Fira\ Code:h9:cANSI
    " set guifont=Fira\ Code\ Nerd\ Font\ Mono:h9:cANSI

    " set guifont=Cousine:h9:cANSI
    " set guifont=Cousine\ Nerd\ Font\ Mono:h9:cANSI

    " JetBrainsMono without Ligatures
    " set guifont=JetBrainsMonoNL\ NFM:h9:cANSI
    " JetBrainsMono with Ligatures
    set guifont=JetBrainsMono\ NFM:h9:cANSI
  endif

  if has('unix')
    " set guifont=DejaVu\ Sans\ Mono\ 9
    set guifont=DejaVuSansM\ Nerd\ Font\ Mono\ 9
    " set guifont=DejaVuSansM\ Nerd\ Font\ Mono\ 9
    " set guifont=JetBrains\ Mono\ Bold\ 9
    set guifont=JetBrains\ Mono\ 9
  endif

  " Remove menu bar
  set guioptions-=m

  " Remove tool bar
  set guioptions-=T

  " Remove right-hand scroll bar
  " set guioptions-=r

  " Remove left-hand scroll bar
  set guioptions-=L

  " " Add bottom scroll bar
  " set guioptions+=b

  " Move visual selection (mouse selection or v selection) automatically to
  " the system clipboard:
  " Remarks:
  " - Confusing with the clipboard=unamed
  " - Useful temporarily to capture messages in the clipboard
  " set guioptions+=a

else
  set cmdheight=2
endif

" Make vim not wrapping long lines
set nowrap

" Turn the bottom scroll bar on and off depending on the value of
" the wrap flag.
if &wrap
  set guioptions-=b
else
  set guioptions+=b
endif

augroup scrollbar
  autocmd!
  autocmd OptionSet wrap if &wrap|set guioptions-=b|else|set guioptions+=b|endif
augroup END

" Make vim breaking line at words boundaries instead of at line length
" for wrapping long lines.
set linebreak

" Set the Tab Label to:
" - Tab index
" - File name (tail)
" - Modified flag (+ | -)
set guitablabel=[%N]\ %t\ %M

" Move between splits
" Remark:
" - Terminal do not support these moves
" - CtrlSF override them
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Restore Vim to its previous size and position
if s:gui_running
  function! ScreenFilename()
    let l:vim_data_folder = g:GetVimDataFolder()
    if has('amiga')
      return "s:.vimsize"
    else
      return l:vim_data_folder .. '_vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let gui_running = has('gui_running')
    let f = ScreenFilename()
    if gui_running && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    let gui_running = has('gui_running')
    if gui_running && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance .. ' ' .. &columns .. ' ' .. &lines .. ' ' ..
            \ (getwinposx()<0?0:getwinposx()) .. ' ' ..
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" .. vim_instance .. "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  if !has('nvim')
    " Neovim seems to keep its size from Windows
    augroup savepos
      autocmd!
      autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
      autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
    augroup END
  endif
else
  " Set the windows size to be 46, 100
  " Set to the size of the corresponding console window
  " set lines=46 columns=100

  " if !has('nvim') && $ConEmuANSI == 'ON'
  "   " set termencoding=utf8
  "   set term=xterm
  "   set t_Co=256
  "   let &t_AB="\e[48;5;%dm"
  "   let &t_AF="\e[38;5;%dm"

  "   " inoremap <Char-0x07F> <BS>
  "   " nnoremap <Char-0x07F> <BS>

  "   set encoding=cp1252
  " endif
endif

" Make sure the split are reset to equal height and width when vim is resized.
" This is useful when using vim as vimdiff to compare both file on the same
" screen
autocmd VimResized * wincmd =

" Make sure the QuickFix and LocationList open at the bottom of the screen
augroup quickfix
  autocmd FileType qf wincmd J
augroup END

" Allow block selection to cover region past the end of the line:
set virtualedit=block

" Netrw settings:
" ---------------

" Allow the gx command that open a file with the associated viewer/editor
" Allow directory navigation

" Disable Netrw
" let loaded_netrwPlugin = 0

" Hide the directory banner
let g:netrw_banner = 0

" Make it is possible to close the netrw buffer
" autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0

" Workaround to make the Ctrl-] working on a Belgian keyboard with Vim 9.0
" Remark: The <C-]> is used to navigate through the help system
if !has('nvim')
  nnoremap <C-$> <C-]>
endif

" 2. Plugins
" ==========

" Table of Content
" 2.1. Look & Feel
"     2.1.1. Color Scheme
"     2.1.2. Devicon
"     2.1.3. Status Line
" 2.2.  Ergonomic
"     2.2.1. Unimpaired
"     2.2.2. Wilder
"     2.2.3. Repeat
"     2.2.4. Text Objects
"     2.2.5. Dashboard
"     2.2.6. Windows
"     2.2.7. Clipboard
"     2.2.8. Search
"     2.2.9. Moves
"     2.2.10. Unicode
"     2.2.11. Multiple Cursors
"     2.2.12. CSS Colors
"     2.2.13. Miscellaneous
" 2.3.  File Browsing
"     2.3.1. Rooter
"     2.3.2. Fuzzy searching
"     2.3.3. File searching
"     2.3.4. File browsing
" 2.4.  Sessions
" 2.5.  Bookmark
" 2.6.  Undo Tree
" 2.7.  Difference
"     2.7.1. Diff Char
"     2.7.2. Diff Command
" 2.8.  Git
"     2.8.1. Git Operation
"     2.8.2. Git Signs
"     2.8.3. Git Helper
" 2.9.  Indentation
"     2.9.1. Indentation lines
"     2.9.2. EditorConfig
"     2.9.3. Sleuth
" 2.10. Align
" 2.11. Folding
"     2.11.1. Fold Creation
"     2.11.2. Fold Handling
" 2.12. Commenting
" 2.13. Parenthesis
"     2.13.1. Surround
"     2.13.2. Auto-Pair
" 2.14. Snippet
" 2.15. Tags
"     2.15.1. Tag Generation
"     2.15.2. Tag Browsing
" 2.16. Code Completion
" 2.17. Code Formatting
"     2.17.1. ISort
"     2.17.2. Prettier
" 2.18. Linting
"     2.18.1. Linting Engine
"     2.18.2. Linting Mark
" 2.19. Asynchronous Run
" 2.20. QuickFix filtering
" 2.21. Terminal
" 2.22. Debugging
" 2.23. File Types
"     2.23.1. VimScript
"     2.23.2. Markdown
"     2.23.3. CSV
"     2.23.4. Rust
"     2.23.5. Jinja
"     2.23.6. Logs

function! IsPlugInstalled()
  if has('nvim')
    let plug_file = GetVimDataFolder() .. 'site/autoload/plug.vim'
  else
    let plug_file = GetVimDataFolder() .. 'autoload/plug.vim'
  endif
  if empty(glob(plug_file))
    return 0
  else
    return 1
  endif
endfunction

function! InstallPlug()
  let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if has('win32')
    if has('nvim')
      let cmd = 'silent !powershell -Command "&{iwr -useb ' .. l:plug_url .. ' | ni ' .. GetVimDataFolder() .. 'site/autoload/plug.vim -Force}"'
    else
      let cmd = 'silent !powershell -Command "&{iwr -useb ' .. l:plug_url .. ' | ni ' .. GetVimDataFolder() .. 'autoload/plug.vim -Force}"'
    endif
  else
    if has('nvim')
      let cmd = 'silent !curl -fLo ' .. GetVimDataFolder() .. 'site/autoload/plug.vim --create-dirs ' .. l:plug_url
    else
      let cmd = 'silent !curl -fLo ' ..GetVimDataFolder() .. 'autoload/plug.vim --create-dirs ' .. l:plug_url
    endif
  endif
  execute cmd
endfunction

if !IsPlugInstalled()
  call InstallPlug()
endif

" Initialization of the switches:

let s:plugins = 1

function! s:activate(flag)
  " let s:[a:flag] = a:value
  if a:flag ==# 'startuptime'
    let s:[a:flag] = 1
    return
  endif
  if !s:plugins
    let s:[a:flag] = 0
  else
    let s:[a:flag] = 1
  endif
endfunction

function! s:isactive(flag)
  if !exists("s:" . a:flag)
    return 0
  endif
  return s:[a:flag]
endfunction

" Plugin Selection

" Selection of the plugins/features you want to keep:
if 1
  " 2.1. Look & Feel
  " ---------------

  " 2.1.1. Color Scheme
  " ------------------

  " call s:activate('vim_gruvbox')

  " call s:activate('Vim_color_solarized')

  " call s:activate('tokyonight')

  " call s:activate('onedark')

  " call s:activate('molokai')

  " call s:activate('papercolor')

  call s:activate('nord_vim')

  " call s:activate('everforest')

  " call s:activate('kanagawa')

  " call s:activate('afterglow')

  " 2.1.2. Devicon
  " -------------

  " Add Language specific icons to NerdTree, AirLine, LightLine, ...
  " Depend on full font to be download at: https://github.com/ryanoasis/nerd-fonts/
  " Set the guifont to the installed Nerd-Font (e.g.: Cousine_Nerd_Font_Mono)
  call s:activate('vim_devicons')

  " 2.1.3. Status Line
  " -----------------

  " Status line enrichment
  " call s:activate('vim_airline')

  " call s:activate('powerline')

  call s:activate('vim_lightline')

  " 2.2. Ergonomic
  " -------------

  " 2.2.1. Unimpaired
  " ----------------

  " Add a number of [x ]x mapping
  call s:activate('vim_unimpaired')

  " 2.2.2. Wilder
  " ------------

  " Command line helper (completion, proposition)
  " Remark:
  "   A addition call to :UpdateRemotePlugins may needed
  call s:activate('wilder')
  call s:activate('wilder_simple')

  " 2.2.3. Repeat
  " ------------

  " Make the '.' repeat action working with:
  " - vim-unimpaired
  " - vim-surround
  " - vim-easyclip
  " call s:activate('vim_repeat')

  " call s:activate('repmo')

  " call s:activate('repeatable_motion')

  " Make the ';', ',' repeat motion working for more motions:
  call s:activate('vim_remotions')

  " 2.2.4. Text Objects
  " -------------------

  " Improved Text Objects
  " - Multiple line strings
  call s:activate('target_vim')

  " - Indentation block
  call s:activate('vim_ident_object')

  " Text object and motions for Python code
  call s:activate('vim_pythonsense')

  " Indentation moves (seems to be buggy):
  " [- parent indentation
  " [= previous sibling indentation
  " ]= next sibling indentation
  " call s:activate('vim_indentwise')

  " 2.2.5. Dashboard
  " ---------------

  " call s:activate('vim_startify')

  if has('nvim')
    " call s:activate('dashboard_vim')
  endif

  " 2.2.6. Windows
  " --------------

  " Allows you to close buffer without closing the corresponding window
  " Introducing the :Bd command
  " call s:activate('vim_bbye')

  " Re-size windows
  " call s:activate('winresizer')

  " Split management
  " call s:activate('vim_maximizer')

  " Allow to run vim in full screen
  " call s:activate('vim_fullscreen')

  " 2.2.7. Clipboard
  " ----------------

  " Highlight the yanked text:
  if !has('nvim')
    call s:activate('vim_highlightedyank')
  else
    " Neovim has it own way to highlight yank:
    call s:activate('neovim_highlightedyank')
  endif

  " Highlight the yanked text:
  " call s:activate('vim_illuminate')

  " Introduce Move and change Delete:
  " call s:activate('vim_cutlass')

  " Introduce a Yank Ring:
  " call s:activate('vim_yoink')

  " 2.2.8. Search
  " -------------

  " Visual Selection Search (using '*' and '#')
  call s:activate('vim_visual_star_search')

  " Preview substitution of the s command before performing it
  " Remarks:
  "   Trace is not necessary for NeoVim
  "   Since Vim 8.1.0271 incseach highlight the match
  if !has('nvim')
    call s:activate('traces')
  endif

  " Highlight all pattern match
  " Remark:
  "   In the meantime the set incsearch bring a fair fraction of the features
  " call s:activate('incsearch')

  " New version of incsearch
  " - Highlight all pattern match
  " - Stop highlighting on cursor move
  " call s:activate('is_vim')

  " Case sensitive search and replace
  call s:activate('vim_abolish')

  " 2.2.9. Moves
  " -------------

  " Extend the matching '%' movement to matching keywords
  call s:activate('matchit_legacy')

  " Extend the matching '%' movement to matching keywords
  " call s:activate('vim_matchup')

  " Add alternatives to the f <char> motion and friends (f, F, t, T)
  " Remark:
  " - You get the \\f <char> motion and friends (f, F, t, T)
  " call s:activate('vim_easymotion')

  " call s:activate('leap')

  " call s:activate('vim_sneak')

  " 2.2.10. Unicode
  " --------------

  " Help to find Unicode characters
  " Remark:
  " - Seems to be broken on Windows (23/03/2023)
  call s:activate('unicode_helper')

  " Help to understand Unicode characters
  " call s:activate('vim_characterize')

  " 2.2.11. Multiple Cursors
  " -----------------------

  " Multiple cursors
  " call s:activate('vim_visual_multi')

  " Multiple cursors for parallel modifications
  " call s:activate('vim_multiple_cursors')

  " 2.2.12. CSS Colors
  " -----------------

  " Highlight color codes
  call s:activate("vim_css_color")

  " Remarks:
  " - Requires: Go Language installation
  " call s:activate('hexokinase')

  " Remarks:
  " - Requires: awk
  " - Requires: Cygwin?
  " - Doesn't seems to work on windows
  " call s:activate('clrzr')

  " Remarks:
  " - Doesn't seems to be supported anymore
  " call s:activate('colorizer')

  " 2.2.13. Miscellaneous
  " ---------------------

  " Make C-x C-f completion relative to the file and not to the current working directory
  call s:activate('vim_relatively_complete')

  " call s:activate('vim_expand_region')

  " Hint about keyboard shortcuts
  " call s:activate('which_key')

  " call s:activate('vim_peekaboo')

  " Basic large files support
  " Make large files not slowing down vim as much as possible
  " call s:activate('large_file')

  " Add the CheckHealth command to Vim
  if !has('nvim')
    call s:activate('checkhealth')
  endif

  call s:activate('startuptime')

  " Register visibility
  " Ensure the context lines keep being visible
  call s:activate('context')

  " Spell checking
  " call s:activate('vim_spellcheck')

  " Add database query support
  call s:activate('vim_dadbod')

  " call s:activate('vim_dadbod_ui')

  " Remarks:
  " - It seems that when a file is locked by Excel sudo prevent the saveas
  "   method to work
  " call s:activate('sudoedit_vim')

  " call s:activate('vim_cool')

  " call s:activate('vimcaps')

  " Highlight briefly the cursor when it jump from split to split
  " call s:activate('beacon')

  " Introduce a LongLines mode where the j and k key works like gj and gk
  " call s:activate('vim_long_lines')

  " Interactive Scratchpad
  " Remarks:
  " - Currently only working for Linux or MacOS
  " call s:activate('codi_vim')

  " Tridactyl Firefox add-on support
  call s:activate('vim_tridactyl')

  call s:activate('vim_orpheus')

  " 2.3. File Browsing
  " ------------------

  " 2.3.1. Rooter
  " -------------

  " Adapt automatically the working directory
  call s:activate('vim_rooter')

  " 2.3.2. Fuzzy Searching
  " ---------------------

  " FzF (File Fuzzy Finder)
  " Remark:
  " - In order to make preview working make sure C:\Program Files\Git\Bin is part of the path.
  " - On Windows it seems FzF proposes buffers with the wrong path
  " call s:activate('fzf')

  " Fuzzy finder
  " call s:activate('ctrlp')

  " In order to make tag generation working install maple:
  " Downloading from GitHub:
  "   :call clap#installer#download_binary()
  " Or building from source using Rust
  "   :call clap#installer#build_maple()
  " Remark:
  "   - Deleting the vimfiles/plugged/vim-clap/bin/maple.exe manually to make
  "     sure it is replaced by the fresh version.
  call s:activate('vim_clap')

  " Remark:
  "   Only available for NeoVim
  if has('nvim')
    call s:activate('nvim_telescope')
    call s:activate('telescope_live_grep_arg')
  endif

  " call s:activate('bufexplorer')

  " 2.3.3. File searching
  " --------------------

  " Remark:
  " - Seems not to support asynchronous mode on Windows
  " call s:activate('ack_vim')

  " Remark:
  " - Seems to work in asynchronous mode on Windows
  call s:activate('ctrlsf')

  " call s:activate('ferret')

  " 2.3.4. File browsing
  " -------------------

  " call s:activate('nerdtree')

  if has('nvim')
    call s:activate('nvim_tree')
  endif

  call s:activate('fern')

  " File browser netrw helper
  " call s:activate('vim_vinegar')

  " 2.4. Sessions
  " -------------

  " Session management made easy
  " call s:activate('vim_obsession')

  " Addition to Obsession
  " call s:activate('vim_prosession')

  " Auto-reload the my session at startup
  " call s:activate('reload_session_at_start')

  " 2.5. Bookmark
  " -------------

  " Bookmarks made easy
  " - Add mark in the margin
  " - Provide shortcut to add and remove marks
  call s:activate('vim_signature')

  " Bookmarks made easy
  " call s:activate('vim_bookmarks')

  " 2.6. Undo Tree
  " --------------

  " Visualize and Navigate the undo tree:
  call s:activate('undotree')

  " Visualize and Navigate the undo tree:
  " call s:activate('gundo')

  " Visualize and Navigate the undo tree:
  " call s:activate('vim_mundo')

  " 2.7. Difference
  " ---------------

  " 2.7.1. Diff Char
  " ---------------

  " Diff at char level
  call s:activate('diffchar')

  " 2.7.2. Diff Command
  " ------------------

  " Introduces the DiffOrig command that compare the current file with the
  " saved version
  " call s:activate('difforig')
  
  " 2.7.3 Spot Diff
  " ---------------

  " Introduces the Diffthis command that let you compare range of buffers
  call s:activate('spotdiff')


  " 2.8. Git
  " --------

  " 2.8.1. Git Operation
  " -------------------

  " Git integration
  " call s:activate('vim_fugitive')


  " 2.8.2. Git Signs
  " ---------------

  " call s:activate('vim_signify')

  " Remarks:
  " - Only for Git
  " - Only for Neovim
  " call s:activate('gitsigns')

  " call s:activate('vim_gitgutter')

  " 2.8.3. Git Helper
  " ----------------

  " call s:activate('vim_gitbranch')

  " 2.9. Indentation
  " ----------------

  " 2.9.1. Indentation lines
  " -----------------------

  " Visualize indentation vertical lines
  " call s:activate('indentline')

  " call s:activate('vim_indent_guides')

  " 2.9.2. EditorConfig
  " ------------------

  " Let each project have its own setting regarding:
  " - Indentation
  " - Trailing Whitespaces
  " - ...
  " call s:activate('editorconfig')

  " 2.9.3. Sleuth
  " ------------

  " call s:activate('vim_sleuth')

  " 2.10. Align
  " -----------

  " Alignment made easy
  " call s:activate('vim_easy_align')

  " Alignment made easy
  " call s:activate('tabular')

  " 2.11. Folding
  " -------------

  " 2.11.1. Fold Creation
  " --------------------

  " Fold based on indentation
  call s:activate('any_fold')

  " Python code folding
  " Remarks:
  "   any_fold seems to give better results
  " call s:activate('simpylfold')

  " 2.11.2. Fold Handling
  " --------------------

  " Folding level control using [ret] and [bs]
  " call s:activate('cycle_fold')

  " Limit fold computation and update to improve speed
  " call s:activate('fast_fold')

  " 2.12. Commenting
  " ----------------

  call s:activate('vim_commentary')

  " call s:activate('nerdcommenter')

  " 2.13. Parenthesis
  " -----------------

  " 2.13.1. Surround
  " ---------------

  " Add additional commands to manage pairs
  call s:activate('vim_surround')

  " 2.13.2. Auto-Pair
  " ----------------

  " Automatically introduce the pairing character
  " (e.g. ", ', (, [, etc. )

  " Remark:
  " - Seems to support the dot command
  " call s:activate('auto_pairs')

  " Remark:
  " - Claim to support the dot command
  " call s:activate('lexima')

  " call s:activate('vim_closing_brackets')

  " Remark:
  " - Seems not to support the dot command
  " call s:activate('auto_pairs_gentle')

  " 2.14. Snippet
  " -------------

  " Remark: for coc user a coc-snippets is available suggesting snippets
  " - :CocInstall coc-snippets

  call s:activate('ultisnips')

  " call s:activate('emmet_vim')

  " 2.15. Tags
  " ----------

  " 2.15.1. Tag Generation
  " ---------------------

  " Automatic tag generation
  call s:activate('vim_gutentags')

  " 2.15.2. Tag Browsing
  " -------------------

  " Remarks:
  " - Telescope requires traditional tags
  call s:activate('tagbar')

  " call s:activate('vista_vim')

  " 2.16. Code Completion
  " ---------------------

  " Remark:
  " - Depend on Node.js
  "   - sudo apt install nodejs
  "   - sudo apt install npm
  " - Run the CocInstall command for each language you want to support:
  "   - CocInstall coc-json
  "   - CocInstall coc-pyright
  "   - CocInstall coc-snippets
  "   - CocInstall coc-tsserver

  "   - CocInstall coc-rust-analyzer
  "     Depends on:
  "     - rustup component add rust-analyzer

  "   - CocInstall coc-pairs (overtaken by auto-pairs-gentle)
  "   - CocInstall coc-jedi (overtaken by coc-pyright)
  "     Depends on (optionally if jedi-language-server is not available the
  "     installation should be triggered):
  "     - pip install jedi-language-server
  " - Depends on pip install jedi-language-server
  call s:activate('coc_nvim')

  " Remark: Install additional lsp modules with:
  " - MasonInstall pyright
  if has('nvim')
    call s:activate('lsp')
  endif

  " Code completion
  " Remark:
  " - To complete the installation make sure you have:
  "   - CMake
  "   - Visual Studio 2019 or superior
  "   - The Python that match Vim (e.g.: Python 3.10 for Vim 9.0)
  "   - Go
  " - Run: install.py
  " call s:activate('you_complete_me')

  " Code Completion
  " Remark:
  " - Install the corresponding plugin for each language you want to support:
  "   - deoplete-jedi
  "   - deoplete-rust
  " call s:activate('deoplete')

  " Python code completion
  " call s:activate('jedi_vim')

  " Semantic highlighting
  " call s:activate('semshi')

  " Semantic highlighting
  " call s:activate('hlargs')

  " 2.17. Code Formatting
  " ---------------------

  " 2.17.1. ISort
  " ------------

  " Sort Python imports
  call s:activate('vim_isort')

  " 2.17.2. Prettier
  " ---------------

  " Format Web files (.html, .css, .ts, ...)
  " call s:activate('vim_prettier')

  " Support for javascript react files
  " call s:activate('vim_jsx_pretty')

  " 2.18. Linting
  " -------------

  " 2.18.1. Linting Engine
  " ----------------------

  " call s:activate('ale')

  " call s:activate('lightbulb')

  if has('nvim')
    call s:activate('treesitter')
  endif

  " 2.18.2. Linting Mark
  " -------------------

  " call s:activate('vim_syntastic')

  " 2.19. Asynchronous Run
  " ----------------------

  " call s:activate('asyncrun')

  " call s:activate('vim_dispatch')

  " 2.20 QuickFix filtering
  " -----------------------

  " call s:activate('cfilter')

  " call s:activate('vim_editqf')

  " 2.20. Terminal
  " --------------

  " call s:activate('vim_floaterm')

  " vim-clap support for floaterm
  " call s:activate('clap_floaterm')

  " Terminal support
  " call s:activate('neoterm')

  " 2.21. Debugging
  " ---------------

  call s:activate('vimspector')

  if has('nvim')
    call s:activate('nvim_dab')
  endif

  " 2.22. File Types
  " ----------------

  " 2.22.1. VimScript
  " -----------------

  " Helper to analyze vim scripts
  call s:activate('vim_scriptease')

  " Helper to debug vim scripts
  call s:activate('lh_vim_lib')

  " Helper to analyze syntax
  " Remark:
  " - scriptease comes with the zS action
  " call s:activate('vim_synstax')

  " 2.22.2. Markdown
  " ----------------

  " Add vim wiki
  " Remark:
  " - On some files it prevent to insert a carriage return
  call s:activate('vimwiki')

  if has('nvim')
    call s:activate('neorg')
  endif

  " Markdown extra support
  " Remark:
  " - Doesn't seems compatible with vimwiki
  call s:activate('vim_markdown')

  " Markdown preview
  " call s:activate('markdown_preview')

  " 2.22.3. CSV
  " -----------

  call s:activate('csv')

  " call s:activate('rainbow_csv')

  " 2.22.4. Rust
  " ------------

  " Rust support
  " call s:activate('rust_vim')

" 2.23.5. Jinja
" -------------

  call s:activate('vim_jinja2_syntax')

" 2.23.6. Logs
" ------------

  call s:activate('vim_log_highligthing')

" 2.23.7 TeX/LaTeX
" ----------------

  " call s:activate('vimtex')

  " call s:activate('vimlatex')

endif

" Make sure at least "nord" FzF (File Fuzzy Finder)
" and "gruvbox" color scheme are loaded
let s:nord_vim = 1
" let s:vim_gruvbox = 1

if s:isactive('matchit_legacy')
  runtime macros/matchit.vim
endif

call plug#begin()

" 2.1. Look & Feel
" ---------------

" 2.1.1. Color Scheme
" ------------------

if s:isactive('vim_gruvbox')
  Plug 'morhetz/gruvbox'
endif

if s:isactive('Vim_color_solarized')
  Plug 'altercation/vim-colors-solarized'
endif

if s:isactive('tokyonight')
  Plug 'folke/tokyonight.nvim'
endif

if s:isactive('onedark')
  Plug 'joshdick/onedark.vim'
endif

if s:isactive('molokai')
  Plug 'tomasr/molokai'
endif

if s:isactive('papercolor')
  Plug 'NLKNguyen/papercolor-theme'
endif

if s:isactive('nord_vim')
  " Plug 'nordtheme/vim'
  Plug 'nordtheme/vim', {'as': 'nordtheme'}
endif

if s:isactive('everforest')
  Plug 'sainnhe/everforest'
endif

if s:isactive('kanagawa')
  Plug 'rebelot/kanagawa.nvim'
endif

if s:isactive('afterglow')
  Plug 'danilo-augusto/vim-afterglow'
endif

" 2.1.2. Devicon
" -------------

if s:isactive('vim_devicons')
  Plug 'ryanoasis/vim-devicons'
endif

" 2.1.3. Status Line
" -----------------

" Status line enrichment
if s:isactive('vim_airline')
  " Plug 'vim-airline/vim-airline', { 'on': 'AirlineToggle' }
  " Plug 'vim-airline/vim-airline-themes', { 'on': 'AirlineToggle' }
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

" Status line enrichment
if s:isactive('powerline')
  Plug 'powerline/powerline'
endif

" Status line enrichment
if s:isactive('vim_lightline')
  Plug 'itchyny/lightline.vim'
endif

" 2.2. Ergonomic
" -------------

" 2.2.1. Unimpaired
" -----------------

if s:isactive('vim_unimpaired')
  Plug 'tpope/vim-unimpaired'
endif

" 2.2.2. Wilder
" -------------

if s:isactive('wilder')
  " Fuzzy command line
  " Requires yarp
  " Requires pynvim
  "   C:\Python312_x64\Scripts\pip install pynvim
  if has('nvim')
    function! UpdateRemotePlugins(...)
      " Needed to refresh runtime files
      let &rtp=&rtp
      UpdateRemotePlugins
    endfunction

    Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
  else
    Plug 'gelguy/wilder.nvim'
  endif
  " More information: :help wilder.txt
endif

" 2.2.3. Repeat
" ------------

" Make the .repeat action working with :
" - vim-unimpaired
" - vim-surround
" - vim-easyclip
if s:isactive('vim_repeat')
  Plug 'tpope/vim-repeat'
endif

if s:isactive('repmo')
  " Used from the pack folder
  " packadd repmo-vim
  Plug 'Houl/repmo-vim'
endif

if s:isactive('repeatable_motion')
  packadd repeatable-motions
endif

if s:isactive('vim_remotions')
  Plug 'vds2212/vim-remotions'
endif

" 2.2.4. Text Objects
" -------------------

if s:isactive('target_vim')
  Plug 'wellle/targets.vim'
endif

" Define ident text object:
if s:isactive('vim_ident_object')
  Plug 'michaeljsmith/vim-indent-object'
endif

" Text object and motions for Python code
if s:isactive('vim_pythonsense')
  Plug 'jeetsukumaran/vim-pythonsense'
endif

if s:isactive('vim_indentwise')
  Plug 'jeetsukumaran/vim-indentwise'
endif

" 2.2.5. Dashboard
" ---------------

" Startup Screen
if s:isactive('vim_startify')
  Plug 'mhinz/vim-startify'
endif

if s:isactive('dashboard_vim')
  Plug 'glepnir/dashboard-nvim'
endif


" 2.2.6. Windows
" --------------

" Allows you to close buffer without closing the corresponding window
" Introducing the :Bd command
if s:isactive('vim_bbye')
  Plug 'moll/vim-bbye'
endif

" Re-size windows
if s:isactive('winresizer')
  Plug 'simeji/winresizer'
endif

" Split management
if s:isactive('vim_maximizer')
  Plug 'szw/vim-maximizer'
endif

if s:isactive('vim_fullscreen')
  " Requires pywin32:
  "   C:\Python312_x64\Scripts\pip install pywin32
  Plug 'ruedigerha/vim-fullscreen'
endif

" 2.2.7. Clipboard
" ----------------

" Highlight briefly yank section
" NeoVim has builtin support
if s:isactive('vim_highlightedyank')
  Plug 'machakann/vim-highlightedyank'
endif

" Make the current word highlighted
if s:isactive('vim_illuminate')
  Plug 'RRethy/vim-illuminate'
endif

if s:isactive('vim_cutlass')
  Plug 'svermeulen/vim-cutlass'
endif

if s:isactive('vim_yoink')
  Plug 'svermeulen/vim-yoink'
endif

" 2.2.8. Search
" -------------

" Visual Selection Search (using '*' and '#')
if s:isactive('vim_visual_star_search')
  Plug 'nelstrom/vim-visual-star-search'
endif

" Preview substitution of the s command before performing them
if s:isactive('traces')
  Plug 'markonm/traces.vim'
endif

" Highlight ALL pattern match
if s:isactive('incsearch')
  Plug 'haya14busa/incsearch'
endif

if s:isactive('is_vim')
  Plug 'haya14busa/is.vim'
endif

" Case sensitive search and replace
if s:isactive('vim_abolish')
  Plug 'tpope/vim-abolish'
endif

" 2.2.9. Moves
" ------------

if s:isactive('vim_matchup')
  Plug 'andymass/vim-matchup'
endif

if s:isactive('vim_easymotion')
  Plug 'easymotion/vim-easymotion'
endif

if s:isactive('leap') && has('nvim')
  Plug 'ggandor/leap.nvim'
endif

if s:isactive('vim_sneak')
  Plug 'justinmk/vim-sneak'
endif

" 2.2.10. Unicode
" ---------------

if s:isactive('unicode_helper')
  Plug 'chrisbra/unicode.vim'
endif

if s:isactive('vim_characterize')
  Plug 'tpope/vim-characterize'
endif

" 2.2.11. Multiple Cursors
" ------------------------

" Multiple cursors
if s:isactive('vim_visual_multi')
  Plug 'mg979/vim-visual-multi'
endif

" Add multiple cursor edition
if s:isactive('vim_multiple_cursors')
  Plug 'terryma/vim-multiple-cursors'
endif

" 2.2.12. CSS Colors
" ------------------

if s:isactive('vim_css_color')
  Plug 'ap/vim-css-color'
endif

" Highlight color code
if s:isactive('hexokinase')
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
endif

" Highlight color code
if s:isactive('clrzr')
  Plug 'BourgeoisBear/clrzr'
endif

" Highlight color code
if s:isactive('colorizer')
  Plug 'lilydjwg/colorizer'
endif

" 2.2.13. Miscellaneous
" ---------------------

" Make C-x C-f completion relative to the file and not to the current working directory
if s:isactive('vim_relatively_complete')
  Plug 'thezeroalpha/vim-relatively-complete'
endif

if s:isactive('vim_expand_region')
  Plug 'terryma/vim-expand-region'
endif

if s:isactive('which_key')
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
endif

if s:isactive('vim_peekaboo')
  Plug 'junegunn/vim-peekaboo'
endif

" Basic large files support
if s:isactive('large_file')
  Plug '~/_vimfiles/plugged/LargeFile'
endif

if s:isactive('checkhealth')
  if !has('nvim')
    Plug 'rhysd/vim-healthcheck'
  endif
endif

if s:isactive('startuptime')
  Plug 'dstein64/vim-startuptime'
endif

if s:isactive('context')
  Plug 'wellle/context.vim'
endif

if s:isactive('vim_spellcheck')
  Plug 'inkarkat/vim-ingo-library'
  Plug 'inkarkat/vim-SpellCheck'
endif

if s:isactive('vim_dadbod')
  Plug 'tpope/vim-dadbod'
endif

if s:isactive('vim_dadbod_ui')
  Plug 'kristijanhusak/vim-dadbod-ui'
endif

if s:isactive('sudoedit_vim')
  Plug 'chrisbra/SudoEdit.vim'
endif

if s:isactive('vim_cool')
  Plug 'romainl/vim-cool'
endif

if s:isactive('vimcaps')
  Plug 'suxpert/vimcaps'
endif

if s:isactive('beacon')
  Plug 'DanilaMihailov/beacon.nvim'
endif

if s:isactive('vim_long_lines')
  Plug 'manu-mannattil/vim-longlines'
endif

if s:isactive('codi_vim')
  Plug 'metakirby5/codi.vim'
endif

" Tridactyl .tridactylrc support
if s:isactive('vim_tridactyl')
  Plug 'tridactyl/vim-tridactyl'
endif

if s:isactive('vim_orpheus')
  Plug 'vds2212/vim-orpheus'
endif

" 2.3. File Browsing
" ------------------

" 2.3.1. Rooter
" ------------

" Adapt automatically the working directory
if s:isactive('vim_rooter')
  Plug 'airblade/vim-rooter'
endif

" 2.3.2. Fuzzy searching
" ---------------------

if s:isactive('fzf')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
endif

" CtrlP (File Finder)
if s:isactive('ctrlp')
  Plug 'ctrlpvim/ctrlp.vim'
endif

" Fuzzy finders of: Files, Buffers, Tags, ...
" In order to make tag generation working instal maple:
" Building from source using Rust
"   :call clap#installer#build_maple()
" Or downloading from GitHub:
"   :call clap#installer#download_binary()
" Remark:
" - In order to download make sure you have a connection without proxy
if s:isactive('vim_clap')
  Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
endif

if s:isactive('nvim_telescope')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  if s:isactive('telescope_live_grep_arg')
    Plug 'nvim-telescope/telescope-live-grep-args.nvim'
  endif
endif

if s:isactive('bufexplorer')
  Plug 'jlanzarotta/bufexplorer'
endif

" 2.3.3. File searching
" --------------------

if s:isactive('ack_vim')
  Plug 'mileszs/ack.vim'
endif

if s:isactive('ctrlsf')
  Plug 'dyng/ctrlsf.vim'
endif

if s:isactive('ferret')
  Plug 'wincent/ferret'
endif

" 2.3.4. File browsing
" -------------------

" File browser
if s:isactive('nerdtree')
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

  " Add Git status icon to NerdTree files and folders
  " Plug 'Xuyuanp/nerdtree-git-plugin'
endif

if s:isactive('nvim_tree')
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'
endif

if s:isactive('fern')
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/fern-mapping-mark-children.vim'

  " Add Git status icon to Fern files and folders
  if s:isactive('vim_fugitive')
    Plug 'lambdalisue/fern-git-status.vim'
  endif
endif

" File browser netrw helper
if s:isactive('vim_vinegar')
  Plug 'tpope/vim-vinegar'
endif

" 2.4. Sessions
" -------------

" Session management made easy
if s:isactive('vim_obsession') || s:isactive('vim_prosession')
  Plug 'tpope/vim-obsession'
endif

" Addition to Obsession
if s:isactive('vim_prosession')
  Plug 'dhruvasagar/vim-prosession'
endif

" 2.5. Bookmark
" -------------

" Bookmarks made easy
if s:isactive('vim_signature')
  Plug 'kshenoy/vim-signature'
endif

" Bookmarks made easy
if s:isactive('vim_bookmarks')
  Plug 'MattesGroeger/vim-bookmarks'
endif

" 2.6. Undo Tree
" --------------

" Visualize the undo tree:
if s:isactive('undotree')
  Plug 'mbbill/undotree'
endif

" Visualize the undo tree:
if s:isactive('gundo')
  Plug 'sjl/gundo.vim'
endif

" Visualize the undo tree:
if s:isactive('vim_mundo')
  Plug 'simnalamburt/vim-mundo'
endif

" 2.7. Difference
" ---------------

" 2.7.1. Diff Char
" ---------------

if s:isactive('diffchar')
  Plug 'rickhowe/diffchar.vim'
endif

" 2.7.2. Diff Command
" ------------------

if s:isactive('difforig')
  Plug 'lifecrisis/vim-difforig'
endif

  " 2.7.3 Spot Diff
  " ---------------

if s:isactive('spotdiff')
  Plug 'rickhowe/spotdiff.vim'
endif

" 2.8. Git
" --------

" 2.8.1. Git Operation
" -------------------

" Git integration
if s:isactive('vim_fugitive')
  Plug 'tpope/vim-fugitive'
endif

" 2.8.2. Git Signs
" ---------------

if s:isactive('vim_signify')
  Plug 'mhinz/vim-signify'
endif

if s:isactive('gitsigns')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
endif

if s:isactive('vim_gitgutter')
  Plug 'airblade/vim-gitgutter'
endif

" 2.8.3. Git Helper
" ----------------

if s:isactive('vim_gitbranch')
  Plug 'itchyny/vim-gitbranch'
endif

" 2.9. Indentation
" ----------------

" 2.9.1. Indentation lines
" -----------------------

" Visualize indentation vertical lines
if s:isactive('indentline')
  Plug 'Yggdroot/indentLine'
endif

if s:isactive('vim_indent_guides')
  Plug 'preservim/vim-indent-guides'
endif

" 2.9.2. EditorConfig
" ------------------

if s:isactive('editorconfig')
  " Plug 'editorconfig/editorconfig-vim'
  packadd! editorconfig
endif

" 2.9.3. Sleuth
" ------------

if s:isactive('vim_sleuth')
  Plug 'tpope/vim-sleuth'
endif

" 2.10. Align
" -----------

" Alignment made easy
if s:isactive('vim_easy_align')
  Plug 'junegunn/vim-easy-align'
endif

" Alignment made easy
if s:isactive('tabular')
  Plug 'godlygeek/tabular'
endif

" 2.11. Folding
" -------------

" 2.11.1. Fold Creation
" --------------------

if s:isactive('any_fold')
  Plug 'pseewald/vim-anyfold'
endif

if s:isactive('simpylfold')
  Plug 'tmhedberg/SimpylFold'
endif

" 2.11.2. Fold Handling
" --------------------

if s:isactive('cycle_fold')
  Plug 'arecarn/vim-fold-cycle'
endif

if s:isactive('fast_fold')
  Plug 'Konfekt/FastFold'
endif

" 2.12. Commenting
" ----------------

" Commenting made easy
if s:isactive('vim_commentary')
  Plug 'tpope/vim-commentary'
endif

if s:isactive('nerdcommenter')
  Plug 'preservim/nerdcommenter'
endif

" 2.13. Parenthesis
" -----------------

" 2.13.1. Surround
" ---------------

" Add additional commands to manage pairs
if s:isactive('vim_surround')
  Plug 'tpope/vim-surround'
endif

" 2.13.2. Auto-Pair
" ----------------

" Automatically introduce the pairing character (e.g. ", ', (, [, etc. )
if s:isactive('auto_pairs')
  Plug 'jiangmiao/auto-pairs'
endif

" Automatically introduce the pairing character (e.g. ", ', (, [, etc. )
if s:isactive('lexima')
  Plug 'cohama/lexima.vim'
endif

" Automatically introduce the pairing character (e.g. ", ', (, [, etc. )
if s:isactive('vim_closing_brackets')
  Plug 'tpenguinltg/vim-closing-brackets'
endif

" Automatically introduce the pairing character (e.g. ", ', (, [, etc. )
if s:isactive('auto_pairs_gentle')
  Plug 'vim-scripts/auto-pairs-gentle'
endif

" 2.14. Snippet
" -------------

if s:isactive('ultisnips')
  if has('python3')
    " Snippet (code generation)
    Plug 'SirVer/ultisnips'
  endif
endif

if s:isactive('emmet_vim')
  Plug 'mattn/emmet-vim'
endif

" 2.15. Tags
" ----------

" 2.15.1. Tag Generation
" ---------------------

" Automatically generate and update your tag files:
if s:isactive('vim_gutentags')
  Plug 'ludovicchabant/vim-gutentags'
endif

" 2.15.2. Tag Browsing
" -------------------

" Code tags overview
if s:isactive('tagbar')
  Plug 'preservim/tagbar'
endif

" Code tags overview from LSP server
if s:isactive('vista_vim')
  Plug 'liuchengxu/vista.vim'
endif

" 2.16. Code Completion
" ---------------------

if s:isactive('coc_nvim')
  Plug 'neoclide/coc.nvim' , {'branch': 'release'}
endif

if s:isactive('lsp')
  Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'jose-elias-alvarez/null-ls.nvim'
endif
"
if s:isactive('you_complete_me')
  Plug 'ycm-core/YouCompleteMe'
endif

if s:isactive('deoplete')
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
  endif
  Plug 'deoplete-plugins/deoplete-jedi'
endif

" Python code completion
if s:isactive('jedi_vim')
  Plug 'davidhalter/jedi-vim'
endif

" Semantic highlighting for Python
if s:isactive('semshi')
  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
endif

" Semantic highlighting
if s:isactive('hlargs')
  Plug 'm-demare/hlargs.nvim'
endif

" 2.17. Code Formatting
" ---------------------

" 2.17.1. ISort
" ------------

if s:isactive('vim_isort')
  if has('python3')
    Plug 'fisadev/vim-isort'
  endif
endif

" 2.17.2. Prettier
" ---------------

if s:isactive('vim_prettier')
  Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn add --dev --exact prettier',
      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json',
      \  'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html', 'sql'] }
  " Remark:
  " - Original installation command:
  " \ 'do': 'yarn install --frozen-lockfile --production',
endif

if s:isactive('vim_jsx_pretty')
  Plug 'MaxMEllon/vim-jsx-pretty'
endif

" 2.18. Linting
" -------------

" 2.18.1. Linting Engine
" ---------------------

" Linting
if s:isactive('ale')
  Plug 'dense-analysis/ale'
endif

if s:isactive('lightbulb')
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'antoinemadec/FixCursorHold.nvim'
endif

if s:isactive('treesitter')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" 2.18.2. Linting Mark
" -------------------

" Linting
if s:isactive('vim_syntastic')
  Plug 'vim-syntastic/syntastic'
endif

" 2.19. Asynchronous Run
" ----------------------

if s:isactive('asyncrun')
  Plug 'skywind3000/asyncrun.vim'
endif

if s:isactive('vim_dispatch')
  Plug 'tpope/vim-dispatch'
endif

" 2.20. QuickFix filtering
" ------------------------

if s:isactive('cfilter')
  packadd cfilter
endif

if s:isactive('vim_editqf')
  Plug 'jceb/vim-editqf'
endif

" 2.21. Terminal
" --------------

" Terminal support
if s:isactive('vim_floaterm')
  Plug 'voldikss/vim-floaterm'
endif

" vim-clap support for floaterm
if s:isactive('vim_clap') && s:isactive('vim_floaterm') && s:isactive('clap_floaterm')
  " Seems not to work properly
  Plug 'voldikss/clap-floaterm'
endif

" Terminal support (reuse)
if s:isactive('neoterm')
  Plug 'kassio/neoterm'
endif

" 2.22. Debugging
" ---------------

if s:isactive('vimspector')
  if has('python3')
    " Python debugging
    Plug 'puremourning/vimspector'
  endif
endif

if s:isactive('nvim_dab')
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'mfussenegger/nvim-dap-python'
endif

" 2.23. File Types
" ----------------

" 2.23.1. VimScript
" -----------------

if s:isactive('vim_scriptease')
  Plug 'tpope/vim-scriptease'
endif

if s:isactive('lh_vim_lib')
  Plug 'LucHermitte/lh-vim-lib'
endif

" Help discovering the color group behind a token
if s:isactive('vim_synstax')
  Plug 'benknoble/vim-synstax'
endif

" 2.23.2. Markdown
" ----------------

" Simple Markdown based wiki
if s:isactive('vimwiki')
    Plug 'vimwiki/vimwiki'
endif

if s:isactive('neorg')
  Plug 'nvim-neorg/neorg'
endif

" Markdown extra support
if s:isactive('vim_markdown')
  Plug 'preservim/vim-markdown'
endif

" Markdown preview
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
if s:isactive('markdown_preview')
  if !has('nvim')
    " Remark: It seems that markdown_preview works on vim only until commit: 'e5bfe9b'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'], 'commit': 'e5bfe9b'}
  else
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  endif
endif
" Run manually ~\vimfiles\plugged\markdown-preview.nvim\app\install.cmd

" 2.23.3. CSV
" -----------

" Csv management
if s:isactive('csv')
  Plug 'chrisbra/csv.vim'
endif

" Csv management
" Add color to each column of csv file:
if s:isactive('rainbow_csv')
  Plug 'mechatroner/rainbow_csv'
endif

" 2.23.4. Rust
" ------------

if s:isactive('rust_vim')
  Plug 'rust-lang/rust.vim'
endif

" 2.23.5. Jinja
" -------------

if s:isactive('vim_jinja2_syntax')
  Plug 'Glench/Vim-Jinja2-Syntax'
endif


" 2.23.6. Logs
" ------------

if s:isactive('vim_log_highligthing')
  Plug 'mtdl9/vim-log-highlighting'
endif


" 2.23.7 TeX/LaTeX
" ----------------

if s:isactive('vimtex')
  Plug 'lervag/vimtex'
endif

if s:isactive('vimlatex')
  Plug 'vim-latex/vim-latex'
endif

" Dependencies
" ------------

if s:isactive('deoplete') || s:isactive('wilder')
  if !has('nvim')
    Plug 'roxma/nvim-yarp', { 'do': 'pip install -r requirements.txt' }
    " Remark:
    " Requires pynvim
    "   C:\Python312_x64\Scripts\pip install pynvim
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif

if s:isactive('neorg') || s:isactive('hlargs') || s:isactive('semshi')
  if !s:isactive('treesitter')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    s:activate('treesitter')
  endif
endif

call plug#end()

" 2.1. Look & Feel
" ----------------

" 2.1.1. Color Scheme
" ------------------

" Dark background
set background=dark

" Set the colorscheme before customizing the plugins colors
function! GetColorSchemes()
   return uniq(sort(map(
   \  globpath(&runtimepath, "colors/*.vim", 0, 1),
   \  'fnamemodify(v:val, ":t:r")'
   \)))
endfunction

if s:isactive('gui_running') || has('unix')
  let s:schemes = GetColorSchemes()

  if s:isactive('vim_gruvbox')
    colorscheme gruvbox
  elseif s:isactive('Vim_color_solarized')
    colorscheme solarized
  " elseif s:isactive('vim_solarized8')
  "   " colorscheme solarized8
  "   colorscheme solarized8_low
  elseif s:isactive('onedark')
    colorscheme onedark
  elseif s:isactive('molokai')
    colorscheme molokai
  elseif s:isactive('papercolor')
    colorscheme papercolor
  elseif s:isactive('nord_vim') && index(s:schemes, 'nord') >= 0
    colorscheme nord
  elseif s:isactive('everforest')
    colorscheme everforest
  endif

  if s:isactive('nord_vim')
    " colorscheme habamax
    " colorscheme morning
    " colorscheme sorbet
    colorscheme nord
  endif
endif

if s:isactive('nord_vim')
  " Make the search background a bit less bright:
  hi Search guibg=#67909e guifg=#2e3440

  " Make the foreground color of the folded line more bright:
  hi Folded gui=None guibg=#3b4252 guifg=#d8dee9

  " Don't change the color of bad spelled words (only the underline)
  " Using Nord colors
  " hi clear SpellBad
  " hi SpellBad term=reverse cterm=underline gui=undercurl guisp=#BF616A
  " hi clear SpellCap
  " hi SpellCap term=reverse cterm=underline gui=undercurl guisp=#EBCB8B
  " hi clear SpellLocal
  " hi SpellLocal term=reverse cterm=underline gui=undercurl guisp=#E5E9F0
  " hi clear SpellRare
  " hi SpellRare term=reverse cterm=underline gui=undercurl guisp=#ECEFF4
  " hi clear DiagnosticUnderlineError
  " hi DiagnosticUnderlineError cterm=underline gui=undercurl guisp=#bf616a
endif


" 2.1.2. Devicon
" -------------

" 2.1.3. Status Line
" -----------------

" Airline plugin settings:
" ------------------------

if s:isactive('vim_airline')
  " Add a header section for every open buffer
  " let g:airline#extensions#tabline#enabled = 1
  " let g:airline#extensions#tabline#formatter = 'unique_tail'

  if s:isactive('vista_vim')
    " Make sure airline report the function you are in:
    let g:airline#extensions#vista#enabled = 0
  endif

  if s:isactive('tagbar')
    " Make sure airline report the function you are in:
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline#extensions#tagbar#flags = 'f'
  endif

  if s:isactive('ale')
    " Disable code error and warning detection in airline
    " There are just too much false positives
    let g:airline#extensions#ale#enabled = 0
  endif

  if s:isactive('coc_nvim')
    " Disable code error and warning detection in airline
    " There are just too much false positives
    let g:airline#extensions#coc#enabled = 0
    " let g:airline#extensions#coc#show_coc_status = 0
  endif

  " Add the arrow like separator
  let g:airline_powerline_fonts = 1
endif

" Lightline plugin settings:
" --------------------------

if s:isactive('vim_lightline')
  " Make the status line visible
  set laststatus=2

  if !exists('g:lightline')
    let g:lightline = {}
  endif
  if !exists('g:lightline.component')
    let g:lightline.component = {}
  endif

  " Replace the relative buffer name by the full buffer path
  " let g:lightline.component.filename='%F'

  " Replace the relative buffer name by the absolute buffer path
  " let g:lightline.component.filename="%{fnamemodify(bufname(), ':p')}"
  if s:isactive('vim_fugitive')
    function! MyFugitiveHead()
      let head = FugitiveHead()
      if head != ""
        let head = "\uf126 " .. head
      endif
      return head
    endfunction

    " function! MyHour()
    "   return strftime("%H:%M")
    " endfunction

    let g:lightline = {
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
          \  'right': [ [ 'lineinfo' ],
          \             [ 'percent' ],
          \             [ 'fileformat', 'fileencoding', 'filetype' ], ]
          \ },
          \ 'component_function': {
          \   'gitbranch': 'MyFugitiveHead',
          \ },
          \}
  endif

  if s:isactive('vimcaps')
    function! MyVimCaps()
        return vimcaps#statusline(7)
    endfunction

    let g:lightline = {
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'readonly', 'relativepath', 'modified' ] ],
          \  'right': [ [ 'lineinfo' ],
          \             [ 'percent' ],
          \             [ 'fileformat', 'fileencoding', 'filetype' ],
          \             [ 'vimcaps' ] ]
          \ },
          \ 'component_function': {
          \   'vimcaps': 'MyVimCaps'
          \ },
          \}
  endif
  let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
        \  'right': [ [ 'lineinfo' ],
        \             [ 'percent' ],
        \             [ 'fileformat', 'fileencoding', 'filetype' ], ]
        \ },
        \}
endif


" 2.2. Ergonomic
" --------------

" 2.2.1. Unimpaired
" -----------------

" 2.2.2. Wilder
" -------------

" Wilder plugin settings:
" -----------------------

if s:isactive('wilder')
  " let g:python3_host_prog='C:\Python36_x64\python.exe'

  " Default keys
  " Use <C-p> and <C-n> for command history browsing
  " Use <Tab> and <S-Tab> for wilder suggestions
  " call wilder#setup({
  "       \ 'modes': [':', '/', '?'],
  "       \ 'next_key': '<Tab>',
  "       \ 'previous_key': '<S-Tab>',
  "       \ 'accept_key': '<Down>',
  "       \ 'reject_key': '<Up>',
  "       \ })

  call wilder#setup({
        \ 'modes': [':', '/', '?'],
        \ 'next_key': '<C-j>',
        \ 'previous_key': '<C-k>',
        \ 'accept_key': '<Down>',
        \ 'reject_key': '<Up>',
        \ })

  " Hide next/previous command:
  " call wilder#setup({
  "       \ 'modes': [':', '/', '?'],
  "       \ 'next_key': '<C-n>',
  "       \ 'previous_key': '<C-p>',
  "       \ 'accept_key': '<CR>',
  "       \ 'reject_key': '<C-[>',
  "       \ })

  " cnoremap <expr> <C-n> wilder#in_context() ? wilder#next() : "\<down>"
  " cnoremap <expr> <C-p> wilder#in_context() ? wilder#previous() : "\<up>"

  nnoremap <leader>tx :call wilder#toggle()<CR>

  if s:isactive('wilder_simple')
    call wilder#set_option('pipeline', [
          \   wilder#branch(
          \     wilder#cmdline_pipeline(),
          \     wilder#search_pipeline(),
          \   ),
          \ ])

    " 'border'            : 'single', 'double', 'rounded' or 'solid'
    "                     : can also be a list of 8 characters
    " 'highlights.border' : highlight to use for the border`
    " if s:gui_running
      call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \ 'highlights': {
            \   'border': 'Normal',
            \ },
            \ 'border': 'single',
            \ })))
    " else
    "   call wilder#set_option('renderer', wilder#wildmenu_renderer({
    "         \ 'highlighter': wilder#basic_highlighter(),
    "         \ }))
    " endif
  else
    " For Neovim or Vim with yarp
    " For wild#cmdline_pipeline():
    "   'language'   : set to 'python' to use python
    "   'fuzzy'      : set fuzzy searching
    " For wild#python_search_pipeline():
    "   'pattern'    : can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
    "   'sorter'     : omit to get results in the order they appear in the buffer
    "   'engine'     : can be set to 're2' for performance, requires pyre2 to be installed

    call wilder#set_option('pipeline', [
          \   wilder#branch(
          \     wilder#cmdline_pipeline({
          \       'language': 'python',
          \       'fuzzy': 1,
          \     }),
          \     wilder#python_search_pipeline({
          \       'pattern': wilder#python_fuzzy_pattern(),
          \       'sorter': wilder#python_difflib_sorter(),
          \       'engine': 're',
          \     }),
          \   ),
          \ ])

    let s:highlighters = [
          \ wilder#pcre2_highlighter(),
          \ wilder#basic_highlighter(),
          \ ]

    " 'border'            : 'single', 'double', 'rounded' or 'solid'
    "                     : can also be a list of 8 characters
    " 'highlights.border' : highlight to use for the border`
    if s:gui_running
      call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \ 'highlights': {
              \   'border': 'Normal',
              \ },
              \ 'border': 'single',
              \ })))
    else
      call wilder#set_option('renderer', wilder#wildmenu_renderer({
            \ 'highlighter': wilder#basic_highlighter(),
            \ }))
    endif

    " call wilder#set_option('renderer', wilder#renderer_mux({
    "       \ ':': wilder#popupmenu_renderer({
    "       \   'highlighter': s:highlighters,
    "       \ }),
    "       \ '/': wilder#wildmenu_renderer({
    "       \   'highlighter': s:highlighters,
    "       \ }),
    "       \ }))
  endif

  " More information with: :help wilder.txt
endif


" 2.2.3. Repeat
" -------------

" RepMo plugin settings
" ---------------------

if s:isactive('repmo')
  map <expr> ; repmo#LastKey(';')|sunmap ;
  map <expr> , repmo#LastRevKey(',')|sunmap ,

  " Still repeat fFtT (now with counts):
  noremap <expr> f repmo#ZapKey('f')|sunmap f
  noremap <expr> F repmo#ZapKey('F')|sunmap F
  noremap <expr> t repmo#ZapKey('t')|sunmap t
  noremap <expr> T repmo#ZapKey('T')|sunmap T

  " Now following can also be repeated with `;` and `,`:
  for keys in [ ['[[', ']]'], ['[]', ']['], ['[m', ']m'], ['[M', ']M'], ['[c', ']c'] ]
    execute 'noremap <expr> '.keys[0]." repmo#SelfKey('".keys[0]."', '".keys[1]."')|sunmap ".keys[0]
    execute 'noremap <expr> '.keys[1]." repmo#SelfKey('".keys[1]."', '".keys[0]."')|sunmap ".keys[1]
  endfor
endif

" Repeatable Motion plugin settings:
" ----------------------------------

if s:isactive('repeatable_motion')
  " call AddRepeatableMotion("[m", "]m", 1)
endif

" Remotions plugin settings
" -------------------------

if s:isactive('vim_remotions')
  let g:remotions_direction = 1
  let g:remotions_repeat_count = 1

  let g:remotions_motions = {
        \ 'EeFf' : {},
        \ 'para' : { 'backward' : '{', 'forward' : '}' },
        \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
        \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
        \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
        \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
        \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
        \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
        \
        \ 'line' : {
        \     'backward' : 'k',
        \    'forward' : 'j',
        \    'repeat_if_count' : 1,
        \    'repeat_count': 1
        \ },
        \
        \ 'undo' : { 'backward' : 'u', 'forward' : '<C-r>', 'direction' : 1 },
        \
        \ 'vsplit' : { 'backward' : '<C-w><', 'forward' : '<C-w>>', 'direction' : 1 },
        \ 'hsplit' : { 'backward' : '<C-w>-', 'forward' : '<C-w>+', 'direction' : 1 },
        \
        \ 'arg' : { 'backward' : '[a', 'forward' : ']a', 'doc': 'unimpaired' },
        \ 'buffer' : { 'backward' : '[b', 'forward' : ']b', 'doc': 'unimpaired' },
        \ 'location' : { 'backward' : '[l', 'forward' : ']l', 'doc': 'unimpaired' },
        \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q', 'doc': 'unimpaired' },
        \ 'tag' : { 'backward' : '[t', 'forward' : ']t', 'doc': 'unimpaired' },
        \
        \ 'diagnostic' : { 'backward' : '[g', 'forward' : ']g', 'doc': 'coc-diagnostic' },
        \ }

  if s:isactive('vim_easymotion')
    let g:remotions_motions.easymotion = { 'backward' : '<Plug>(easymotion-prev)', 'forward' : '<Plug>(easymotion-next)', 'motion': '<leader><leader>', 'motion_plug' : '<Plug>(easymotion-prefix)', 'doc': 'easymotion' }
  endif

  if s:isactive('leap')
    let g:remotions_motions.leap_fwd = { 'backward' : '<Plug>(leapbackward)', 'forward' : '<Plug>(leapforward)', 'motion': 's', 'motion_plug' : '<Plug>(leap-forward-to)', 'doc': 'leap' }
    let g:remotions_motions.leap_bck = { 'backward' : '<Plug>(leapbackward)', 'forward' : '<Plug>(leapforward)', 'motion': 'S', 'motion_plug' : '<Plug>(leap-backward-to)', 'doc': 'leap' }
  endif

  if s:isactive('vim_sneak')
    let g:remotions_motions.sneak_fwd = { 'backward' : '<Plug>Sneak_,', 'forward' : '<Plug>Sneak_;', 'motion': 's', 'motion_plug' : '<Plug>Sneak_s', 'doc': 'vim_sneak' }
    let g:remotions_motions.sneak_bck = { 'backward' : '<Plug>Sneak_,', 'forward' : '<Plug>Sneak_;', 'motion': 'S', 'motion_plug' : '<Plug>Sneak_S', 'doc': 'vim_sneak' }
  endif
endif

" 2.2.4. Text Objects
" -------------------

" 2.2.5. Dashboard
" ----------------

" Startify plugin settings:
" -------------------------

if s:isactive('vim_startify')
  " Disable Donkey quotes
  let g:startify_custom_header = ''

  " Save session when:
  " - Leaving vim
  " - Loading another session (via :SLoad)
  let g:startify_session_persistence = 1

  let g:startify_session_before_save = [
        \ 'echo "Cleaning up before saving.."',
        \ 'silent! cclose',
        \ 'silent! lclose'
        \ ]

  if s:isactive('tagbar')
    let g:startify_session_before_save += ['silent! TagbarClose']
  endif

  if s:isactive('nerdtree')
    let g:startify_session_before_save += ['silent! NERDTreeTabsClose']
  endif

  " Delete buffers before closing a session
  let g:startify_session_delete_buffers = 1

  " vim-rooter does something similar
  " let g:startify_change_to_vcs_root = 1

  let g:startify_bookmarks = [
        \ '~\_vimrc',
        \ '~\Bookmarks.txt',
        \ '~\Projects\Samples-Vim\Commands.md',
        \ '~\Projects\Samples-Git\Commands.md',
        \ '~\Projects\Samples-Vim\keyboard_shortcuts.rst',
        \]

  " Add SName command to display the current session name
  command! SName :echo v:this_session

  " More information with: :help startify
endif


" Dashboard plugin settings:
" --------------------------

if s:isactive('dashboard_vim')
  if s:isactive('vim_clap')
    let g:dashboard_default_executive ='clap'
  endif
  if s:isactive('nvim_telescope')
    let g:dashboard_default_executive ='telescope'
  endif
  if s:isactive('fzf')
    let g:dashboard_default_executive ='fzf'
  endif
endif


" 2.2.6. Windows
" --------------

" Vim-BBye plugin settings:
" -------------------------

if s:isactive('vim_bbye')
  " Can't introduce lower case commands
  " command! bd :Bd
endif


" Winresizer plugin settings:
" ---------------------------

if s:isactive('winresizer')
  " let g:winresizer_start_key=<C-e>
  let g:winresizer_start_key = "<leader>tw"

  " More information with: :help winresizer
endif


" Vim-Maximizer plugin settings:
" ------------------------------

if s:isactive('vim_maximizer')
  " Maximize current split or return to previous split states
  let g:maximizer_set_default_mapping = 0
  let g:maximizer_default_mapping_key = '<C-w>m'
  " Prefer normal mapping to not hinder the <C-w> in insert mode:
  nnoremap <C-w>m :MaximizerToggle<CR>
endif


" 2.2.7. Clipboard
" ----------------

" Highlighted Yank plugin settings:
" ---------------------------------

if s:isactive('vim_highlightedyank')
  let g:highlightedyank_highlight_duration = 700

  " More information with: :help highlightedyank.txt
endif


" Neovim HighlightedYank:
" -----------------------

if s:isactive('neovim_highlightedyank')
  " NeoVim alternative to highlightedyank
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  augroup END
endif


" Vim-Illuminate plugin settings:
" -------------------------------

if s:isactive('vim_illuminate')
  " autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
  autocmd VimEnter * hi illuminatedWord guifg=#2e3440 guibg=#8fbcbb
endif


" Cutlass plugin settings:
" ------------------------

if s:isactive('vim_cutlass')
  " Prefer x over m to not shadow mark
  nnoremap x d
  xnoremap x d

  nnoremap xx dd
  nnoremap X D
endif


" Yoink plugin settings:
" ----------------------

if s:isactive('vim_yoink')
  nmap <C-n> <plug>(YoinkPostPasteSwapBack)
  nmap <C-p> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  " Also replace the default gp with yoink paste so we can toggle paste in this case too
  nmap gp <plug>(YoinkPaste_gp)
  nmap gP <plug>(YoinkPaste_gP)

  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)
  if s:isactive('vim_cutlass')
    let g:yoinkIncludeDeleteOperations = 1
  endif
endif


" 2.2.8. Search
" -------------

" Traces plugin settings:
" -----------------------

if s:isactive('traces')
  " More information with: :help traces.txt
endif


" Is Vim plugin settings:
" -----------------------

if s:isactive('is_vim')
  " Make sure the <C-k> is not overridden:
  let g:is#do_default_mappings = 0
  for s:map in ['n', 'N', '*', '#', 'g*', 'g#']
    if mapcheck(s:isactive('map'), 'n') ==# ''
      execute printf(':nmap %s <Plug>(is-%s)', s:map, s:map)
    endif
    if mapcheck(s:isactive('map'), 'x') ==# ''
      execute printf(':xmap %s <Plug>(is-%s)', s:map, s:map)
    endif
    if mapcheck(s:isactive('map'), 'o') ==# ''
      execute printf(':omap %s <Plug>(is-%s)', s:map, s:map)
    endif
  endfor
  unlet s:map

  " More information with: :help is.txt?
endif


" 2.2.9. Moves
" ------------

" Easy Motion plugin settings:
" ----------------------------

if s:isactive('vim_easymotion')
endif


" Leap plugin settings:
" ---------------------

if s:isactive('leap') && has('nvim')
  lua require('leap').add_default_mappings()
  if s:isactive('vim_remotions')
    lua require('leap').add_repeat_mappings('<Plug>(leapforward)', '<Plug>(leapbackward)')
  else
    lua require('leap').add_repeat_mappings(';', ',')
  endif
  " lua require('leap').add_repeat_mappings(';', ',', { relative_directions = true, modes = {'n', 'x', 'o'}, })
endif


" Sneak plugin settings:
" ----------------------

if s:isactive('vim_sneak')
  let g:sneak#label = 1
endif


" 2.2.10. Unicode
" ---------------

" Unicode plugin settings:
" ------------------------

if s:isactive('unicode_helper')
  " nnoremap ga :UnicodeName<CR>
  noremap ga <Plug>(UnicodeGA)
  " let g:Unicode_no_default_mappings = v:true
endif


" 2.2.11. Multiple Cursors
" ------------------------

" 2.2.12. CSS Colors
" ------------------

" Vim-Css-Color settings:
" -----------------------

if s:isactive('vim_css_color')
  nnoremap <leader>th :call css_color#toggle()<CR>
endif


" Hexokinase plugin settings:
" ---------------------------

if s:isactive('hexokinase')
  let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript', 'tsn']

  " All possible highlighters
  let g:Hexokinase_highlighters = [
  \   'backgroundfull',
  \ ]

  " \   'virtual',
  " \   'sign_column',
  " \   'background',
  " \   'backgroundfull',
  " \   'foreground',
  " \   'foregroundfull'

  " Choose which patterns are matched:

  " Patterns to match for all filetypes
  " Can be a comma separated string or a list of strings
  " Default value:
  " let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

  " All possible values
  " let g:Hexokinase_optInPatterns = [
  " \     'full_hex',
  " \     'triple_hex',
  " \     'rgb',
  " \     'rgba',
  " \     'hsl',
  " \     'hsla',
  " \     'colour_names'
  " \ ]

  " Filetype specific patterns to match
  " entry value must be comma seperated list
  " let g:Hexokinase_ftOptInPatterns = {
  " \     'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
  " \     'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
  " \     'tsn': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
  " \ }

  nnoremap <leader>th :HexokinaseToggle<CR>
endif


" Clrz plugin settings:
" ---------------------

if s:isactive('clrzr')
endif


" Colorizer plugin settings:
" --------------------------

if s:isactive('colorizer')
  let g:colorizer_maxlines = 1000
endif


" 2.2.13. Miscellaneous
" ---------------------

" Vim Relatively Complete plugin settings:
" ----------------------------------------

if s:isactive('vim_relatively_complete')
  imap <C-x><C-f> <Plug>RelativelyCompleteFile
endif


" Vim Expand Region plugin settings:
" ----------------------------------

if s:isactive('vim_expand_region')
  " Make sure the _ is not overridden:
  map + <Plug>(expand_region_expand)
  map - <Plug>(expand_region_shrink)
endif


" Context plugins settings:
" -------------------------

if s:isactive('context')
  " Disable context by default
  let g:context_enabled = 0

  " Don't insert the default plugin mapping
  let g:context_add_mappings = 0

  nnoremap <leader>tc :ContextToggle <CR>
endif


" SpellCheck plugin settings:
" ---------------------------

if s:isactive('vim_spellcheck')
endif


" SudoEdit plugin settings:
" -------------------------

if s:isactive('sudoedit_vim')
  let g:sudoAuthArg = '/noprofile /user:MT-BRU-2-0102\ladmin'
  " More information with: :help SudoEdit.txt
endif


" Beacon plugin settings:
" -----------------------

if s:isactive('beacon')
  " let g:beacon_enable = 0

  " This settings seems to give strange results
  " let g:beacon_size = 10

  highlight Beacon guibg=white ctermbg=15
  let g:beacon_timeout = 300

  " Disable beacon on jumps
  let g:beacon_show_jumps = 0
endif


" Codi Vim settings:
" ------------------

if s:isactive('codi_vim')
  let g:codi#interpreters = {
  \ 'python': {
    \ 'bin': 'C:\Python36_x64\python.exe',
    \ 'prompt': '^\(>>>\|\.\.\.\) ',
    \ },
  \ }
endif


" Grammalected plugin settings:
" -----------------------------

" Remark: currently not used

if 0
  let g:grammalecte_python = "py.exe"
  let g:grammalecte_cli_py = "C:\\Python36_x64\\Scripts\\grammalecte-cli.py"
endif

" vim-Riv plugin settings:
" ------------------------

" ReStructuredText preview
" Prefer Markdown preview instead (vim-markdown, markdown-preview)

if 0
  " Bad solution because it 'hide' the scrolling shortcut
  " let g:riv_global_leader = "<C-e>"

  " Bad solution since it make \ clumsy to insert in insert mode
  " let g:riv_global_leader = "<leader>e"

  let g:riv_global_leader = ""
endif


" InstantRst plugin settings:
" ---------------------------

" ReStructuredText preview
" Prefer Markdown preview instead (vim-markdown, markdown-preview)

if 0
  " let g:instant_rst_slow = 1
  let g:instant_rst_bind_scroll = 0
  " let g:instant_rst_localhost_only = 1
endif


" python-mode plugin settings:
" ----------------------------

" Remark: currently not used
if 0
  let g:pymode_folding = 1

  let g:pymode_breakpoint_bind = "<leader><s-b>"

  let g:pymode_rope = 1
  let g:pymode_rope_complete_on_dot = 0

  let g:pymode_lint_ignore=[
        \ "E501",
        \ "E203",
        \ "E265",
        \ "E402",
        \ "E128",
        \ ]
  " "E501", " Line too long
  " "E203", " White-space before '?'
  " "E265", " Block comment should start with '# '
  " "E402", " Module level import not at top of file
  " "E128", " Continuation line under-indented for visual indent
endif


" 2.3. File Browsing
" ------------------

" 2.3.1. Rooter
" ------------

" Vim-Rooter plugin settings:
" ---------------------------

if s:isactive('vim_rooter')
  " This is to make sure Vim-Rooter is triggered when a file is open via the gVim  --remote-silent option
  " But it doesn't seems to work for me
  " augroup mygroup
  "     autocmd BufReadPost * :Rooter
  " augroup end

  let g:rooter_patterns = ['.git', '.gitignore', '_darcs', '.hg', '.bzr', '.svn', 'Makefile']

  nnoremap <leader>tr :RooterToggle <CR>

  " More information with: :help rooter.txt
endif


" 2.3.2. Fuzzy searching
" ---------------------

" Fzf plugin settings:
" --------------------

if s:isactive('fzf')
  nnoremap <C-p> :Files<CR>
  nnoremap <leader>m :History<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>p :Tags<CR>

  " This is the default option:
  "   - Preview window on the right with 50% width
  "   - CTRL-/ will toggle preview window.
  " - Note that this array is passed as arguments to fzf#vim#with_preview function.
  " - To learn more about preview window options, see `--preview-window` section of `man fzf`.
  " Remark:
  " - It seems that on a Belgium keyboard Ctrl-/ lead to Ctrl-_
  let g:fzf_preview_window = ['right:50%', 'ctrl-_']

  " Preview window on the upper side of the window with 40% height,
  " hidden by default, ctrl-/ to toggle
  " let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

  " Empty value to disable preview window altogether
  " let g:fzf_preview_window = []
endif


" CtrlP plugin settings:
" ----------------------

if s:isactive('ctrlp')
  " <C-p> is the default of CtrlP ;-)
  nnoremap <leader>m :CtrlPMRUFiles<CR>
  nnoremap <leader>b :CtrlPBuffer<CR>

  let g:ctrlp_working_path_mode = 'ra'

  let g:ctrlp_root_markers = ['.git', '.gitignore', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', '.vimspector.json']
endif


" Clap plugin settings:
" ---------------------

if s:isactive('vim_clap')
  nnoremap <C-p> :call LeaveSideBar() <bar> Clap files<CR>
  nnoremap <leader>m :call LeaveSideBar() <bar> Clap history<CR>
  nnoremap <leader>b :call LeaveSideBar() <bar> Clap buffers<CR>

  " Requires Vista and maple
  nnoremap <leader>p :call LeaveSideBar() <bar> Clap proj_tags<CR>

  let g:clap_layout = { 'relative': 'editor' }

  " let g:clap_open_preview = 'on_move'
  let g:clap_open_preview = 'never'

  " let g:clap_disable_run_rooter = v:true
  let g:clap_project_root_markers = ['.gitignore', '.vimspector.json', '.root', '.git', '.git/']
  " let g:clap_provider_grep_opts = '-H --no-heading --vimgrep --smart-case -g!*.pyc'

  " Change the default next/previous suggestion
  " from <C-j>/<C-k> to <C-n>/<C-p>:
  let g:clap_popup_move_manager = {
      \ "\<C-N>": "\<Down>",
      \ "\<C-P>": "\<Up>",
      \ }

  " More information with: :help clap
endif


" Telescope plugin settings:
" --------------------------

if s:isactive('nvim_telescope')
  " Find files using Telescope command-line sugar.
  nnoremap <C-p> <cmd>Telescope find_files<cr>
  nnoremap <leader>m <cmd>Telescope oldfiles<cr>
  nnoremap <leader>b <cmd>Telescope buffers<cr>

  " Requires tags to be generate (manually or via vim-gutentags)
  nnoremap <leader>p <cmd>Telescope tags<cr>

  " nnoremap <leader>g <cmd>Telescope live_grep<cr>
  " nnoremap <leader>h <cmd>Telescope help_tags<cr>

  lua require('config/telescope')
endif

set grepprg=rp\ --vimgrep
set grepformat=%f:%l:%c:%m


" Buffer Explorer settings:
" -------------------------

if s:isactive('bufexplorer')
  " Disable default mapping
  let g:bufExplorerDisableDefaultKeyMapping = 1

  let g:bufExplorerSplitVertSize=60

  " Split Left
  let g:bufExplorerSplitRight=0
endif


" 2.3.3. File searching
" --------------------

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

" Ack plugin settings:
" --------------------

if s:isactive('ack_vim')
  " Use ripgrep for searching
  " Options include:
  " --vimgrep -> Needed to parse the rg response properly for ack.vim
  " --type-not sql -> Avoid huge sql file dumps as it slows down the search
  " --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
  let g:ackprg = 'rg --vimgrep --type-not sql --smart-case -g !tags'
  " let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

  " Auto close the Quickfix list after pressing '<enter>' on a list item
  " let g:ack_autoclose = 1

  " Any empty ack search will search for the work the cursor is on
  let g:ack_use_cword_for_empty_search = 1

  if s:isactive('vim_dispatch')
    " let g:ack_use_dispatch = 1
  endif

  " Provide for each solution a Ack command such that it is easier to switch
  " from one to the next

  " Don't jump to first match
  " cnoreabbrev Ack Ack!

  " More information with: :help ack.txt
  nnoremap <silent> <leader>ts <cmd>call ToggleQuickFix()<cr>
endif

if s:isactive('ctrlsf')
  " Compact view
  let g:ctrlsf_default_view_mode = 'compact'

  " let g:ctrlsf_extra_root_markers = ['.root']

  let g:ctrlsf_search_mode = 'async'

  let g:ctrlsf_auto_focus = {
    \ 'at': 'done',
    \ 'duration_less_than': 1000
    \ }

  " let g:ctrlsf_populate_qflist = 1
  " Match the NerdTree mapping:
  " - Switch to location: <CR>
  " - Synchronize to location: go
  let g:ctrlsf_mapping = {
      \ "open" : "<CR>",
      \ "openb" : { "key" : "go", "suffix" : "<C-w>p" },
      \ "next" : "]q",
      \ "prev" : "[q",
      \ "nfile" : "]Q",
      \ "pfile" : "[Q",
      \ "popen" : "",
      \ "popenf" : "",
      \ "tab" : "",
      \ "tabb" : "",
      \ }

  function! CtrlSFNextMatch()
    CtrlSFOpen
    call ctrlsf#NextMatch(1)
    call ctrlsf#JumpTo('open_background')
    " wincmd p
  endfunction

  function! CtrlSFPreviousMatch()
    CtrlSFOpen
    call ctrlsf#NextMatch(0)
    call ctrlsf#JumpTo('open_background')
    " wincmd p
  endfunction

  function! CtrlSFNextFMatch()
    CtrlSFOpen
    call ctrlsf#NextMatch(1, 1)
    call ctrlsf#JumpTo('open_background')
    " wincmd p
  endfunction

  function! CtrlSFPreviousFMatch()
    CtrlSFOpen
    call ctrlsf#NextMatch(0, 1)
    call ctrlsf#JumpTo('open_background')
    " wincmd p
  endfunction

  nnoremap ]q <Cmd>call CtrlSFNextMatch()<CR>
  nnoremap [q <Cmd>call CtrlSFPreviousMatch()<CR>
  nnoremap ]Q <Cmd>call CtrlSFNextFMatch()<CR>
  nnoremap [Q <Cmd>call CtrlSFPreviousFMatch()<CR>

  nnoremap <leader>ts <Cmd>CtrlSFToggle<CR>

  " Provide for each solution a Ack command such that it is easier to switch
  " from one to the next
  command! -nargs=* Ack CtrlSF <args>
endif


" Ferret plugin settings:
" -----------------------

if s:isactive('ferret')
  " Disable ferret keyboard mapping
  let g:FerretMap = 0

  " Make sure rg do not search within:
  " - The tags files
  " - The *.pyc files
  let g:FerretExecutableArguments = {
        \   'rg': '--vimgrep --no-heading --no-config --max-columns 4096 -g!tags  -g!*.pyc'
        \ }

  " Provide for each solution a Ack command such that it is easier to switch
  " from one to the next

  nnoremap <silent> <leader>ts <cmd>call ToggleQuickFix()<cr>
endif


" 2.3.4. File browsing
" -------------------

" NERDTree plugin settings:
" -------------------------

if s:isactive('nerdtree')
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1

  " let NERDTreeHijackNetrw = 1

  " noremap <F4> :NERDTreeToggle<CR>
  nnoremap <leader>tn :NERDTreeToggle <CR>

  " Set the NERDTree constext menu Shift-F10
  " in order to replace the default m that is used by signature
  " It seems that <S-F10> can't be assigned to NerdTree
  " let NERDTreeMapMenu = '<S-F10>'
  let NERDTreeMapMenu = '<F2>'

  " Allow to explore:
  " - Current working directory with :E .
  " - Local file directory with :E
function! NERDTreeExplore(...)
  if a:0 == 0
    NERDTree %:p:h
  else
    if isdirectory(a:1)
      execute printf("NERDTree %s", a:1)
    else
      call LeaveSideBar()
      execute printf("e %s", a:1)
    endif
  endif
endfunction

command! -nargs=* -complete=file E call NERDTreeExplore(<f-args>)

  " More information with: :help NERDTree.txt
endif


" Nvim-Tree plugin settings:
" --------------------------

if s:isactive('nvim_tree')
  lua require("config/nvimtree")

  " noremap <F4> :NvimTreeToggle<CR>
  nnoremap <leader>tn :NvimTreeToggle <CR>
endif


" Fern plugin settings:
" ---------------------

" Remarks:
" - Put Fern plugin setting after Vimspector to override F5
if s:isactive('fern')
  " Custom settings and mappings.
  let g:fern#disable_default_mappings = 1
  let g:fern#default_hidden = 1

  function! s:init_fern() abort
    " Use 'select' instead of 'edit' for default 'open' action
    " nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
    nmap <buffer><expr>
          \ <Plug>(fern-my-open-expand-collapse)
          \ fern#smart#leaf(
          \   "\<Plug>(fern-action-open:select)",
          \   "\<Plug>(fern-action-expand)",
          \   "\<Plug>(fern-action-collapse)",
          \ )
    nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> n <Plug>(fern-action-new-path)
    nmap <buffer> d <Plug>(fern-action-remove)
    nmap <buffer> r <Plug>(fern-action-move)
    nmap <buffer> R <Plug>(fern-action-rename)
    " nmap <buffer> h <Plug>(fern-action-hidden-toggle)
    " nmap <buffer> F5 <Plug>(fern-action-reload)
    nmap <buffer> m <Plug>(fern-action-mark)
    nmap <buffer> M <Plug>(fern-action-mark-children:leaf)
    " nmap <buffer> b <Plug>(fern-action-open:split)
    " nmap <buffer> v <Plug>(fern-action-open:vsplit)
    nmap <buffer><nowait> < <Plug>(fern-action-leave)
    nmap <buffer><nowait> > <Plug>(fern-action-enter)
  endfunction

  augroup fern-custom
    autocmd! *
    autocmd FileType fern setlocal norelativenumber | setlocal nonumber | call s:init_fern()
  augroup END
  " Use nerdfont:
  let g:fern#renderer = "nerdfont"

  noremap <silent> <Leader>tn :Fern .. -drawer -reveal=% -toggle -width=35<CR>

  " Add the E command
  function! FernExplore(...)
    if a:0 == 0
      Fern %:h -drawer -reveal=% -width=35
    else
      if isdirectory(a:1)
        execute printf("Fern %s -drawer -reveal=% -width=35", a:1)
      else
        call LeaveSideBar()
        execute printf("e %s", a:1)
      endif
    endif
  endfunction

  command! -nargs=* -complete=file E call FernExplore(<f-args>)
endif

" 2.4. Sessions
" -------------

" Obsession plugin settings:
" --------------------------

if s:isactive('vim_obsession') || s:isactive('vim_prosession')
  " Ease the management of the sessions (Jay Sitter tips from dockyard.com)

  " Save session tracking with \ss
  " exec 'nnoremap <Leader>ss :mks! ' .. g:sessions_dir .. '\*.vim<C-D><BS><BS><BS><BS><BS>'
  " exec 'nnoremap <Leader>ss :Obsession ' .. g:sessions_dir .. '\*.vim<C-D><BS><BS><BS><BS><BS>'

  " Read session with \sr
  " exec 'nnoremap <Leader>sr :so ' .. g:sessions_dir. '\*.vim<C-D><BS><BS><BS><BS><BS>'

  " Display the active session
  nnoremap <Leader>sn :echo v:this_session<CR>

  " Pause session update with \sp
  nnoremap <Leader>sp :Obsession<CR>

  " To avoid to switch to insert mode when I'm too slow with \sr
  " nnoremap s <Nop>
endif


" Sessions settings:
" ------------------

let s:session = s:isactive('vim_startify') || s:isactive('vim_obsession') || s:isactive('vim_prosession') || s:isactive('reload_session_at_start')
if s:isactive('session')
  if !isdirectory(g:sessions_dir)
    call mkdir(g:sessions_dir)
  endif
  let g:sessions_dir = GetVimDataFolder() .. 'session'

  if has('unix')
      call mkdir(g:sessions_dir, "p", 0700)j
  endif

  " Make sure the commands: SSave and SLoad are defined
  if s:isactive('vim_startify')
  elseif s:isactive('vim_obsession') || s:isactive('vim_prosession')
    command! -nargs=1 SSave exec 'Obsession ' .. g:sessions_dir .. '/<args>'
    command! -nargs=1 SLoad exec 'so' .. g:sessions_dir .. '/<args>'
  else
    command! -nargs=1 SSave exec 'mks! ' .. g:sessions_dir .. '/<args>'
    command! -nargs=1 SLoad exec 'so ' .. g:sessions_dir .. '/<args>'
  endif
endif


" Reload the my session at start
" ------------------------------
if s:isactive('reload_session_at_start')
  " Try to close the terminals before closing vim:
  if s:isactive('vim_floaterm')
    autocmd QuitPre * FloatermKill!
  endif

  if s:isactive('nerdtree')
    " Close NERDTree before the session is stored.
    " It seems the session restoring doesn't restore it right
    function! CloseNerdTree()
      if exists("g:NERDTree") && g:NERDTree.IsOpen()
        :NERDTreeClose
      endif
    endfunction
    " autocmd VimLeavePre * NERDTreeClose
    autocmd VimLeavePre * call CloseNerdTree()
  endif

  if s:isactive('vista_vim')
    " Close Vista before the session is stored.
    " It seems the session restoring doesn't restore it right
    autocmd VimLeavePre * Vista!
  endif

  " Close the help screen before the session is stored
  " It seems the session restoring doesn't restore it right
  autocmd VimLeavePre * helpclose

  if s:isactive('vim_startify')
    autocmd VimEnter * SLoad startup
  elseif s:isactive('vim_obsession')
    autocmd vimEnter * Obsess startup
  else
    " autocmd SessionLoadPost * wincmd =
    autocmd GUIEnter * so ~\vimfiles\session\startup
  endif

  " autocmd VimEnter * SLoad my
  " autocmd GUIEnter * windo filetype detect
  " autocmd GUIEnter * wincmd =
  " autocmd VimEnter * windo filetype detect
  " autocmd SessionLoadPost * windo e %
  " autocmd SessionLoadPost * wincmd =
  " autocmd SessionLoadPost * windo filetype detect
endif


" 2.5. Bookmark
" -------------

" Signature plugin settings:
" --------------------------

if s:isactive('vim_signature')
  nnoremap <leader>tm :SignatureToggleSigns <CR>

  " More information with: :help signature.txt
endif


" Bookmarks plugin settings:
" --------------------------

if s:isactive('vim_bookmarks')
  highlight BookmarkSign ctermbg=NONE ctermfg=160
  highlight BookmarkLine ctermbg=194 ctermfg=NONE

  " Black flag: U0001F3F4 🏴
  " White flag: U0001F3F3 🏳
  " Heart: u2665 ♥
  " let g:bookmark_sign = '🏴'
  let g:bookmark_sign = '🏳'
  " let g:bookmark_sign = '♥'
  let g:bookmark_highlight_lines = 1

  " let g:bookmark_auto_save_file = $VIMFILES .'/vim-bookmarks'
endif


" 2.6. Undo Tree
" --------------

" Undotree plugin settings:
" -------------------------

if s:isactive('undotree')
  let g:undotree_DiffAutoOpen = 0

  " Force the timestamps to be absolute instead of relative:
  " let g:undotree_RelativeTimestamp = 0

  let g:undotree_ShortIndicators = 1

  nnoremap <leader>tu :UndotreeToggle <CR>

  " More information with: :help undotree.txt
endif


" 2.7. Difference
" ---------------

" 2.7.1. Diff Char
" ---------------

if s:isactive('spotdiff') || s:isactive('diffchar')
  " let g:DiffUnit = ''
  let g:DiffColors = 'hl-DiffText'
  let g:DiffPairVisible = 1
endif

if s:isactive('spotdiff')
  " Disable the default spotdiff mappings:
  let g:VDiffDoMapping = 0
  set diffopt+=vertical
  " augroup spotfiff
  "   autocmd! VimEnter * nunmap <leader>t
  "   autocmd! VimEnter * nunmap <leader>T
  "   autocmd! VimEnter * nunmap <leader>o
  "   autocmd! VimEnter * nunmap <leader>O
  "   autocmd! VimEnter * nunmap <leader>u
  " augroup END
endif

" 2.7.2. Diff Command
" ------------------

" 2.8. Git
" --------

" 2.8.1. Git Operation
" -------------------

" 2.8.2. Git Signs
" ---------------

" Signify plugin settings:
" ------------------------

if s:isactive('vim_signify')
  " Disable signify by default
  let g:signify_disable_by_default = 1

  nnoremap <leader>ts :SignifyToggle <CR>

  " More information with: :help signify.txt
endif


" Git Signs plugin settings:
" --------------------------

if s:isactive('gitsigns')
  lua require('config/gitsigns')
endif


" Git-Gutter plugin settings:
" ---------------------------

" Remark: currently not used
if s:isactive('vim_gitgutter')
  if has('win32')
    let g:gitgutter_git_executable = 'C:/Program Files/Git/bin/git.exe'
  endif
  let g:gitgutter_grep=''
endif


" 2.8.3. Git Helper
" ----------------

" Git Branch settings:
" --------------------

if s:isactive('vim_gitbranch')
endif


" 2.9. Indentation
" ----------------

" 2.9.1. Indentation lines
" -----------------------

" Indentline plugin settings:
" ---------------------------

if s:isactive('indentline')
  " let g:indentLine_setColors = 0
  " let g:indentLine_bgcolor_gui = '#2e3440'

  " Indentline disabled by default
  let g:indentLine_enabled = 1
  let g:indentLine_char = '│'
  " set listchars+=lead:\ 

  nnoremap <leader>ti :IndentLinesToggle<CR>

  " More information with: :help indent_guides.txt
endif

if s:isactive('vim_indent_guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_guide_size = 1

  nnoremap <leader>ti :IndentGuidesToggle<CR>
endif


" 2.9.2. EditorConfig
" ------------------

" Editor Config settings:
" -----------------------

if s:isactive('editorconfig')
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
endif


" 2.9.3. Sleuth
" ------------

" 2.10. Align
" -----------

" Easy Align plugin settings:
" ---------------------------

if s:isactive('vim_easy_align')
  " Align PSI format file using vim-easy-align plugin
  function! AlignFormat()
    %EasyAlign /\<Display-Name\>/
    %EasyAlign /\<Type\>/
    %EasyAlign /\<Unit\>/
    %EasyAlign /\<Column\>/
    %EasyAlign /\<\(Alpha-Identifier\|Beta-Attribute\|Identifier\)\>/
    %EasyAlign /\<Scale\>/
    %EasyAlign /)/
    echo "Align Format"
  endfunction

  " Add the AlignFormat command
  command! AlignFormat :call AlignFormat()

  command! AlignSetup :%EasyAlign /"[^"]*"/dll10

  " More information with: :help easy-align.txt
endif


" 2.11. Folding
" -------------

" 2.11.1. Fold Creation
" --------------------

" Any-Fold plugin settings:
" -------------------------

if s:isactive('any_fold')
  augroup anyfold
    autocmd!
    " autocmd Filetype * AnyFoldActivate               " activate for all filetypes
    " or
    autocmd Filetype python AnyFoldActivate " activate for python
    autocmd Filetype tsn AnyFoldActivate " activate for tsn
  augroup END

  " Disable anyfold movement (e.g. ]])
  let g:anyfold_motion = 0

  " More information with: :help anyfold.txt
endif


" 2.11.2. Fold Handling
" --------------------

" Fast Fold plugin settings:
" --------------------------

if s:isactive('fast_fold')
  nmap zuz <Plug>(FastFoldUpdate)
  let g:fastfold_savehook = 1
  let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
  let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
endif


" 2.12. Commenting
" ----------------

" Vim Commentary settings:
" ------------------------

if s:isactive('vim_commentary')
endif


" Nerd Commenter settings:
" ------------------------

if s:isactive('nerdcommenter')
  " Don't create default mappings
  let g:NERDCreateDefaultMappings = 0
endif


" 2.13. Parenthesis
" -----------------

" 2.13.1. Surround
" ---------------

" 2.13.2. Auto-Pair
" ----------------

" 2.14. Snippet
" -------------

" UltiSnips plugin settings:
" --------------------------

if s:isactive('ultisnips')
  " Trigger configuration.
  " Do not use <tab> if you use:
  " - https://github.com/Valloric/YouCompleteMe.
  " - https://github.com/neoclide/coc.nvim

  " This mapping conflict with Coc mapping for completion
  " let g:UltiSnipsExpandTrigger = "<tab>"

  " Bad solution since it make \ clumsy to insert in insert mode
  " let g:UltiSnipsExpandTrigger = "<leader>u"

  let g:UltiSnipsExpandTrigger = "<C-s>"
  if s:isactive('emmet_vim')
    let g:UltiSnipsExpandTrigger='<C-F12>'
    let g:user_emmet_leader_key='<C-S-F12>'
  endif

  " let g:UltiSnipsJumpForwardTrigger = "<C-b>"
  " let g:UltiSnipsJumpBackwardTrigger = "<C-z>"

  " If you want :UltiSnipsEdit to split your window.
  " let g:UltiSnipsEditSplit="vertical"

  " let g:UltiSnipsRemoveSelectModeMappings = 0

  " More information with: :help UltiSnips.txt
endif


" Emmet plugin settings:
" ----------------------

if s:isactive('emmet_vim')
  let g:user_emmet_leader_key='<C-s>'
  " let g:user_emmet_expandabbr_key='<C-s>,'
  if s:isactive('ultisnips')
    let g:UltiSnipsExpandTrigger='<C-F12>'
    let g:user_emmet_leader_key='<C-S-F12>'
  endif

  " More information with: :help emmet.txt
endif


function! IsEmmet(filetype)
  echom a:filetype

  if a:filetype == 'html'
    return 1
  endif

  if a:filetype == 'css'
    return 1
  endif

  if a:filetype == 'xslt'
    return 1
  endif

  return 0
endf

if s:isactive('ultisnips') && s:isactive('emmet_vim')
  imap <expr> <C-s> IsEmmet(&filetype) ? "\<C-S-F12>" : "\<C-F12>"
endif


" 2.15. Tags
" ----------

" 2.15.1. Tag Generation
" ---------------------

" Gutentags plugin settings:
" --------------------------

if s:isactive('vim_gutentags')
  " Make the gutentags project root as the first parent folder containing:
  " - .gitignore file
  " - .vimspector.json file
  let g:gutentags_project_root = [".vimspector.json", ".gitignore"]
  let g:gutentags_ctags_exclude = [".mypy_cache"]
  " let g:gutentags_ctags_exclude = [".mypy_cache", "*.json"]
endif


" 2.15.2. Tag Browsing
" -------------------

" Tagbar plugin settings:
" -----------------------

if s:isactive('tagbar')
  let g:tagbar_iconchars = ['●', '▼']
  " let g:tagbar_ctags_bin = "C:\\Softs\\ctags.exe"

  hi TagbarVisibilityPublic guifg=#7b8b93 ctermfg=Grey
  hi TagbarVisibilityProtected guifg=#7b8b93 ctermfg=Grey
  hi TagbarVisibilityPrivate guifg=#7b8b93 ctermfg=Grey

  " hi TagbarScope guifg=#7b8b93 ctermfg=Grey

  " nnoremap <F8> :TagbarToggle<CR>
  nnoremap <leader>tg :TagbarOpen fj<CR>
  nnoremap <leader>tt :TagbarToggle <CR>

  " The tagbar configuration for config has been moved in ftplugin\config.vim

  " let g:tagbar_type_config = {
  "     \ 'ctagstype' : 'config',
  "     \ 'kinds' : [
  "         \ 'p:Perspectives',
  "         \ 'g:Groupes',
  "         \ 's:Scripts',
  "         \ 'a:Actions',
  "     \ ],
  "     \ 'kind2scope' : {
  "         \ 'p' : 'Perspectives',
  "         \ 'g' : 'Groups',
  "         \ 's' : 'Scripts',
  "         \ 'a' : 'Actions',
  "     \ },
  "     \ 'scope2kind' : {
  "         \ 'Perspectives' : 'p',
  "         \ 'Groups' : 'g',
  "         \ 'Scripts' : 's',
  "         \ 'Actions' : 'a',
  "     \ },
  " \ }

  " Add support rst (ReStructuredText) file in tagbar
  " Requires rst2ctags
  " pip install rst2ctags
  let g:tagbar_type_rst = {
        \ 'ctagstype': 'rst',
        \ 'ctagsbin' : 'rst2ctags.exe',
        \ 'ctagsargs' : '-f - --sort=yes',
        \ 'kinds' : [
          \ 's:sections',
          \ 'i:images'
          \ ],
          \ 'sro' : '|',
          \ 'kind2scope' : {
            \ 's' : 'section',
            \ },
            \ 'sort': 0,
            \ }

  " Add support for markdown files in tagbar.
  " Requires markdown2ctags
  " pip install markdown2ctags
  let g:tagbar_type_markdown = {
        \ 'ctagstype': 'markdown',
        \ 'ctagsbin' : 'markdown2ctags.exe',
        \ 'ctagsargs' : '-f - --sort=yes --sro=»',
        \ 'kinds' : [
          \ 's:sections',
          \ 'i:images'
          \ ],
          \ 'sro' : '»',
          \ 'kind2scope' : {
            \ 's' : 'section',
            \ },
            \ 'sort': 0,
            \ }

  " Add support for markdown file when considered as vimwiki.
  " Requires markdown2ctags
  " pip install markdown2ctags
  if s:isactive('vimwiki')
    let g:tagbar_type_vimwiki = g:tagbar_type_markdown
  endif

  " " ReStructuredText support in tagbar
  " let g:tagbar_type_rst = {
  "     \ 'ctagstype' : 'ReStructuredText',
  "     \ 'kinds'     : [
  "         \ 'c:chapters',
  "         \ 's:sections',
  "         \ 'S:subsections',
  "         \ 't:subsubsections'
  "     \ ],
  "     \ 'kind2scope' : {
  "         \ 'c' : 'chapter',
  "         \ 's' : 'section',
  "         \ 'S' : 'subsection',
  "         \ 't' : 'subsubsection',
  "     \ },
  "     \ 'sro' : '|',
  "     \ 'scope2kind' : {
  "         \ 'chapter' : 'c',
  "         \ 'section' : 's',
  "         \ 'subsection': 'S',
  "         \ 'subsubsection' : 't',
  "     \ },
  "     \ 'sort': 0,
  " \ }
endif


" Vista plugin settings:
" ----------------------

if s:isactive('vista_vim')
  nnoremap <leader>tt :Vista!! <CR>

  let g:vista_sidebar_width = 40

  " How each level is indented and what to prepend.
  " This could make the display more compact or more spacious.
  " e.g., more compact: ["▸ ", ""]
  " e.g., more compact: [" ", ""]
  " Note: this option only works for the kind renderer, not the tree renderer.
  " let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
  " let g:vista_icon_indent = ['└ ', '│ ']
  let g:vista_icon_indent = ["└ ", "├ "]

  let g:vista_fold_toggle_icons = ['▼', '●']

  " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
  let g:vista#renderer#enable_icon = 1

  " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
  " let g:vista#renderer#icons = {
  " \   "member": "m",
  " \   "class": "c",
  " \   "function": "f",
  " \   "script": "s",
  " \   "variable": "v",
  " \  }

  " let g:vista#renderer#icons = {
  " \   "function": "\uf794",
  " \   "variable": "\uf71b",
  " \  }
  let g:vista#renderer#icons = {
        \   "member": "",
        \   "function": "",
        \   "variable": "",
        \  }

  " let g:vista_ctags_executable = "C:\\Softs\\ctags.exe"

  " let g:vista_log_file = 'C:\\Users\\vds\\vista.log'

  let g:vista_default_executive = 'ctags'
  " let g:vista_psi_executive = 'ctags'
  let g:vista_executive_for = {
        \ 'psi': 'ctags',
        \ 'cpp': 'vim_lsp',
        \ 'php': 'vim_lsp',
        \ }

  if s:isactive('coc_nvim')
    let g:vista_executive_for.python = 'coc_nvim'
  endif

  " \ 'md': 'markdown2ctags.exe -f - --sort=yes --sro=»',
  let g:vista_ctags_cmd = {
        \ 'rst': 'rst2ctags.exe -f - --sort=yes',
        \ }

  hi VistaPublic     guifg=#a3be8c    ctermfg=Green
  hi VistaProtected  guifg=#ebcb8b    ctermfg=Yellow
  hi VistaPrivate    guifg=#bf616a    ctermfg=Red
  hi VistaTag        guifg=#d8dee9    ctermfg=White
endif


" TagList plugin settings:
" ------------------------

" Remark: currently not used
if 0
  " Position the tag list split to the right side
  let Tlist_Use_Right_Window  = 1
  " Set the width of the tag list split to 40 char
  let Tlist_WinWidth = 40
  " Present tags only of the current file
  let Tlist_Show_One_File = 1
  " Switch focus to tag list of toggle on
  " let Tlist_GainFocus_On_ToggleOpen = 1
  " Quit vim if the only spit open is the tag list
  let Tlist_Exit_OnlyWindow = 1

  " nnoremap <F8> :TlistToggle<CR>
  nnoremap <leader>tt :TlistToggle <CR>
endif


" 2.16. Code Completion
" ---------------------

" Coc plugin settings:
" --------------------

if s:isactive('coc_nvim')
  if !has('nvim')
    let $XDG_CONFIG_HOME=$HOME .. '\vimfiles'
    let $XDG_DATA_HOME=$HOME .. '\vimfiles'
    let $XDG_STATE_HOME=$HOME .. '\vimfiles'
  endif

  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup

  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
  nmap <silent> ]g <Plug>(coc-diagnostic-next-error)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  " nmap <silent><expr> gd GoToDef()

  function! DelayedGotoDef(timer)
    if g:start_curpos == getcurpos()
      execute "normal! [\<C-i>"
    endif
  endfunction

  function! GoToDef()
    let g:start_curpos = getcurpos()
    call timer_start(200, 'DelayedGotoDef', {'repeat' : 1})
    return "\<Plug>(coc-definition)"
  endfunction

  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mycocauto
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  " Remark: in conflict with ferret search
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  " Remark: in conflict with ferret search
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Run the Code Lens action on the current line.
  nmap <leader>cl  <Plug>(coc-codelens-action)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    " Don't remap to not hide <C-f>
    " inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    " inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocActionAsync('format')
  " command! -nargs=0 Format :call CocActionAsync('format') | CocCommand python.sortImports

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  " Specifc Settings:
  function! CocToggle()
    if g:coc_enabled
      CocDisable
    else
      CocEnable
    endif
  endfunction
  command! CocToggle :call CocToggle()

  " nnoremap <leader>tj <cmd>CocToggle<CR>
  nnoremap <leader>tj <cmd>CocCommand document.toggleInlayHint<CR>

  " For performance reason disable coc on non code files
  " autocmd BufNew,BufEnter *.json,*.py,*.pyw,*.vim,*.lua execute "silent! CocEnable"
  " autocmd BufLeave *.json,*.py,*.pyw,*.vim,*.lua execute "silent! CocDisable"

  " Control the way the current symbol is highlighted
  " hi CocHighlightText guifg=#2e3440 guibg=#8fbcbb
  hi CocHighlightText guifg=#d8dee9 guibg=#516f7a
  " hi CocHighlightText guifg=#d8dee9 guibg=#44555b

  " Set the color of unused variable the same color as the color of the
  " comments
  hi def link CocFadeOut Comment
  " hi CocFadeOut guifg=#616E88
  " hi CocFadeOut guifg=#4c566a
  " let g:coc_filetype_map = {
  "   \ 'python': 'python',
  "   \ }
  if s:isactive('nord_vim')
    " Adaptation to the nord theme
    hi CocErrorSign guifg = #bf616a
    hi CocErrorVirtualText guifg=#bf616a
    " hi CocErrorLine guifg=#bf616a

    hi CocWarningSign guifg=#d08770
    hi CocWarningVirtualText guifg=#d08770
    " hi CocWarningLine guifg=#d08770
  endif

  " More information with: :help coc-nvim
endif


" LSP plugin settings:
" --------------------

if s:isactive('lsp')
  lua require("mason").setup()
  lua require("mason-lspconfig").setup()
  lua require("null-ls")

  lua require("config.mason")
  lua require("handlers").setup()
  lua require("config.cmp")
  lua require("config.null-ls")
endif


" YouCompleteMe plugin settings:
" ------------------------------

if s:isactive('you_complete_me')
endif


" Deoplete plugin settings:
" -------------------------

if s:isactive('deoplete')
  let g:deoplete#enable_at_startup = 1
endif


" Jedi-Vim plugin settings:
" -------------------------

if s:isactive('jedi_vim')
  " let g:jedi#use_splits_not_buffers = "left"

  " Jedi automatically starts the completion, if you type a dot, e.g. str.,
  " if you don't want this:
  let g:jedi#popup_on_dot = 1

  " Jedi selects the first line of the completion menu: for a better typing-flow and usually saves one keypress.
  " let g:jedi#popup_select_first = 0

  " I don't want the docstring window to popup during completion
  augroup myjedi_fim
    autocmd!
    autocmd FileType python setlocal completeopt-=preview
  augroup END

  " g:jedi#force_py_version = 3.9
endif

if s:isactive('hlargs')
lua << EOF
require('hlargs').setup()
EOF
endif


" 2.17. Code Formatting
" ---------------------

" 2.17.1. ISort
" ------------

" ISort plugin settings:
" ----------------------

if s:isactive('vim_isort')
  " let g:vim_isort_map = '<C-i>'
  let g:vim_isort_map = ''
  let g:vim_isort_python_version = 'python3'
endif


" 2.17.2. Prettier
" ---------------

" Prettier plugin settings:
" -------------------------

if s:isactive('vim_prettier')
  " Change the mapping to run from the default of <Leader>p
  nmap <Leader>fp <Plug>(Prettier)
  " Enable auto formatting of files that have "@format" or "@prettier" tag
  let g:prettier#autoformat = 1

  " Toggle the g:prettier#autoformat setting based on whether a config file can
  " be found in the current directory or any parent directory. Note that this
  " will override the g:prettier#autoformat setting!
  " let g:prettier#autoformat_config_present = 1
endif


" 2.18. Linting
" -------------

" 2.18.1. Linting Engine
" ---------------------

" ALE plugin settings:
" --------------------

if s:isactive('ale')
  " Use the location list instead of the quickfix list (default)
  let g:ale_set_loclist = 1
  let g:ale_set_quickfix = 0

  " Use the quickfix list instead of the location list
  " let g:ale_set_loclist = 0
  " let g:ale_set_quickfix = 1

  " let g:ale_sign_error = '✘'
  let g:ale_sign_error = '⚡'
  " let g:ale_sign_warning = '⚠'
  let g:ale_sign_warning = '▲'

  " let g:ale_python_flake8_executable="C:\\Python36_x64\\Scripts\\flake8.exe"

  " Although Coc-pyright can be used to detect error with flake8 and mypy
  " It seems that for me ALE does a better job
  " This requiers to install flak8 and mypy
  " - pip install flake8
  " - pip install mypy
  " let g:ale_linters = {
  "         \ 'python': [
  "         \       'flake8',
  "         \       'mypy',
  "         \       'isort',
  "         \   ]
  "         \}

  let g:ale_linters = {
          \ 'python': [
          \       'pylint',
          \   ]
          \}

  " I rely on flak8 and mypy to detect problems
  "         \       'flake8',
  "         \       'mypy',
  "         \       'pylint',
  "         \       'pyright',

  let g:ale_fixers = {
        \   'python': [
          \       'black',
          \       'isort',
          \   ],
          \}

  ""\       'nayvy#ale_fixer',
  " \       'autopep8',
  " \       'isort',

  " nmap <F10> :ALEFix<CR>
  let g:ale_exclude_highlights =["E501: line too long.*", "line too long.*"]

  " let g:ale_fix_on_save = 1
  nnoremap <leader>ta :ALEToggle <CR>
endif


" LightBulb settings
" ------------------

if s:isactive('lightbulb')
  lua require('config/lightbulb')
  autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
endif


" 2.18.2. Linting Mark
" --------------------

" Syntastic plugin settings:
" --------------------------

if s:isactive('vim_syntastic')
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_auto_jump = 0

  " high voltage: u26A1 ⚡
  let g:syntastic_error_symbol =  '⚡'
  " warning: u26A0 ⚠
  let g:syntastic_warning_symbol = '▲'
  " umbrella: u2602 ☂
  " thunder clound: u26c8 ⛈
  let g:syntastic_style_error_symbol =  '☾'
  " cloud: u2601 ☁
  " white circle: u25CB ○
  " black circle: u25CF ●
  let g:syntastic_style_warning_symbol =  '☂'
endif


" 2.19. Asynchronous Run
" ----------------------

" 2.21. Terminal
" --------------

" Floaterm plugin settings:
" -------------------------

if s:isactive('vim_floaterm')
  " let g:floaterm_keymap_toggle = '<M-F5>'
  " It seems impossible to map <C-ù>
  " It is most probably a dead key in Belgium keyboard
  let g:floaterm_keymap_toggle = '<M-ù>'
endif


" Neoterm plugin settings:
" ------------------------

if s:isactive('neoterm')
  nnoremap <C-q> :Ttoggle<CR>
  inoremap <C-q> <Esc>:Ttoggle<CR>
  tnoremap <C-q>  <C-\><C-n>:Ttoggle<CR>
endif


" 2.22. Debugging
" ---------------

" Vimspector plugin settings:
" --------------------

if s:isactive('vimspector')
  " Select the keyboard shortcuts (old VisualStudio)
  " - Toggle Breakpoint: F9
  " - Continue: F5
  " - Pause: F6
  " - Stop: Shift-F5
  " - Step Over: F10
  " - Step Into: F11
  " - Step Out: Shift-F11
  let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

  " - Run to Cursor: Ctrl-F10
  nmap <C-F10> <Plug>VimspectorRunToCursor
  " - Go to Cursor: Ctrl-Shift-F10
  nmap <C-S-F10> <Plug>VimspectorGoToCurrentLine

  nnoremap <leader>vr <Cmd>VimspectorReset <CR>
  nnoremap <leader>va <Cmd>call vimspector#ReadSessionFile(expand("%:h") .. "/debuggingsession.json")<CR>
  nnoremap <leader>vz <Cmd>call vimspector#WriteSessionFile(expand("%:h") .. "/debuggingsession.json")<CR>

  nnoremap <leader>vc <Cmd>call win_gotoid(g:vimspector_session_windows.code)<CR>
  nnoremap <leader>vw <Cmd>call win_gotoid(g:vimspector_session_windows.watches)<CR>
  nnoremap <leader>vv <Cmd>call win_gotoid(g:vimspector_session_windows.variables)<CR>

  nnoremap <leader>vs <Cmd>call win_gotoid(g:vimspector_session_windows.stack_trace)<CR>
  nnoremap <leader>vd <Cmd>call vimspector#DownFrame<CR>
  nnoremap <leader>vu <Cmd>call vimspector#UpFrame<CR>

  nnoremap <leader>vb <Cmd>call vimspector#ListBreakpoints()<CR>

  let g:vimspector_enable_auto_hover = 0
  nnoremap <leader>vb <Plug>VimspectorBalloonEval

  let g:vimspector_enable_winbar = 0

  function! VimspectorConfig()
    edit %:h/.vimspector.json
  endfunction

  " Add the VimspectorConfig command
  command! VimspectorConfig :call VimspectorConfig()

endif


" Nvim-Dab plugin settings:
" -------------------------

if s:isactive('nvim_dab')
  lua require("dapui").setup()
  lua require('dap-python').setup('C:\\Python39_x64\\python.exe')

  nnoremap <leader>td :lua require("dapui").toggle()<CR>

  nnoremap <F5> :lua require('dap').continue()<CR>
  nnoremap <C-F5> :lua require('dap').terminate()<CR>
  nnoremap <F10> :lua require'dap'.step_over()<CR>
  nnoremap <S-F10> :lua run_to_cursor()<CR>
  nnoremap <C-S-F10> :lua require'dap'.goto_()<CR>
  nnoremap <F11> :lua require'dap'.step_into()<CR>
  nnoremap <S-F11> :lua require('dap').step_out()<CR>
  nnoremap <F9> :lua require'dap'.toggle_breakpoint()<CR>
endif


" 2.23. File Types
" ----------------

" 2.23.1. VimScript
" -----------------

" Luc Hermite Vim Library settings:
" ---------------------------------

if s:isactive('lh_vim_lib')
    " Parameter: number of errors to decode, default: "1"
    command! -nargs=? WTF call lh#exception#say_what(<f-args>)
    " command! WTF call lh#exception#say_what()
endif


" Synstax settings:
" -----------------

if s:isactive('vim_synstax')
  command! Synstax echo synstax#UnderCursor()
endif


" 2.23.2. Markdown
" ----------------

" Vim Wiki plugin setting:
" ------------------------

if s:isactive('vimwiki')
  " Switch to Markdown syntax:
  " let g:vimwiki_list = [{
  "   \ 'path': '~\vimwiki',
  "   \ 'template_path': '~\vimwiki\templates',
  "   \ 'template_default': 'default',
  "   \ 'syntax': 'markdown',
  "   \ 'ext': '.md',
  "   \ 'path_html': '~/vimwiki/site_html/',
  "   \ 'custom_wiki2html': 'vimwiki_markdown',
  "   \ 'template_ext': '.tpl'}]
  " let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

  " Disable links key mapping to avoid overriding Ctrl-i and Ctrl-o
  " let g:vimwiki_key_mappings =
  "   \ {
  "   \   'all_maps': 1,
  "   \   'global': 1,
  "   \   'headers': 1,
  "   \   'text_objs': 1,
  "   \   'table_format': 1,
  "   \   'table_mappings': 1,
  "   \   'lists': 1,
  "   \   'links': 0,
  "   \   'html': 1,
  "   \   'mouse': 0,
  "   \ }

  " let g:vimwiki_list = [{'path': '~/vimwiki'}]
  " let g:vimwiki_ext2syntax = {
  " \   '.md': 'markdown',
  " \   '.mkd': 'markdown',
  " \   '.wiki': 'media'
  " \ }

  " Make that only .wiki files are considered as vimwiki documents
  let g:vimwiki_global_ext = 0
endif


" Neorg plugin settings
" ---------------------

if s:isactive('neorg')
lua << EOF
  require('neorg').setup {
      load = {
          -- Loads default behaviour
          ["core.defaults"] = {}, 

          -- Adds pretty icons to your documents
          ["core.concealer"] = {}, 

          -- Manages Neorg workspaces
          ["core.dirman"] = { 
              config = {
                  workspaces = {
                      notes = "~/notes",
                      neorg = "~/neorg",
                  },
                  default_workspace = "notes"
              },
          },

          -- ["core.pivot"] = {},

          -- ["core.keybinds"] = {
          --     config = {
          --         default_keybinds = true,
          --     }
          -- }
      }
  }
EOF
endif


" Markdown-Preview plugin settings:
" ---------------------------------

if s:isactive('markdown_preview')
  " set to 1, nvim will open the preview window after entering the markdown buffer
  " default: 0
  let g:mkdp_auto_start = 0

  " set to 1, the nvim will auto close current preview window when change
  " from markdown buffer to another buffer
  " default: 1
  let g:mkdp_auto_close = 1

  " set to 1, the vim will refresh markdown when save the buffer or
  " leave from insert mode, default 0 is auto refresh markdown as you edit or
  " move the cursor
  " default: 0
  let g:mkdp_refresh_slow = 0

  " set to 1, the MarkdownPreview command can be use for all files,
  " by default it can be use in markdown file
  " default: 0
  let g:mkdp_command_for_global = 0

  " set to 1, preview server available to others in your network
  " by default, the server listens on localhost (127.0.0.1)
  " default: 0
  let g:mkdp_open_to_the_world = 0

  " use custom IP to open preview page
  " useful when you work in remote vim and preview on local browser
  " more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
  " default empty
  let g:mkdp_open_ip = ''

  " specify browser to open preview page
  " default: ''
  let g:mkdp_browser = ''

  " set to 1, echo preview page url in command line when open preview page
  " default is 0
  let g:mkdp_echo_preview_url = 0

  " a custom vim function name to open preview page
  " this function will receive url as param
  " default is empty
  let g:mkdp_browserfunc = ''

  " options for markdown render
  " mkit: markdown-it options for render
  " katex: katex options for math
  " uml: markdown-it-plantuml options
  " maid: mermaid options
  " disable_sync_scroll: if disable sync scroll, default 0
  " sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
  "   middle: mean the cursor position alway show at the middle of the preview page
  "   top: mean the vim top viewport alway show at the top of the preview page
  "   relative: mean the cursor position alway show at the relative positon of the preview page
  " hide_yaml_meta: if hide yaml metadata, default is 1
  " sequence_diagrams: js-sequence-diagrams options
  " content_editable: if enable content editable for preview page, default: v:false
  " disable_filename: if disable filename header for preview page, default: 0
  let g:mkdp_preview_options = {
        \ 'mkit': {},
        \ 'katex': {},
        \ 'uml': {},
        \ 'maid': {},
        \ 'disable_sync_scroll': 0,
        \ 'sync_scroll_type': 'middle',
        \ 'hide_yaml_meta': 1,
        \ 'sequence_diagrams': {},
        \ 'flowchart_diagrams': {},
        \ 'content_editable': v:false,
        \ 'disable_filename': 0
        \ }

  " use a custom markdown style must be absolute path
  " like '/Users/username/markdown.css' or expand('~/markdown.css')
  let g:mkdp_markdown_css = GetVimDataFolder() .. 'markdownpreview/markdown.css'

  " use a custom highlight style must absolute path
  " like '/Users/username/highlight.css' or expand('~/highlight.css')
  let g:mkdp_highlight_css = ''

  " use a custom port to start server or random for empty
  let g:mkdp_port = ''

  " preview page title
  " ${name} will be replace with the file name
  let g:mkdp_page_title = '「${name}」'

  " recognized filetypes
  " these filetypes will have MarkdownPreview... commands
  let g:mkdp_filetypes = ['markdown']

  " let g:markdown_fenced_languages = ['html', 'python', 'vim']
endif


" 2.23.3. CSV
" -----------

" Csv plugin settings:
" --------------------

if s:isactive('csv')
  let g:csv_start = 1
  let g:csv_end = 100
  let g:csv_strict_columns = 1

  let g:csv_no_column_highlight = 0
  if s:isactive('nord_vim')
    " Adaptation to the nord theme
    hi CSVDelimiter guifg=#616E88 guibg=#2E3440
    hi CSVColumnEven guifg=#D8DEE9 guibg=#434c5e
    hi CSVColumnOdd guifg=#D8DEE9 guibg=#2E3440
    hi CSVColumnHeaderEven guifg=#D8DEE9 guibg=#434c5e
    hi CSVColumnHeaderOdd guifg=#D8DEE9 guibg=#2E3440
  endif

  " command! SetDelim execute 'NewDelimiter ' . getline('.')[col('.') - 1]
  let g:csv_delim_test = ";\t,|"

  " More information: :help ft-csv
endif


" Csv Rainbow plugin settings:
" ----------------------------

if s:isactive('rainbow_csv')
  let g:rcsv_colorpairs = [
  \ ['magenta', '#B48EAD'],
  \ ['red', '#BF616A'],
  \ ['lightred', '#D08770'],
  \ ['yellow', '#EBCB8B'],
  \ ['green', '#A3BE8C'],
  \ ['cyan', '#8FBCBB'],
  \ ['lightblue', '#88C0D0'],
  \ ['blue', '#5E81AC'],
  \ ['grey', '#616E88'],
  \ ['NONE', 'NONE']
  \ ]

  let g:rcsv_delimiters = [";", "\t", ",", "|"]

  command! SetDelim RainbowDelim

  " More information: :help rainbow_csv
endif

" 2.23.7 TeX/LaTeX
" ----------------

if s:isactive('vimtex')
  let g:vimtex_imaps_disabled = ['b', 'B', 'c', 'f', '/', '-']
endif


if s:isactive('vimlatex')
endif


" 3. Miscellaneous
" ================

" Restore cursor position
" -----------------------

" Make sure the position of the cursor is restored
" when you switch between buffers
" Remark:
" - It is incompatible with tagbar jump to tag
" - The default.vim comes with a better solution for the purpose
if !s:isactive('tagbar')
  augroup saveview
    au!
    au BufLeave * let b:winview = winsaveview()
    au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  augroup END
endif


" Create the file under the cursor if not existing:
" -------------------------------------------------

:noremap <leader>gf :e %:h/<cfile><CR>


" Search in the direction of the document:
" ----------------------------------------

nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')


" Which Key plugin settings:
" --------------------------

if s:isactive('which_key')
  " Trigger Which Key with \ [ret]
  nnoremap <silent> <leader><CR> :<C-u>WhichKey '\'<CR>

  let g:which_key_map =  {}

  " Spelling Suggestion:
  let g:which_key_map['z'] = [':normal! eas', 'Spelling Suggestion']

  " Refresh:
  " Doesn't seems to work fine
  let g:which_key_map['l'] = [':nohlsearch:diffupdate:syntax sync fromstart', 'Refresh']

  " Toggle:
  let g:which_key_map.t = {
        \ 'name' : '+Toggle'
        \ }
  if s:isactive('ale')
    let g:which_key_map.t.a = [':ALEToggle', 'Toggle ALE']
  endif

  if s:isactive('vim_css_color')
    let g:which_key_map.t.h = [':call css_color#toggle()', 'Toggle Colorizer']
  endif

  if s:isactive('hexokinase')
    let g:which_key_map.t.h = [':HexokinaseToggle', 'Toggle Colorizer']
  endif

  if s:isactive('colorizer')
    let g:which_key_map.t.h = ['<Plug>Colorizer', 'Toggle Colorizer']
  endif

  if s:isactive('indentline')
    let g:which_key_map.t.i = [':IndentLinesToggle', 'Toggle Indent Guide']
  endif

  if s:isactive('coc_nvim')
    let g:which_key_map.t.j = [':CocToggle', 'Toggle Coc']
  endif

  if s:isactive('vim_signature')
    let g:which_key_map.t.m = [':SignatureToggleSigns', 'Toggle Marks']
  endif

  if s:isactive('nerdtree')
    let g:which_key_map.t.n = [':NERDTreeToggle', 'Toggle Nerd Tree']
  endif

  if s:isactive('vim_rooter')
    let g:which_key_map.t.r = [':RooterToggle', 'Toggle Rooter']
  endif

  if s:isactive('vim_signify')
    let g:which_key_map.t.s = [':SignifyToggle', 'Toggle Signify']
  endif

  if s:isactive('tagbar')
    let g:which_key_map.t.t = [':TagbarToggle', 'Toggle Tags']
  endif

  if s:isactive('vista_vim')
    let g:which_key_map.t.t = [':Vista!!', 'Toggle Tags']
  endif

  if s:isactive('undotree')
    let g:which_key_map.t.u = [':UndotreeToggle', 'Toggle Undo Tree']
  endif

  if s:isactive('winresizer')
    let g:which_key_map.t.w = [':WinResizerStartResize', 'Toggle Window Resizer']
  endif

  " vim-visual-star-search:
  let g:which_key_map['*'] = [":execute 'noautocmd vimgrep /\\V' .. substitute(escape(expand('<cword>'), '\'), '\n', '\\n', 'g') .. '/ **'", 'Search Current Word']

  " Clap:
  if s:isactive('vim_clap')
    let g:which_key_map['m'] = [':Clap history', 'MRU']
    let g:which_key_map['b'] = [':Clap buffers', 'Buffers']
    let g:which_key_map['p'] = [':Clap proj_tags', 'Tags']
  endif

  if s:isactive('nvim_telescope')
    let g:which_key_map['m'] = [':Telescope oldfiles', 'MRU']
    let g:which_key_map['b'] = [':Telescope buffers', 'Buffers']
    let g:which_key_map['p'] = [':Telescope tags', 'Tags']
  endif

  " Vimspector:
  if s:isactive('vimspector')
    let g:which_key_map.v = {
          \ 'name' : '+VimSpector',
          \ 'r' : [':VimspectorReset', 'Reset'],
          \ 's' : [':call vimspector#WriteSessionFile(expand("%:h") .. "/debuggingsession.json")', 'Save Session'],
          \ 'l' : [':call vimspector#ReadSessionFile(expand("%:h") .. "/debuggingsession.json")', 'Load Session'],
          \ }
  endif

  let g:which_key_map.f = {
          \ 'name' : '+Format'
          \ }

  " Format:
  if s:isactive('vim_prettier')
      let g:which_key_map.f.p = ['<Plug>(Prettier)', 'Format Selection using Prettier']
  endif
  if s:isactive('coc_nvim')
      let g:which_key_map.f.s = ['<Plug>(coc-format-selected)', 'Format Selection using Coc']
  endif

  " Coc:
  if s:isactive('coc_nvim')
    let g:which_key_map.r = {
          \ 'n' : ['<Plug>(coc-rename)', 'Rename'],
          \ }

    let g:which_key_map.q = {
          \ 'f' : ['<Plug>(coc-fix-current)', 'Quick Fix'],
          \ }
  endif

  let g:which_key_map.g = {
        \ 'name' : '+GoTo',
        \ 'f' : [':e %:h/<cfile>', 'GoTo New File'],
        \ }

  " Standard mapping configuration:
  " call which_key#register('\', "g:which_key_map")
  " Plug mapping configuration:
  autocmd! User vim-which-key call which_key#register('\', 'g:which_key_map')
endif

if s:isactive('treesitter')
lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif

if 1
" inoremap jk <Esc>
if has('nvim')
  " On Belgian keyboard make <C-[> be <Esc>
  inoremap <C-¨> <Esc>
  cnoremap <C-¨> <Esc>
endif

" Faster scrolling (by 3 lines)
" nnoremap <C-e> 3<C-e>
" nnoremap <C-y> 3<C-y>

" Make a number of moves (e.g. G, gg, Ctrl-d, Ctrl-u) respect the starting column.
" It make the selection in block mode more intuitive.
" It is a Neovim default
set nostartofline

" Define config_files to fasten the use of the :vim command
abbreviate config_files **/*.cfg **/*.fmt **/*.tsn **/*.cof **/*.tng **/*.rls **/*.setup **/*.alpha **/*.beta **/*.pm **/*.mfc **/*.py **/*.bat

set wildignore+=Tests/**

" Add a Diff command to compare with the disk buffer
function! DiffOrig(spec)
    vertical new
    setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
        let cmd = "++edit #"
    if len(a:spec)
        let cmd = "!git -C " .. shellescape(fnamemodify(finddir('.git', '.;'), ':p:h:h')) .. " show " .. a:spec .. ":#"
    endif
    execute "read " .. cmd
    silent 0d_
    diffthis
    wincmd p
    diffthis
endfunction

command! -nargs=? DiffOrig call DiffOrig(<q-args>)

" Define the H command to display help in a vertical split:
command! -nargs=1 H :vert help <args>

" Add two command to increase and decrease the font size:
command! IncreaseFont :let &guifont = substitute(&guifont, '\(\d\+\)\ze\(:cANSI\)\?$', '\=submatch(1)+1', '')
command! DecreaseFont :let &guifont = substitute(&guifont, '\(\d\+\)\ze\(:cANSI\)\?$', '\=submatch(1)-1', '')

" Leave terminal with Ctrl-q
tnoremap <C-q>  <C-\><C-n>

" Make the \z trigger the spell check context menu (floating window)
nnoremap <Leader>z ea<C-x>s
" nnoremap <leader>z :call search('\w\>', 'c')<CR>a<C-x>s
" Make <CR> validate the spell entry selected
" inoremap <expr> <CR> pumvisible() ? "\<C-y><Esc>" : "\<CR>"

" Here are some trick from Vim-Galore

" Make Ctrl-n and Ctrl-p on the command line work like Down and Up
" Searching for a next/previous command in the history instead of going for the next/previous command
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<up>"

" Make <leader>l disable highlighting temporarily (:nohlsearch)
" A kind of improved Ctrl-l
nnoremap <leader>l :nohlsearch<cr>:windo filetype detect<cr>:diffupdate<cr>:syntax sync fromstart<cr>:setlocal wincolor=<cr><C-l>

" Select the text that has just been pasted
" (inspired from gv that select the text that has been just selected)
nnoremap gp `[v`]

" set lazyredraw

" Keep selection when indenting
" xnoremap <  <gv
" xnoremap >  >gv

" Make sure the QuickFix and LocationList open at the bottom of the screen
" command! Cw bot cw
" command! Copen bot copen

" Adapt the color of the inactive window:
hi DimNormal guibg=#1b212c
" hi DimNormal guibg=#3b4252

if !has('nvim')
  augroup ActiveWin | au!
    au WinEnter,BufEnter,BufWinEnter * setlocal wincolor=
    au WinLeave,BufLeave * setlocal wincolor=DimNormal
  augroup END
endif

" Hide the cursor line for the non active window:
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Add the search clipboard shortcut
function! SearchClipboard()
  let pattern='\V' . @*
  let pattern = pattern->substitute('/', '\/', 'g')

  " Trim last carriage return to easy searching Excel cell copy
  if pattern[-1:] == "\n"
    let pattern = pattern[:-2]
  endif

  let @/=pattern

  call search(pattern)
endfunction

nnoremap <leader>* :call SearchClipboard()<CR>

function! IsSideBar(buf_nr)
" Return 1 if the buffer correspond to a side bar:
" - A terminal window
" - The quickfix window
" - The help
" - The NERDTree side bar
" - ...
  let buf_name = bufname(a:buf_nr)
  let buf_type = getbufvar(a:buf_nr, '&filetype')
  let readonly = getbufvar(a:buf_nr, '&readonly')

  if !has('nvim')
    " Neovim doesn't support the term_list function
    let term_buffers = term_list()
  else
    let term_buffers = []
  endif

  " if readonly
  "   return 1

  if buf_type ==# 'qf'
    " QuickFix, LocationList:
    " Not Read Only
    echom 'QuickFix'
    return 1

  " There are situation where the only buffer you have is help and you are
  " fine with it :-)
  " elseif buf_type ==# 'help'
  "   " Read Only
  "   " Help Window:
  "   " echom 'Help'
  "   return 1

  elseif buf_type ==# 'undotree'
    " Not Read Only
    " echom 'UndoTree'
    return 1

  elseif buf_type ==# 'tagbar'
    " Not Read Only
    " echom 'TagBar'
    return 1

  elseif buf_type ==# 'nerdtree'
    " Read Only
    " echom 'NerdTree'
    return 1

  elseif buf_type ==# "fern"
    " Read Only
    " echom 'Fern'
    return 1

  elseif buf_name =~# 'vimspector.Variables\(\[\d\+\]\)\?$'
    " Read Only
    " echom 'vimspector.Variables'
    return 1

  elseif buf_type ==# 'vimspectorPrompt'
    return 1

  elseif buf_name =~# 'vimspector.Watches\(\[\d\+\]\)\?$'
    " Not Read Only
    " echom 'vimspector.Watches'
    return 1

  elseif buf_name =~# 'vimspector.StackTrace\(\[\d\+\]\)\?$'
    " Read Only
    " echom 'vimspector.StackTrace'
    return 1

  elseif buf_name =~# 'vimspector.Console\(\[\d\+\]\)\?$'
    " Not Read Only
    " echom 'vimspector.Console'
    return 1

  elseif buf_type ==# 'ctrlsf'
    " Not Read Only
    " echom 'vimspector.Console'
    return 1

  " elseif buf_name ==# '!python'
  "   " Not Read Only
  "   return 1

  " elseif buf_name ==# '!python.exe'
  "   " Not Read Only
  "   return 1

  " elseif buf_name ==# '!C:\Windows\system32\cmd.exe'
  "   " Not Read Only
  "   return 1

  elseif index(term_buffers, a:buf_nr) >= 0
    " echom 'Console'
    return 1

  else
    return 0

  endif
endfunction

function! LeaveSideBar()
  " Go to a non side bar window
  let loop = 0
  while 1
    let loop = loop + 1
    let bufnr = bufnr('%')

    if loop > 10
      " Don't search for more than 10 windows
      " To handle the case all the windows are 'side bars'
      break
    endif

    if IsSideBar(bufnr)
      wincmd w
    else
      break
    endif

  endwhile
endfunction

command! LeaveSideBar call LeaveSideBar()

function! GetNumWindows()
  let num_windows = 0

  " echom 'winnr($):' .. winnr('$')

  for win_nr in range(1, winnr('$'))
    let buf_nr = winbufnr(win_nr)
    " echom "Analyze buffer: " . buf_nr
    if IsSideBar(buf_nr)
      continue
    endif
    let num_windows = num_windows + 1
  endfor

  " echom 'Num Windows: ' . num_windows
  return num_windows
endfunction

function! IsAutoClose(buf_nr)
  " Return 1 if the side bar should already auto close
  let buf_type = getbufvar(a:buf_nr, '&filetype')

  let term_buffers = term_list()

  if buf_type ==# 'tagbar'
    " Not Read Only
    return 1

  else
    return 0
  endif
endfunction

function! KillSideBars()
  let num_windows = GetNumWindows()
  " echom "Num windows: " . num_windows
  if num_windows > 0
    " If there are non side bar windows do nothing
    return
  endif

  " Debug
  " return

  " Delete the terminal buffers that don't correspond to a window
  let term_buffers = term_list()
  for buf_nr in term_buffers
    " echom "what about terminal: " . buf_nr
    if len(win_findbuf(buf_nr)) == 0
      " echom "delete terminal: " . buf_nr
      execute 'bd! ' . buf_nr
    endif
  endfor

  let term_buffers = term_list()
  let buf_nr = bufnr('%')
  " echom "buffer: " . buf_nr
  if index(term_buffers, buf_nr) >= 0
    " Kill the terminal buffer and quit
    " echom "terminal buffer"
    call feedkeys("\<C-w>:bd!\<CR>:quit\<CR>:\<BS>")
  elseif !IsAutoClose(buf_nr)
    " Kill the side bar window
    " echom "side bar"
    call feedkeys(":quit\<CR>:\<BS>")
  endif
endfunction

" Close Vim if the last buffer is side bar:
autocmd BufEnter * call KillSideBars()

" Toggle terminal window
" Conflict with the go-back action in help buffer
" nnoremap <C-t> :call ChooseTerm("term-slider", 1)<CR>

function! ChooseTerm(termname, slider)
  let pane = bufwinnr(a:termname)
  let buf = bufexists(a:termname)
  if pane > 0
    " pane is visible
    if a:slider > 0
      :exe pane .. "wincmd c"
    else
      :exe "e #"
    endif
  elseif buf > 0
    " buffer is not in pane
    if a:slider
      :exe "topleft split"
    endif
    :exe "buffer " .. a:termname
  else
    " buffer is not loaded, create
    if a:slider
      :exe "topleft split"
    endif
    :terminal
    :exe "f " a:termname
  endif
endfunction


" Add the trim white spaces function
" (that trim the trailing white spaces ;-) )
function! TrimWhitespaces()
  mark Z
  %s/\s\+$//e
  if line("'Z") != line(".")
    echo "Some white spaces trimmed"
  endif
  normal `Z
  delmarks Z
endfunction

" Add the TrimWhitespaces command
command! TrimWhitespaces :call TrimWhitespaces()

":call Exec('command')
"This will include the output of :command into the current buffer.
"e.g:
":call Exec('ls')
":call Exec('autocmd')
" funct! Exec(command)
"   redir =>output
"   silent exec a:command
"   redir END
"   let @o = output
"   execute "put o"
"   return ''
" endfunct!

" Add the WipeReg command that wipe out the content of all registers
" command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

" Force the detection of the file types to get the correct colorization:
" command! Detect :filetype detect

" Add a UnloadNonProjectFiles to close all the buffers
" that are not child's of the current working directory
command! UnloadNonProjectFiles let cwd=getcwd() | bufdo if (expand('%:p')[0:len(cwd)-1] !=# cwd) | bd | endif

" Enable all Python syntax highlighting features
" let python_highlight_all = 1

let g:python_recommended_style = 1
let g:pyindent_open_paren = shiftwidth()

" Seems to be a Neovim parameters used by some plugins
if has('win32')
  " let g:python3_host_prog='C:\Python27_Win32\python.exe'
  " let g:python3_host_prog='C:\Python36_x64\python.exe'
  let g:python3_host_prog='C:\Python39_x64\python.exe'
  " let g:python3_host_prog='C:\Python312_x64\python.exe'
endif

" autocmd BufRead *.py set makeprg=C:\\python27\\python.exe\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"

" Set the error format to make cnext and cprevious working nice
" Remark:
" - this need autochdir to be set to work properly
" augroup errorformat
"   autocmd!
"   autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" augroup END

" Make Ctrl-F5 run the script in an external console:
augroup console
  autocmd!
  autocmd BufRead *.py,*.bat nmap <C-F5> :silent !start /min "py.exe" C:\\Softs\\open_console.py "%:p:h" --command "%:t"<CR>
  " autocmd BufRead *.py nmap <C-F5> :!start "C:\\Program Files\\Console\\Console.exe" -d "%:p" -p "\"%:t\""<CR>
augroup END

" Helper to convert short month string into month index for date conversions:
function! GetMonthIndex(month)
  if index(["Jan"], a:month) >= 0
    return 1
  endif
  if index(["Feb"], a:month) >= 0
    return 2
  endif
  if index(["Mar", "Mär"], a:month) >= 0
    return 3
  endif
  if index(["Apr"], a:month) >= 0
    return 4
  endif
  if index(["Mai"], a:month) >= 0
    return 5
  endif
  if index(["Jun"], a:month) >= 0
    return 6
  endif
  if index(["Jul"], a:month) >= 0
    return 7
  endif
  if index(["Aug"], a:month) >= 0
    return 8
  endif
  if index(["Sep"], a:month) >= 0
    return 9
  endif
  if index(["Oct", "Okt"], a:month) >= 0
    return 10
  endif
  if index(["Nov"], a:month) >= 0
    return 11
  endif
  if index(["Dec", "Dez"], a:month) >= 0
    return 12
  endif
  return 0
endfunction

function! s:vimclippy() abort
  " Create the vimclippy buffer:
  edit vimclippy
  " Put the content of the clipboard into the buffer:
  silent put! *
  " Delete the last line:
  $delete _
  " Move to the first line:
  1
  " Make `:w` save the content of the buffer into the clipboard:
  augroup vimclippy
    autocmd!
    autocmd BufWriteCmd vimclippy %yank * | set nomodified
  augroup END
endfunction

command! VimClippy call s:vimclippy()
endif
