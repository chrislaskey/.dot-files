" Disable GUI interface elements
set guioptions-=m " Disable menubar
set guioptions-=T " Disable toolbar
set guioptions-=r " Disable right scroll-bar

" Turn off beeping
set noerrorbells 
set visualbell
autocmd VimEnter * set vb t_vb= " Make the visual bell zero time, so it doesn't blink.

