setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab

if exists('+colorcolumn')
	" Vim 7.3+ includes colorcolumn option, which highlights columns over the defined width
	" set colorcolumn=80

	" Alternatively can be set relative to textwidth:
	set colorcolumn=+1
else
	" If support doesn't exist add ErrorMsg syntax highlighting
	let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
