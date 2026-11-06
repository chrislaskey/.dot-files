
" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.


" Unknown Theme - A nice dark theme

" ==========> Reset
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'unknown-theme'

" ==========> Highlight function
function! s:h(face, guibg, guifg, ctermbg, ctermfg, gui)
  let l:cmd="highlight " . a:face
  
  if a:guibg != ""
    let l:cmd = l:cmd . " guibg=" . a:guibg
  endif

  if a:guifg != ""
    let l:cmd = l:cmd . " guifg=" . a:guifg
  endif

  if a:ctermbg != ""
    let l:cmd = l:cmd . " ctermbg=" . a:ctermbg
  endif

  if a:ctermfg != ""
    let l:cmd = l:cmd . " ctermfg=" . a:ctermfg
  endif

  if a:gui != ""
    let l:cmd = l:cmd . " gui=" . a:gui
  endif

  exec l:cmd
endfun


" ==========> Colors dictionary

" GUI colors dictionary (hex)
let s:hex = {}
" Terminal colors dictionary (256)
let s:bit = {}

let s:hex.color0="#1a1a1a"
let s:hex.color1="#d8dee9"
let s:hex.color2="#ffffff"
let s:hex.color3="#474747"
let s:hex.color4="#242424"
let s:hex.color5="#4c4c4c"
let s:hex.color6="#2e2e2e"
let s:hex.color7="#606060"
let s:hex.color8="#282828"
let s:hex.color9="#ecf2fd"
let s:hex.color10="#414141"
let s:hex.color11="#656565"
let s:hex.color12="#db9c6c"
let s:hex.color13="#383838"
let s:hex.color14="#f6fcff"
let s:hex.color15="#e2e8f3"
let s:hex.color16="#3d3d3d"
let s:hex.color17="#D6D6DD"
let s:hex.color18="#EFB080"
let s:hex.color19="#83D6C5"
let s:hex.color20="#E394DC"
let s:hex.color21="#EBC88D"

let s:bit.color7="59"
let s:bit.color14="116"
let s:bit.color15="176"
let s:bit.color10="179"
let s:bit.color16="186"
let s:bit.color12="188"
let s:bit.color13="216"
let s:bit.color2="231"
let s:bit.color0="234"
let s:bit.color4="235"
let s:bit.color6="236"
let s:bit.color11="237"
let s:bit.color3="238"
let s:bit.color5="239"
let s:bit.color9="241"
let s:bit.color1="254"
let s:bit.color8="255"


" ==========> General highlights 
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color2, "", s:bit.color2, "", "none")
call s:h("Visual", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("ColorColumn", s:hex.color4, "", s:bit.color4, "", "none")
call s:h("LineNr", "", s:hex.color5, "", s:bit.color5, "none")
call s:h("CursorLine", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("CursorLineNr", "", s:hex.color7, "", s:bit.color7, "none")
call s:h("CursorColumn", s:hex.color6, "", s:bit.color6, "", "none")
call s:h("StatusLineNC", s:hex.color8, s:hex.color9, s:bit.color4, s:bit.color8, "none")
call s:h("StatusLine", s:hex.color10, s:hex.color2, s:bit.color3, s:bit.color2, "none")
call s:h("VertSplit", "", s:hex.color11, "", s:bit.color9, "none")
call s:h("Folded", s:hex.color6, s:hex.color12, s:bit.color6, s:bit.color10, "none")
call s:h("Pmenu", s:hex.color13, s:hex.color14, s:bit.color11, s:bit.color2, "none")
call s:h("PmenuSel", s:hex.color4, s:hex.color15, s:bit.color4, s:bit.color8, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color16, s:bit.color0, s:bit.color11, "none")
call s:h("NonText", s:hex.color0, s:hex.color16, s:bit.color0, s:bit.color11, "none")


" ==========> Syntax highlights
call s:h("Identifier", "", s:hex.color17, "", s:bit.color12, "none")
call s:h("Function", "", s:hex.color18, "", s:bit.color13, "none")
call s:h("Statement", "", s:hex.color19, "", s:bit.color14, "none")
call s:h("Operator", "", s:hex.color17, "", s:bit.color12, "none")
call s:h("PreProc", "", s:hex.color19, "", s:bit.color14, "none")
call s:h("Type", "", s:hex.color19, "", s:bit.color14, "none")
call s:h("String", "", s:hex.color20, "", s:bit.color15, "none")
call s:h("Number", "", s:hex.color21, "", s:bit.color16, "none")

highlight link cStatement Statement
highlight link cSpecial Special


" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.
