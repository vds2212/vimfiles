" -----------------------------------------------------------------------------
" File: nordbox.vim
" Description: Retro groove color scheme for Vim
" Author: morhetz <morhetz@gmail.com>
" Source: https://github.com/morhetz/nordbox
" Last Modified: 12 Aug 2017
" -----------------------------------------------------------------------------

" Supporting code -------------------------------------------------------------
" Initialisation: {{{

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name='nordbox'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" }}}
" Global Settings: {{{

if !exists('g:nordbox_bold')
  let g:nordbox_bold=1
endif
if !exists('g:nordbox_italic')
  if has('gui_running') || $TERM_ITALICS == 'true'
    let g:nordbox_italic=1
  else
    let g:nordbox_italic=0
  endif
endif
if !exists('g:nordbox_undercurl')
  let g:nordbox_undercurl=1
endif
if !exists('g:nordbox_underline')
  let g:nordbox_underline=1
endif
if !exists('g:nordbox_inverse')
  let g:nordbox_inverse=1
endif

if !exists('g:nordbox_guisp_fallback') || index(['fg', 'bg'], g:nordbox_guisp_fallback) == -1
  let g:nordbox_guisp_fallback='NONE'
endif

if !exists('g:nordbox_improved_strings')
  let g:nordbox_improved_strings=0
endif

if !exists('g:nordbox_improved_warnings')
  let g:nordbox_improved_warnings=0
endif

if !exists('g:nordbox_termcolors')
  let g:nordbox_termcolors=256
endif

if !exists('g:nordbox_invert_indent_guides')
  let g:nordbox_invert_indent_guides=0
endif

if exists('g:nordbox_contrast')
  echo 'g:nordbox_contrast is deprecated; use g:nordbox_contrast_light and g:nordbox_contrast_dark instead'
endif

if !exists('g:nordbox_contrast_dark')
  let g:nordbox_contrast_dark='medium'
endif

if !exists('g:nordbox_contrast_light')
  let g:nordbox_contrast_light='medium'
endif

let s:is_dark=(&background == 'dark')

" }}}
" Palette: {{{

" setup palette dictionary
let s:gb = {}

" fill it with absolute colors
let s:gb.dark0_hard  = ['#2e3440', 234]     " 29-32-33
let s:gb.dark0       = ['#3b4252', 235]     " 40-40-40
let s:gb.dark0_soft  = ['#434c5e', 236]     " 50-48-47
let s:gb.dark1       = ['#4c566a', 237]     " 60-56-54
let s:gb.dark2       = ['#504945', 239]     " 80-73-69 TODO:
let s:gb.dark3       = ['#665c54', 241]     " 102-92-84 TODO:
let s:gb.dark4       = ['#7c6f64', 243]     " 124-111-100 TODO:
let s:gb.dark4_256   = ['#7c6f64', 243]     " 124-111-100 TODO:

let s:gb.gray_245    = ['#928374', 245]     " 146-131-116 TODO:
let s:gb.gray_244    = ['#928374', 244]     " 146-131-116 TODO:

let s:gb.light0_hard = ['#eceff4', 230]     " 249-245-215
let s:gb.light0      = ['#e5e9f0', 229]     " 253-244-193
let s:gb.light0_soft = ['#d8dee9', 228]     " 242-229-188
let s:gb.light1      = ['#ebdbb2', 223]     " 235-219-178 TODO:
let s:gb.light2      = ['#d5c4a1', 250]     " 213-196-161 TODO:
let s:gb.light3      = ['#bdae93', 248]     " 189-174-147 TODO:
let s:gb.light4      = ['#a89984', 246]     " 168-153-132 TODO:
let s:gb.light4_256  = ['#a89984', 246]     " 168-153-132 TODO:

let s:gb.bright_red     = ['#bf616a', 167]     " 251-73-52
let s:gb.bright_green   = ['#a3be8c', 142]     " 184-187-38
let s:gb.bright_yellow  = ['#ebcb8b', 214]     " 250-189-47
let s:gb.bright_blue    = ['#81a1c1', 109]     " 131-165-152
let s:gb.bright_purple  = ['#b48ead', 175]     " 211-134-155
let s:gb.bright_aqua    = ['#88c0d0', 108]     " 142-192-124
let s:gb.bright_orange  = ['#d08770', 208]     " 254-128-25

let s:gb.neutral_red    = ['#cc241d', 124]     " 204-36-29 TODO: #cc241d is used at lines 729 and 733
let s:gb.neutral_green  = ['#98971a', 106]     " 152-151-26 TODO:
let s:gb.neutral_yellow = ['#d79921', 172]     " 215-153-33 TODO:
let s:gb.neutral_blue   = ['#5e81ac', 66]      " 69-133-136 TODO: #458588 is used at lines 729 and 733
let s:gb.neutral_purple = ['#b16286', 132]     " 177-98-134 TODO: #b16286 is used at lines 729 and 733
let s:gb.neutral_aqua   = ['#8fbcbb', 72]      " 104-157-106
let s:gb.neutral_orange = ['#d65d0e', 166]     " 214-93-14 TODO: #d65d0e is used at lines: 729 and 733

let s:gb.faded_red      = ['#9d0006', 88]      " 157-0-6 TODO:
let s:gb.faded_green    = ['#79740e', 100]     " 121-116-14 TODO:
let s:gb.faded_yellow   = ['#b57614', 136]     " 181-118-20 TODO:
let s:gb.faded_blue     = ['#076678', 24]      " 7-102-120 TODO:
let s:gb.faded_purple   = ['#8f3f71', 96]      " 143-63-113 TODO:
let s:gb.faded_aqua     = ['#427b58', 66]      " 66-123-88 TODO:
let s:gb.faded_orange   = ['#af3a03', 130]     " 175-58-3 TODO:

" }}}
" Setup Emphasis: {{{

let s:bold = 'bold,'
if g:nordbox_bold == 0
  let s:bold = ''
endif

let s:italic = 'italic,'
if g:nordbox_italic == 0
  let s:italic = ''
endif

let s:underline = 'underline,'
if g:nordbox_underline == 0
  let s:underline = ''
endif

let s:undercurl = 'undercurl,'
if g:nordbox_undercurl == 0
  let s:undercurl = ''
endif

let s:inverse = 'inverse,'
if g:nordbox_inverse == 0
  let s:inverse = ''
endif

" }}}
" Setup Colors: {{{

let s:vim_bg = ['bg', 'bg']
let s:vim_fg = ['fg', 'fg']
let s:none = ['NONE', 'NONE']

" determine relative colors
if s:is_dark
  let s:bg0  = s:gb.dark0
  if g:nordbox_contrast_dark == 'soft'
    let s:bg0  = s:gb.dark0_soft
  elseif g:nordbox_contrast_dark == 'hard'
    let s:bg0  = s:gb.dark0_hard
  endif

  let s:bg1  = s:gb.dark1
  let s:bg2  = s:gb.dark2
  let s:bg3  = s:gb.dark3
  let s:bg4  = s:gb.dark4

  let s:gray = s:gb.gray_245

  let s:fg0 = s:gb.light0
  let s:fg1 = s:gb.light1
  let s:fg2 = s:gb.light2
  let s:fg3 = s:gb.light3
  let s:fg4 = s:gb.light4

  let s:fg4_256 = s:gb.light4_256

  let s:red    = s:gb.bright_red
  let s:green  = s:gb.bright_green
  let s:yellow = s:gb.bright_yellow
  let s:blue   = s:gb.bright_blue
  let s:purple = s:gb.bright_purple
  let s:aqua   = s:gb.bright_aqua
  let s:orange = s:gb.bright_orange
else
  let s:bg0  = s:gb.light0
  if g:nordbox_contrast_light == 'soft'
    let s:bg0  = s:gb.light0_soft
  elseif g:nordbox_contrast_light == 'hard'
    let s:bg0  = s:gb.light0_hard
  endif

  let s:bg1  = s:gb.light1
  let s:bg2  = s:gb.light2
  let s:bg3  = s:gb.light3
  let s:bg4  = s:gb.light4

  let s:gray = s:gb.gray_244

  let s:fg0 = s:gb.dark0
  let s:fg1 = s:gb.dark1
  let s:fg2 = s:gb.dark2
  let s:fg3 = s:gb.dark3
  let s:fg4 = s:gb.dark4

  let s:fg4_256 = s:gb.dark4_256

  let s:red    = s:gb.faded_red
  let s:green  = s:gb.faded_green
  let s:yellow = s:gb.faded_yellow
  let s:blue   = s:gb.faded_blue
  let s:purple = s:gb.faded_purple
  let s:aqua   = s:gb.faded_aqua
  let s:orange = s:gb.faded_orange
endif

" reset to 16 colors fallback
if g:nordbox_termcolors == 16
  let s:bg0[1]    = 0
  let s:fg4[1]    = 7
  let s:gray[1]   = 8
  let s:red[1]    = 9
  let s:green[1]  = 10
  let s:yellow[1] = 11
  let s:blue[1]   = 12
  let s:purple[1] = 13
  let s:aqua[1]   = 14
  let s:fg1[1]    = 15
endif

" save current relative colors back to palette dictionary
let s:gb.bg0 = s:bg0
let s:gb.bg1 = s:bg1
let s:gb.bg2 = s:bg2
let s:gb.bg3 = s:bg3
let s:gb.bg4 = s:bg4

let s:gb.gray = s:gray

let s:gb.fg0 = s:fg0
let s:gb.fg1 = s:fg1
let s:gb.fg2 = s:fg2
let s:gb.fg3 = s:fg3
let s:gb.fg4 = s:fg4

let s:gb.fg4_256 = s:fg4_256

let s:gb.red    = s:red
let s:gb.green  = s:green
let s:gb.yellow = s:yellow
let s:gb.blue   = s:blue
let s:gb.purple = s:purple
let s:gb.aqua   = s:aqua
let s:gb.orange = s:orange

" }}}
" Setup Terminal Colors For Neovim: {{{

if has('nvim')
  let g:terminal_color_0 = s:bg0[0]
  let g:terminal_color_8 = s:gray[0]

  let g:terminal_color_1 = s:gb.neutral_red[0]
  let g:terminal_color_9 = s:red[0]

  let g:terminal_color_2 = s:gb.neutral_green[0]
  let g:terminal_color_10 = s:green[0]

  let g:terminal_color_3 = s:gb.neutral_yellow[0]
  let g:terminal_color_11 = s:yellow[0]

  let g:terminal_color_4 = s:gb.neutral_blue[0]
  let g:terminal_color_12 = s:blue[0]

  let g:terminal_color_5 = s:gb.neutral_purple[0]
  let g:terminal_color_13 = s:purple[0]

  let g:terminal_color_6 = s:gb.neutral_aqua[0]
  let g:terminal_color_14 = s:aqua[0]

  let g:terminal_color_7 = s:fg4[0]
  let g:terminal_color_15 = s:fg1[0]
endif

" }}}
" Overload Setting: {{{

let s:hls_cursor = s:orange
if exists('g:nordbox_hls_cursor')
  let s:hls_cursor = get(s:gb, g:nordbox_hls_cursor)
endif

let s:number_column = s:none
if exists('g:nordbox_number_column')
  let s:number_column = get(s:gb, g:nordbox_number_column)
endif

let s:sign_column = s:bg1

if exists('g:gitgutter_override_sign_column_highlight') &&
      \ g:gitgutter_override_sign_column_highlight == 1
  let s:sign_column = s:number_column
else
  let g:gitgutter_override_sign_column_highlight = 0

  if exists('g:nordbox_sign_column')
    let s:sign_column = get(s:gb, g:nordbox_sign_column)
  endif
endif

let s:color_column = s:bg1
if exists('g:nordbox_color_column')
  let s:color_column = get(s:gb, g:nordbox_color_column)
endif

let s:vert_split = s:bg0
if exists('g:nordbox_vert_split')
  let s:vert_split = get(s:gb, g:nordbox_vert_split)
endif

let s:invert_signs = ''
if exists('g:nordbox_invert_signs')
  if g:nordbox_invert_signs == 1
    let s:invert_signs = s:inverse
  endif
endif

let s:invert_selection = s:inverse
if exists('g:nordbox_invert_selection')
  if g:nordbox_invert_selection == 0
    let s:invert_selection = ''
  endif
endif

let s:invert_tabline = ''
if exists('g:nordbox_invert_tabline')
  if g:nordbox_invert_tabline == 1
    let s:invert_tabline = s:inverse
  endif
endif

let s:italicize_comments = s:italic
if exists('g:nordbox_italicize_comments')
  if g:nordbox_italicize_comments == 0
    let s:italicize_comments = ''
  endif
endif

let s:italicize_strings = ''
if exists('g:nordbox_italicize_strings')
  if g:nordbox_italicize_strings == 1
    let s:italicize_strings = s:italic
  endif
endif

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:nordbox_guisp_fallback != 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:nordbox_guisp_fallback == 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" }}}
" Nordbox Hi Groups: {{{

" memoize common hi groups
call s:HL('NordboxFg0', s:fg0)
call s:HL('NordboxFg1', s:fg1)
call s:HL('NordboxFg2', s:fg2)
call s:HL('NordboxFg3', s:fg3)
call s:HL('NordboxFg4', s:fg4)
call s:HL('NordboxGray', s:gray)
call s:HL('NordboxBg0', s:bg0)
call s:HL('NordboxBg1', s:bg1)
call s:HL('NordboxBg2', s:bg2)
call s:HL('NordboxBg3', s:bg3)
call s:HL('NordboxBg4', s:bg4)

call s:HL('NordboxRed', s:red)
call s:HL('NordboxRedBold', s:red, s:none, s:bold)
call s:HL('NordboxGreen', s:green)
call s:HL('NordboxGreenBold', s:green, s:none, s:bold)
call s:HL('NordboxYellow', s:yellow)
call s:HL('NordboxYellowBold', s:yellow, s:none, s:bold)
call s:HL('NordboxBlue', s:blue)
call s:HL('NordboxBlueBold', s:blue, s:none, s:bold)
call s:HL('NordboxPurple', s:purple)
call s:HL('NordboxPurpleBold', s:purple, s:none, s:bold)
call s:HL('NordboxAqua', s:aqua)
call s:HL('NordboxAquaBold', s:aqua, s:none, s:bold)
call s:HL('NordboxOrange', s:orange)
call s:HL('NordboxOrangeBold', s:orange, s:none, s:bold)

call s:HL('NordboxRedSign', s:red, s:sign_column, s:invert_signs)
call s:HL('NordboxGreenSign', s:green, s:sign_column, s:invert_signs)
call s:HL('NordboxYellowSign', s:yellow, s:sign_column, s:invert_signs)
call s:HL('NordboxBlueSign', s:blue, s:sign_column, s:invert_signs)
call s:HL('NordboxPurpleSign', s:purple, s:sign_column, s:invert_signs)
call s:HL('NordboxAquaSign', s:aqua, s:sign_column, s:invert_signs)
call s:HL('NordboxOrangeSign', s:orange, s:sign_column, s:invert_signs)

" }}}

" Vanilla colorscheme ---------------------------------------------------------
" General UI: {{{

" Normal text
call s:HL('Normal', s:fg1, s:bg0)

" Correct background (see issue #7):
" --- Problem with changing between dark and light on 256 color terminal
" --- https://github.com/morhetz/nordbox/issues/7
if s:is_dark
  set background=dark
else
  set background=light
endif

if version >= 700
  " Screen line that the cursor is
  call s:HL('CursorLine',   s:none, s:bg1)
  " Screen column that the cursor is
  hi! link CursorColumn CursorLine

  " Tab pages line filler
  call s:HL('TabLineFill', s:bg4, s:bg1, s:invert_tabline)
  " Active tab page label
  call s:HL('TabLineSel', s:green, s:bg1, s:invert_tabline)
  " Not active tab page label
  hi! link TabLine TabLineFill

  " Match paired bracket under the cursor
  call s:HL('MatchParen', s:none, s:bg3, s:bold)
endif

if version >= 703
  " Highlighted screen columns
  call s:HL('ColorColumn',  s:none, s:color_column)

  " Concealed element: \lambda → λ
  call s:HL('Conceal', s:blue, s:none)

  " Line number of CursorLine
  call s:HL('CursorLineNr', s:yellow, s:bg1)
endif

hi! link NonText NordboxBg2
hi! link SpecialKey NordboxBg2

call s:HL('Visual',    s:none,  s:bg3, s:invert_selection)
hi! link VisualNOS Visual

call s:HL('Search',    s:yellow, s:bg0, s:inverse)
call s:HL('IncSearch', s:hls_cursor, s:bg0, s:inverse)

call s:HL('Underlined', s:blue, s:none, s:underline)

call s:HL('StatusLine',   s:bg2, s:fg1, s:inverse)
call s:HL('StatusLineNC', s:bg1, s:fg4, s:inverse)

" The column separating vertically split windows
call s:HL('VertSplit', s:bg3, s:vert_split)

" Current match in wildmenu completion
call s:HL('WildMenu', s:blue, s:bg2, s:bold)

" Directory names, special names in listing
hi! link Directory NordboxGreenBold

" Titles for output from :set all, :autocmd, etc.
hi! link Title NordboxGreenBold

" Error messages on the command line
call s:HL('ErrorMsg',   s:bg0, s:red, s:bold)
" More prompt: -- More --
hi! link MoreMsg NordboxYellowBold
" Current mode message: -- INSERT --
hi! link ModeMsg NordboxYellowBold
" 'Press enter' prompt and yes/no questions
hi! link Question NordboxOrangeBold
" Warning messages
hi! link WarningMsg NordboxRedBold

" }}}
" Gutter: {{{

" Line number for :number and :# commands
call s:HL('LineNr', s:bg4, s:number_column)

" Column where signs are displayed
call s:HL('SignColumn', s:none, s:sign_column)

" Line used for closed folds
call s:HL('Folded', s:gray, s:bg1, s:italic)
" Column where folds are displayed
call s:HL('FoldColumn', s:gray, s:bg1)

" }}}
" Cursor: {{{

" Character under cursor
call s:HL('Cursor', s:none, s:none, s:inverse)
" Visual mode cursor, selection
hi! link vCursor Cursor
" Input moder cursor
hi! link iCursor Cursor
" Language mapping cursor
hi! link lCursor Cursor

" }}}
" Syntax Highlighting: {{{

if g:nordbox_improved_strings == 0
  hi! link Special NordboxOrange
else
  call s:HL('Special', s:orange, s:bg1, s:italicize_strings)
endif

call s:HL('Comment', s:gray, s:none, s:italicize_comments)
call s:HL('Todo', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('Error', s:red, s:vim_bg, s:bold . s:inverse)

" Generic statement
hi! link Statement NordboxRed
" if, then, else, endif, swicth, etc.
hi! link Conditional NordboxRed
" for, do, while, etc.
hi! link Repeat NordboxRed
" case, default, etc.
hi! link Label NordboxRed
" try, catch, throw
hi! link Exception NordboxRed
" sizeof, "+", "*", etc.
hi! link Operator Normal
" Any other keyword
hi! link Keyword NordboxRed

" Variable name
hi! link Identifier NordboxBlue
" Function name
hi! link Function NordboxGreenBold

" Generic preprocessor
hi! link PreProc NordboxAqua
" Preprocessor #include
hi! link Include NordboxAqua
" Preprocessor #define
hi! link Define NordboxAqua
" Same as Define
hi! link Macro NordboxAqua
" Preprocessor #if, #else, #endif, etc.
hi! link PreCondit NordboxAqua

" Generic constant
hi! link Constant NordboxPurple
" Character constant: 'c', '/n'
hi! link Character NordboxPurple
" String constant: "this is a string"
if g:nordbox_improved_strings == 0
  call s:HL('String',  s:green, s:none, s:italicize_strings)
else
  call s:HL('String',  s:fg1, s:bg1, s:italicize_strings)
endif
" Boolean constant: TRUE, false
hi! link Boolean NordboxPurple
" Number constant: 234, 0xff
hi! link Number NordboxPurple
" Floating point constant: 2.3e10
hi! link Float NordboxPurple

" Generic type
hi! link Type NordboxYellow
" static, register, volatile, etc
hi! link StorageClass NordboxOrange
" struct, union, enum, etc.
hi! link Structure NordboxAqua
" typedef
hi! link Typedef NordboxYellow

" }}}
" Completion Menu: {{{

if version >= 700
  " Popup menu: normal item
  call s:HL('Pmenu', s:fg1, s:bg2)
  " Popup menu: selected item
  call s:HL('PmenuSel', s:bg2, s:blue, s:bold)
  " Popup menu: scrollbar
  call s:HL('PmenuSbar', s:none, s:bg2)
  " Popup menu: scrollbar thumb
  call s:HL('PmenuThumb', s:none, s:bg4)
endif

" }}}
" Diffs: {{{

call s:HL('DiffDelete', s:red, s:bg0, s:inverse)
call s:HL('DiffAdd',    s:green, s:bg0, s:inverse)
"call s:HL('DiffChange', s:bg0, s:blue)
"call s:HL('DiffText',   s:bg0, s:yellow)

" Alternative setting
call s:HL('DiffChange', s:aqua, s:bg0, s:inverse)
call s:HL('DiffText',   s:yellow, s:bg0, s:inverse)

" }}}
" Spelling: {{{

if has("spell")
  " Not capitalised word, or compile warnings
  if g:nordbox_improved_warnings == 0
    call s:HL('SpellCap',   s:none, s:none, s:undercurl, s:red)
  else
    call s:HL('SpellCap',   s:green, s:none, s:bold . s:italic)
  endif
  " Not recognized word
  call s:HL('SpellBad',   s:none, s:none, s:undercurl, s:blue)
  " Wrong spelling for selected region
  call s:HL('SpellLocal', s:none, s:none, s:undercurl, s:aqua)
  " Rare word
  call s:HL('SpellRare',  s:none, s:none, s:undercurl, s:purple)
endif

" }}}

" Plugin specific -------------------------------------------------------------
" EasyMotion: {{{

hi! link EasyMotionTarget Search
hi! link EasyMotionShade Comment

" }}}
" Sneak: {{{

hi! link Sneak Search
hi! link SneakLabel Search

" }}}
" Indent Guides: {{{

if !exists('g:indent_guides_auto_colors')
  let g:indent_guides_auto_colors = 0
endif

if g:indent_guides_auto_colors == 0
  if g:nordbox_invert_indent_guides == 0
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg1)
  else
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2, s:inverse)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg3, s:inverse)
  endif
endif

" }}}
" IndentLine: {{{

if !exists('g:indentLine_color_term')
  let g:indentLine_color_term = s:bg2[1]
endif
if !exists('g:indentLine_color_gui')
  let g:indentLine_color_gui = s:bg2[0]
endif

" }}}
" Rainbow Parentheses: {{{

if !exists('g:rbpt_colorpairs')
  let g:rbpt_colorpairs =
    \ [
      \ ['blue', '#458588'], ['magenta', '#b16286'],
      \ ['red',  '#cc241d'], ['166',     '#d65d0e']
    \ ]
endif

let g:rainbow_guifgs = [ '#d65d0e', '#cc241d', '#b16286', '#458588' ]
let g:rainbow_ctermfgs = [ '166', 'red', 'magenta', 'blue' ]

if !exists('g:rainbow_conf')
   let g:rainbow_conf = {}
endif
if !has_key(g:rainbow_conf, 'guifgs')
   let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
endif
if !has_key(g:rainbow_conf, 'ctermfgs')
   let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
endif

let g:niji_dark_colours = g:rbpt_colorpairs
let g:niji_light_colours = g:rbpt_colorpairs

"}}}
" GitGutter: {{{

hi! link GitGutterAdd NordboxGreenSign
hi! link GitGutterChange NordboxAquaSign
hi! link GitGutterDelete NordboxRedSign
hi! link GitGutterChangeDelete NordboxAquaSign

" }}}
" GitCommit: "{{{

hi! link gitcommitSelectedFile NordboxGreen
hi! link gitcommitDiscardedFile NordboxRed

" }}}
" Signify: {{{

hi! link SignifySignAdd NordboxGreenSign
hi! link SignifySignChange NordboxAquaSign
hi! link SignifySignDelete NordboxRedSign

" }}}
" Syntastic: {{{

call s:HL('SyntasticError', s:none, s:none, s:undercurl, s:red)
call s:HL('SyntasticWarning', s:none, s:none, s:undercurl, s:yellow)

hi! link SyntasticErrorSign NordboxRedSign
hi! link SyntasticWarningSign NordboxYellowSign

" }}}
" Signature: {{{
hi! link SignatureMarkText   NordboxBlueSign
hi! link SignatureMarkerText NordboxPurpleSign

" }}}
" ShowMarks: {{{

hi! link ShowMarksHLl NordboxBlueSign
hi! link ShowMarksHLu NordboxBlueSign
hi! link ShowMarksHLo NordboxBlueSign
hi! link ShowMarksHLm NordboxBlueSign

" }}}
" CtrlP: {{{

hi! link CtrlPMatch NordboxYellow
hi! link CtrlPNoEntries NordboxRed
hi! link CtrlPPrtBase NordboxBg2
hi! link CtrlPPrtCursor NordboxBlue
hi! link CtrlPLinePre NordboxBg2

call s:HL('CtrlPMode1', s:blue, s:bg2, s:bold)
call s:HL('CtrlPMode2', s:bg0, s:blue, s:bold)
call s:HL('CtrlPStats', s:fg4, s:bg2, s:bold)

" }}}
" Startify: {{{

hi! link StartifyBracket NordboxFg3
hi! link StartifyFile NordboxFg1
hi! link StartifyNumber NordboxBlue
hi! link StartifyPath NordboxGray
hi! link StartifySlash NordboxGray
hi! link StartifySection NordboxYellow
hi! link StartifySpecial NordboxBg2
hi! link StartifyHeader NordboxOrange
hi! link StartifyFooter NordboxBg2

" }}}
" Vimshell: {{{

let g:vimshell_escape_colors = [
  \ s:bg4[0], s:red[0], s:green[0], s:yellow[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg4[0],
  \ s:bg0[0], s:red[0], s:green[0], s:orange[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg0[0]
  \ ]

" }}}
" BufTabLine: {{{

call s:HL('BufTabLineCurrent', s:bg0, s:fg4)
call s:HL('BufTabLineActive', s:fg4, s:bg2)
call s:HL('BufTabLineHidden', s:bg4, s:bg1)
call s:HL('BufTabLineFill', s:bg0, s:bg0)

" }}}
" Asynchronous Lint Engine: {{{

call s:HL('ALEError', s:none, s:none, s:undercurl, s:red)
call s:HL('ALEWarning', s:none, s:none, s:undercurl, s:yellow)
call s:HL('ALEInfo', s:none, s:none, s:undercurl, s:blue)

hi! link ALEErrorSign NordboxRedSign
hi! link ALEWarningSign NordboxYellowSign
hi! link ALEInfoSign NordboxBlueSign

" }}}
" Dirvish: {{{

hi! link DirvishPathTail NordboxAqua
hi! link DirvishArg NordboxYellow

" }}}
" Netrw: {{{

hi! link netrwDir NordboxAqua
hi! link netrwClassify NordboxAqua
hi! link netrwLink NordboxGray
hi! link netrwSymLink NordboxFg1
hi! link netrwExe NordboxYellow
hi! link netrwComment NordboxGray
hi! link netrwList NordboxBlue
hi! link netrwHelpCmd NordboxAqua
hi! link netrwCmdSep NordboxFg3
hi! link netrwVersion NordboxGreen

" }}}
" NERDTree: {{{

hi! link NERDTreeDir NordboxAqua
hi! link NERDTreeDirSlash NordboxAqua

hi! link NERDTreeOpenable NordboxOrange
hi! link NERDTreeClosable NordboxOrange

hi! link NERDTreeFile NordboxFg1
hi! link NERDTreeExecFile NordboxYellow

hi! link NERDTreeUp NordboxGray
hi! link NERDTreeCWD NordboxGreen
hi! link NERDTreeHelp NordboxFg1

hi! link NERDTreeToggleOn NordboxGreen
hi! link NERDTreeToggleOff NordboxRed

" }}}
" Vim Multiple Cursors: {{{

call s:HL('multiple_cursors_cursor', s:none, s:none, s:inverse)
call s:HL('multiple_cursors_visual', s:none, s:bg2)

" }}}
" coc.nvim: {{{

hi! link CocErrorSign NordboxRedSign
hi! link CocWarningSign NordboxOrangeSign
hi! link CocInfoSign NordboxYellowSign
hi! link CocHintSign NordboxBlueSign
hi! link CocErrorFloat NordboxRed
hi! link CocWarningFloat NordboxOrange
hi! link CocInfoFloat NordboxYellow
hi! link CocHintFloat NordboxBlue
hi! link CocDiagnosticsError NordboxRed
hi! link CocDiagnosticsWarning NordboxOrange
hi! link CocDiagnosticsInfo NordboxYellow
hi! link CocDiagnosticsHint NordboxBlue

hi! link CocSelectedText NordboxRed
hi! link CocCodeLens NordboxGray

call s:HL('CocErrorHighlight', s:none, s:none, s:undercurl, s:red)
call s:HL('CocWarningHighlight', s:none, s:none, s:undercurl, s:orange)
call s:HL('CocInfoHighlight', s:none, s:none, s:undercurl, s:yellow)
call s:HL('CocHintHighlight', s:none, s:none, s:undercurl, s:blue)

" }}}

" Filetype specific -----------------------------------------------------------
" Diff: {{{

hi! link diffAdded NordboxGreen
hi! link diffRemoved NordboxRed
hi! link diffChanged NordboxAqua

hi! link diffFile NordboxOrange
hi! link diffNewFile NordboxYellow

hi! link diffLine NordboxBlue

" }}}
" Html: {{{

hi! link htmlTag NordboxBlue
hi! link htmlEndTag NordboxBlue

hi! link htmlTagName NordboxAquaBold
hi! link htmlArg NordboxAqua

hi! link htmlScriptTag NordboxPurple
hi! link htmlTagN NordboxFg1
hi! link htmlSpecialTagName NordboxAquaBold

call s:HL('htmlLink', s:fg4, s:none, s:underline)

hi! link htmlSpecialChar NordboxOrange

call s:HL('htmlBold', s:vim_fg, s:vim_bg, s:bold)
call s:HL('htmlBoldUnderline', s:vim_fg, s:vim_bg, s:bold . s:underline)
call s:HL('htmlBoldItalic', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:vim_fg, s:vim_bg, s:bold . s:underline . s:italic)

call s:HL('htmlUnderline', s:vim_fg, s:vim_bg, s:underline)
call s:HL('htmlUnderlineItalic', s:vim_fg, s:vim_bg, s:underline . s:italic)
call s:HL('htmlItalic', s:vim_fg, s:vim_bg, s:italic)

" }}}
" Xml: {{{

hi! link xmlTag NordboxBlue
hi! link xmlEndTag NordboxBlue
hi! link xmlTagName NordboxBlue
hi! link xmlEqual NordboxBlue
hi! link docbkKeyword NordboxAquaBold

hi! link xmlDocTypeDecl NordboxGray
hi! link xmlDocTypeKeyword NordboxPurple
hi! link xmlCdataStart NordboxGray
hi! link xmlCdataCdata NordboxPurple
hi! link dtdFunction NordboxGray
hi! link dtdTagName NordboxPurple

hi! link xmlAttrib NordboxAqua
hi! link xmlProcessingDelim NordboxGray
hi! link dtdParamEntityPunct NordboxGray
hi! link dtdParamEntityDPunct NordboxGray
hi! link xmlAttribPunct NordboxGray

hi! link xmlEntity NordboxOrange
hi! link xmlEntityPunct NordboxOrange
" }}}
" Vim: {{{

call s:HL('vimCommentTitle', s:fg4_256, s:none, s:bold . s:italicize_comments)

hi! link vimNotation NordboxOrange
hi! link vimBracket NordboxOrange
hi! link vimMapModKey NordboxOrange
hi! link vimFuncSID NordboxFg3
hi! link vimSetSep NordboxFg3
hi! link vimSep NordboxFg3
hi! link vimContinue NordboxFg3

" }}}
" Clojure: {{{

hi! link clojureKeyword NordboxBlue
hi! link clojureCond NordboxOrange
hi! link clojureSpecial NordboxOrange
hi! link clojureDefine NordboxOrange

hi! link clojureFunc NordboxYellow
hi! link clojureRepeat NordboxYellow
hi! link clojureCharacter NordboxAqua
hi! link clojureStringEscape NordboxAqua
hi! link clojureException NordboxRed

hi! link clojureRegexp NordboxAqua
hi! link clojureRegexpEscape NordboxAqua
call s:HL('clojureRegexpCharClass', s:fg3, s:none, s:bold)
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureParen NordboxFg3
hi! link clojureAnonArg NordboxYellow
hi! link clojureVariable NordboxBlue
hi! link clojureMacro NordboxOrange

hi! link clojureMeta NordboxYellow
hi! link clojureDeref NordboxYellow
hi! link clojureQuote NordboxYellow
hi! link clojureUnquote NordboxYellow

" }}}
" C: {{{

hi! link cOperator NordboxPurple
hi! link cStructure NordboxOrange

" }}}
" Python: {{{

hi! link pythonBuiltin NordboxOrange
hi! link pythonBuiltinObj NordboxOrange
hi! link pythonBuiltinFunc NordboxOrange
hi! link pythonFunction NordboxAqua
hi! link pythonDecorator NordboxRed
hi! link pythonInclude NordboxBlue
hi! link pythonImport NordboxBlue
hi! link pythonRun NordboxBlue
hi! link pythonCoding NordboxBlue
hi! link pythonOperator NordboxRed
hi! link pythonException NordboxRed
hi! link pythonExceptions NordboxPurple
hi! link pythonBoolean NordboxPurple
hi! link pythonDot NordboxFg3
hi! link pythonConditional NordboxRed
hi! link pythonRepeat NordboxRed
hi! link pythonDottedName NordboxGreenBold

" }}}
" CSS: {{{

hi! link cssBraces NordboxBlue
hi! link cssFunctionName NordboxYellow
hi! link cssIdentifier NordboxOrange
hi! link cssClassName NordboxGreen
hi! link cssColor NordboxBlue
hi! link cssSelectorOp NordboxBlue
hi! link cssSelectorOp2 NordboxBlue
hi! link cssImportant NordboxGreen
hi! link cssVendor NordboxFg1

hi! link cssTextProp NordboxAqua
hi! link cssAnimationProp NordboxAqua
hi! link cssUIProp NordboxYellow
hi! link cssTransformProp NordboxAqua
hi! link cssTransitionProp NordboxAqua
hi! link cssPrintProp NordboxAqua
hi! link cssPositioningProp NordboxYellow
hi! link cssBoxProp NordboxAqua
hi! link cssFontDescriptorProp NordboxAqua
hi! link cssFlexibleBoxProp NordboxAqua
hi! link cssBorderOutlineProp NordboxAqua
hi! link cssBackgroundProp NordboxAqua
hi! link cssMarginProp NordboxAqua
hi! link cssListProp NordboxAqua
hi! link cssTableProp NordboxAqua
hi! link cssFontProp NordboxAqua
hi! link cssPaddingProp NordboxAqua
hi! link cssDimensionProp NordboxAqua
hi! link cssRenderProp NordboxAqua
hi! link cssColorProp NordboxAqua
hi! link cssGeneratedContentProp NordboxAqua

" }}}
" JavaScript: {{{

hi! link javaScriptBraces NordboxFg1
hi! link javaScriptFunction NordboxAqua
hi! link javaScriptIdentifier NordboxRed
hi! link javaScriptMember NordboxBlue
hi! link javaScriptNumber NordboxPurple
hi! link javaScriptNull NordboxPurple
hi! link javaScriptParens NordboxFg3

" }}}
" YAJS: {{{

hi! link javascriptImport NordboxAqua
hi! link javascriptExport NordboxAqua
hi! link javascriptClassKeyword NordboxAqua
hi! link javascriptClassExtends NordboxAqua
hi! link javascriptDefault NordboxAqua

hi! link javascriptClassName NordboxYellow
hi! link javascriptClassSuperName NordboxYellow
hi! link javascriptGlobal NordboxYellow

hi! link javascriptEndColons NordboxFg1
hi! link javascriptFuncArg NordboxFg1
hi! link javascriptGlobalMethod NordboxFg1
hi! link javascriptNodeGlobal NordboxFg1
hi! link javascriptBOMWindowProp NordboxFg1
hi! link javascriptArrayMethod NordboxFg1
hi! link javascriptArrayStaticMethod NordboxFg1
hi! link javascriptCacheMethod NordboxFg1
hi! link javascriptDateMethod NordboxFg1
hi! link javascriptMathStaticMethod NordboxFg1

" hi! link javascriptProp NordboxFg1
hi! link javascriptURLUtilsProp NordboxFg1
hi! link javascriptBOMNavigatorProp NordboxFg1
hi! link javascriptDOMDocMethod NordboxFg1
hi! link javascriptDOMDocProp NordboxFg1
hi! link javascriptBOMLocationMethod NordboxFg1
hi! link javascriptBOMWindowMethod NordboxFg1
hi! link javascriptStringMethod NordboxFg1

hi! link javascriptVariable NordboxOrange
" hi! link javascriptVariable NordboxRed
" hi! link javascriptIdentifier NordboxOrange
" hi! link javascriptClassSuper NordboxOrange
hi! link javascriptIdentifier NordboxOrange
hi! link javascriptClassSuper NordboxOrange

" hi! link javascriptFuncKeyword NordboxOrange
" hi! link javascriptAsyncFunc NordboxOrange
hi! link javascriptFuncKeyword NordboxAqua
hi! link javascriptAsyncFunc NordboxAqua
hi! link javascriptClassStatic NordboxOrange

hi! link javascriptOperator NordboxRed
hi! link javascriptForOperator NordboxRed
hi! link javascriptYield NordboxRed
hi! link javascriptExceptions NordboxRed
hi! link javascriptMessage NordboxRed

hi! link javascriptTemplateSB NordboxAqua
hi! link javascriptTemplateSubstitution NordboxFg1

" hi! link javascriptLabel NordboxBlue
" hi! link javascriptObjectLabel NordboxBlue
" hi! link javascriptPropertyName NordboxBlue
hi! link javascriptLabel NordboxFg1
hi! link javascriptObjectLabel NordboxFg1
hi! link javascriptPropertyName NordboxFg1

hi! link javascriptLogicSymbols NordboxFg1
hi! link javascriptArrowFunc NordboxYellow

hi! link javascriptDocParamName NordboxFg4
hi! link javascriptDocTags NordboxFg4
hi! link javascriptDocNotation NordboxFg4
hi! link javascriptDocParamType NordboxFg4
hi! link javascriptDocNamedParamType NordboxFg4

hi! link javascriptBrackets NordboxFg1
hi! link javascriptDOMElemAttrs NordboxFg1
hi! link javascriptDOMEventMethod NordboxFg1
hi! link javascriptDOMNodeMethod NordboxFg1
hi! link javascriptDOMStorageMethod NordboxFg1
hi! link javascriptHeadersMethod NordboxFg1

hi! link javascriptAsyncFuncKeyword NordboxRed
hi! link javascriptAwaitFuncKeyword NordboxRed

" }}}
" PanglossJS: {{{

hi! link jsClassKeyword NordboxAqua
hi! link jsExtendsKeyword NordboxAqua
hi! link jsExportDefault NordboxAqua
hi! link jsTemplateBraces NordboxAqua
hi! link jsGlobalNodeObjects NordboxFg1
hi! link jsGlobalObjects NordboxFg1
hi! link jsFunction NordboxAqua
hi! link jsFuncParens NordboxFg3
hi! link jsParens NordboxFg3
hi! link jsNull NordboxPurple
hi! link jsUndefined NordboxPurple
hi! link jsClassDefinition NordboxYellow

" }}}
" TypeScript: {{{

hi! link typeScriptReserved NordboxAqua
hi! link typeScriptLabel NordboxAqua
hi! link typeScriptFuncKeyword NordboxAqua
hi! link typeScriptIdentifier NordboxOrange
hi! link typeScriptBraces NordboxFg1
hi! link typeScriptEndColons NordboxFg1
hi! link typeScriptDOMObjects NordboxFg1
hi! link typeScriptAjaxMethods NordboxFg1
hi! link typeScriptLogicSymbols NordboxFg1
hi! link typeScriptDocSeeTag Comment
hi! link typeScriptDocParam Comment
hi! link typeScriptDocTags vimCommentTitle
hi! link typeScriptGlobalObjects NordboxFg1
hi! link typeScriptParens NordboxFg3
hi! link typeScriptOpSymbols NordboxFg3
hi! link typeScriptHtmlElemProperties NordboxFg1
hi! link typeScriptNull NordboxPurple
hi! link typeScriptInterpolationDelimiter NordboxAqua

" }}}
" PureScript: {{{

hi! link purescriptModuleKeyword NordboxAqua
hi! link purescriptModuleName NordboxFg1
hi! link purescriptWhere NordboxAqua
hi! link purescriptDelimiter NordboxFg4
hi! link purescriptType NordboxFg1
hi! link purescriptImportKeyword NordboxAqua
hi! link purescriptHidingKeyword NordboxAqua
hi! link purescriptAsKeyword NordboxAqua
hi! link purescriptStructure NordboxAqua
hi! link purescriptOperator NordboxBlue

hi! link purescriptTypeVar NordboxFg1
hi! link purescriptConstructor NordboxFg1
hi! link purescriptFunction NordboxFg1
hi! link purescriptConditional NordboxOrange
hi! link purescriptBacktick NordboxOrange

" }}}
" CoffeeScript: {{{

hi! link coffeeExtendedOp NordboxFg3
hi! link coffeeSpecialOp NordboxFg3
hi! link coffeeCurly NordboxOrange
hi! link coffeeParen NordboxFg3
hi! link coffeeBracket NordboxOrange

" }}}
" Ruby: {{{

hi! link rubyStringDelimiter NordboxGreen
hi! link rubyInterpolationDelimiter NordboxAqua

" }}}
" ObjectiveC: {{{

hi! link objcTypeModifier NordboxRed
hi! link objcDirective NordboxBlue

" }}}
" Go: {{{

hi! link goDirective NordboxAqua
hi! link goConstants NordboxPurple
hi! link goDeclaration NordboxRed
hi! link goDeclType NordboxBlue
hi! link goBuiltins NordboxOrange

" }}}
" Lua: {{{

hi! link luaIn NordboxRed
hi! link luaFunction NordboxAqua
hi! link luaTable NordboxOrange

" }}}
" MoonScript: {{{

hi! link moonSpecialOp NordboxFg3
hi! link moonExtendedOp NordboxFg3
hi! link moonFunction NordboxFg3
hi! link moonObject NordboxYellow

" }}}
" Java: {{{

hi! link javaAnnotation NordboxBlue
hi! link javaDocTags NordboxAqua
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen NordboxFg3
hi! link javaParen1 NordboxFg3
hi! link javaParen2 NordboxFg3
hi! link javaParen3 NordboxFg3
hi! link javaParen4 NordboxFg3
hi! link javaParen5 NordboxFg3
hi! link javaOperator NordboxOrange

hi! link javaVarArg NordboxGreen

" }}}
" Elixir: {{{

hi! link elixirDocString Comment

hi! link elixirStringDelimiter NordboxGreen
hi! link elixirInterpolationDelimiter NordboxAqua

hi! link elixirModuleDeclaration NordboxYellow

" }}}
" Scala: {{{

" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition NordboxFg1
hi! link scalaCaseFollowing NordboxFg1
hi! link scalaCapitalWord NordboxFg1
hi! link scalaTypeExtension NordboxFg1

hi! link scalaKeyword NordboxRed
hi! link scalaKeywordModifier NordboxRed

hi! link scalaSpecial NordboxAqua
hi! link scalaOperator NordboxFg1

hi! link scalaTypeDeclaration NordboxYellow
hi! link scalaTypeTypePostDeclaration NordboxYellow

hi! link scalaInstanceDeclaration NordboxFg1
hi! link scalaInterpolation NordboxAqua

" }}}
" Markdown: {{{

call s:HL('markdownItalic', s:fg3, s:none, s:italic)

hi! link markdownH1 NordboxGreenBold
hi! link markdownH2 NordboxGreenBold
hi! link markdownH3 NordboxYellowBold
hi! link markdownH4 NordboxYellowBold
hi! link markdownH5 NordboxYellow
hi! link markdownH6 NordboxYellow

hi! link markdownCode NordboxAqua
hi! link markdownCodeBlock NordboxAqua
hi! link markdownCodeDelimiter NordboxAqua

hi! link markdownBlockquote NordboxGray
hi! link markdownListMarker NordboxGray
hi! link markdownOrderedListMarker NordboxGray
hi! link markdownRule NordboxGray
hi! link markdownHeadingRule NordboxGray

hi! link markdownUrlDelimiter NordboxFg3
hi! link markdownLinkDelimiter NordboxFg3
hi! link markdownLinkTextDelimiter NordboxFg3

hi! link markdownHeadingDelimiter NordboxOrange
hi! link markdownUrl NordboxPurple
hi! link markdownUrlTitleDelimiter NordboxGreen

call s:HL('markdownLinkText', s:gray, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

" }}}
" Haskell: {{{

" hi! link haskellType NordboxYellow
" hi! link haskellOperators NordboxOrange
" hi! link haskellConditional NordboxAqua
" hi! link haskellLet NordboxOrange
"
hi! link haskellType NordboxFg1
hi! link haskellIdentifier NordboxFg1
hi! link haskellSeparator NordboxFg1
hi! link haskellDelimiter NordboxFg4
hi! link haskellOperators NordboxBlue
"
hi! link haskellBacktick NordboxOrange
hi! link haskellStatement NordboxOrange
hi! link haskellConditional NordboxOrange

hi! link haskellLet NordboxAqua
hi! link haskellDefault NordboxAqua
hi! link haskellWhere NordboxAqua
hi! link haskellBottom NordboxAqua
hi! link haskellBlockKeywords NordboxAqua
hi! link haskellImportKeywords NordboxAqua
hi! link haskellDeclKeyword NordboxAqua
hi! link haskellDeriving NordboxAqua
hi! link haskellAssocType NordboxAqua

hi! link haskellNumber NordboxPurple
hi! link haskellPragma NordboxPurple

hi! link haskellString NordboxGreen
hi! link haskellChar NordboxGreen

" }}}
" Json: {{{

hi! link jsonKeyword NordboxGreen
hi! link jsonQuote NordboxGreen
hi! link jsonBraces NordboxFg1
hi! link jsonString NordboxFg1

" }}}


" Functions -------------------------------------------------------------------
" Search Highlighting Cursor {{{

function! NordboxHlsShowCursor()
  call s:HL('Cursor', s:bg0, s:hls_cursor)
endfunction

function! NordboxHlsHideCursor()
  call s:HL('Cursor', s:none, s:none, s:inverse)
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
