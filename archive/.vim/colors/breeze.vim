" Maintainer:   Chris Laskey
" Version:   1.4.0
" Created:  2011-10-08
" Updated:  2016-06-16

" Note: colorscheme is updated for terminal colors.
"       Used primarily on the command line, GUI based colors have not been updates since
"       the 2012-04-13 update.

" Common Colors:
"   Gold 156
"   Light blue 152
"   Bright orange 172
"   Bright green 154

" Settings
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "breeze"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine    guibg=#212121 gui=none ctermbg=234
  hi CursorColumn  guibg=#212121 ctermbg=234
  hi MatchParen    guifg=#f92672 guibg=NONE gui=none ctermfg=127 ctermbg=16 cterm=underline
  hi Pmenu         guifg=#ffffff guibg=#181818 ctermfg=255 ctermbg=238
  hi PmenuSel      guifg=#000000 guibg=#b1d631 ctermfg=0 ctermbg=148
endif

" General colors
hi Cursor          guifg=NONE    guibg=#626262 gui=none ctermbg=236
hi Normal          guifg=#f6f3e8 guibg=#181818 gui=none ctermfg=253 ctermbg=16
hi NonText         guifg=#303030 guibg=#181818 gui=none ctermfg=235 ctermbg=16
hi LineNr          guifg=#303030 guibg=#181818 gui=none ctermfg=236 ctermbg=16
hi ErrorMsg        guifg=#ff0000 ctermfg=196 ctermbg=16
hi WarningMsg      guifg=#ff0000 gui=none ctermfg=196 ctermbg=16
hi StatusLine      guifg=#d3d3d5 guibg=#212121 gui=none ctermfg=253 ctermbg=236
hi StatusLineNC    guifg=#939395 guibg=#212121 gui=none ctermfg=246 ctermbg=236
hi VertSplit       guifg=#444444 guibg=#262626 gui=none ctermfg=238 ctermbg=238
hi Folded          guifg=#666666 guibg=#262626 gui=none ctermfg=67  ctermbg=16
hi Title           guifg=#f6f3e8 guibg=NONE    gui=none ctermfg=254 cterm=bold
hi Visual          guifg=#f92672 guibg=#212121 gui=none ctermfg=161 ctermbg=NONE
hi SpecialKey      guifg=#303030 guibg=#181818 gui=none ctermfg=235 ctermbg=16
hi TabLine         ctermfg=242 ctermbg=234 cterm=none
hi TabLineFill     ctermfg=234
hi TabLineSel      ctermfg=190 ctermbg=16

" Syntax highlighting
hi Error           guifg=#ff0000 gui=none ctermfg=196 ctermbg=16
if hlexists('SpellBad') 
    hi SpellBad    guifg=#ff0000 gui=none ctermfg=196 ctermbg=16
endif
hi Search          guifg=#ffff00 gui=none ctermbg=190
hi Comment         guifg=#444444 gui=italic ctermfg=238
hi Boolean         guifg=#b1d631 gui=none ctermfg=152
hi String          guifg=#808080 gui=none ctermfg=152
hi Function        guifg=#ffff00 gui=none ctermfg=255
hi Constant        guifg=#b1d631 gui=none ctermfg=154
hi Number          guifg=#b1d631 gui=none ctermfg=154
hi PreProc         guifg=#faf4c6 gui=none ctermfg=230
hi Todo            guifg=#ff9f00 guibg=#181818 gui=none ctermfg=161 ctermbg=NONE
" If/elses
hi Type            guifg=#7e8aa2 gui=none ctermfg=103
hi Statement       guifg=#7e8aa2 gui=none ctermfg=103
hi Keyword         guifg=#c2d6e3 gui=none ctermfg=227
hi Identifier      guifg=#c2d6e3 gui=none ctermfg=148
hi Special         guifg=#c2d6e3 gui=none ctermfg=208

" Code-specific colors:
hi htmlItalic      cterm=none ctermfg=none ctermbg=none
hi htmlLink        cterm=underline ctermfg=242 ctermbg=none
hi htmlString      cterm=none ctermfg=253 ctermbg=none
hi htmlTag         cterm=none ctermfg=103 ctermbg=none
hi htmlEndTag      cterm=none ctermfg=103 ctermbg=none
hi htmlTagName     cterm=none ctermfg=153 ctermbg=none
hi htmlSpecialTagName cterm=none ctermfg=153 ctermbg=none
hi htmlArg         cterm=none ctermfg=153 ctermbg=none
hi htmlSpecialChar cterm=none ctermfg=253 ctermbg=none
hi htmlHead        cterm=none ctermfg=none ctermbg=none
hi htmlTitle       cterm=none ctermfg=none ctermbg=none
hi htmlH1          cterm=none ctermfg=none ctermbg=none
hi htmlH2          cterm=none ctermfg=none ctermbg=none
hi htmlH3          cterm=none ctermfg=none ctermbg=none
hi htmlH4          cterm=none ctermfg=none ctermbg=none
hi htmlH5          cterm=none ctermfg=none ctermbg=none
" HTML Brackets
hi htmlKeyword     guifg=#c2d6e3 gui=none ctermfg=227

" Code-specific colors PHP
hi Delimiter       cterm=none ctermfg=190 ctermbg=none
hi phpRegion       cterm=none ctermfg=255 ctermbg=none
hi phpFunctions    cterm=none ctermfg=153 ctermbg=none
" PHP Brackets
hi phpSpecial      cterm=none ctermfg=103 ctermbg=none
hi phpType         cterm=none ctermfg=103 ctermbg=none
hi phpIdentifier   cterm=none ctermfg=153 ctermbg=none
hi phpVarSelector  cterm=none ctermfg=103 ctermbg=none
hi phpParent       cterm=none ctermfg=153 ctermbg=none
hi phpStringSingle cterm=none ctermfg=245 ctermbg=none
hi phpStringDouble cterm=none ctermfg=245 ctermbg=none
hi phpOperator     cterm=none ctermfg=245 ctermbg=none
hi phpNumber       cterm=none ctermfg=190 ctermbg=none

" Code-specific colors Javascript
hi javascript           cterm=none ctermfg=none ctermbg=none
hi javascriptIdentifier cterm=none ctermfg=190 ctermbg=none
hi javascriptMember     cterm=none ctermfg=154 ctermbg=none
hi javascriptFunction   cterm=none ctermfg=154 ctermbg=none
hi javascriptBraces     cterm=none ctermfg=154 ctermbg=none
" Code-specific colors for JavavScript using `vim-javascript`
hi jsStorageClass       cterm=none ctermfg=133 ctermbg=none
hi jsModules            cterm=none ctermfg=227 ctermbg=none
hi jsModuleWords        cterm=none ctermfg=227 ctermbg=none
hi jsStringD            cterm=none ctermfg=152 ctermbg=none
hi jsBraces             cterm=none ctermfg=154 ctermbg=none
hi jsFuncBraces         cterm=none ctermfg=154 ctermbg=none
hi jsBrackets           cterm=none ctermfg=154 ctermbg=none
hi jsNumber             cterm=none ctermfg=152 ctermbg=none
hi jsThis               cterm=none ctermfg=220 ctermbg=none
hi jsTemplateVar        cterm=none ctermfg=none ctermbg=none
hi jsTemplateBraces     cterm=none ctermfg=none ctermbg=none
" Code-specific colors for JavavScript using `vim-jsx`
hi xmlTag               cterm=none ctermfg=152 ctermbg=none
hi xmlTagName           cterm=none ctermfg=152 ctermbg=none
hi xmlEndTag            cterm=none ctermfg=152 ctermbg=none
hi xmlString            cterm=none ctermfg=152 ctermbg=none
hi xmlAttrib            cterm=none ctermfg=152 ctermbg=none
hi xmlEqual             cterm=none ctermfg=152 ctermbg=none
hi jsxRegion            cterm=none ctermfg=152 ctermbg=none

" Code-specific colors Python
hi pythonFunction  guifg=#009000 gui=none ctermfg=190
hi pythonString    guifg=#009000 gui=none ctermfg=153
hi pythonImport    guifg=#009000 gui=none ctermfg=255
hi pythonException guifg=#f00000 gui=none ctermfg=200
hi pythonOperator  guifg=#7e8aa2 gui=none ctermfg=154
hi pythonBuiltinFunction guifg=#009000 gui=none ctermfg=200
hi pythonExClass   guifg=#009000 gui=none ctermfg=200
hi pythonDot       guifg=#009000 gui=none ctermfg=187
hi pythonError     guifg=#009000 gui=none ctermfg=18
hi NonText         guifg=#000000 guibg=#181818 gui=none ctermfg=16 ctermbg=16
hi ColorColumn     guifg=#000000 guibg=#181818 gui=none ctermfg=1 ctermbg=16

" Colors for Indent Guides plugin (not required, will choose other template
" defaults if not defined)
hi IndentGuidesOdd  guifg=#222222 guibg=#000000 gui=none ctermbg=3
hi IndentGuidesEven guifg=#222222 guibg=#101010 gui=none ctermbg=4

" Colors for Nerd Tree plugin (not required, will choose other template
" defaults if not defined)
hi treeFile         ctermfg=7
hi treeDir          ctermfg=117
hi treeLink         ctermfg=148
hi treeDirSlash     ctermfg=0
hi treePart         ctermfg=0
hi treePartFile     ctermfg=0
hi treeOpenable     ctermfg=0
hi treeClosable     ctermfg=0
hi treeHelp         ctermfg=0
