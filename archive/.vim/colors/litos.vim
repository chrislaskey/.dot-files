" Author:	Chris Laskey <contact@chrislaskey.com>
" Version:	v0.0.1 - 2011-09-11
" Credits:	Inspired by dark themes Mustang, Wombat, and Busy Bee

" === Notes ===
" Null values (None):
"	Color values require NONE in capitals (*fg/*bg)
"	Non-color values accept 'none' in lowercase

" === Basic setup values ===
set background=dark
hi clear
if exists('syntax_on')
	syntax reset
endif
let colors_name='litos'

" === Vim >= 7.0 specific colors ===
if version >= 700
	if exists('+colorcolumn') " 7.3+ Option
		hi ColorColumn	guibg=#201616 ctermbg=darkgrey
	endif
	hi CursorLine	guibg=#242424 ctermbg=234
	hi CursorColumn	guibg=#242424 ctermbg=234
	hi MatchParen	guifg=#f92672 guibg=NONE gui=bold ctermfg=157 ctermbg=237 cterm=bold
	hi Pmenu		guifg=#ffffff guibg=#181818 ctermfg=255 ctermbg=238
	hi PmenuSel		guifg=#000000 guibg=#b1d631 ctermfg=0 ctermbg=148
endif

" === General colors (:help highlight-groups) ===
hi Cursor		guifg=NONE guibg=#626262 gui=none ctermbg=241
hi ErrorMsg		guifg=NONE
hi Folded		guifg=#cccccc guibg=#303030 gui=none ctermbg=4   ctermfg=248
hi IncSearch	guifg=#fa25ed guibg=NONE    gui=none ctermfg=254 ctermbg=4
hi LineNr		guifg=#383838 guibg=#181818 gui=none ctermfg=244 ctermbg=232
hi ModeMsg		guifg=NONE    guibg=NONE    gui=none
hi Normal		guifg=#f6f3e8 guibg=#181818 gui=none ctermfg=253 ctermbg=234
hi NonText		guifg=#383838 guibg=#181818 gui=none ctermfg=244 ctermbg=235
hi Question		guifg=NONE
hi Search		guifg=#fa25ed guibg=NONE    gui=none ctermfg=254 ctermbg=4
hi SpecialKey	guifg=#303030 guibg=#181818 gui=none ctermfg=244 ctermbg=236
hi StatusLine	guifg=#d3d3d5 guibg=#242424 gui=none ctermfg=253 ctermbg=238
hi StatusLineNC	guifg=#939395 guibg=#212121 gui=none ctermfg=246 ctermbg=238
hi Title		guifg=#f6f3e8 guibg=NONE	gui=none ctermfg=254 cterm=bold
hi VertSplit	guifg=#444444 guibg=#262626 gui=none ctermfg=238 ctermbg=238
hi Visual		guifg=#f92672 guibg=#212121 gui=none ctermfg=254 ctermbg=4

" === Syntax highlighting ===
hi Boolean		guifg=#b1d631 gui=none   ctermfg=148
hi Comment		guifg=#444444 gui=italic ctermfg=244
hi Constant		guifg=#b1d631 gui=none   ctermfg=208
hi Function		guifg=#ffff00 gui=none   ctermfg=255
hi Identifier	guifg=#c2d6e3 gui=none   ctermfg=148
hi Keyword		guifg=#c2d6e3 gui=none   ctermfg=208
hi Number		guifg=#b1d631 gui=none   ctermfg=208
hi PreProc		guifg=#faf4c6 gui=none   ctermfg=230
hi Special		guifg=#c2d6e3 gui=none   ctermfg=208
hi Statement	guifg=#7e8aa2 gui=none   ctermfg=103
hi String		guifg=#808080 gui=none   ctermfg=148
hi Todo			guifg=#ff9f00 guibg=#181818 gui=italic ctermfg=245
hi Type			guifg=#7e8aa2 gui=none   ctermfg=103

" === Language specific ===

	" --- Python ---
	hi pythonImport				guifg=#009000 gui=none ctermfg=255
	hi pythonException			guifg=#f00000 gui=none ctermfg=200
	hi pythonOperator			guifg=#7e8aa2 gui=none ctermfg=103
	hi pythonBuiltinFunction	guifg=#009000 gui=none ctermfg=200
	hi pythonExClass			guifg=#009000 gui=none ctermfg=200

" === Plugin specific ===

	" --- NerdTree ---
	" hi treePart		
	" hi treeCWD			guifg=#ff9f00 gui=none
	" hi treeDir			guifg=#b1d631 gui=none
	" hi treeExecFile		guifg=#b1d631 gui=none
	" hi treeFile			guifg=#b1d631 gui=none
	" hi treeUp			guifg=#b1d631 gui=none

" Colors for Indent Guides plugin (not required, will choose other template
" defaults if not defined)
" hi IndentGuidesOdd  guifg=#222222 guibg=#000000 gui=none ctermbg=3
" hi IndentGuidesEven guifg=#222222 guibg=#101010 gui=none ctermbg=4

