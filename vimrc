" 0. Vim Default
" ============== {{{

" From: "$VIMRUNTIME/defaults.vim"

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

" Let the cursor move the previous/next line when crossing the start/end of the line
set whichwrap+=<,>,h,l,[,]

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
set scrolloff=1

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

" For Win32 GUI:
" remove 't' flag from 'guioptions': no tearoff menu entries.
" add '!' flag to guioptions so external commands are run in a terminal
if has('win32')
  set guioptions-=t
  if has("terminal")
    set guioptions+=!
  endif
endif

" do not include 'i' in complete option, it may slow down Vim because it
" has to scan all included files
set complete-=i

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
  " Make the "$VIMRUNTIME/filetype.vim" script to set filetype
  " Make the "~/vimviles/ftdetect" folder used to set filetype
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
" }}}

" 1. Standard Vim Settings
" ======================== {{{

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
    let l:vim_data_folder = stdpath('data') . '/'
  else
    if has('win32')
      if $HOME != ''
        let l:vim_data_folder = $HOME . '/vimfiles/'
      else
        let l:vim_data_folder= ' ~/vimfiles/'
      endif
    else
      if $HOME != ''
        let l:vim_data_folder = $HOME . '/.vim/'
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
" vds: the ]m and [m when not executed fast enough for Python code
" fallback to the Vim default
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
command! Noh s/91385034739874398234/

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
if has('nvim') || v:version >= 802 && has("patch-8.2.4907")
  set formatoptions+=/
endif

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
if !isdirectory(GetVimDataFolder() . 'undo')
  call mkdir(GetVimDataFolder() . 'undo')
endif
exe 'set undodir=' . '.undo/,' . GetVimDataFolder() . 'undo/'

" number of undo saved
set undolevels=10000

" Turn off swap files
" set noswapfiles

" Save swap files in the .swap sub-folder (if it exists)
" Otherwise in the ~/vimfiles/swap folder (if it exists)
" (instead of next to the real file)
" It avoid to pollute your local folder
if !isdirectory(GetVimDataFolder() . 'swap')
  call mkdir(GetVimDataFolder() . 'swap')
endif
exe 'set directory=.swap/,' . GetVimDataFolder() . 'swap/'

" Define/Create the view folder to store information from :mkview
if !isdirectory(GetVimDataFolder() . 'view')
  call mkdir(GetVimDataFolder() . 'view')
endif
exe 'set viewdir=' . GetVimDataFolder() .'view/'

" Disable backup files (the myfile.myext~ files)
" It seems to be the default
set nobackup
set nowritebackup
if !isdirectory(GetVimDataFolder() . 'backup')
  call mkdir(GetVimDataFolder() . 'backup')
endif
" exe 'set backupdir=.backup//,' . GetVimDataFolder() . 'backup//'
" exe 'set backupdir=.backup/,' . GetVimDataFolder() . 'backup/'

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

" Move between splits with Ctrl motion keys:
" Remark:
" - Terminal do not support these moves
" - CtrlSF overrides them
if 0
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  tnoremap <C-h> <C-w>h
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
  tnoremap <C-l> <C-w>l
  autocmd! FileType netrw nnoremap <buffer> <C-h> <C-w>h
  autocmd! FileType netrw nnoremap <buffer> <C-j> <C-w>j
  autocmd! FileType netrw nnoremap <buffer> <C-k> <C-w>k
  autocmd! FileType netrw nnoremap <buffer> <C-l> <C-w>l
endif

" Restore Vim to its previous size and position
if s:gui_running
  function! ScreenFilename()
    let l:vim_data_folder = g:GetVimDataFolder()
    if has('amiga')
      return "s:.vimsize"
    else
      return l:vim_data_folder . '_vimsize'
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
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
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
" autocmd VimResized * wincmd =

" Make sure the QuickFix and LocationList open at the bottom of the screen
augroup quickfix
  autocmd FileType qf wincmd J
augroup END

" Allow block selection to cover region past the end of the line:
set virtualedit=block

" Netrw settings:
" --------------- {{{

" Allow the gx command that open a file with the associated viewer/editor
" Allow directory navigation

" Disable Netrw
" let loaded_netrwPlugin = 0

" Hide the directory banner
let g:netrw_banner = 0

" Make it is possible to close the netrw buffer
" autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0
" }}}

" Make a number of moves (e.g. G, gg, Ctrl-d, Ctrl-u) respect the starting column
" It make the selection in block mode more intuitive.
" It is a Neovim default
set nostartofline

" Align the $ motion in Normal and Visual mode
" Don't make the mapping for Visual blockwise since $ has a very special
" meaning in that context
vnoremap <expr> $ (mode() ==# 'v') ? '$h' : '$'

" Ignore compiled files
set wildignore=*.o,*.obj,*~,*.pyc,*.pyd
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
set wildignore+=Tests/**

if has('nvim')
  " On Belgian keyboard make <C-[> be <Esc>
  inoremap <C-¨> <Esc>
  cnoremap <C-¨> <Esc>
endif

" On Belgian keyboard <C-^> is nearly impossible to get
nnoremap <C-§> <C-^>

" Workaround to make the Ctrl-] working on a Belgian keyboard with Vim 9.0
" Remark: The <C-]> is used to navigate through the help system
if !has('nvim')
  nnoremap <C-$> <C-]>
endif
" }}}

" 2. Plugins
" ========== {{{

" 2.1. Plugin Infrastructure
" -------------------------- {{{

function! IsPlugInstalled()
  if has('nvim')
    let plug_file = GetVimDataFolder() . 'site/autoload/plug.vim'
  else
    let plug_file = GetVimDataFolder() . 'autoload/plug.vim'
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
      let cmd = 'silent !powershell -Command "&{iwr -useb ' . l:plug_url . ' | ni ' . GetVimDataFolder() . 'site/autoload/plug.vim -Force}"'
    else
      let cmd = 'silent !powershell -Command "&{iwr -useb ' . l:plug_url . ' | ni ' . GetVimDataFolder() . 'autoload/plug.vim -Force}"'
    endif
  else
    if has('nvim')
      let cmd = 'silent !curl -fLo ' . GetVimDataFolder() . 'site/autoload/plug.vim --create-dirs ' . l:plug_url
    else
      let cmd = 'silent !curl -fLo ' .GetVimDataFolder() . 'autoload/plug.vim --create-dirs ' . l:plug_url
    endif
  endif
  execute cmd
endfunction

if !IsPlugInstalled()
  call InstallPlug()
endif

let s:activate_plugins = 1

let s:plugin_set = {}
let s:plugin_list = []

function! s:newplugin(plugin)
  let l:plugin = {}
  if type(a:plugin) == type('')
    let l:plugin.url = a:plugin
  elseif type(a:plugin) == type({})
    let l:plugin = a:plugin
  else
    echoerr 'Not supported plugin format:' . plugin
  endif

  if !has_key(l:plugin, 'name')
    let l:plugin.name = l:plugin.url
  endif

  if !has_key(l:plugin, 'active')
    let l:plugin.active = 1
  endif

  if !has_key(l:plugin, 'manager')
    let l:plugin.manager = 'plug'
  endif

  if !has_key(l:plugin, 'dependencies')
    let l:plugin.dependencies = []
  else
    let l:dependencies = []
    for l:dplugin in l:plugin.dependencies
      let l:dplugin = s:newplugin(l:dplugin)
      call add(l:dependencies, l:dplugin)
    endfor
    let l:plugin.dependencies = l:dependencies
  endif

  return l:plugin
endfunction

function! s:addplugin(plugin, ...)
  let l:plugin = s:newplugin(a:plugin)
  if a:0 >= 1
    let l:plugin.name = a:1
  endif
  if a:0 >= 2
    let l:plugin.active = a:2
  endif
  let s:plugin_set[l:plugin.name] = l:plugin
  call add(s:plugin_list, l:plugin)
endfunction

function! s:ispluginactive(name)
  if has_key(s:plugin_set, a:name)
    return s:plugin_set[a:name].active
  endif
  return 0
endfunction

function! s:getsubrange(l, locator)
  let low_bound = 0
  let high_bound = len(a:l) - 1
  for loc in a:locator
    let num = high_bound - low_bound + 1
    if loc == '0'
      let high_bound -= num / 2
    else
      if num % 2 == 1
        let num += 1
      endif
      let low_bound += num / 2
    endif
  endfor
  return a:l[low_bound:high_bound]
endfunction

function! s:selectplugins(locator)
  " Deactivate all the plugins that don't belong to a subset determined by the locator.
  " The locator can buffer:
  " - A list of plugin names
  " - A string formed of '0' and '1' that corresponds to a subset of the list:
  "   '0' first Half
  "   '1' second Half
  "   '00' first Quarter
  "   '01' second Quarter
  "   '10' third Quarter
  "   ...
  if type(a:locator) == type('')
    let l:plugin_list = s:getsubrange(range(len(s:plugin_list)), a:locator)
  elseif type(a:locator) == type([])
    let l:plugin_list = copy(s:plugin_list)
    call map(l:plugin_list, {key, val -> index(a:locator, val.name) >= 0 ? key : -1})
    call filter(l:plugin_list, {_, val -> val >= 0})
  endif

  for i in range(len(s:plugin_list))
    if index(l:plugin_list, i) < 0
      let s:plugin_list[i].active = 0
    endif
  endfor
endfunction

function! s:activateplugins(names)
  for name in a:names
    let s:plugin_set[name].active = 1
  endfor
endfunction

function! s:deactivateplugins(names)
  for name in a:names
    let s:plugin_set[name].active = 0
  endfor
endfunction

function s:installplugin(plugin)
  if type(a:plugin) == type({})
    if has_key(a:plugin, 'options')
      Plug a:plugin.url, a:plugin.options
    else
      Plug a:plugin.url
    endif
  else
    if a:plugin == ''
      return
    endif
    Plug a:plugin
  endif
endfunction

function! s:installplugins()
  call plug#begin()
  for plugin in s:plugin_list
    if !plugin.active
      continue
    endif
    if plugin.manager ==# 'packadd'
      " packadd
      execute 'packadd' plugin.url
    elseif plugin.manager ==# 'runtime'
      " runtime
      execute 'runtime' plugin.url
    elseif plugin.manager ==# 'plug'
      " Plug
      if type(plugin) == type({}) && has_key(plugin, 'dependencies')
        " Install dependencies
        for dplugin in plugin.dependencies
          call s:installplugin(dplugin)
        endfor
      endif
      " Install plugin
      call s:installplugin(plugin)
    else
      echoerr 'Unsupported plugin manager:' . plugin.manager
    endif
  endfor
  call plug#end()

  for plugin in s:plugin_list
    if !plugin.active
      continue
    endif
    if has_key(plugin, 'setup')
      try
        call plugin.setup()
      catch
        echom 'Fail to setup:' . plugin.name
      endtry
    endif
  endfor
endfunction

function! GetInstalledPlugins()
  let l:plugin_list = filter(s:plugin_list, {_, val -> val.active})
  return map(copy(l:plugin_list), {_, val -> val.name})
endfunction

let s:mappings = {}
function! s:mapkeys(mode, keys, action, options, description)
  let prefix = keys[0]
  if prefix == '<':
    let prefix = matchstr(keys, '<.*>')
  endif
  if !has_key(s:mapping, prefix)
    s:mappings[prefix] = {}
  endif
  let suffix = keys[len(prefix):]
  s:mapping[prefix][suffix] = [action, description]

  let remap = ''
  if has_key(a:options, 'remap') && a:options['remap']
    let remap = 'nore'
  endif

  let mapping_options=''
  if has_key(a:options, 'buffer') && a:options['buffer']
    let mapping_options = mapping_options . '<buffer>'
  endif
  if has_key(a:options, 'silent') && a:options['silent']
    let mapping_options = mapping_options . '<silent>'
  endif
  if has_key(a:options, 'expr') && a:options['expr']
    let mapping_options = mapping_options . '<expr>'
  endif
  if len(mapping_options):
    let mapping_options = ' ' . mapping_options . ' '

    if !has_key(a:options, 'builtin')
      execute mode . remap . 'map ' . mapping_options . keys . ' ' . action
    endif
endfunction
" }}}

" 2.2. Look & Feel
" ---------------- {{{

" 2.2.1. Color Scheme
" ------------------- {{{

let s:nord_vim = {}
let s:nord_vim.url = 'nordtheme/vim'
let s:nord_vim.options = {'as': 'nordtheme'}
function! s:setup()
  function! FixNord()
    " Make the search background a bit less bright:
    highlight Search guibg=#67909e guifg=#2e3440
    " Make the foreground color of the folded line more bright:
    highlight Folded gui=None guibg=#3b4252 guifg=#d8dee9
  endfunction
  autocmd ColorScheme nord call FixNord()
endfunction
let s:nord_vim.setup = funcref("s:setup")
call s:addplugin(s:nord_vim, "nord_vim")

let s:rose_pine = {}
if has('nvim')
  let s:rose_pine.url = 'rose-pine/neovim'
else
  let s:rose_pine.url = 'rose-pine/vim'
endif
let s:rose_pine.options = {'as': 'rose-pine'}
call s:addplugin(s:rose_pine, "rose_pine")

let s:vim_gruvbox = {'url' : 'morhetz/gruvbox'}
function! s:setup() dict
  function! FixGruvbox()
    " Define terminal colors:
    let g:terminal_ansi_colors = [
          \ '#282828',
          \ '#CC241D',
          \ '#98971A',
          \ '#D79921',
          \ '#458588',
          \ '#B16786',
          \ '#699D6A',
          \ '#A89984',
          \ '#928374',
          \ '#FB4934',
          \ '#B8BB26',
          \ '#FABD2F',
          \ '#83A598',
          \ '#D3869B',
          \ '#8EC07C',
          \ '#EBDBB2',
          \ ]
    highlight Terminal guibg='#282828'
    highlight Terminal guifg='#EBDBB2'

    " Make the cursor always visible:
    highlight Cursor guifg=#ebdbb2 guibg=#282828
    " Make Visual selection transparent
    highlight Visual guifg=NONE guibg=#665C54 ctermbg=NONE term=NONE cterm=NONE gui=NONE

    " Make the quckfix selection solid
    " (at least when the quickfix is not dimmed)
    highlight Search guibg=#fabd2f guifg=#282828 term=None cterm=None gui=None
  endfunction
  autocmd ColorScheme gruvbox call FixGruvbox()
endfunction
let s:vim_gruvbox.setup = funcref("s:setup")
call s:addplugin(s:vim_gruvbox, "vim_gruvbox")

let s:vim_color_solarized = {'url' : 'altercation/vim-colors-solarized'}
call s:addplugin(s:vim_color_solarized, "vim_color_solarized", 0)

let s:iceberg = {'url' : 'cocopon/iceberg.vim'}
call s:addplugin(s:iceberg, "iceberg", 1)

let s:tokyonight = {'url' : 'folke/tokyonight.nvim'}
call s:addplugin(s:tokyonight, "tokyonight", 0)

let s:onedark = {'url' : 'joshdick/onedark.vim'}
call s:addplugin(s:onedark, "onedark", 0)

let s:catppuccin = {'url' : 'catppuccin/nvim'}
let s:catppuccin.options = { 'as': 'catppuccin' }
if has('nvim')
  call s:addplugin(s:catppuccin, "catppuccin", 0)
endif

let s:molokai = {'url' : 'tomasr/molokai'}
call s:addplugin(s:molokai, "molokai", 0)

let s:papercolor = {'url' : 'NLKNguyen/papercolor-theme'}
call s:addplugin(s:papercolor, "papercolor", 0)

let s:everforest = {'url' : 'sainnhe/everforest'}
call s:addplugin(s:everforest, "everforest", 0)

let s:kanagawa = {'url' : 'rebelot/kanagawa.nvim'}
if has('nvim')
  call s:addplugin(s:kanagawa, "kanagawa", 0)
endif

let s:afterglow = {'url' : 'danilo-augusto/vim-afterglow'}
call s:addplugin(s:afterglow, "afterglow", 0)
" }}}

" 2.2.2. Devicon
" -------------- {{{

" Add Language specific icons to NerdTree, AirLine, LightLine, ...
" Depend on full font to be download at: https://github.com/ryanoasis/nerd-fonts/
" Set the guifont to the installed Nerd-Font (e.g.: Cousine_Nerd_Font_Mono)
let s:vim_devicons = {}
let s:vim_devicons.url = 'ryanoasis/vim-devicons'
call s:addplugin(s:vim_devicons, "vim_devicons")
" }}}

" 2.2.3. Status Line
" ------------------ {{{

" Status line enrichment
" Content:
" - Mode
" - Spelling Language
" - Git: +Insert ~Change -Delete Branch-Name
" - Buffer Name [Buffer-Status]
" - ----
" - Method < Class
" - Tags Generation Status (e.g. Gen. ctags)
" - Filetype
" - Encoding [Line-Ending]
" - /Last-Search [Occurence / #Occurences]
" - %Position line nb/file size column
" - [first trailing space line] trailing
let s:vim_airline = {}
let s:vim_airline.url = 'vim-airline/vim-airline'
let s:vim_airline.dependencies = ['vim-airline/vim-airline-themes']
function! s:setup() dict
  " Add a header section for every open buffer
  " let g:airline#extensions#tabline#enabled = 1
  " let g:airline#extensions#tabline#formatter = 'unique_tail'

  if s:ispluginactive('vista_vim')
    " Make sure airline report the function you are in:
    let g:airline#extensions#vista#enabled = 0
  endif

  if s:ispluginactive('tagbar')
    " Make sure airline report the function you are in:
    let g:airline#extensions#tagbar#enabled = 1
    let g:airline#extensions#tagbar#flags = 'f'
  endif

  if s:ispluginactive('ale')
    " Disable code error and warning detection in airline
    " There are just too much false positives
    let g:airline#extensions#ale#enabled = 0
  endif

  if s:ispluginactive('coc_nvim')
    " Disable code error and warning detection in airline
    " There are just too much false positives
    let g:airline#extensions#coc#enabled = 0
    " let g:airline#extensions#coc#show_coc_status = 0
  endif

  " Add the arrow like separator
  let g:airline_powerline_fonts = 1

  if has('win32')
    if has("terminal")
      " vds: It seems that airline is not compatible with the '!' option
      " set guioptions-=!
    endif
  endif
endfunction
let s:vim_airline.setup = funcref("s:setup")
call s:addplugin(s:vim_airline, "vim_airline", 0)

let s:powerline = {}
let s:powerline.url = 'powerline/powerline'
call s:addplugin(s:powerline, "powerline", 0)


let s:vim_lightline = {}
let s:vim_lightline.url = 'itchyny/lightline.vim'
function! s:setup() dict
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

  let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
        \  'right': [ [ 'lineinfo' ],
        \             [ 'percent' ],
        \             [ 'fileformat', 'fileencoding', 'filetype' ], ]
        \ },
        \}
  if s:ispluginactive('vim_fugitive')
    function! MyFugitiveHead()
      let head = FugitiveHead()
      if head != ""
        let head = "\uf126 " . head
      endif
      return head
    endfunction

    call insert(g:lightline.active.left[1], 'gitbranch', 0)
    if !has_key(g:lightline, 'component_function')
      let g:lightline['component_function'] = {}
    endif
    let g:lightline.component_function['gitbranch'] = 'MyFugitiveHead'
  endif

  if s:ispluginactive('vimcaps')
    function! MyVimCaps()
      return vimcaps#statusline(7)
    endfunction

    call add(g:lightline.active.right, ['vimcaps'])
    if !has_key(g:lightline, 'component_function')
      let g:lightline['component_function'] = {}
    endif
    let g:lightline.component_function['vimcaps'] = 'MyVimCaps'
  endif

  let g:lightline.colorscheme = s:colorscheme_desired

  function! UpdateLightline()
    if !exists('g:loaded_lightline')
      return
    endif
    if !g:loaded_lightline
      return
    endif
    let g:lightline.colorscheme = g:colors_name
    call lightline#toggle()
    call lightline#toggle()
  endfunction
  autocmd ColorScheme * call UpdateLightline()
endfunction
let s:vim_lightline.setup = funcref("s:setup")
call s:addplugin(s:vim_lightline, "vim_lightline")
" }}}
" }}}

" 2.3. Ergonomic
" -------------- {{{

" 2.3.1. Unimpaired
" ----------------- {{{

" Add a number of [x ]x mapping
call s:addplugin('tpope/vim-unimpaired', "vim_unimpaired")
" }}}

" 2.3.2. Wilder
" ------------- {{{

" Command line helper (completion, proposition)
" Fuzzy command line
" Requires yarp
" Requires pynvim
"   C:\Python312_x64\Scripts\pip install pynvim
" Remark:
"   A addition call to :UpdateRemotePlugins may needed
"   It seems wilder prevent digraph in the command line
"   (because of the <C-k> mapping for previous completion menu)
" More information: :help wilder.txt
if has('nvim') || v:version >= 801
let s:wilder_simple = 0
let s:wilder = {}
let s:wilder.url = 'gelguy/wilder.nvim'
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  let s:wilder.options = { 'do': function('UpdateRemotePlugins') }
else
  if !has('nvim')
    let s:wilder.dependencies = [{'url': 'roxma/nvim-yarp', 'options': { 'do': 'pip install -r requirements.txt' }}, 'roxma/vim-hug-neovim-rpc']
  endif
endif
function! s:setup() dict
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
  if s:ispluginactive('which_key')
    let g:which_key_map.t.x = [':call wilder#toggle()', 'Toggle Wilder']
  endif

  if s:wilder_simple
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
endfunction
let s:wilder.setup = funcref("s:setup")
call s:addplugin(s:wilder, "wilder")
endif
" }}}

" 2.3.3. Repeat
" ------------- {{{

" Make the '.' repeat action working with:
" - vim-unimpaired
" - vim-surround
" - vim-easyclip
call s:addplugin('tpope/vim-repeat', "vim_repeat", 0)

let s:repmo = {}
let s:repmo.url = 'Houl/repmo-vim'
function! s:setup() dict
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
endfunction
let s:repmo.setup = funcref("s:setup")
call s:addplugin(s:repmo, "repmo", 0)

let s:repeatable_motion = { 'url': 'repeatable-motions', 'manager': 'packadd'}
" let s:repeatable_motion.url = 'repeatable-motions'
" let s:repeatable_motion.manager = "packadd"
function! s:setup() dict
  " call AddRepeatableMotion("[m", "]m", 1)
endfunction
let s:repeatable_motion.setup = funcref("s:setup")
call s:addplugin(s:repeatable_motion, "repeatable_motion", 0)

" Make the ';', ',' repeat motion working for more motions:
if has('nvim') || v:version >= 801
let s:vim_remotions = {}
let s:vim_remotions.url = 'vds2212/vim-remotions'
" let s:vim_remotions.url = 'vim-remotions'
" let s:vim_remotions.manager = "packadd"
function! s:setup() dict
  let g:remotions_direction = 1
  let g:remotions_repeat_count = 1

  let g:remotions_motions = {
        \ 'TtFf' : {},
        \ 'para' : { 'backward' : '{', 'forward' : '}' },
        \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
        \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
        \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
        \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
        \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
        \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
        \
        \ 'line' : {
        \    'backward' : 'k',
        \    'forward' : 'j',
        \    'repeat_if_count' : 1,
        \ },
        \
        \ 'displayline' : {
        \    'backward' : 'gk',
        \    'forward' : 'gj',
        \ },
        \
        \ 'linescroll' : { 'backward' : '<C-e>', 'forward' : '<C-y>' },
        \ 'columnscroll' : { 'backward' : 'zh', 'forward' : 'zl' },
        \ 'columnsscroll' : { 'backward' : 'zH', 'forward' : 'zL' },
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

  " let g:remotions_motions = {
  "       \ 'TtFf' : {},
  "       \ 'char' : {
  "       \    'backward' : 'h',
  "       \    'forward' : 'l',
  "       \    'repeat_if_count' : 0,
  "       \ },
  "       \ }

  if s:ispluginactive('vim_easymotion')
    let g:remotions_motions.easymotion = { 'backward' : '<Plug>(easymotion-prev)', 'forward' : '<Plug>(easymotion-next)', 'motion': '<leader><leader>', 'motion_plug' : '<Plug>(easymotion-prefix)', 'doc': 'easymotion' }
  endif

  if s:ispluginactive('leap')
    let g:remotions_motions.leap_fwd = { 'backward' : '<Plug>(leapbackward)', 'forward' : '<Plug>(leapforward)', 'motion': 's', 'motion_plug' : '<Plug>(leap-forward-to)', 'doc': 'leap' }
    let g:remotions_motions.leap_bck = { 'backward' : '<Plug>(leapbackward)', 'forward' : '<Plug>(leapforward)', 'motion': 'S', 'motion_plug' : '<Plug>(leap-backward-to)', 'doc': 'leap' }
  endif

  if s:ispluginactive('vim_sneak')
    let g:remotions_motions.sneak_fwd = { 'backward' : '<Plug>Sneak_,', 'forward' : '<Plug>Sneak_;', 'motion': 's', 'motion_plug' : '<Plug>Sneak_s', 'doc': 'vim_sneak' }
    let g:remotions_motions.sneak_bck = { 'backward' : '<Plug>Sneak_,', 'forward' : '<Plug>Sneak_;', 'motion': 'S', 'motion_plug' : '<Plug>Sneak_S', 'doc': 'vim_sneak' }
  endif

  if s:ispluginactive('hop')
  endif
endfunction
let s:vim_remotions.setup = funcref("s:setup")
call s:addplugin(s:vim_remotions, "vim_remotions")
endif
" }}}

" 2.3.4. Text Objects
" ------------------- {{{

" Improved Text Objects
" - Multiple line strings
" Remark: seems buggy with nested brace on multilines
" see [issue#228](https://github.com/wellle/targets.vim/issues/288)
call s:addplugin('wellle/targets.vim', "target_vim", 0)

" - Indentation block
call s:addplugin('michaeljsmith/vim-indent-object', "vim_ident_object", 0)

" Text object and motions for Python code
call s:addplugin('jeetsukumaran/vim-pythonsense', "vim_pythonsense", 0)

" Indentation moves (seems to be buggy):
" [- parent indentation
" [= previous sibling indentation
" ]= next sibling indentation
call s:addplugin('jeetsukumaran/vim-indentwise', "vim_indentwise", 0)

let s:vim_sentence = {'url': 'preservim/vim-textobj-sentence'}
let s:vim_sentence.dependencies = ['kana/vim-textobj-user']
function! s:setup() dict
  augroup textobj_sentence
    autocmd!
    autocmd FileType text call textobj#sentence#init()
    autocmd FileType markdown call textobj#sentence#init()
    autocmd FileType textile call textobj#sentence#init()
  augroup END
endfunction
let s:vim_sentence.setup = funcref("s:setup")
call s:addplugin(s:vim_sentence, "vim_sentence", 0)
" }}}

" 2.3.5. Dashboard
" ----------------  {{{

let s:vim_startify = {}
let s:vim_startify.url = 'mhinz/vim-startify'
let s:vim_startify.options = {}
function! s:setup() dict
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

  if s:ispluginactive('tagbar')
    let g:startify_session_before_save += ['silent! TagbarClose']
  endif

  if s:ispluginactive('nerdtree')
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
  command! SName echo v:this_session

  " More information with: :help startify
endfunction
let s:vim_startify.setup = funcref("s:setup")
call s:addplugin(s:vim_startify, "vim_startify", 0)

let s:dashboard_vim = {}
let s:dashboard_vim.url = 'nvimdev/dashboard-nvim'
let s:dashboard_vim.options = {}
function! s:setup() dict
  if s:ispluginactive('vim_clap')
    let g:dashboard_default_executive ='clap'
  endif
  if s:ispluginactive('nvim_telescope')
    let g:dashboard_default_executive ='telescope'
  endif
  if s:ispluginactive('fzf')
    let g:dashboard_default_executive ='fzf'
  endif
endfunction
let s:dashboard_vim.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:dashboard_vim, "dashboard_vim", 0)
endif
" }}}

" 2.3.6. Windows
" -------------- {{{

" Allows you to close buffer without closing the corresponding window
" Introducing the :Bd command
call s:addplugin('moll/vim-bbye', "vim_bbye")

" Re-size windows
" Split management
let s:winresizer = {}
let s:winresizer.url = 'simeji/winresizer'
function! s:setup() dict
  " let g:winresizer_start_key=<C-e>
  let g:winresizer_start_key = "<leader>tw"
  if s:ispluginactive('which_key')
    let g:which_key_map.t.w = [':WinResizerStartResize', 'Toggle Window Resizer']
  endif
  " More information with: :help winresizer
endfunction
let s:winresizer.setup = funcref("s:setup")
call s:addplugin(s:winresizer, "winresizer", 0)

let s:vim_maximizer = {}
let s:vim_maximizer.url = 'szw/vim-maximizer'
function! s:setup() dict
  " Maximize current split or return to previous split states
  let g:maximizer_set_default_mapping = 0
  let g:maximizer_default_mapping_key = '<C-w>m'
  " Prefer normal mapping to not hinder the <C-w> in insert mode:
  nnoremap <C-w>m :MaximizerToggle<CR>
endfunction
let s:vim_maximizer.setup = funcref("s:setup")
call s:addplugin(s:vim_maximizer, "vim_maximizer")

" Allow to run vim in full screen
" Requires pywin32:
"   C:\Python312_x64\Scripts\pip install pywin32
call s:addplugin('ruedigerha/vim-fullscreen', "vim_fullscreen", 0)
" }}}

" 2.3.7. Clipboard
" ---------------- {{{

" Highlight the yanked text:
let s:vim_highlightedyank = {}
let s:vim_highlightedyank.url = 'machakann/vim-highlightedyank'
function! s:setup() dict
  let g:highlightedyank_highlight_duration = 700
  " More information with: :help highlightedyank.txt
endfunction
let s:vim_highlightedyank.setup = funcref("s:setup")
if !has('nvim')
  call s:addplugin(s:vim_highlightedyank, "vim_highlightedyank")
else
  " NeoVim alternative to highlightedyank
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  augroup END
endif

" Highlight the yanked text:
let s:vim_illuminate = {}
let s:vim_illuminate.url = 'RRethy/vim-illuminate'
function! s:setup() dict
  " autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
  autocmd VimEnter * hi illuminatedWord guifg=#2e3440 guibg=#8fbcbb
endfunction
let s:vim_illuminate.setup = funcref("s:setup")
call s:addplugin(s:vim_illuminate, "vim_illuminate", 0)

" Vim is slow on buffer with long lines
" Changing the synmaxcol from 3000 (the default) to 300 improve the
" performance on large files (or files that contains very long lines)
set synmaxcol=300

" Introduce Move and change Delete:
let s:vim_cutlass = {}
let s:vim_cutlass.url = 'svermeulen/vim-cutlass'
let s:vim_cutlass.options = {}
function! s:setup() dict
  " Prefer x over m to not shadow mark
  nnoremap x d
  xnoremap x d

  nnoremap xx dd
  nnoremap X D
endfunction
let s:vim_cutlass.setup = funcref("s:setup")
call s:addplugin(s:vim_cutlass, "vim_cutlass", 0)


" Introduce a Yank Ring:
let s:vim_yoink = {}
let s:vim_yoink.url = 'svermeulen/vim-yoink'
let s:vim_yoink.options = {}
function! s:setup() dict
  nmap <C-n> <plug>(YoinkPostPasteSwapBack)
  nmap <C-p> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  " Also replace the default gp with yoink paste so we can toggle paste in this case too
  nmap gp <plug>(YoinkPaste_gp)
  nmap gP <plug>(YoinkPaste_gP)

  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)
  if s:ispluginactive('vim_cutlass')
    let g:yoinkIncludeDeleteOperations = 1
  endif
endfunction
let s:vim_yoink.setup = funcref("s:setup")
call s:addplugin(s:vim_yoink, "vim_yoink", 0)
" }}}

" 2.3.8. Search
" ------------- {{{

" Visual Selection Search (using '*' and '#')
call s:addplugin('nelstrom/vim-visual-star-search', "vim_visual_star_search")

" Preview substitution of the s command before performing it
" Remarks:
"   Trace is not necessary for NeoVim
"   Since Vim 8.1.0271 incseach highlight the match
let s:traces = {}
let s:traces.url = 'markonm/traces.vim'
let s:traces.options = {}
if !has('nvim')
  call s:addplugin(s:traces, "traces")
endif

" Highlight all pattern match
" Remark:
"   In the meantime the set incsearch bring a fair fraction of the features
call s:addplugin('haya14busa/incsearch', "incsearch", 0)

" New version of incsearch
" - Highlight all pattern match
" - Stop highlighting on cursor move
let s:is_vim = {}
let s:is_vim.url = 'haya14busa/is.vim'
function! s:setup() dict
  " Make sure the <C-k> is not overridden:
  let g:is#do_default_mappings = 0
  for s:map in ['n', 'N', '*', '#', 'g*', 'g#']
    if mapcheck(s:ispluginactive('map'), 'n') ==# ''
      execute printf(':nmap %s <Plug>(is-%s)', s:map, s:map)
    endif
    if mapcheck(s:ispluginactive('map'), 'x') ==# ''
      execute printf(':xmap %s <Plug>(is-%s)', s:map, s:map)
    endif
    if mapcheck(s:ispluginactive('map'), 'o') ==# ''
      execute printf(':omap %s <Plug>(is-%s)', s:map, s:map)
    endif
  endfor
  unlet s:map

  " More information with: :help is.txt?
endfunction
let s:is_vim.setup = funcref("s:setup")
call s:addplugin(s:is_vim, "is_vim", 0)

" Case sensitive search and replace
call s:addplugin('tpope/vim-abolish', "vim_abolish")

" Allow buffer specific search register
let s:local_search = {}
let s:local_search.url = 'mox-mox/vim-localsearch'
function! s:setup() dict
  nmap <leader>/ <Plug>localsearch_toggle
  if s:ispluginactive('which_key')
    let g:which_key_map['/'] = ['<Plug>localsearch_toggle', 'Toggle Local Search']
  endif
endfunction
let s:local_search.setup = funcref("s:setup")
call s:addplugin(s:local_search, "local_search", 0)
" }}}

" 2.3.9. Moves
" ------------ {{{

" Extend the matching '%' movement to matching keywords
let s:matchit_legacy = {}
let s:matchit_legacy.url = 'macros/matchit.vim'
let s:matchit_legacy.manager = 'runtime'
function! s:setup() dict
  if s:ispluginactive('which_key')
    let g:which_key_map_g['%'] = ["<Plug>(MatchitNormalBackward)", 'Matchit']
  endif
endfunction
let s:matchit_legacy.setup = funcref("s:setup")
call s:addplugin(s:matchit_legacy, "matchit_legacy")

" Extend the matching '%' movement to matching keywords
call s:addplugin('andymass/vim-matchup', "vim_matchup", 0)

" Add alternatives to the
" - w, W, b, B
" - f <char> motion and friends (f, F, t, T)
" - ...
" Remark:
" - You get the <leader><leader>f <char> motion and friends (f, F, t, T)
call s:addplugin('easymotion/vim-easymotion', "vim_easymotion", 1)

let s:leap = {}
let s:leap.url = 'ggandor/leap.nvim'
let s:leap.options = {}
function! s:setup() dict
  lua require('leap').add_default_mappings()
  if s:ispluginactive('vim_remotions')
    lua require('leap').add_repeat_mappings('<Plug>(leapforward)', '<Plug>(leapbackward)')
  else
    lua require('leap').add_repeat_mappings(';', ',')
  endif
  " lua require('leap').add_repeat_mappings(';', ',', { relative_directions = true, modes = {'n', 'x', 'o'}, })
endfunction
let s:leap.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:leap, "leap", 0)
endif

let s:vim_sneak = {}
let s:vim_sneak.url = 'justinmk/vim-sneak'
function! s:setup() dict
  let g:sneak#label = 1
endfunction
let s:vim_sneak.setup = funcref("s:setup")
call s:addplugin(s:vim_sneak, "vim_sneak", 0)

let s:hop = {}
let s:hop.url = 'smoka7/hop.nvim'
function! s:setup() dict
  lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  " lua vim.keymap.set('n', '<leader>gw', function() require('hop').hint_words() end, { remap = true, desc = 'move to word in buffer' })
endfunction
let s:hop.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:hop, "hop", 0)
endif

" 2.3.10. Unicode
" ---------------

" Help to find Unicode characters
" Remark:
" - Seems to be broken on Windows (23/03/2023)
let s:unicode_helper = {}
let s:unicode_helper.url = 'chrisbra/unicode.vim'
function! s:setup() dict
  " nnoremap ga :UnicodeName<CR>
  noremap ga <Plug>(UnicodeGA)
  " let g:Unicode_no_default_mappings = v:true
endfunction
let s:unicode_helper.setup = funcref("s:setup")
call s:addplugin(s:unicode_helper, "unicode_helper", 0)

" Help to understand Unicode characters
call s:addplugin('tpope/vim-characterize', "vim_characterize", 0)
" }}}

" 2.3.11. Multiple Cursors
" ------------------------ {{{

" Multiple cursors
call s:addplugin('mg979/vim-visual-multi', "vim_visual_multi", 0)

" Multiple cursors for parallel modifications
call s:addplugin('terryma/vim-multiple-cursors', "vim_multiple_cursors", 0)
" }}}

" 2.3.12. CSS Colors
" ------------------ {{{

" Highlight color codes
let s:vim_css_color = {}
let s:vim_css_color.url = 'ap/vim-css-color'
let s:vim_css_color.options = {}
function! s:setup() dict
  nnoremap <leader>th :call css_color#toggle()<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.h = [':call css_color#toggle()', 'Toggle Colorizer']
  endif
endfunction
let s:vim_css_color.setup = funcref("s:setup")
call s:addplugin(s:vim_css_color, "vim_css_color")

" Remarks:
" - Requires: Go Language installation
let s:hexokinase = {}
let s:hexokinase.url = 'rrethy/vim-hexokinase'
let s:hexokinase.options = { 'do': 'make hexokinase' }
function! s:setup() dict
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
  if s:ispluginactive('which_key')
    let g:which_key_map.t.h = [':HexokinaseToggle', 'Toggle Colorizer']
  endif
endfunction
let s:hexokinase.setup = funcref("s:setup")
call s:addplugin(s:hexokinase, "hexokinase", 0)

" Remarks:
" - Requires: awk
" - Requires: Cygwin?
" - Doesn't seems to work on windows
call s:addplugin('BourgeoisBear/clrzr', "clrzr", 0)

" Remarks:
" - Doesn't seems to be supported anymore
let s:colorizer = {}
let s:colorizer.url = 'lilydjwg/colorizer'
let s:colorizer.options = {}
function! s:setup() dict
  let g:colorizer_maxlines = 1000
  if s:ispluginactive('which_key')
    let g:which_key_map.t.h = ['<Plug>Colorizer', 'Toggle Colorizer']
  endif
endfunction
let s:colorizer.setup = funcref("s:setup")
call s:addplugin(s:colorizer, "colorizer", 0)
" }}}

" 2.3.13. Miscellaneous
" --------------------- {{{

" Make C-x C-f completion relative to the file and not to the current working directory
let s:vim_relatively_complete = {}
let s:vim_relatively_complete.url = 'thezeroalpha/vim-relatively-complete'
function! s:setup() dict
  imap <C-x><C-f> <Plug>RelativelyCompleteFile
endfunction
let s:vim_relatively_complete.setup = funcref("s:setup")
call s:addplugin(s:vim_relatively_complete, "vim_relatively_complete")

let s:vim_expand_region = {}
let s:vim_expand_region.url = 'terryma/vim-expand-region'
function! s:setup() dict
  " Make sure the _ is not overridden:
  map + <Plug>(expand_region_expand)
  map - <Plug>(expand_region_shrink)
endfunction
let s:vim_expand_region.setup = funcref("s:setup")
call s:addplugin(s:vim_expand_region, "vim_expand_region", 0)

" Hint about keyboard shortcuts
let s:which_key = {}
let s:which_key.url = 'liuchengxu/vim-which-key'
let s:which_key.options = { 'on': ['WhichKey', 'WhichKey!'] }
function! s:setup() dict
  set timeoutlen=1000
  let g:which_key_timeout=300

  " let g:which_key_ignore_outside_mappings = 1

  autocmd! User vim-which-key
  nnoremap <silent> <leader> :<C-u>WhichKey '<leader>'<CR>
  autocmd User vim-which-key call which_key#register(g:mapleader, 'g:which_key_map')

  nnoremap <silent> g :<C-u>WhichKey 'g'<CR>
  autocmd User vim-which-key call which_key#register('g', 'g:which_key_map_g')

  " :help *z*
  nnoremap <silent> z :<C-u>WhichKey 'z'<CR>
  autocmd User vim-which-key call which_key#register('z', 'g:which_key_map_z')
endfunction
let s:which_key.setup = funcref("s:setup")
call s:addplugin(s:which_key, "which_key", 0)

" Register visibility
call s:addplugin('junegunn/vim-peekaboo', "vim_peekaboo", 0)

" Distraction free mode:
call s:addplugin('junegunn/goyo.vim', "goyo", 0)

" Distraction free colorization of the other paragraphs
call s:addplugin('junegunn/limelight.vim', "limelight", 0)

" Basic large files support
" Make large files not slowing down vim as much as possible
let s:large_file = {}
" let s:large_file.url = 'vim-scripts/LargeFile'
let s:large_file.url = 'vds2212/LargeFile'
function! s:setup() dict
  " Size of what is considered a large file in Mb
  let g:LargeFile = 1.0
  let g:LargeFile_dont = ["undo"]
  " let g:LargeFile_dont = ["syntax", "filetype"]
endfunction
let s:large_file.setup = funcref("s:setup")
call s:addplugin(s:large_file, "large_file")

call s:addplugin('PeterRincker/vim-argumentative', "argumentative")

" Add the CheckHealth command to Vim
if !has('nvim')
  call s:addplugin('rhysd/vim-healthcheck', "checkhealth", 0)
endif

call s:addplugin('dstein64/vim-startuptime', "startuptime", 0)

" Ensure the context lines keep being visible
let s:context = {}
let s:context.url = 'wellle/context.vim'
" let s:context.options = {'commit': '5d14952'}
function! s:setup() dict
  " Disable context by default
  let g:context_enabled = 0

  " Don't insert the default plugin mapping
  let g:context_add_mappings = 0

  let g:Context_border_indent = { -> [0, 0] }

  " let g:context_skip_regex = '^\([<=>]\{7\}\|\s*\($\|\h\+\S\s*:\|#\|//\|/\*\|\*\($\|\s\|/\)\)\)'
  " Allow \h\+\S\s*: for pccts grammar names
  let g:context_skip_regex = '^\([<=>]\{7\}\|\s*\($\|#\|//\|/\*\|\*\($\|\s\|/\)\)\)'

  " let g:context_extend_regex = '^\s*\([]{})]\|end\|else\|\(case\|default\|done\|elif\|fi\)\>\)'

  nnoremap <leader>tc :ContextToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.c = [':ContextToggle', 'Toggle Context']
  endif
endfunction
let s:context.setup = funcref("s:setup")
call s:addplugin(s:context, "context")

call s:addplugin('AndrewRadev/splitjoin.vim', "context", 0)

let s:treejs = {}
let s:treejs.url = 'Wansmer/treesj'
let s:treejs.dependencies = ['nvim-treesitter/nvim-treesitter']
function! s:setup() dict
lua << EOF
  require("treejs").setup({})
EOF
endfunction
let s:treejs.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:treejs, "treejs", 0)
endif

" Spell checking
let s:vim_spellcheck = {}
let s:vim_spellcheck.url = 'inkarkat/vim-SpellCheck'
let s:vim_spellcheck.dependencies = ['inkarkat/vim-ingo-library']
call s:addplugin(s:vim_spellcheck, "vim_spellcheck", 0)

" Add database query support
call s:addplugin('tpope/vim-dadbod', "vim_dadbod")

call s:addplugin('kristijanhusak/vim-dadbod-completion', "vim_dadbod_completion", 0)

call s:addplugin('kristijanhusak/vim-dadbod-ui', "vim_dadbod_ui")

" Remarks:
" - It seems that when a file is locked by Excel sudo prevent the saveas
"   method to work
let s:sudoedit_vim = {}
let s:sudoedit_vim.url = 'chrisbra/SudoEdit.vim'
function! s:setup() dict
  let g:sudoAuthArg = '/noprofile /user:MT-BRU-2-0102\ladmin'
  " More information with: :help SudoEdit.txt
endfunction
let s:sudoedit_vim.setup = funcref("s:setup")
call s:addplugin(s:sudoedit_vim, "sudoedit_vim", 0)

call s:addplugin('romainl/vim-cool', "vim_cool", 0)

call s:addplugin('suxpert/vimcaps', "vimcaps", 0)

" Highlight briefly the cursor when it jump from split to split
let s:beacon = {}
let s:beacon.url = 'DanilaMihailov/beacon.nvim'
function! s:setup() dict
  " let g:beacon_enable = 0

  " This settings seems to give strange results
  " let g:beacon_size = 10

  highlight Beacon guibg=white ctermbg=15
  let g:beacon_timeout = 300

  " Disable beacon on jumps
  let g:beacon_show_jumps = 0
endfunction
let s:beacon.setup = funcref("s:setup")
call s:addplugin(s:beacon, "beacon", 0)

" Introduce a LongLines mode where the j and k key works like gj and gk
call s:addplugin('manu-mannattil/vim-longlines', "vim_long_lines", 0)

" Interactive Scratchpad
" Remarks:
" - Currently only working for Linux or MacOS
let s:codi_vim = {}
let s:codi_vim.url = 'metakirby5/codi.vim'
function! s:setup() dict
  let g:codi#interpreters = {
        \ 'python': {
        \ 'bin': 'C:\Python36_x64\python.exe',
        \ 'prompt': '^\(>>>\|\.\.\.\) ',
        \ },
        \ }
endfunction
let s:codi_vim.setup = funcref("s:setup")
call s:addplugin(s:codi_vim, "codi_vim", 0)

" Tridactyl Firefox add-on support
call s:addplugin('tridactyl/vim-tridactyl', "vim_tridactyl", 0)

call s:addplugin('vds2212/vim-orpheus', "vim_orpheus", 0)

call s:addplugin('ThePrimeagen/vim-be-good', "vim_be_good", 0)
" }}}
" }}}

" 2.4. File Browsing
" ------------------ {{{

" 2.4.1. Rooter
" ------------- {{{

" Adapt automatically the working directory
let s:vim_rooter = {}
let s:vim_rooter.url = 'airblade/vim-rooter'
function! s:setup() dict
  " This is to make sure Vim-Rooter is triggered when a file is open via the gVim  --remote-silent option
  " But it doesn't seems to work for me
  " augroup mygroup
  "     autocmd BufReadPost * :Rooter
  " augroup end

  let g:rooter_patterns = ['.git', '.gitignore', '_darcs', '.hg', '.bzr', '.svn', 'Makefile']
  let g:rooter_change_directory_for_non_project_files = 'current'

  nnoremap <leader>tr :RooterToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.r = [':RooterToggle', 'Toggle Rooter']
  endif

  " More information with: :help rooter.txt
endfunction
let s:vim_rooter.setup = funcref("s:setup")
call s:addplugin(s:vim_rooter, "vim_rooter")
" }}}

" 2.4.2. Fuzzy Searching
" ---------------------- {{{

" FzF (File Fuzzy Finder)
" Remark:
" - In order to make preview working make sure C:\Program Files\Git\Bin is part of the path.
" - On Windows it seems FzF proposes buffers with the wrong path
let s:fzf = {}
let s:fzf.url = 'junegunn/fzf'
let s:fzf.options = { 'do': { -> fzf#install() } }
let s:fzf.dependencies = ['junegunn/fzf.vim']
function! s:setup() dict
  nnoremap <C-p> :Files<CR>
  nnoremap <leader>m :History<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>p :Tags<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.m = [':History', 'Browse MRU']
    let g:which_key_map.b = [':Buffers', 'Browse Buffers']
    let g:which_key_map.p = [':Tags', 'Browse Tags']
  endif

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
endfunction
let s:fzf.setup = funcref("s:setup")
call s:addplugin(s:fzf, "fzf", 0)

" Fuzzy finder
let s:ctrlp = {}
let s:ctrlp.url = 'ctrlpvim/ctrlp.vim'
let s:ctrlp.options = {}
function! s:setup() dict
  " <C-p> is the default of CtrlP ;-)
  nnoremap <leader>m :CtrlPMRUFiles<CR>
  nnoremap <leader>b :CtrlPBuffer<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.m = [':CtrlPMRUFiles', 'Browse MRU']
    let g:which_key_map.b = [':CtrlPBuffer', 'Browse Buffers']
    " let g:which_key_map.p = [':Tags', 'Browse Tags']
  endif

  let g:ctrlp_working_path_mode = 'ra'

  let g:ctrlp_root_markers = ['.git', '.gitignore', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', '.vimspector.json']
endfunction
let s:ctrlp.setup = funcref("s:setup")
call s:addplugin(s:ctrlp, "ctrlp", 0)

if has('nvim') || v:version >= 801 && has('patch-8.1.2114')
" In order to make tag generation working install maple:
" Downloading from GitHub:
"   :call clap#installer#download_binary()
" Or building from source using Rust
"   :call clap#installer#build_maple()
" Remark:
"   - Deleting the vimfiles/plugged/vim-clap/bin/maple.exe manually to make
"     sure it is replaced by the fresh version.
let s:vim_clap = {}
let s:vim_clap.url = 'liuchengxu/vim-clap'
let s:vim_clap.options = { 'do': { -> clap#installer#force_download() } }
function! s:setup() dict
  nnoremap <C-p> :call LeaveSideBar() <bar> Clap files<CR>
  nnoremap <leader>m :call LeaveSideBar() <bar> Clap history<CR>
  nnoremap <leader>b :call LeaveSideBar() <bar> Clap buffers<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.m = [':Clap history', 'Browse MRU']
    let g:which_key_map.b = [':Clap buffers', 'Browse Buffers']
  endif

  " Requires Vista and maple
  nnoremap <leader>p :call LeaveSideBar() <bar> Clap proj_tags<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.p = [':Clap proj_tags', 'Browse Tags']
  endif

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

  " For Gruvbox colorscheme
  function! FixClapColorScheme()
    highlight ClapFuzzyMatches1 guifg=#FABD2F
    highlight ClapFuzzyMatches2 guifg=#FABD2F
    highlight ClapFuzzyMatches3 guifg=#FABD2F
    highlight ClapFuzzyMatches4 guifg=#FABD2F
    highlight ClapFuzzyMatches5 guifg=#FABD2F
    highlight ClapFuzzyMatches6 guifg=#FABD2F
    highlight ClapFuzzyMatches7 guifg=#FABD2F
    highlight ClapFuzzyMatches8 guifg=#FABD2F
    highlight ClapFuzzyMatches9 guifg=#FABD2F
  endfunction
  autocmd ColorScheme gruvbox call FixClapColorScheme()
endfunction
let s:vim_clap.setup = funcref("s:setup")
call s:addplugin(s:vim_clap, "vim_clap", 1)
endif

" Remark:
"   Only available for NeoVim
let s:nvim_telescope = {}
let s:nvim_telescope.url = 'nvim-telescope/telescope.nvim'
let s:nvim_telescope.dependencies = ['nvim-lua/plenary.nvim', 'nvim-telescope/telescope-live-grep-args.nvim']
" nvim-telescope/telescope-live-grep-args.nvim
function! s:setup() dict
  " Find files using Telescope command-line sugar.
  nnoremap <C-p> <cmd>Telescope find_files<cr>
  nnoremap <leader>m <cmd>Telescope oldfiles<cr>
  nnoremap <leader>b <cmd>Telescope buffers<cr>
  if s:ispluginactive('which_key')
    let g:which_key_map.m = [':Telescope oldfiles', 'Browse MRU']
    let g:which_key_map.b = [':Telescope buffers', 'Browse Buffers']
  endif

  " Requires tags to be generate (manually or via vim-gutentags)
  nnoremap <leader>p <cmd>Telescope tags<cr>
  if s:ispluginactive('which_key')
    let g:which_key_map.p = [':Telescope tags', 'Browse Tags']
  endif

  " nnoremap <leader>g <cmd>Telescope live_grep<cr>
  " nnoremap <leader>h <cmd>Telescope help_tags<cr>

  lua require('config/telescope')
endfunction
let s:nvim_telescope.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:nvim_telescope, "nvim_telescope")
endif

let s:bufexplorer = {}
let s:bufexplorer.url = 'jlanzarotta/bufexplorer'
function! s:setup() dict
  " Disable default mapping
  let g:bufExplorerDisableDefaultKeyMapping = 1

  let g:bufExplorerSplitVertSize=60

  " Split Left
  let g:bufExplorerSplitRight=0
endfunction
let s:bufexplorer.setup = funcref("s:setup")
call s:addplugin(s:bufexplorer, "bufexplorer")

call s:addplugin('troydm/easybuffer.vim', "easybuffer", 0)
" }}}

" 2.4.3. File searching
" --------------------- {{{

" Ack
" --- {{{
" Remark:
" - Seems not to support asynchronous mode on Windows
let s:ack_vim = {}
let s:ack_vim.url = 'mileszs/ack.vim'
function! s:setup() dict
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

  if s:ispluginactive('vim_dispatch')
    " let g:ack_use_dispatch = 1
  endif

  " Provide for each solution a Ack command such that it is easier to switch
  " from one to the next

  " Don't jump to first match
  " cnoreabbrev Ack Ack!

  " More information with: :help ack.txt
  nnoremap <silent> <leader>ts <cmd>call ToggleQuickFix()<cr>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.s = [':call ToggleQuickFix()', 'Toggle Quick Fix']
  endif
endfunction
let s:ack_vim.setup = funcref("s:setup")
call s:addplugin(s:ack_vim, "ack_vim", 0)
" }}}

" CtrlSF
" ------ {{{
" Remark:
" - Seems to work in asynchronous mode on Windows
let s:ctrlsf = {}
let s:ctrlsf.url = 'dyng/ctrlsf.vim'
function! s:setup() dict
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

  " QuickFix List bufnr
  " getqflist(0, {"qfbufnr":1}).qfbufnr
  " Location List bufnr
  " getloclist(0, {"qfbufnr":1}).qfbufnr
  " last utilization time
  " getbufinfo(bufnr)[0].lastused
  function! QuickFixVisible()
    for winnr in range(1, winnr('$'))
      if getwinvar(winnr, '&syntax') == 'qf'
        return 1
      endif
    endfor
    return 0
  endfunction

  function! CtrlSFNextMatch()
    if QuickFixVisible() && s:ispluginactive('vim_unimpaired')
      execute "normal \<Plug>(unimpaired-cnext)"
      return
    endif
    CtrlSFOpen
    call ctrlsf#NextMatch(1)
    call ctrlsf#JumpTo('open_background')
  endfunction

  function! CtrlSFPreviousMatch()
    if QuickFixVisible() && s:ispluginactive('vim_unimpaired')
      execute "normal \<Plug>(unimpaired-cprevious)"
      return
    endif
    CtrlSFOpen
    call ctrlsf#NextMatch(0)
    call ctrlsf#JumpTo('open_background')
  endfunction

  function! CtrlSFNextFMatch()
    if QuickFixVisible()
      cnfile
      return
    endif
    CtrlSFOpen
    call ctrlsf#NextMatch(1, 1)
    call ctrlsf#JumpTo('open_background')
  endfunction

  function! CtrlSFPreviousFMatch()
    if QuickFixVisible()
      cpfile
      return
    endif
    CtrlSFOpen
    call ctrlsf#NextMatch(0, 1)
    call ctrlsf#JumpTo('open_background')
  endfunction

  nnoremap ]q <Cmd>call CtrlSFNextMatch()<CR>
  nnoremap [q <Cmd>call CtrlSFPreviousMatch()<CR>
  nnoremap ]Q <Cmd>call CtrlSFNextFMatch()<CR>
  nnoremap [Q <Cmd>call CtrlSFPreviousFMatch()<CR>

  nnoremap <leader>ts <Cmd>call ToggleQuickFix()<CR>
  " nnoremap <leader>ts <Cmd>CtrlSFToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.s = [':call ToggleQuickFix()', 'Toggle Quick Fix']
  endif

  " Provide for each solution a Ack command such that it is easier to switch
  " from one to the next
  command! -nargs=* Ack CtrlSF <args>
endfunction
let s:ctrlsf.setup = funcref("s:setup")
call s:addplugin(s:ctrlsf, "ctrlsf")
" }}}

" Ferret
" ------ {{{
let s:ferret = {}
let s:ferret.url = 'wincent/ferret'
function! s:setup() dict
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
  if s:ispluginactive('which_key')
    let g:which_key_map.t.s = [':call ToggleQuickFix()', 'Toggle Quick Fix']
  endif
endfunction
let s:ferret.setup = funcref("s:setup")
call s:addplugin(s:ferret, "ferret", 0)
" }}}
" }}}

" 2.4.4. File browsing
" -------------------- {{{

let s:nerdtree = {}
let s:nerdtree.url = 'scrooloose/nerdtree'
let s:nerdtree.options = { 'on':  'NERDTreeToggle' }
function! s:setup() dict
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1

  " let NERDTreeHijackNetrw = 1

  " noremap <F4> :NERDTreeToggle<CR>
  nnoremap <leader>tn :NERDTreeToggle <CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.n = [':NERDTreeToggle', 'Toggle Nerd Tree']
  endif

  " Set the NERDTree constext menu Shift-F10
  " in order to replace the default m that is used by signature
  " It seems that <S-F10> can't be assigned to NerdTree
  " let NERDTreeMapMenu = '<S-F10>'
  let NERDTreeMapMenu = '<F2>'
  let NERDTreeMapChangeRoot = 'D'

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

  command! -nargs=? -complete=file E call NERDTreeExplore(<f-args>)

  " More information with: :help NERDTree.txt
endfunction
let s:nerdtree.setup = funcref("s:setup")
call s:addplugin(s:nerdtree, "nerdtree")
" Plug 'Xuyuanp/nerdtree-git-plugin'

let s:nvim_tree = {}
let s:nvim_tree.url = 'nvim-tree/nvim-tree.lua'
let s:nvim_tree.dependencies = ['nvim-tree/nvim-web-devicons']
function! s:setup() dict
  lua require("config/nvimtree")

  " noremap <F4> :NvimTreeToggle<CR>
  nnoremap <leader>tn :NvimTreeToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.n = [':NvimTreeToggle', 'Toggle Nvim Tree']
  endif
endfunction
let s:nvim_tree.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:nvim_tree, "nvim_tree")
endif

if has('nvim')
  call s:addplugin('stevearc/oil.nvim', "oil", 0)
endif

let s:fern = {}
let s:fern.url = 'lambdalisue/fern.vim'
let s:fern.dependencies = ['lambdalisue/fern-hijack.vim', 'lambdalisue/nerdfont.vim', 'lambdalisue/fern-renderer-nerdfont.vim', 'lambdalisue/fern-mapping-mark-children.vim']
" lambdalisue/fern-git-status.vim
function! s:setup() dict
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
  if s:ispluginactive('which_key')
    let g:which_key_map.t.n = [':Fern .. -drawer -reveal=% -toggle -width=35', 'Toggle Fern']
  endif

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
endfunction
let s:fern.setup = funcref("s:setup")
call s:addplugin(s:fern, "fern", 0)


" File browser netrw helper
call s:addplugin('tpope/vim-vinegar', "vim_vinegar", 0)
" }}}
" }}}

" 2.5. Sessions
" ------------- {{{

" Session management made easy
let s:vim_obsession = {}
let s:vim_obsession.url = 'tpope/vim-obsession'
function! s:setup() dict
  " Ease the management of the sessions (Jay Sitter tips from dockyard.com)

  " Save session tracking with \ss
  " exec 'nnoremap <Leader>ss :mks! '.  g:sessions_dir . '\*.vim<C-D><BS><BS><BS><BS><BS>'
  " exec 'nnoremap <Leader>ss :Obsession ' . g:sessions_dir . '\*.vim<C-D><BS><BS><BS><BS><BS>'

  " Read session with \sr
  " exec 'nnoremap <Leader>sr :so '  g:sessions_dir. '\*.vim<C-D><BS><BS><BS><BS><BS>'

  if s:ispluginactive('which_key')
    let g:which_key_map.s = { 'name' : '+Session' }
  endif

  " Display the active session
  nnoremap <Leader>sn :echo v:this_session<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.s.n = [':echo v:this_session', 'Session Name']
  endif

  " Pause session update with \sp
  nnoremap <Leader>sp :Obsession<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.s.p = [':Obsession', 'Session Update']
  endif

  " To avoid to switch to insert mode when I'm too slow with \sr
  " nnoremap s <Nop>
endfunction
let s:vim_obsession.setup = funcref("s:setup")
call s:addplugin(s:vim_obsession, "vim_obsession", 0)

" Addition to Obsession
call s:addplugin('dhruvasagar/vim-prosession', "vim_prosession", 0)
" }}}

" 2.6. Bookmark
" ------------- {{{

" Bookmarks made easy
" - Add mark in the margin
" - Provide shortcut to add and remove marks
let s:vim_signature = {}
let s:vim_signature.url = 'kshenoy/vim-signature'
function! s:setup() dict
  nnoremap <leader>tm :SignatureToggleSigns <CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.m = [':SignatureToggleSigns', 'Toggle Marks']
  endif
  " More information with: :help signature.txt
endfunction
let s:vim_signature.setup = funcref("s:setup")
call s:addplugin(s:vim_signature, "vim_signature")

" Bookmarks made easy
let s:vim_bookmarks = {}
let s:vim_bookmarks.url = 'MattesGroeger/vim-bookmarks'
function! s:setup() dict
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
endfunction
let s:vim_bookmarks.setup = funcref("s:setup")
call s:addplugin(s:vim_bookmarks, "vim_bookmarks", 0)
" }}}

" 2.7. Undo Tree
" -------------- {{{

" Visualize and Navigate the undo tree:
let s:undotree = {}
let s:undotree.url = 'mbbill/undotree'
function! s:setup() dict
  let g:undotree_DiffAutoOpen = 0

  " Force the timestamps to be absolute instead of relative:
  " let g:undotree_RelativeTimestamp = 0

  let g:undotree_ShortIndicators = 1

  nnoremap <leader>tu :UndotreeToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.u = [':UndotreeToggle', 'Toggle Undo Tree']
  endif

  " More information with: :help undotree.txt
endfunction
let s:undotree.setup = funcref("s:setup")
call s:addplugin(s:undotree, "undotree")

" Visualize and Navigate the undo tree:
call s:addplugin('sjl/gundo.vim', "gundo", 0)

" Visualize and Navigate the undo tree:
call s:addplugin('simnalamburt/vim-mundo', "vim_mundo", 0)
" }}}

" 2.8. Difference
" --------------- {{{

" 2.8.1. Diff Char
" ---------------- {{{

" Diff at char level
let s:diffchar = {}
let s:diffchar.url = 'rickhowe/diffchar.vim'
function! s:setup() dict
  " let g:DiffUnit = ''
  let g:DiffColors = 'hl-DiffText'
  let g:DiffPairVisible = 1
endfunction
let s:diffchar.setup = funcref("s:setup")
call s:addplugin(s:diffchar, "diffchar", 0)
" }}}

" 2.8.2. Diff Command
" ------------------- {{{

" Introduces the DiffOrig command that compare the current file with the
" saved version
call s:addplugin('lifecrisis/vim-difforig', "difforig", 0)
" }}}

" 2.8.3. Spot Diff
" ---------------- {{{

" Introduces the Diffthis command that let you compare range of buffers
let s:spotdiff = {}
let s:spotdiff.url = 'rickhowe/spotdiff.vim'
function! s:setup() dict
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
endfunction
let s:spotdiff.setup = funcref("s:setup")
call s:addplugin(s:spotdiff, "spotdiff", 0)
" }}}
" }}}

" 2.9. Git
" -------- {{{

" 2.9.1. Git Operation
" -------------------- {{{

" Git integration
let s:vim_fugitive = {}
let s:vim_fugitive.url = 'tpope/vim-fugitive'
" function! s:setup() dict
"   " let g:fugitive_git_executable = fnamemodify('C:/Program Files/Git/bin/git.exe', ':8')
" endfunction
" let s:vim_fugitive.setup = funcref("s:setup")
call s:addplugin(s:vim_fugitive, "vim_fugitive")
" }}}

" 2.9.2. Git Signs
" ---------------- {{{

let s:vim_signify = {}
let s:vim_signify.url = 'mhinz/vim-signify'
function! s:setup() dict
  " Disable signify by default
  let g:signify_disable_by_default = 1

  nnoremap <leader>tf :SignifyToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.f = [':SignifyToggle', 'Toggle Git Signs']
  endif

  " More information with: :help signify.txt
endfunction
let s:vim_signify.setup = funcref("s:setup")
call s:addplugin(s:vim_signify, "vim_signify", 0)


" Remarks:
" - Only for Git
" - Only for Neovim
let s:gitsigns = {}
let s:gitsigns.url = 'lewis6991/gitsigns.nvim'
let s:gitsigns.dependencies = ['nvim-lua/plenary.nvim']
function! s:setup() dict
  lua require('config/gitsigns')
endfunction
let s:gitsigns.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:gitsigns, "gitsigns", 0)
endif


let s:vim_gitgutter = {}
let s:vim_gitgutter.url = 'airblade/vim-gitgutter'
function! s:setup() dict
  if has('win32')
    " let g:gitgutter_git_executable = 'C:/Progra~1/Git/bin/git.exe'
    let g:gitgutter_git_executable = fnamemodify('C:/Program Files/Git/bin/git.exe', ':8')
  endif
  let g:gitgutter_grep=''

  let g:gitgutter_map_keys = 1
  if s:ispluginactive('which_key')
    if g:gitgutter_map_keys
      let g:which_key_map.h = {'name' : '+Hunk'}
      let g:which_key_map.h.p = ['<Plug>(GitGutterPreviewHunk)', 'Hunk Preview']
      let g:which_key_map.h.s = ['<Plug>(GitGutterStageHunk)', 'Hunk Stage']
      let g:which_key_map.h.u = ['<Plug>(GitGutterUndoHunk)', 'Hunk Undo']
    endif
  endif
endfunction
let s:vim_gitgutter.setup = funcref("s:setup")
call s:addplugin(s:vim_gitgutter, "vim_gitgutter")

" }}}

" 2.9.3. Git Helper
" ----------------- {{{

call s:addplugin('itchyny/vim-gitbranch', "vim_gitbranch", 0)
" }}}
" }}}

" 2.10. Indentation
" ----------------- {{{

" 2.10.1. Indentation lines
" ------------------------- {{{

" Visualize indentation vertical lines
let s:indentline = {}
let s:indentline.url = 'Yggdroot/indentLine'
function! s:setup() dict
  " let g:indentLine_setColors = 0
  " let g:indentLine_bgcolor_gui = '#2e3440'

  " Indentline disabled by default
  let g:indentLine_enabled = 1
  let g:indentLine_char = '│'
  " set listchars+=lead:\

  nnoremap <leader>ti :IndentLinesToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.i = [':IndentLinesToggle', 'Toggle Indent Guide']
  endif

  " More information with: :help indent_guides.txt
endfunction
let s:indentline.setup = funcref("s:setup")
call s:addplugin(s:indentline, "indentline", 0)

let s:vim_indent_guides = {}
let s:vim_indent_guides.url = 'preservim/vim-indent-guides'
function! s:setup() dict
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_guide_size = 1

  nnoremap <leader>ti :IndentGuidesToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.i = [':IndentGuidesToggle', 'Toggle Indent Guide']
  endif
endfunction
let s:vim_indent_guides.setup = funcref("s:setup")
call s:addplugin(s:vim_indent_guides, "vim_indent_guides", 0)

" }}}

" 2.10.2. EditorConfig
" -------------------- {{{

" Let each project have its own setting regarding:
" - Indentation
" - Trailing Whitespaces
" - ...
if has('nvim') || v:version >= 901
let s:editorconfig = {}
let s:editorconfig.url = 'editorconfig'
let s:editorconfig.manager = "packadd"
function! s:setup() dict
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
endfunction
let s:editorconfig.setup = funcref("s:setup")
if !has('nvim')
  call s:addplugin(s:editorconfig, "editorconfig")
endif
endif
" }}}

" 2.10.3. Sleuth
" -------------- {{{

call s:addplugin('tpope/vim-sleuth', "vim_sleuth", 0)
" }}}
" }}}

" 2.11. Align
" ----------- {{{

" Alignment made easy
let s:vim_easy_align = {}
let s:vim_easy_align.url = 'junegunn/vim-easy-align'
function! s:setup() dict
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)

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
  command! AlignFormat call AlignFormat()

  command! AlignSetup %EasyAlign /"[^"]*"/dll10

  " More information with: :help easy-align.txt
endfunction
let s:vim_easy_align.setup = funcref("s:setup")
call s:addplugin(s:vim_easy_align, "vim_easy_align")

" Alignment made easy
call s:addplugin('godlygeek/tabular', "tabular", 0)
" }}}

" 2.12. Folding
" ------------- {{{

" 2.12.1. Fold Creation
" --------------------- {{{

" Fold based on indentation
let s:any_fold = {}
let s:any_fold.url = 'pseewald/vim-anyfold'
function! s:setup() dict
  augroup anyfold
    autocmd!
    " Activate for all filetypes
    " autocmd Filetype * AnyFoldActivate

    " Activate for python
    " Should take into account &diff option?
    autocmd Filetype python AnyFoldActivate
    " Open the fold that correspond to Python classes:
    " autocmd FileType python g/^class\s\+/norm zo

    " Activate for tsn
    " Should take into account &diff option?
    " autocmd Filetype tsn AnyFoldActivate
    autocmd Filetype tsn if (getfsize(expand("<afile>")) < 0.1 * 1024 * 1024) | execute "AnyFoldActivate" | endif

    " Activate for json
    " Should take into account &diff option?
    " autocmd Filetype json AnyFoldActivate
    autocmd Filetype json if (getfsize(expand("<afile>")) < 0.1 * 1024 * 1024) | execute "AnyFoldActivate" | endif
  augroup END

  " Disable anyfold movement (e.g. ]])
  let g:anyfold_motion = 0

  " More information with: :help anyfold.txt
endfunction
let s:any_fold.setup = funcref("s:setup")
call s:addplugin(s:any_fold, "any_fold")

" Python code folding
" Remarks:
"   any_fold seems to give better results
call s:addplugin('tmhedberg/SimpylFold', "simpylfold", 0)
" }}}

" 2.12.2. Fold Handling
" --------------------- {{{

" Folding level control using [ret] and [bs]
call s:addplugin('arecarn/vim-fold-cycle', "cycle_fold", 0)

" Limit fold computation and update to improve speed
let s:fast_fold = {}
let s:fast_fold.url = 'Konfekt/FastFold'
function! s:setup() dict
  nmap zuz <Plug>(FastFoldUpdate)
  let g:fastfold_savehook = 1
  let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
  let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
endfunction
let s:fast_fold.setup = funcref("s:setup")
call s:addplugin(s:fast_fold, "fast_fold", 0)
" }}}
" }}}

" 2.13. Commenting
" ---------------- {{{

let s:vim_commentary = {}
let s:vim_commentary.url = 'tpope/vim-commentary'
function! s:setup() dict
  if s:ispluginactive('which_key')
    let g:which_key_map_g.c = ["", 'which_key_ignore']
    let g:which_key_map_g.cc = ["<Plug>CommentaryLine", 'Comment']
  endif
endfunction
let s:vim_commentary.setup = funcref("s:setup")
call s:addplugin(s:vim_commentary, "vim_commentary")

let s:nerdcommenter = {}
let s:nerdcommenter.url = 'preservim/nerdcommenter'
function! s:setup() dict
  " Don't create default mappings
  let g:NERDCreateDefaultMappings = 0
endfunction
let s:nerdcommenter.setup = funcref("s:setup")
call s:addplugin(s:nerdcommenter, "nerdcommenter", 0)
" }}}

" 2.14. Parenthesis
" ----------------- {{{

" 2.14.1. Surround
" ---------------- {{{

" Add additional commands to manage pairs
call s:addplugin('tpope/vim-surround', "vim_surround")

call s:addplugin('machakann/vim-sandwich', "vim_sandwich", 0)
" }}}

" 2.14.2. Auto-Pair
" ----------------- {{{

" Automatically introduce the pairing character
" (e.g. ", ', (, [, etc. )

" Remark:
" - Seems to support the dot command
call s:addplugin('jiangmiao/auto-pairs', "auto_pairs", 0)

" Remark:
" - Claim to support the dot command
call s:addplugin('cohama/lexima.vim', "lexima", 0)

call s:addplugin('tpenguinltg/vim-closing-brackets', "vim_closing_brackets", 0)

" Remark:
" - Seems not to support the dot command
call s:addplugin('vim-scripts/auto-pairs-gentle', "auto_pairs_gentle", 0)
" }}}
" }}}

" 2.15. Snippet
" ------------- {{{

" Remark: for coc user a coc-snippets is available suggesting snippets
" - :CocInstall coc-snippets

" UltiSnips
" --------- {{{

let s:ultisnips = {}
let s:ultisnips.url = 'SirVer/ultisnips'
let s:ultisnips.options = {}
function! s:setup() dict
  " Trigger configuration.
  " Do not use <tab> if you use:
  " - https://github.com/Valloric/YouCompleteMe.
  " - https://github.com/neoclide/coc.nvim

  " This mapping conflict with Coc mapping for completion
  " let g:UltiSnipsExpandTrigger = "<tab>"
  let g:UltiSnipsExpandTrigger = "<C-s>"
  if s:ispluginactive('emmet_vim')
    let g:UltiSnipsExpandTrigger='<C-F12>'
    let g:user_emmet_leader_key='<C-S-F12>'
  endif

  " Default is <C-j>
  " let g:UltiSnipsJumpForwardTrigger = "<C-b>"
  " Default is <C-k>
  " let g:UltiSnipsJumpBackwardTrigger = "<C-z>"

  " If you want :UltiSnipsEdit to split your window.
  " let g:UltiSnipsEditSplit="vertical"

  " let g:UltiSnipsRemoveSelectModeMappings = 0

  " More information with: :help UltiSnips.txt
endfunction
let s:ultisnips.setup = funcref("s:setup")
if has('python3')
  call s:addplugin(s:ultisnips, "ultisnips")
endif
" }}}

" Emmet
" ----- {{{
let s:emmet_vim = {}
let s:emmet_vim.url = 'mattn/emmet-vim'
function! s:setup() dict
  let g:user_emmet_leader_key='<C-s>'
  let g:user_emmet_expandabbr_key='<C-s>,'
  if s:ispluginactive('ultisnips')
    let g:UltiSnipsExpandTrigger='<C-F12>'
    let g:user_emmet_leader_key='<C-S-F12>'
  endif

  " More information with: :help emmet.txt
endfunction
let s:emmet_vim.setup = funcref("s:setup")
call s:addplugin(s:emmet_vim, "emmet_vim", 0)
" }}}
" }}}

" 2.16. Tags
" ---------- {{{

" 2.16.1. Tag Generation
" ---------------------- {{{

" Automatic tag generation
let s:vim_gutentags = {}
let s:vim_gutentags.url = 'ludovicchabant/vim-gutentags'
function! s:setup() dict
  " Make the gutentags project root as the first parent folder containing:
  " - .gitignore file
  " - .vimspector.json file
  let g:gutentags_project_root = [".vimspector.json", ".gitignore"]
  let g:gutentags_ctags_exclude = [".mypy_cache"]
  " let g:gutentags_ctags_exclude = [".mypy_cache", "*.json"]
endfunction
let s:vim_gutentags.setup = funcref("s:setup")
call s:addplugin(s:vim_gutentags, "vim_gutentags")
" }}}

" 2.16.2. Tag Browsing
" -------------------- {{{

" TagBar
" ------ {{{
" Remarks:
" - Telescope requires traditional tags
let s:tagbar = {}
let s:tagbar.url = 'preservim/tagbar'
function! s:setup() dict
  let g:tagbar_iconchars = ['●', '▼']
  " let g:tagbar_ctags_bin = "C:\\Softs\\ctags.exe"

  autocmd ColorScheme nord hi TagbarVisibilityPublic guifg=#7b8b93 ctermfg=Grey
  autocmd ColorScheme nord hi TagbarVisibilityProtected guifg=#7b8b93 ctermfg=Grey
  autocmd ColorScheme nord hi TagbarVisibilityPrivate guifg=#7b8b93 ctermfg=Grey

  autocmd ColorScheme gruvbox hi TagbarVisibilityPublic guifg=#B8BB26 ctermfg=Grey
  autocmd ColorScheme gruvbox hi TagbarVisibilityProtected guifg=#B8BB26 ctermfg=Grey
  autocmd ColorScheme gruvbox hi TagbarVisibilityPrivate guifg=#B8BB26 ctermfg=Grey

  " hi TagbarScope guifg=#7b8b93 ctermfg=Grey

  " nnoremap <F8> :TagbarToggle<CR>
  nnoremap <leader>tg :TagbarOpen fj<CR>
  nnoremap <leader>tt :TagbarToggle <CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.g = [':TagbarOpen fj', 'Tag Go']
    let g:which_key_map.t.t = [':TagbarToggle', 'Toggle Tags']
  endif

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
  if s:ispluginactive('vimwiki')
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
endfunction
let s:tagbar.setup = funcref("s:setup")
call s:addplugin(s:tagbar, "tagbar")
" }}}

" Vista
" ----- {{{
let s:vista_vim = {}
let s:vista_vim.url = 'liuchengxu/vista.vim'
let s:vista_vim.options = {}
function! s:setup() dict
  nnoremap <leader>tt :Vista!!<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.t = [':Vista!!', 'Toggle Tags']
  endif

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

  if s:ispluginactive('coc_nvim')
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
endfunction
let s:vista_vim.setup = funcref("s:setup")
call s:addplugin(s:vista_vim, "vista_vim", 0)
" }}}

" Taglist
" ------- {{{
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
  nnoremap <leader>tt :TlistToggle<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.t = [':TlistToggle', 'Toggle Tags']
  endif
endif
" }}}
" }}}
" }}}

" 2.17. Code Completion
" --------------------- {{{

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
"     Depes on (optionally if jedi-language-server is not available the
"     installation should be triggered):
"     - pip install jedi-language-server
" - Depends on pip install jedi-language-server

if has('nvim') || v:version >= 900 && has('patch-9.0.438')
let coc_nvim = {}
let coc_nvim.url = 'neoclide/coc.nvim'
let coc_nvim.options = {'branch': 'release'}
function! s:setup() dict
  if !has('nvim')
    let $XDG_CONFIG_HOME=$HOME . '\vimfiles'
    let $XDG_DATA_HOME=$HOME . '\vimfiles'
    let $XDG_STATE_HOME=$HOME . '\vimfiles'
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
  if s:ispluginactive('which_key')
    let g:which_key_map_g.d = ["\<Plug>(coc-definition)", 'Go To Definition']
  endif

  function! DelayedGotoDef(timer)
    if g:start_curpos == getcurpos()
      execute "normal! [\<C-i>"
    endif
  endfunction
  " nmap <silent><expr> gd GoToDef()

  function! GoToDef()
    let g:start_curpos = getcurpos()
    call timer_start(200, 'DelayedGotoDef', {'repeat' : 1})
    return "\<Plug>(coc-definition)"
  endfunction

  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  if s:ispluginactive('which_key')
    let g:which_key_map_g.y = ["\<Plug>(coc-type-definition)", 'Go To Definition']
    let g:which_key_map_g.i = ["\<Plug>(coc-implementation)", 'Go To Implementation']
    let g:which_key_map_g.r = ["\<Plug>(coc-references)", 'Go To Reference']
  endif

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
  if s:ispluginactive('which_key')
    " let g:which_key_map.r = 'which_key_ignore'
    let g:which_key_map.r = ['', 'which_key_ignore']
    let g:which_key_map.rn = ['<Plug>(coc-rename)', 'Coc Rename']
  endif

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  " nmap <leader>f  <Plug>(coc-format-selected)
  if s:ispluginactive('which_key')
    " let g:which_key_map.f = 'which_key_ignore'
    let g:which_key_map.f = ['', 'which_key_ignore']
    let g:which_key_map.fs = ['<Plug>(coc-format-selected)', 'Coc Format Selection']
  endif

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
  " nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  " Remark: in conflict with ferret search
  nmap <leader>ac  <Plug>(coc-codeaction)
  if s:ispluginactive('which_key')
    let g:which_key_map.a = ['', 'which_key_ignore']
    let g:which_key_map.ac = ['<Plug>(coc-codeaction)', 'Coc Code Action']
  endif

  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)
  if s:ispluginactive('which_key')
    let g:which_key_map.q = ['', 'which_key_ignore']
    let g:which_key_map.qf = ['<Plug>(coc-fix-current)', 'Coc Quick Fix']
  endif

  " Run the Code Lens action on the current line.
  nmap <leader>cl  <Plug>(coc-codelens-action)
  if s:ispluginactive('which_key')
    let g:which_key_map.c = ['', 'which_key_ignore']
    let g:which_key_map.cl = ['<Plug>(coc-codelens-action)', 'Coc Code Lens']
  endif

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  " xmap if <Plug>(coc-funcobj-i)
  " omap if <Plug>(coc-funcobj-i)
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
  command! -nargs=0 Format call CocActionAsync('format')
  " command! -nargs=0 Format call CocActionAsync('format') | CocCommand python.sortImports

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR call     CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Specifc Settings:
  function! CocToggle()
    if g:coc_enabled
      CocDisable
    else
      CocEnable
    endif
  endfunction
  command! CocToggle call CocToggle()

  " nnoremap <leader>tj <cmd>CocToggle<CR>
  nnoremap <leader>tj <cmd>CocCommand document.toggleInlayHint<CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.j = [':CocCommand document.toggleInlayHint', 'Toggle Inlay Hints']
  endif

  " For performance reason disable coc on non code files
  " autocmd BufNew,BufEnter *.json,*.py,*.pyw,*.vim,*.lua execute "silent! CocEnable"
  " autocmd BufLeave *.json,*.py,*.pyw,*.vim,*.lua execute "silent! CocDisable"

  " Control the way the current symbol is highlighted
  hi CocHighlightText guifg=#d8dee9 guibg=#516f7a

  " Set the color of unused variable the same color as the color of the
  " comments
  hi def link CocFadeOut Comment

  " More information with: :help coc-nvim
endfunction
let coc_nvim.setup = funcref("s:setup")
call s:addplugin(coc_nvim, "coc_nvim", 1)
endif

" Remark: Install additional lsp modules with:
" - MasonInstall pyright

let s:mason = {}
let s:mason.url = 'williamboman/mason.nvim'
let s:mason.options = { 'do': ':MasonUpdate' }
let s:mason.dependencies = [
      \ 'williamboman/mason-lspconfig.nvim',
      \ 'neovim/nvim-lspconfig',
      \ 'jose-elias-alvarez/null-ls.nvim',
      \ ]
function! s:setup() dict
  lua require("mason").setup()
  lua require("mason-lspconfig").setup()

  " local configuration:
  lua require("config.mason")
  lua require("handlers").setup()

  nnoremap <leader>tj <cmd>:lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.j = [':lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())', 'Toggle Inlay Hints']
  endif
endfunction
let s:mason.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:mason, "mason", 1)
endif

let s:null_ls = {}
let s:null_ls.url = 'jose-elias-alvarez/null-ls.nvim'
function! s:setup() dict
  lua require("null-ls")

  " local configuration:
  lua require("config.null-ls")
endfunction
let s:null_ls.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:null_ls, "null_ls", 0)
endif

let s:nvim_cmp = {}
let s:nvim_cmp.url = 'hrsh7th/nvim-cmp'
let s:nvim_cmp.dependencies = [
      \ 'hrsh7th/cmp-nvim-lsp',
      \ 'hrsh7th/cmp-buffer',
      \ 'hrsh7th/cmp-path',
      \ 'hrsh7th/cmp-cmdline',
      \ ]
function! s:setup() dict
  " local configuration:
  lua require("config.cmp")
endfunction
let s:nvim_cmp.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:nvim_cmp, "nvim_cmp")
endif

let s:blink_cmp = {}
let s:blink_cmp.url = 'Saghen/blink.cmp'
" let s:blink_cmp.dependencies = [
"       \ 'rafamadriz/friendly-snippets',
"       \ ]
function! s:setup() dict
  " local configuration:
lua << EOF
  require("blink.cmp").setup({
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'enter' },

      appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = true,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
  })
EOF
endfunction
let s:blink_cmp.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:blink_cmp, "blink_cmp", 0)
endif


let s:r_nvim = {}
let s:r_nvim.url = 'R-nvim/R.nvim'
let s:r_nvim.dependencies = ['R-nvim/cmp-r']
function! s:setup() dict
  lua require("cmp").setup({ sources = {{ name = "cmp_r" }} })
  lua require("cmp_r").setup()
endfunction
let s:r_nvim.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:r_nvim, "r_nvim", 0)
endif


" Code completion
" Remark:
" - To complete the installation make sure you have:
"   - CMake
"   - Visual Studio 2019 or superior
"   - The Python that match Vim (e.g.: Python 3.10 for Vim 9.0)
"   - Go
" - Run: install.py
call s:addplugin('ycm-core/YouCompleteMe', "you_complete_me", 0)

" Multiple Languages Support:
let s:vim_polyglot = {}
let s:vim_polyglot.url = 'sheerun/vim-polyglot'
function! s:setup() dict
  " let g:polyglot_disabled = ['ftdetect']
  " let g:polyglot_disabled = ['html5']
  function! RestoreIndent()
    setlocal indentexpr=HtmlIndent() nocindent nosmartindent autoindent
    let b:did_indent = 0
    let g:force_reload_html = 1
    execute 'source $VIMRUNTIME' . '/indent/html.vim'
  endfunction

  augroup HtmlIndent
    autocmd!
    autocmd FileType html call RestoreIndent()
  augroup END
endfunction
let s:vim_polyglot.setup = funcref("s:setup")
call s:addplugin(s:vim_polyglot, "vim_polyglot", 0)

" Code Completion
" Remark:
" - Install the corresponding plugin for each language you want to support:
"   - deoplete-jedi
"   - deoplete-rust
let s:deoplete = {}
let s:deoplete.url = 'Shougo/deoplete.nvim'
if has('nvim')
  let s:deoplete.options = { 'do': ':UpdateRemotePlugins' }
endif
let s:deoplete.dependencies = ['deoplete-plugins/deoplete-jedi']
if !has('nvim')
  let s:deoplete.dependencies += [{'url': 'roxma/nvim-yarp', 'options': { 'do': 'pip install -r requirements.txt' }}, 'roxma/vim-hug-neovim-rpc']
endif
function! s:setup() dict
  let g:deoplete#enable_at_startup = 1
endfunction
let s:deoplete.setup = funcref("s:setup")
call s:addplugin(s:deoplete, "deoplete", 0)

" Python code completion
let s:jedi_vim = {}
let s:jedi_vim.url = 'davidhalter/jedi-vim'
let s:jedi_vim.options = {}
function! s:setup() dict
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
endfunction
let s:jedi_vim.setup = funcref("s:setup")
call s:addplugin(s:jedi_vim, "jedi_vim", 0)


" Semantic highlighting
let s:semshi = {}
let s:semshi.url = 'numirias/semshi'
let s:semshi.dependencies = ['nvim-treesitter/nvim-treesitter']
let s:semshi.options = { 'do': ':UpdateRemotePlugins' }
if has('nvim')
  call s:addplugin(s:semshi, "semshi", 0)
endif


" Semantic highlighting
let s:hlargs = {}
let s:hlargs.url = 'm-demare/hlargs.nvim'
let s:hlargs.dependencies = ['nvim-treesitter/nvim-treesitter']
function! s:setup() dict
  lua require('hlargs').setup()
endfunction
let s:hlargs.setup = funcref("s:setup")
call s:addplugin(s:hlargs, "hlargs", 0)

" }}}

" 2.18. Code Formatting
" --------------------- {{{

" 2.18.1. ISort
" ------------- {{{

" Sort Python imports
let s:vim_isort = {}
let s:vim_isort.url = 'fisadev/vim-isort'
function! s:setup() dict
  " let g:vim_isort_map = '<C-i>'
  " Depends on:
  " - pip install isort
  " Where pip is the version associated to Vim
  " To know which version of Python is associated with Vim execute:
  " :py3 print(sys.version)
  let g:vim_isort_map = ''
  let g:vim_isort_python_version = 'python3'
endfunction
let s:vim_isort.setup = funcref("s:setup")
if has('python3')
  call s:addplugin(s:vim_isort, "vim_isort")
endif
" }}}

" 2.18.2. Prettier
" ---------------- {{{

" Format Web files (.html, .css, .ts, ...)
let s:vim_prettier = {}
let s:vim_prettier.url = 'prettier/vim-prettier'
let s:vim_prettier.options = {
      \   'do': 'yarn add --dev --exact prettier',
      \   'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json',
      \     'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html', 'sql'
      \   ]
      \ }
function! s:setup() dict
  " Change the mapping to run from the default of <Leader>p
  nmap <Leader>fp <Plug>(Prettier)
  if s:ispluginactive('which_key')
    let g:which_key_map.f.p = ['<Plug>(Prettier)', 'Format Selection using Prettier']
  endif
  " Enable auto formatting of files that have "@format" or "@prettier" tag
  let g:prettier#autoformat = 1

  " Toggle the g:prettier#autoformat setting based on whether a config file can
  " be found in the current directory or any parent directory. Note that this
  " will override the g:prettier#autoformat setting!
  " let g:prettier#autoformat_config_present = 1
endfunction
let s:vim_prettier.setup = funcref("s:setup")
call s:addplugin(s:vim_prettier, "vim_prettier", 0)


" Support for javascript react files
call s:addplugin('MaxMEllon/vim-jsx-pretty', "vim_jsx_pretty", 0)


let s:neoformat = {}
let s:neoformat.url = 'sbdchd/neoformat'
let s:neoformat.options = {}
function! s:setup() dict
  let g:neoformat_enabled_cs = ['csharpier']
endfunction
let s:neoformat.setup = funcref("s:setup")
call s:addplugin(s:neoformat, "neoformat", 0)
" }}}
" }}}

" 2.19. Linting
" ------------- {{{

" 2.19.1. Linting Engine
" ---------------------- {{{

" Ale
" --- {{{
let s:ale = {}
let s:ale.url = 'dense-analysis/ale'
function! s:setup() dict
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
        \  ],
        \ 'html' : [
        \       'djlint',
        \  ]
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
  let g:ale_exclude_highlights =['E501: line too long.*', 'line too long.*']

  " let g:ale_fix_on_save = 1
  nnoremap <leader>ta :ALEToggle <CR>
  if s:ispluginactive('which_key')
    let g:which_key_map.t.a = [':ALEToggle', 'Toggle ALE']
  endif
endfunction
let s:ale.setup = funcref('s:setup')
call s:addplugin(s:ale, 'ale', 0)
" }}}

" LightBulb
" --------- {{{

let s:lightbulb = {}
let s:lightbulb.url = 'kosayoda/nvim-lightbulb'
let s:lightbulb.depencies = ['antoinemadec/FixCursorHold.nvim']
function! s:setup() dict
  lua require('config/lightbulb')
  autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
endfunction
let s:lightbulb.setup = funcref("s:setup")
call s:addplugin(s:lightbulb, "lightbulb", 0)
" }}}

" Treesitter
" ---------- {{{

let s:treesitter = {}
let s:treesitter.url = 'nvim-treesitter/nvim-treesitter'
let s:treesitter.options = {'do': ':TSUpdate'}
function! s:setup() dict
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

      indent = {enable = true},

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
endfunction
let s:treesitter.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:treesitter, "treesitter")
  " Remark:
  " A TSUpdateSync call maybe necessary to update your language parser
  " A TSUpdate call maybe necessary to update your language parser
endif
" }}}
" }}}

" 2.19.2. Linting Mark
" -------------------- {{{

let s:vim_syntastic = {}
let s:vim_syntastic.url = 'vim-syntastic/syntastic'
function! s:setup() dict
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
endfunction
let s:vim_syntastic.setup = funcref("s:setup")
call s:addplugin(s:vim_syntastic, "vim_syntastic", 0)
" }}}
" }}}

" 2.20. Testing
" ------------- {{{

let s:vader = {}
let s:vader.url = 'junegunn/vader.vim'
call s:addplugin(s:vader, "vader")
" }}}

" 2.21. Asynchronous Run
" ---------------------- {{{

call s:addplugin('skywind3000/asyncrun.vim', "asyncrun", 0)

call s:addplugin('tpope/vim-dispatch', "vim_dispatch", 0)
" }}}

" 2.22. QuickFix filtering
" ------------------------ {{{

let s:cfilter = {}
let s:cfilter.url = 'cfilter'
let s:cfilter.manager = 'packadd'
call s:addplugin(s:cfilter, "cfilter", 0)


call s:addplugin('jceb/vim-editqf', "vim_editqf", 0)
" }}}

" 2.23. Terminal
" -------------- {{{

let s:vim_floaterm = {}
let s:vim_floaterm.url = 'voldikss/vim-floaterm'
function! s:setup() dict
  " let g:floaterm_keymap_toggle = '<M-F5>'
  " It seems impossible to map <C-ù>
  " It is most probably a dead key in Belgium keyboard
  let g:floaterm_keymap_toggle = '<M-ù>'
endfunction
let s:vim_floaterm.setup = funcref("s:setup")
call s:addplugin(s:vim_floaterm, "vim_floaterm", 0)


" vim-clap support for floaterm
call s:addplugin('voldikss/clap-floaterm', "clap_floaterm", 0)


let s:toggleterm = {}
let s:toggleterm.url = 'akinsho/toggleterm.nvim'
let s:toggleterm.options = {'tag' : '*'}
function! s:setup() dict
  lua require("toggleterm").setup()
endfunction
let s:toggleterm.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:toggleterm, "toggleterm")
endif

" Provide control on the terminal cursor shape:
" Remark: Doesn't seems to have any effect on Windows
let s:terminus = {}
let s:terminus.url = 'wincent/terminus'
function! s:setup() dict
  let g:TerminusInsertCursorShape = 1
endfunction
let s:terminus.setup = funcref("s:setup")
call s:addplugin(s:terminus, "terminus", 0)


let s:jupyter_vim = {}
let s:jupyter_vim.url = 'jupyter-vim/jupyter-vim'
let s:jupyter_vim.options = {}
function! s:setup() dict
  let g:jupyter_mapkeys = 0

  function! SetJupyterMapping()
    nnoremap <buffer> <silent> <localleader>jc <cmd>JupyterConnect<CR>
    nnoremap <buffer> <silent> <localleader>jd <cmd>JupyterDisconnect<CR>
    nnoremap <buffer> <silent> <localleader>jr <cmd>JupyterRunFile<CR>
    nnoremap <buffer> <silent> <localleader>je <cmd>JupyterSendCell<CR>
    vnoremap <buffer> <silent> <localleader>je :JupyterSendRange<CR>
  endfunction

  if s:ispluginactive('which_key')
    let g:which_key_map.j = {'name' : '+Jupyter'}
    let g:which_key_map.j.c = [':JupyterConnect', 'Connect']
    let g:which_key_map.j.d = [':JupyterDisconnect', 'Disconnect']
    let g:which_key_map.j.r = [':JupyterRunFile', 'Run File']
    let g:which_key_map.j.e = [':JupyterSendCell', 'Send Cell']
  endif

  autocmd FileType python call SetJupyterMapping()

  command! JupyterConsole !start pyw C:\Softs\run_qtconsole.py
endfunction
let s:jupyter_vim.setup = funcref("s:setup")
call s:addplugin(s:jupyter_vim, "jupyter_vim")


let s:magma = {}
let s:magma.url = 'dccsillag/magma-nvim'
let s:magma.options = { 'do': ':UpdateRemotePlugins' }
function! s:setup() dict
  function! MagmaInitPython()
    MagmaInit python3
    MagmaEvaluateArgument 5
  endfunction

  function! SetJupyterMapping()
    nnoremap <buffer> <silent> <localleader>jc <cmd>call MagmaInitPython()<CR>
    nnoremap <buffer> <silent> <localleader>jd <cmd>MagmaDeinit<CR>
    " nnoremap <buffer> <silent> <localleader>jr <cmd>JupyterRunFile<CR>
    " nnoremap <buffer> <silent> <localleader>je <cmd>JupyterSendCell<CR>
    vnoremap <buffer> <silent> <localleader>je :MagmaEvaluateVisual<CR>
  endfunction

  autocmd FileType python call SetJupyterMapping()
endfunction
let s:magma.setup = funcref("s:setup")
call s:addplugin(s:magma, "magma", 0)


" Terminal support
let s:neoterm = {}
let s:neoterm.url = 'kassio/neoterm'
function! s:setup() dict
    nnoremap <C-q> :Ttoggle<CR>
    inoremap <C-q> <Esc>:Ttoggle<CR>
  if has('nvim') || v:version >= 801
    tnoremap <C-q>  <C-\><C-n>:Ttoggle<CR>
  endif
endfunction
let s:neoterm.setup = funcref("s:setup")
call s:addplugin(s:neoterm, "neoterm", 0)
" }}}

" 2.24. Debugging
" --------------- {{{

let s:vimspector = {}
let s:vimspector.url = 'puremourning/vimspector'
function! s:setup() dict
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

  nnoremap <leader>vr <Cmd>VimspectorReset<CR>
  nnoremap <leader>va <Cmd>call vimspector#ReadSessionFile(expand("%:h") . "/debuggingsession.json")<CR>
  nnoremap <leader>vz <Cmd>call vimspector#WriteSessionFile(expand("%:h") . "/debuggingsession.json")<CR>

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

  if s:ispluginactive('which_key')
    let g:which_key_map.v = { 'name' : '+VimSpector' }
    let g:which_key_map.v.r = [':VimspectorReset', 'Reset']
    let g:which_key_map.v.a = ['call vimspector#ReadSessionFile(expand("%:h") . "/debuggingsession.json")', 'Load Session']
    let g:which_key_map.v.z = [':call vimspector#WriteSessionFile(expand("%:h") . "/debuggingsession.json")', 'Save Session']
    let g:which_key_map.v.c = [':call win_gotoid(g:vimspector_session_windows.code)', 'Code']
    let g:which_key_map.v.w = [':call win_gotoid(g:vimspector_session_windows.watches)', 'Watches']
    let g:which_key_map.v.v = [':call win_gotoid(g:vimspector_session_windows.variables)', 'Variables']
    let g:which_key_map.v.s = [':call win_gotoid(g:vimspector_session_windows.stack_trace)', 'Stack']
    let g:which_key_map.v.d = [':call vimspector#DownFrame', 'Frame Down']
    let g:which_key_map.v.u = [':call vimspector#UpFrame', 'Frame Up']
    let g:which_key_map.v.b = ['<Plug>VimspectorBalloonEval', 'Show Baloon']
  endif

  " Add the VimspectorConfig command
  command! VimspectorConfig call VimspectorConfig()
endfunction
let s:vimspector.setup = funcref("s:setup")
if has('python3')
  call s:addplugin(s:vimspector, "vimspector", 1)
endif

let s:nvim_dap = {}
let s:nvim_dap.url = 'mfussenegger/nvim-dap'
let s:nvim_dap.dependencies = ['nvim-neotest/nvim-nio', 'rcarriga/nvim-dap-ui', 'mfussenegger/nvim-dap-python']
function! s:setup() dict
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
endfunction
let s:nvim_dap.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:nvim_dap, "nvim_dap")
endif
" }}}

" 2.25. File Types
" ---------------- {{{

" 2.25.1. VimScript
" ----------------- {{{

" Helper to analyze vim scripts
let s:vim_scriptease = {}
let s:vim_scriptease.url = 'tpope/vim-scriptease'
function! s:setup() dict
  " Avoid scriptease removes the ':' for the iskeyword such that ctags works
  " correctly
  let g:scriptease_iskeyword = 0
endfunction
let s:vim_scriptease.setup = funcref("s:setup")
call s:addplugin(s:vim_scriptease, "vim_scriptease")


" Helper to debug vim scripts
let s:lh_vim_lib = {}
let s:lh_vim_lib.url = 'LucHermitte/lh-vim-lib'
function! s:setup() dict
  " Parameter: number of errors to decode, default: "1"
  command! -nargs=? WTF call lh#exception#say_what(<f-args>)
  " command! WTF call lh#exception#say_what()
endfunction
let s:lh_vim_lib.setup = funcref("s:setup")
call s:addplugin(s:lh_vim_lib, "lh_vim_lib", 0)

" Helper to analyze syntax
" Remark:
" - scriptease comes with the zS action
let s:vim_synstax = {}
let s:vim_synstax.url = 'benknoble/vim-synstax'
function! s:setup() dict
  command! Synstax echo synstax#UnderCursor()
endfunction
let s:vim_synstax.setup = funcref("s:setup")
call s:addplugin(s:vim_synstax, "vim_synstax")
" }}}

" 2.25.2. Markdown
" ---------------- {{{

" VimWiki
" ------- {{{

" Remark:
" - On some files it prevent to insert a carriage return
let s:vimwiki = {}
let s:vimwiki.url = 'vimwiki/vimwiki'
let s:vimwiki.options = {}
function! s:setup() dict
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

  " let g:vimwiki_list = [{'path': '~/vimwiki'}]
  " let g:vimwiki_ext2syntax = {
  " \   '.md': 'markdown',
  " \   '.mkd': 'markdown',
  " \   '.wiki': 'media'
  " \ }

  " Disable links key mapping to avoid overriding Ctrl-i and Ctrl-o
  " let g:vimwiki_key_mappings = { 'all_maps': 0, }
  let g:vimwiki_key_mappings =
        \ {
        \   'global': 0,
        \   'headers': 0,
        \   'text_objs': 0,
        \   'table_format': 0,
        \   'table_mappings': 0,
        \   'lists': 0,
        \   'links': 0,
        \   'html': 0,
        \   'mouse': 0,
        \ }

  " Make that only .wiki files are considered as vimwiki documents
  let g:vimwiki_global_ext = 0
  if s:ispluginactive('which_key')
    if g:vimwiki_global_ext
      let g:which_key_map.w = { 'name' : '+VimWiki' }
      let g:which_key_map.w.i = ['<Plug>VimwikiDiaryIndex', 'Diary Index']
      let g:which_key_map.w.s = ['<Plug>VimwikiUISelect', 'UI Select']
      let g:which_key_map.w.t = ['<Plug>VimwikiTabIndex', 'Tab Index']
      let g:which_key_map.w.w = ['<Plug>VimwikiIndex', 'Index']
      let g:which_key_map.w[" "] = { "name" : "Note" }
      let g:which_key_map.w[" "].i = ['<Plug>VimwikiDiaryGenerateLinks', 'Generate Links']
      let g:which_key_map.w[" "].m = ['<Plug>VimwikiMakeTomorrowDiaryNote', 'Tomorrow Diary Note']
      let g:which_key_map.w[" "].t = ['<Plug>VimwikiTabMakeDiaryNote', 'Tab Diary Note']
      let g:which_key_map.w[" "].w = ['<Plug>VimwikiMakeDiaryNote', 'Dairy Note']
      let g:which_key_map.w[" "].y = ['VimwikiMakeYesterdayDiaryNote', 'Yesterday Diary Note']
    endif
  endif
endfunction
let s:vimwiki.setup = funcref("s:setup")
call s:addplugin(s:vimwiki, "vimwiki")

let s:neorg = {}
let s:neorg.url = 'nvim-neorg/neorg'
let s:neorg.dependencies = ['nvim-treesitter/nvim-treesitter']
function! s:setup() dict
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
              --   config = {
                  --     default_keybinds = true,
                  --   }
              -- }
      }
  }
EOF
endfunction
let s:neorg.setup = funcref("s:setup")
if has('nvim')
  call s:addplugin(s:neorg, "neorg", 0)
endif

" Markdown extra support
" Remark:
" - Doesn't seems compatible with vimwiki
let s:vim_markdown = {}
let s:vim_markdown.url = 'preservim/vim-markdown'
function! s:setup() dict
  " It seems that lua is not correctly supported:
  " let g:markdown_fenced_languages = ['html', 'python', 'vim', 'lua']
  let g:markdown_fenced_languages = ['html', 'python', 'vim']
endfunction
let s:vim_markdown.setup = funcref("s:setup")
call s:addplugin(s:vim_markdown, "vim_markdown")
" }}}

" Markdown Preview
" ---------------- {{{

let s:markdown_preview = {}
let s:markdown_preview.url = 'iamcco/markdown-preview.nvim'
let s:markdown_preview.options = { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
if !has('nvim')
  " Remark: It seems that markdown_preview works on vim only until commit: 'e5bfe9b'
  let s:markdown_preview.options.commit = 'e5bfe9b'
else
endif
function! s:setup() dict
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
  let g:mkdp_markdown_css = GetVimDataFolder() . 'markdownpreview/markdown.css'

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
endfunction
let s:markdown_preview.setup = funcref("s:setup")
call s:addplugin(s:markdown_preview, "markdown_preview")
" }}}

" Grammalecte
" ----------- {{{

" Remark: currently not used

let s:grammalecte = {}
let s:grammalecte.url = 'dpelle/vim-Grammalecte'
function! s:setup() dict
  let g:grammalecte_python = "py.exe"
  let g:grammalecte_cli_py = "C:\\Python36_x64\\Scripts\\grammalecte-cli.py"
endfunction
let s:grammalecte.setup = funcref("s:setup")
call s:addplugin(s:grammalecte, "grammalecte", 0)
" }}}
" }}}

" 2.25.3. RST
" ----------- {{{

" Riv
" --- {{{

let s:riv = {}
let s:riv.url = 'gu-fan/riv.vim'
" Prefer Markdown preview instead (vim-markdown, markdown-preview)
function! s:setup() dict
  " Bad solution because it 'hide' the scrolling shortcut
  " let g:riv_global_leader = "<C-e>"

  " Bad solution since it make \ clumsy to insert in insert mode
  " let g:riv_global_leader = "<leader>e"

  let g:riv_global_leader = ""
endfunction
let s:riv.setup = funcref("s:setup")
call s:addplugin(s:riv, "riv", 0)
" }}}

" InstantRst
" ---------- {{{

" ReStructuredText preview
" Prefer Markdown preview instead (vim-markdown, markdown-preview)
let s:instant_rst = {}
let s:instant_rst.url = 'gu-fan/InstantRst'
function! s:setup() dict
  " let g:instant_rst_slow = 1
  let g:instant_rst_bind_scroll = 0
  " let g:instant_rst_localhost_only = 1
endfunction
let s:instant_rst.setup = funcref("s:setup")
call s:addplugin(s:instant_rst, "instant_rst", 0)
" }}}
" }}}

" 2.25.4. CSV
" ----------- {{{

let s:csv = {}
let s:csv.url = 'chrisbra/csv.vim'
function! s:setup() dict
  let g:csv_start = 1
  let g:csv_end = 100
  let g:csv_strict_columns = 1

  let g:csv_no_column_highlight = 0
  let g:csv_delim_test = ";\t,|"

  " command! SetDelim let b:delimiter = getline('.')[col('.') - 1] | CSVInit!

  " More information: :help ft-csv
endfunction
let s:csv.setup = funcref("s:setup")
call s:addplugin(s:csv, "csv")

let s:rainbow_csv = {}
let s:rainbow_csv.url = 'mechatroner/rainbow_csv'
function! s:setup() dict
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
endfunction
let s:rainbow_csv.setup = funcref("s:setup")
call s:addplugin(s:rainbow_csv, "rainbow_csv", 0)
" }}}

" 2.25.5. Python Mode
" ------------------- {{{

let s:python_mode = {}
let s:python_mode.url = 'python-mode/python-mode'
let s:python_mode.options = { 'for': 'python', 'branch': 'develop'}
function! s:setup()
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
endfunction
let s:python_mode.setup = funcref("s:setup")
call s:addplugin(s:python_mode, "python_mode", 0)
" }}}

" 2.25.6. Rust
" ------------ {{{

" Rust support
call s:addplugin('rust-lang/rust.vim', "rust_vim", 0)
" }}}

" 2.25.7. Jinja
" ------------- {{{

call s:addplugin('Glench/Vim-Jinja2-Syntax', "vim_jinja2_syntax")
" }}}

" 2.25.8. Logs
" ------------ {{{

call s:addplugin('mtdl9/vim-log-highlighting', "vim_log_highligthing")

call s:addplugin('powerman/vim-plugin-AnsiEsc', "ansiesc", 0)
" }}}

" 2.25.9. TeX/LaTeX
" ----------------- {{{

let s:vimtex = {}
let s:vimtex.url = 'lervag/vimtex'
let s:vimtex.options = {}
function! s:setup() dict
  let g:vimtex_imaps_disabled = ['b', 'B', 'c', 'f', '/', '-']
endfunction
let s:vimtex.setup = funcref("s:setup")
call s:addplugin(s:vimtex, "vimtex", 0)


let s:vim_latex = {}
let s:vim_latex.url = 'vim-latex/vim-latex'
function! s:setup() dict
  "let g:Tex_AdvancedMath = 1
  "set winaltkeys=no
endfunction
let s:vim_latex.setup = funcref("s:setup")
call s:addplugin(s:vim_latex, "vim_latex", 0)
" }}}

" 2.25.10. Vim Help
" ----------------- {{{

call s:addplugin('tweekmonster/helpful.vim', "helpful", 0)
" }}}
" }}}

" 2.26. Select Plugins
" -------------------- {{{

" Dark background
set background=dark

if !(has('gui_running') || has('unix'))
  " Seems that termguicolors and nord colorscheme work well on Windows console
  set termguicolors
endif

let s:colorscheme_desired = 'gruvbox'
" let s:colorscheme_desired = 'nord'

" call s:selectplugins('11110001')

" Problem with b:undo_ftpplugin (the four plugins should be present together)
" call s:selectplugins(['vim_easymotion', 'markdown_preview', 'csv', 'vim_remotions'])
" call s:deactivateplugins(['csv']) " important
" call s:deactivateplugins(['vim_remotions']) " important
" call s:deactivateplugins(['vim_easymotion']) " important
" call s:deactivateplugins(['markdown_preview']) " optional

" call s:activateplugins(['ale'])
" call s:activateplugins(['vim_gruvbox', 'vim_easymotion', 'vim_remotions'])
" call s:deactivateplugins(['vim_easymotion'])
" call s:activateplugins(['vim_gruvbox'])

call s:installplugins()

try
  execute 'colorscheme' s:colorscheme_desired
catch
  colorscheme desert
endtry
" }}}

" 2.27. Plugin Settings
" --------------------- {{{

" Which-Key Settings
" ------------------ {{{

if s:ispluginactive('which_key')
  let g:which_key_map =  {}
  let g:which_key_map.f = { 'name' : '+Format' }
  let g:which_key_map.t = { 'name' : '+Toggle' }

  let g:which_key_map_g = {}
  " :help g
  let g:which_key_map_g.8 = [':normal! g8', 'Show Utf8 code']
  let g:which_key_map_g.a = [':normal! ga', 'Show Unicode code']

  let g:which_key_map_g.v = [':normal! gv', 'Reselect']

  let g:which_key_map_g.g = [':normal! gg', 'Go to Start']
  let g:which_key_map_g.j = [':normal! gj', 'Go Down']
  let g:which_key_map_g.k = [':normal! gk', 'Go Up']
  let g:which_key_map_g.0 = [':normal! g0', 'Go Home']
  let g:which_key_map_g['$'] = [':normal! g$', 'Go End']
  let g:which_key_map_g.E = [':normal! gE', 'Go to End of Word']
  let g:which_key_map_g.e = [':normal! ge', 'Go to End of word']
  let g:which_key_map_g.m = [':normal! gm', 'Go to Middle Screen']
  let g:which_key_map_g.M = [':normal! gM', 'Go to Middle Line']

  let g:which_key_map_g.d = [':normal! gd', 'Go to Definition']
  let g:which_key_map_g.D = [':normal! gD', 'Go to Definition']
  let g:which_key_map_g[']'] = [':normal! g]', 'Go to Tag']
  let g:which_key_map_g.f = [':normal! gf', 'Go to File']
  let g:which_key_map_g.F = [':normal! gF', 'Go to File:Line']

  let g:which_key_map_g.t = [':normal! gt', 'Go to Next Tab']
  let g:which_key_map_g.T = [':normal! gT', 'Go to Previous Tab']

  let g:which_key_map_g.q = [':normal! gq', 'Format']
  let g:which_key_map_g.J = [':normal! gJ', 'Join Raw Line']

  let g:which_key_map_g['<'] = [':normal! g<', 'Show Last Command Output']

  let g:which_key_map_g['*'] = [':normal! g*', 'Search']
  let g:which_key_map_g['#'] = [':normal! g#', 'Search']

  let g:which_key_map_g[','] = [':normal! g,', 'Previous Edition']
  let g:which_key_map_g[';'] = [':normal! g;', 'Next Edition']

  " Doesn't seems to work (waiting for a move)
  let g:which_key_map_g.w = [':normal! gw', 'Format']

  " :help z
  let g:which_key_map_z = {}
  let g:which_key_map_z['+'] = [':normal! z+', 'Scroll to Top']
  let g:which_key_map_z['<CR>'] = [":normal! z\<CR>", 'Scroll to Top']
  let g:which_key_map_z['.'] = [':normal! z.', 'Scroll to Center']
  let g:which_key_map_z['-'] = [':normal! z-', 'Scroll to Bottom']
  let g:which_key_map_z.t = [':normal! zt', 'Scroll to Top']
  let g:which_key_map_z.z = [':normal! zz', 'Scroll to Center']
  let g:which_key_map_z.b = [':normal! zb', 'Scroll to Bottom']

  let g:which_key_map_z['='] = [':normal! z=', 'Spelling Suggestions']
  let g:which_key_map_z.g = [':normal! zg', 'Mark Word Good']
  let g:which_key_map_z.G = [':normal! zG', 'Mark Word Good Temporarily']
  let g:which_key_map_z.w = [':normal! zw', 'Mark Word Wrong']
  let g:which_key_map_z.W = [':normal! zW', 'Mark Word Wrong Temporarily']
  let g:which_key_map_z.u = { 'name': '+Undo' }
  let g:which_key_map_z.u.g = [':normal! zug', 'Undo Mark Word Good']
  let g:which_key_map_z.u.G = [':normal! zuG', 'Undo Mark Word Good Temporarily']
  let g:which_key_map_z.u.w = [':normal! zuw', 'Undo Mark Word Wrong']
  let g:which_key_map_z.u.W = [':normal! zuW', 'Undo Mark Word Wrong Temporarily']

  let g:which_key_map_z.r = [':normal! zr', 'Reveal Fold']
  let g:which_key_map_z.R = [':normal! zR', 'Reveal Fold Recursively']
  let g:which_key_map_z.m = [':normal! zm', 'Mask Fold']
  let g:which_key_map_z.M = [':normal! zM', 'Mask Fold Recursively']
  let g:which_key_map_z.o = [':normal! zo', 'Open Fold']
  let g:which_key_map_z.O = [':normal! zO', 'Open Fold Recursively']
  let g:which_key_map_z.c = [':normal! zc', 'Close Fold']
  let g:which_key_map_z.C = [':normal! zC', 'Close Fold Recursively']
  let g:which_key_map_z.f = [':normal! zf', 'Create Fold by Move']
  let g:which_key_map_z.F = [':normal! zF', 'Create Fold by Number']
  let g:which_key_map_z.d = [':normal! zd', 'Delete Fold by Move']
  let g:which_key_map_z.D = [':normal! zD', 'Delete Fold by Number']
  let g:which_key_map_z.E = [':normal! zE', 'Eleminate All Folds']

  let g:which_key_map_z.j = [':normal! zj', 'Move to Next Fold']
  let g:which_key_map_z.k = [':normal! zk', 'Move to Previous Fold']

  let g:which_key_map_z.H = [':normal! zH', 'H-Scroll Half Screen Left']
  let g:which_key_map_z.h = [':normal! zh', 'H-Scroll Left']
  let g:which_key_map_z['<Left>'] = [":normal! z\<Left>", 'H-Scroll Left']
  let g:which_key_map_z.L = [':normal! zL', 'H-Scroll Half Sreeen Right']
  let g:which_key_map_z.l = [':normal! zl', 'H-Scroll Right']
  let g:which_key_map_z['<right>'] = [":normal! z\<right>", 'H-Scroll Right']
  let g:which_key_map_z.s = [':normal! zs', 'H-Scroll at Start']
  let g:which_key_map_z.e = [':normal! ze', 'H-Scroll at End']

  let g:which_key_map_z.y = [':normal! zy', 'Yank No Trailer']
  let g:which_key_map_z.p = [':normal! zp', 'Paste After No Trailer']
  let g:which_key_map_z.P = [':normal! zP', 'Paste Before No Trailer']
endif
if s:ispluginactive('which_key')
  let g:which_key_map_g.x = ["<Plug>NetrwBrowseX", 'Open File']
endif
" }}}
" }}}
" }}}

" 3. Miscellaneous
" ================ {{{

" 3.1. Improved Ctrl-l
" -------------------- {{{

nnoremap <leader>l :nohlsearch<cr>:windo filetype detect<cr>:diffupdate<cr>:syntax sync fromstart<cr>:setlocal wincolor=<cr><C-l>
if s:ispluginactive('which_key')
  let g:which_key_map.l = [':nohlsearch:diffupdate:syntax sync fromstart', 'Refresh']
endif
" }}}

" 3.2. Spelling correction <leader>z
" ---------------------------------- {{{
nnoremap <Leader>z ea<C-x>s
if s:ispluginactive('which_key')
  let g:which_key_map.z = [':normal! eas', 'Spelling Suggestion']
endif
" }}}

" 3.3. Make Ctrl-n and Ctrl-p on the command line work like Down and Up
" --------------------------------------------------------------------- {{{

" Searching for a next/previous command in the history
" instead of going for the next/previous command
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<up>"
" }}}

" 3.4. Select the pasted text with gp
" ----------------------------------- {{{
" (inspired from gv that select the text that has been just selected)
nnoremap gp `[v`]
if s:ispluginactive('which_key')
  let g:which_key_map_g.p = ['`[v`]', 'Select Pasted']
endif
" }}}

" 3.5. File Browsing
" ------------------ {{{

" 3.5.1. Fuzzy searching
" ---------------------- {{{

set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
" }}}

" 3.5.2. File searching
" --------------------- {{{

function! ToggleQuickFix()
  if !empty(filter(getwininfo(), {_, val -> getbufinfo(val.bufnr)[0].command}))
    " Command window
    " echom 'Command Window'
    call feedkeys("\<C-c>\<C-c>")
    return
  endif
  if empty(filter(getwininfo(), 'v:val.quickfix')) && ctrlsf#win#FindMainWindow() == -1
    if !exists('g:bottom_bar') || g:bottom_bar ==# 'quickfix'
      copen
    elseif g:bottom_bar ==# 'location'
      lopen
    elseif g:bottom_bar ==# 'ctrlsf'
      CtrlSFOpen
    endif
  else
    if !empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
      let g:bottom_bar = 'quickfix'
      cclose
    endif
    if !empty(filter(getwininfo(), 'v:val.quickfix && v:val.loclist'))
      let g:bottom_bar = 'location'
      lclose
    endif
    if s:ispluginactive('ctrlsf') && ctrlsf#win#FindMainWindow() != -1
      let g:bottom_bar = 'ctrlsf'
      CtrlSFClose
      " Trick to force the redraw of the cmdheight:
      let &cmdheight=&cmdheight
    endif
  endif
endfunction
" }}}
" }}}

" 3.6. Sessions
" ------------- {{{

let g:sessions_dir = GetVimDataFolder() . 'session'

" Sessions settings:
" ------------------

let s:session = s:ispluginactive('vim_startify') || s:ispluginactive('vim_obsession') || s:ispluginactive('vim_prosession') || s:ispluginactive('reload_session_at_start')
if s:ispluginactive('session')
  if !isdirectory(g:sessions_dir)
    call mkdir(g:sessions_dir)
  endif

  if has('unix')
    call mkdir(g:sessions_dir, "p", 0700)j
  endif

  " Make sure the commands: SSave and SLoad are defined
  if s:ispluginactive('vim_startify')
  elseif s:ispluginactive('vim_obsession') || s:ispluginactive('vim_prosession')
    command! -nargs=1 SSave exec 'Obsession ' . g:sessions_dir . '/<args>'
    command! -nargs=1 SLoad exec 'so' . g:sessions_dir . '/<args>'
  else
    command! -nargs=1 SSave exec 'mks! ' . g:sessions_dir . '/<args>'
    command! -nargs=1 SLoad exec 'so ' . g:sessions_dir . '/<args>'
  endif
endif


" Reload the my session at start
" ------------------------------
if s:ispluginactive('reload_session_at_start')
  " Try to close the terminals before closing vim:
  if s:ispluginactive('vim_floaterm')
    autocmd QuitPre * FloatermKill!
  endif

  if s:ispluginactive('nerdtree')
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

  if s:ispluginactive('vista_vim')
    " Close Vista before the session is stored.
    " It seems the session restoring doesn't restore it right
    autocmd VimLeavePre * Vista!
  endif

  " Close the help screen before the session is stored
  " It seems the session restoring doesn't restore it right
  autocmd VimLeavePre * helpclose

  if s:ispluginactive('vim_startify')
    autocmd VimEnter * SLoad startup
  elseif s:ispluginactive('vim_obsession')
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
" }}}

" 3.7. Snippet Trigger
" -------------------- {{{

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

if s:ispluginactive('ultisnips') && s:ispluginactive('emmet_vim')
  imap <expr> <C-s> IsEmmet(&filetype) ? "\<C-S-F12>" : "\<C-F12>"
endif
" }}}

" 3.8. Restore cursor position
" ---------------------------- {{{

" Make sure the position of the cursor is restored
" when you switch between buffers
" Remark:
" - It is incompatible with tagbar jump to tag
" - The default.vim comes with a better solution for the purpose
if !s:ispluginactive('tagbar')
  augroup saveview
    au!
    au BufLeave * let b:winview = winsaveview()
    au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
  augroup END
endif
" }}}

" 3.9. Create the file under the cursor if not existing:
" ------------------------------------------------------ {{{

:noremap <leader>gf :e %:h/<cfile><CR>
if s:ispluginactive('which_key')
  let g:which_key_map.g = ['', 'which_key_ignore']
  let g:which_key_map.gf =  [':e %:h/<cfile>', 'Go to New File']
endif
" }}}

" 3.10. Search in the direction of the document:
" ---------------------------------------------- {{{

nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')
" }}}

" 3.11. Move divider logic instead of adapting window size logic:
" --------------------------------------------------------------- {{{

" function! s:right_ids(layout)
"   let type = a:layout[0]
"   if type ==# 'leaf'
"     return [a:layout[1]]
"   elseif type ==# 'row'
"     return s:right_ids(a:layout[1][-1])
"   elseif type ==# 'col'
"     let ret = []
"     for sublayout in a:layout[1]
"       let ret = ret + s:right_ids(sublayout)
"     endfor
"     return ret
"   endif
" endfunction

" function! s:left_ids(layout)
"   let type = a:layout[0]
"   if type ==# 'leaf'
"     return [a:layout[1]]
"   elseif type ==# 'row'
"     return s:left_ids(a:layout[1][0])
"   elseif type ==# 'col'
"     let ret = []
"     for sublayout in a:layout[1]
"       let ret = ret + s:left_ids(sublayout)
"     endfor
"     return ret
"   endif
" endfunction

" function! s:bottom_ids(layout)
"   let type = a:layout[0]
"   if type ==# 'leaf'
"     return [a:layout[1]]
"   elseif type ==# 'col'
"     return s:bottom_ids(a:layout[1][-1])
"   elseif type ==# 'row'
"     let ret = []
"     for sublayout in a:layout[1]
"       let ret = ret + s:bottom_ids(sublayout)
"     endfor
"     return ret
"   endif
" endfunction

" function! s:top_ids(layout)
"   let type = a:layout[0]
"   if type ==# 'leaf'
"     return [a:layout[1]]
"   elseif type ==# 'col'
"     return s:top_ids(a:layout[1][0])
"   elseif type ==# 'row'
"     let ret = []
"     for sublayout in a:layout[1]
"       let ret = ret + s:top_ids(sublayout)
"     endfor
"     return ret
"   endif
" endfunction

" nnoremap <expr> <C-w>< index(<SID>right_ids(winlayout()), win_getid()) >= 0 ? "<C-w>>" : "<C-w><lt>"
" nnoremap <expr> <C-w>> index(<SID>right_ids(winlayout()), win_getid()) >= 0 ? "<C-w><lt>" : "<C-w>>"
" nnoremap <expr> <C-w>- index(<SID>bottom_ids(winlayout()), win_getid()) >= 0 ? "<C-w>+" : "<C-w>-"
" nnoremap <expr> <C-w>+ index(<SID>bottom_ids(winlayout()), win_getid()) >= 0 ? "<C-w>-" : "<C-w>+"

function! s:right_ids(layout, right)
  let type = a:layout[0]
  if type ==# 'leaf'
    if a:right
      return [a:layout[1]]
    else
      return []
    endif
  elseif type ==# 'col'
    let ret = []
    for sublayout in a:layout[1]
      let ret = ret + s:right_ids(sublayout, a:right)
    endfor
    return ret
  elseif type ==# 'row'
    let ret = []
    for index in range(len(a:layout[1]))
      let sublayout = a:layout[1][index]
      let right = 0
      if index == len(a:layout[1]) - 1
        let right = 1
      endif
      let ret = ret + s:right_ids(sublayout, right)
    endfor
    return ret
  endif
endfunction

function! s:bottom_ids(layout, bottom)
  let type = a:layout[0]
  if type ==# 'leaf'
    if a:bottom
      return [a:layout[1]]
    else
      return []
    endif
  elseif type ==# 'row'
    let ret = []
    for sublayout in a:layout[1]
      let ret = ret + s:bottom_ids(sublayout, a:bottom)
    endfor
    return ret
  elseif type ==# 'col'
    let ret = []
    for index in range(len(a:layout[1]))
      let sublayout = a:layout[1][index]
      let bottom = 0
      if index == len(a:layout[1]) - 1
        let bottom = 1
      endif
      let ret = ret + s:bottom_ids(sublayout, bottom)
    endfor
    return ret
  endif
endfunction

nnoremap <expr> <C-w>< index(<SID>right_ids(winlayout(), 0), win_getid()) >= 0 ? "<C-w>>" : "<C-w><lt>"
nnoremap <expr> <C-w>> index(<SID>right_ids(winlayout(), 0), win_getid()) >= 0 ? "<C-w><lt>" : "<C-w>>"
nnoremap <expr> <C-w>- index(<SID>bottom_ids(winlayout(), 0), win_getid()) >= 0 ? "<C-w>-" : "<C-w>+"
nnoremap <expr> <C-w>+ index(<SID>bottom_ids(winlayout(), 0), win_getid()) >= 0 ? "<C-w>+" : "<C-w>-"

" nnoremap <expr><C-W>< printf("\<cmd>vert %dresize%+d\r", winnr('h'), -v:count1)
" nnoremap <expr><C-W>> printf("\<cmd>vert %dresize%+d\r", winnr('h'), v:count1)
" nnoremap <expr><C-W>- printf("\<cmd>%dresize%+d\r", winnr('k'), -v:count1)
" nnoremap <expr><C-W>+ printf("\<cmd>%dresize%+d\r", winnr('k'), v:count1)
" }}}

" 3.12. Which Key plugin settings:
" -------------------------------- {{{

if s:ispluginactive('which_key')
  set timeoutlen=1000
  let g:which_key_timeout=300

  " let g:which_key_ignore_outside_mappings = 1

  autocmd! User vim-which-key
  nnoremap <silent> <leader> :<C-u>WhichKey '<leader>'<CR>
  autocmd User vim-which-key call which_key#register(g:mapleader, 'g:which_key_map')

  nnoremap <silent> g :<C-u>WhichKey 'g'<CR>
  autocmd User vim-which-key call which_key#register('g', 'g:which_key_map_g')

  " :help *z*
  nnoremap <silent> z :<C-u>WhichKey 'z'<CR>
  autocmd User vim-which-key call which_key#register('z', 'g:which_key_map_z')
endif
" }}}

" 3.13. Add a Diff command to compare with the disk buffer
" -------------------------------------------------------- {{{

function! DiffOrig(spec)
  let cft=&filetype
  vertical new
  let &filetype=cft
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  let cmd = "++edit #"
  if len(a:spec)
    let cmd = "!git -C " . shellescape(fnamemodify(finddir('.git', '.;'), ':p:h:h')) . " show " . a:spec . ":#"
  endif
  execute "read " . cmd
  silent 0d_
  diffthis
  wincmd p
  diffthis
endfunction

command! -nargs=? DiffOrig call DiffOrig(<q-args>)
" }}}

" 3.14. Correct Commands
" ---------------------- {{{

" Define the Help command to display help in a vertical split:
command! -nargs=? Help vert help <args>

function! CorrectCommand()
  if getcmdtype() != ':'
    return "\<CR>"
  endif

  let l:substitutions = []
  call add(l:substitutions, ['\v^(h%[elp])>(.*)', 'Help\2'])
  if s:ispluginactive('vim_bbye')
    call add(l:substitutions, ['\v^(bd>)(.*)', 'Bd\2'])
  endif
  let g:substitutions = l:substitutions

  let l:command = getcmdline()
  for l:substitution in l:substitutions
    if matchstr(l:command, l:substitution[0]) != ''
      let l:command = substitute(l:command, l:substitution[0], l:substitution[1], '')
      return "\<End>\<C-u>" . l:command . "\<CR>"
    endif
  endfor

  return "\<CR>"
endfunction

cnoremap <expr> <CR> CorrectCommand()
" }}}

" 3.15. Change Font Size
" ---------------------- {{{

function! ChangeFontSize()
  " let g:columns=&columns
  " let g:lines=&lines
  if !exists("g:columns")
    let g:columns = &columns
  endif
  if !exists("g:lines")
    let g:lines = &lines
  endif

  let old_size = substitute(v:option_old, '^.*:h\(\d\+\).*$', '\=submatch(1)', '')
  let new_size = substitute(v:option_new, '^.*:h\(\d\+\).*$', '\=submatch(1)', '')

  let width_factor = str2float(new_size) / str2float(old_size)
  " echom "width_factor: " . width_factor

  let height_factor = str2float(new_size) / str2float(old_size)
  let size2pixel = 36.0/20.0
  " Theoretical approximation:
  " (line height = 1.5 font height, 1pt = 1/72 inch, 1 px = 1/96 inch)
  let size2pixel = 1.5 * 16.0/12.0
  " let height_factor = str2float(new_size * size2pixel + &linespace) / str2float(old_size * size2pixel + &linespace)
  " echom "height_factor: " . height_factor

  " echom "columns: " . g:columns
  let &columns = float2nr(round(g:columns / width_factor))
  let g:columns=&columns
  " echom "columns: " . &columns

  " echom "lines: " . g:lines
  " echom "old_size: " . &lines * (old_size * size2pixel + &linespace)
  let &lines = float2nr(round(g:lines / height_factor))
  " echom "new_size: " . &lines * (new_size * size2pixel + &linespace)
  let g:lines=&lines
  " echom "lines: " . &lines
endfunction

function! GetScreenSize(timer)
  let g:columns=&columns
  let g:lines=&lines
endfunction

" autocmd VimEnter * let g:columns=&columns|let g:lines=&lines|echom "Lines(S): " . &lines
" autocmd VimResized * let g:columns=&columns|let g:lines=&lines|echom "Lines(R): " . &lines
autocmd VimEnter * call timer_start(200, 'GetScreenSize', {'repeat' : 1})
autocmd VimResized * call timer_start(200, 'GetScreenSize', {'repeat' : 1})
autocmd OptionSet guifont call ChangeFontSize()

command! -count=1 FontIncrease let &guifont = substitute(&guifont, '\(\d\+\)\ze\(:cANSI\)\?$', '\=submatch(1)+<count>', '')
command! -count=1 FontDecrease let &guifont = substitute(&guifont, '\(\d\+\)\ze\(:cANSI\)\?$', '\=submatch(1)-<count>', '')
command! -nargs=1 FontSet let &guifont = substitute(&guifont, '\(\d\+\)\ze\(:cANSI\)\?$', '<args>', '')
" }}}

" 3.16. Terminal
" -------------- {{{

" Leave terminal with Ctrl-q
if has('nvim') || v:version >= 801
  tnoremap <C-q>  <C-\><C-n>

  " Make Neovim supporting the Ctrl-w mapping like Vim does
  " tnoremap <C-w> <C-w>
  tnoremap <C-w><C-w> <cmd>wincmd w<CR>
  tnoremap <C-w>w <cmd>wincmd w<CR>
  tnoremap <C-w>h <cmd>wincmd h<CR>
  tnoremap <C-w>l <cmd>wincmd l<CR>
  tnoremap <C-w>j <cmd>wincmd j<CR>
  tnoremap <C-w>k <cmd>wincmd k<CR>
  tnoremap <C-w>p <cmd>wincmd p<CR>

  " Make <kbd>Ctrl-v</kbd> paste the content of the clipboard into the terminal
  tnoremap <expr> <C-v> getreg('*')

  " make <kbd>Ctrl-Enter</kbd> passed correctly into the terminal
  tnoremap <expr> <C-Cr> <SID>SendToTerm("\<Esc>\<Cr>")
endif

function! <SID>SendToTerm(what)
  call term_sendkeys('', a:what)
  return ''
endfunc

function! s:SwitchToTerminal(...) abort
  let l:bufindex = 0
  if a:0 == 0
    " If no name is given use the working directory:
    " let l:name = fnamemodify(getcwd(), ':p')
    " If no name is given use the current file directory:
    let l:name = fnamemodify(expand('%:p:h'), ':p')
  else
    if a:1 =~ '^\d\+'
      let l:bufindex = str2nr(a:1)
      let l:name = ''
    else
      let l:name = expand(a:1)
      if !isdirectory(l:name)
        " If the name given is the name of a file
        " use the parent folder
        " End with '/'
        let l:name = fnamemodify(fnamemodify(l:name, ':p:h'), ':p')
      else
        " End with '/'
        let l:name = fnamemodify(l:name, ':p')
      endif
    endif
  endif

  let win_infos = filter(getwininfo(), "v:val.terminal")
  if len(win_infos)
    let winnr = win_infos[-1].winnr

    " If a terminal window exist with the right name/index switch to it:
    if l:bufindex == 0
      let win_info = filter(win_infos, "getbufvar(v:val.bufnr, 'terminal_name')=='" . l:name . "'")
    else
      let win_info = filter(win_infos, "v:val.bufnr ==" . l:bufindex)
    endif
    if len(win_info) > 0
      let winnr = win_info[0].winnr
      execute winnr . 'wincmd w'
      return
    endif

    " Otherwise if a terminal window exist reuse it:
    execute winnr . 'wincmd w'
  else
    " If no terminal window create a vertical window at the right side:
    wincmd s
    wincmd L
    100wincmd |
    let winnr = winnr()
  endif

  " Search among existing terminal buffer:
  if l:bufindex == 0
    let buf_infos = filter(getbufinfo(), "getbufvar(v:val.bufnr, '&buftype')=='terminal'")
  else
    let buf_infos = filter(getbufinfo(), "v:val.bufnr ==" . l:bufindex)
  endif
  if len(buf_infos)
    if l:bufindex == 0
      let buf_infos = filter(buf_infos, "getbufvar(v:val.bufnr, 'terminal_name')=='" . l:name . "'")
    endif
    if len(buf_infos)
      " If a hidden terminal with the right name exist use it:
      execute 'buffer ' . buf_infos[0].bufnr
      return
    endif
  endif

  if l:bufindex != 0
    echom 'Fail to find buffer:' . l:bufindex
    return
  endif

  let l:workingdir = getcwd()
  if l:name != l:workingdir
    " Change the working directory temporarily
    " In order to create the terminal with the correct working directory
    execute 'cd' l:name

    let l:restore_rooter = 0
    if exists('g:rooter_manual_only') && !g:rooter_manual_only
      " Disable vim-rooter temporarily
      RooterToggle
      let l:restore_rooter = 1
    endif
  endif

  " Load a new terminal into the window:
  if has('nvim')
    " The redirection to >nul hide the output of the console
    terminal cmd.exe /s /k C:\Softs\Clink\Clink.bat inject
    " Switch to console mode:
    norma a
  else
    " 96 = 100 - &numberwidth
    " &signcolumn == yes -> 2 columns
    " &numberwidth -> max(&numberwidth, ceil(log(line('$'))/log(10)) + 1)
    terminal ++curwin ++cols=96 ++close ++kill=kill cmd.exe /k C:\Softs\Clink\Clink.bat inject >nul
  endif

  setlocal nobuflisted
  let b:terminal_name = l:name
  " Set a name for the terminal buffer:
  execute 'file' 'Term ' . bufnr()

  if l:name != l:workingdir
    execute 'cd' l:workingdir
    if l:restore_rooter
      RooterToggle
    endif
  endif
endfunction

function! s:TermList()
  let ret = []
  let buf_infos = filter(getbufinfo(), "getbufvar(v:val.bufnr, '&buftype')=='terminal'")

  let cwd = getcwd()
  let cwd = fnamemodify(cwd, ':p')

  for buf_info in buf_infos
    if !has_key(buf_info.variables, 'terminal_name')
      continue
    endif
    let terminal_name  = buf_info.variables.terminal_name
    if terminal_name[0:len(cwd)-1] ==# cwd
      let terminal_name = terminal_name[len(cwd):]
      if terminal_name == ''
        let terminal_name = '.'
      endif
    endif
    call add(ret, [buf_info.bufnr, terminal_name])
  endfor
  return ret
endfunction

function! s:CompleteTerm(arg_lead, cmd_line, position)
  let ret = map(s:TermList(), {_, val -> val[1]})
  return join(ret, "\n")
endfunction

" command! -nargs=? Term call s:SwitchToTerminal(<f-args>)
command! -complete=custom,<SID>CompleteTerm -nargs=? Term call <SID>SwitchToTerminal(<f-args>)

command TermList echo join(map(<SID>TermList(), {_, val -> printf("%3d %s", val[0], val[1])}), "\n")

function! s:ToggleTerm(name)
  let win_infos = filter(getwininfo(), "v:val.terminal")
  if len(win_infos)
    " If a terminal window exist go to the terminal:
    for i in range(len(win_infos)-1, 0, -1)
      execute win_infos[i].winnr . 'wincmd c'
    endfor
    return
  else
    call s:SwitchToTerminal(a:name)
  endif
endfunction

nnoremap <leader>tb <cmd>call <SID>ToggleTerm(expand('%:p:h'))<CR>
if s:ispluginactive('which_key')
  let g:which_key_map.t.b = [":call <SID>ToggleTerm(expand('%:p:h'))", 'Toggle Term']
endif
" }}}

" 3.17. Active Window Focus
" ------------------------- {{{

" Adapt the color of the inactive window:
if has('nvim') || v:version >= 801
if g:colors_name == 'nord'
  hi DimNormal guibg=#1b212c
  hi DimConsole guifg=#d8dee9 guibg=#1b212c
elseif g:colors_name == 'gruvbox'
  hi DimNormal guibg=#1b1b1b
  hi DimConsole guifg=#D5C4A1 guibg=#1b1b1b
endif
" hi DimNormal guibg=#3b4252

if !has('nvim')
  function! DimWindow()
    if getwinvar(winnr(), '&diff')==1
      return
    endif
    if getwininfo(win_getid())[0].terminal==1
      setlocal wincolor=DimConsole
    else
      setlocal wincolor=DimNormal
    endif
  endfunction

  augroup ActiveWin | au!
    au WinEnter,BufEnter,BufWinEnter * setlocal wincolor=
    au WinLeave,BufLeave * call DimWindow()
  augroup END
endif

" Hide the cursor line for the non active window:
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
endif
" }}}

" 3.18. SearchClipboard
" --------------------- {{{

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
if s:ispluginactive('which_key')
  let g:which_key_map['*'] = [':call SearchClipboard()', 'Search Clipboard']
endif
" }}}

" 3.19. Barmade
" ------------- {{{

function! IsSideBar(buf_nr)
  " Return 1 if the buffer correspond to a side bar:
  " - A terminal window
  " - The quickfix window
  " - The help
  " - The NERDTree side bar
  " - ...
  let buf_type = getbufvar(a:buf_nr, '&buftype')

  if buf_type ==# 'terminal'
    return 1
  endif

  if buf_type ==# 'quickfix'
    return 1
  endif

  if bufname(a:buf_nr) == ''
    " the [No Name] buffer
    return 0
  endif

  let listed = getbufvar(a:buf_nr, '&buflisted')
  if !listed
    return 1
  endif

  return 0
endfunction

function! LeaveSideBar()
  " Go to a non side bar window
  let win_infos = getwininfo()
  let win_infos =  filter(getwininfo(), "v:val.tabnr == " . tabpagenr())
  let winindex = winnr() - 1
  for i in range(len(win_infos))
    let index = (winindex + i) % len(win_infos)
    if IsSideBar(win_infos[index].bufnr)
      continue
    endif
    execute (index + 1) . 'wincmd w'
    return
  endfor
endfunction

command! LeaveSideBar call LeaveSideBar()

function! GetNumNonSideBarWindows()
  let num_windows = 0
  " echom "winnr('$'):" . winnr('$')

  for win_nr in range(1, winnr('$'))
    let buf_nr = winbufnr(win_nr)
    if IsSideBar(buf_nr)
      continue
    endif
    let num_windows = num_windows + 1
  endfor

  return num_windows
endfunction

function! IsAutoClose(buf_nr)
  " Return 1 if the side bar should already auto close
  let buf_type = getbufvar(a:buf_nr, '&filetype')

  " let term_buffers = term_list()

  if buf_type ==# 'tagbar'
    " Not Read Only
    return 1
  else
    return 0
  endif
endfunction

function! KillSideBars()
  let num_windows = GetNumNonSideBarWindows()
  " echom "Num windows: " . num_windows
  if num_windows > 0
    " If there are non side bar windows do nothing
    return
  endif

  " Delete the terminal buffers that don't correspond to a window
  let wininfos = getwininfo()
  let win_infos =  filter(getwininfo(), "v:val.tabnr == " . tabpagenr())
  if has('nvim')
    let term_buffers = map(filter(win_infos, 'v:val.terminal'), 'v:val.winnr')
  else
    let term_buffers = term_list()
  endif
  for buf_nr in term_buffers
    " echom "what about terminal: " . buf_nr
    if len(win_findbuf(buf_nr)) == 0
      " echom "delete terminal: " . buf_nr
      execute 'bd! ' . buf_nr
    endif
  endfor

  let wininfos = getwininfo()
  let win_infos =  filter(getwininfo(), "v:val.tabnr == " . tabpagenr())
  if has('nvim')
    let term_buffers = map(filter(wininfos, 'v:val.terminal'), 'v:val.winnr')
  else
    let term_buffers = term_list()
  endif
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
" }}}

" 3.20. TrimWhitespaces
" --------------------- {{{

" Add the trim white spaces function
" (that trim the trailing white spaces ;-) )
function! TrimWhitespaces() range
  let cmd = a:firstline . ',' . a:lastline . 's/\s\+$//e'
  mark Z
  " echom cmd
  execute cmd
  " if line("'Z") != line(".")
  "   echo "Some white spaces trimmed"
  " endif
  normal `Z
  delmarks Z
endfunction

" Add the TrimWhitespaces command
command! -range=% TrimWhitespaces <line1>,<line2>call TrimWhitespaces()
" }}}

" 3.21. WipeReg 
" -------------- {{{

" Wipe out the content of all registers
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
" }}}

" 3.23. Python Configuration
" -------------------------- {{{

" Enable all Python syntax highlighting features
" let python_highlight_all = 1

let g:python_recommended_style = 1
let g:pyindent_open_paren = shiftwidth()

" Seems to be a Neovim parameters used by some plugins
if has('win32')
  if has('nvim')
    " set pyxversion=0
    let g:python3_host_prog='C:\Python39_x64\python.exe'
  else
    " Used by wilder
    " set pythonthreedll=python39.dll
    " set pythonthreehome=C:\Python39_x64
    let g:python3_host_prog='C:\Python39_x64\python.exe'
  endif
endif
" }}}

" 3.24. py_compile
" ---------------- {{{

if 0
  autocmd BufRead *.py set makeprg=C:\\python27\\python.exe\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"

  " Set the error format to make cnext and cprevious working nice
  " Remark:
  " - this need autochdir to be set to work properly
  augroup errorformat
    autocmd!
    autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
  augroup END
endif
" }}}

" 3.25. Ctrl-F5
" ------------- {{{

augroup console
  autocmd!
  autocmd BufRead *.py,*.bat nmap <C-F5> :silent !start /min "py.exe" C:\\Softs\\open_console.py "%:p:h" --command "%:t"<CR>
  " autocmd BufRead *.py nmap <C-F5> :!start "C:\\Program Files\\Console\\Console.exe" -d "%:p" -p "\"%:t\""<CR>
augroup END
" }}}

" 3.26. GetMonthIndex
" ------------------- {{{

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
" }}}

" 3.27. Renumber
" -------------- {{{

function! Renumber() range
  let g:indexes = []
  function! NewIndex(bullets)
    let v = split(a:bullets, '\.')
    if len(g:indexes) == 0
      let g:indexes = v
    else
      if len(v) > len(g:indexes)
        let g:indexes += repeat([1], len(v) - len(g:indexes))
      elseif len(v) <= len(g:indexes)
        let g:indexes = g:indexes[0:len(v)-1]
        let g:indexes[len(v)-1] += 1
      endif
    endif
    return join(g:indexes, '.') . '.'
  endfunction
  for i in range(a:firstline, a:lastline)
    execute i . 's/\v^"\s+\zs\d+(\.\d+)*\.?/\=NewIndex(submatch(0))/e'
  endfor
  %s/\v"(.*)\n"\s*([=\-~]{3,})/\='"'.submatch(1)."\n\" ".repeat(submatch(2)[0], len(submatch(1))-1)
endfunction
command! -range=% Renumber <line1>,<line2>call Renumber()
" }}}

" 3.28. vimclippy
" --------------- {{{

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
" command! VimClippy call s:vimclippy()
" }}}

" 3.22. UnloadNonProjectFiles
" --------------------------- {{{

" Close all the buffers that are not child's of the current working directory
command! UnloadNonProjectFiles let cwd=getcwd() | bufdo if (expand('%:p')[0:len(cwd)-1] !=# cwd) | bd | endif
" }}}

" 3.29. Browse
" ------------ {{{

function! Browse(...)
  let l:dir = '"%:p:h"'
  if a:0 > 0
    let l:dir = a:1
  endif

  execute 'silent !open_folder.vbs' l:dir
endfunction
command! -complete=dir -nargs=? Browse call Browse(<f-args>)
" }}}
" }}}

" vim:foldmethod=marker:
