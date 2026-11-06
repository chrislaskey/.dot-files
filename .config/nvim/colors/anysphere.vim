
" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.


" Anysphere dark - A nice  theme

" ==========> Reset
set background=

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'anysphere-dark'

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

let s:hex.color0="#181818"
let s:hex.color1="#d6d6dd"
let s:hex.color2="#163761"
let s:hex.color3="#0e0e0e"
let s:hex.color4="#000000"
let s:hex.color5="#040404"
let s:hex.color6="#c2c2c9"
let s:hex.color7="#a9a9b0"
let s:hex.color8="#b8b8bf"
let s:hex.color9="#ccccd3"
let s:hex.color10="#D6D6DD"
let s:hex.color11="#83D6C5"
let s:hex.color12="#E394DC"
let s:hex.color13="#EBC88D"

let s:bit.color4="16"
let s:bit.color2="23"
let s:bit.color9="116"
let s:bit.color10="176"
let s:bit.color11="186"
let s:bit.color1="188"
let s:bit.color3="233"
let s:bit.color0="234"
let s:bit.color6="248"
let s:bit.color7="250"
let s:bit.color5="251"
let s:bit.color8="252"


" ==========> General highlights 
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Cursor", s:hex.color1, s:hex.color0, s:bit.color1, s:bit.color0, "none")
call s:h("Visual", s:hex.color2, "", s:bit.color2, "", "none")
call s:h("ColorColumn", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("LineNr", "", s:hex.color4, "", s:bit.color4, "none")
call s:h("CursorLine", s:hex.color5, "", s:bit.color4, "", "none")
call s:h("CursorLineNr", "", s:hex.color4, "", s:bit.color4, "none")
call s:h("CursorColumn", s:hex.color5, "", s:bit.color4, "", "none")
call s:h("StatusLineNC", s:hex.color5, s:hex.color6, s:bit.color4, s:bit.color5, "none")
call s:h("StatusLine", s:hex.color4, s:hex.color7, s:bit.color4, s:bit.color6, "none")
call s:h("VertSplit", "", s:hex.color4, "", s:bit.color4, "none")
call s:h("Folded", s:hex.color5, "", s:bit.color4, "", "none")
call s:h("Pmenu", s:hex.color4, s:hex.color8, s:bit.color4, s:bit.color7, "none")
call s:h("PmenuSel", s:hex.color3, s:hex.color9, s:bit.color3, s:bit.color8, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color4, s:bit.color0, s:bit.color4, "none")
call s:h("NonText", s:hex.color0, s:hex.color4, s:bit.color0, s:bit.color4, "none")


" ==========> Syntax highlights
call s:h("Identifier", "", s:hex.color10, "", s:bit.color1, "none")
call s:h("Statement", "", s:hex.color11, "", s:bit.color9, "none")
call s:h("Operator", "", s:hex.color10, "", s:bit.color1, "none")
call s:h("PreProc", "", s:hex.color11, "", s:bit.color9, "none")
call s:h("Type", "", s:hex.color11, "", s:bit.color9, "none")
call s:h("String", "", s:hex.color12, "", s:bit.color10, "none")
call s:h("Number", "", s:hex.color13, "", s:bit.color11, "none")

highlight link cStatement Statement
highlight link cSpecial Special


" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.

