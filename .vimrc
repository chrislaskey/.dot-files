" General settings
" ==============================================================================
set nocompatible

" Number characters before swap file is created,
" default is 200, 10000 in read only mode.
set updatecount=100
set undolevels=1000
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set viminfo='1000,n~/.vim/history/viminfo.history

if has('undodir')
	set undodir=~/.vim/undo
endif

set encoding=utf-8
set termencoding=utf-8

set autoread " Auto-reload modified files with no local changes
set modeline " Allow in-line VIM overrides within a file.

" Source the vimrc file after saving it
" Disabled as it causes exponentially increasing file write times
" in MacVim 7.3.
if has('autocmd')
	" autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Pathogen (package manager for vim plugins by Tim Pope)
" Turn filetype off momentarily to fix an issue in Debian.
" This needs to be off before pathogen calls.
" Turn filetype back on below.
filetype off
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Filetype general (this must come after pathogen)
filetype on
filetype plugin on
filetype indent on

" set wildmenu " More advanced listing when using tab auto complete
" set wildmode=list,full " Determines the way the advanced listing is displayed
set wildignore+=.svn/*,.git/*,.hg/*,*.gif,*.jpg,*.jpeg,*.png,*.pdf
set wildignore+=*.docx,*.doc,*.ppt,*.pptx,*.psd,*.pyc,*.DS_Store

" Program settings
" ------------------------------------------------------------------------------

" Set timeout length to be quicker than the default 1000
" Great for leader based commands
set timeoutlen=500

" Turn off beeping
" On buffer enter make the visual bell zero time, so it doesn't blink.
set noerrorbells
set visualbell
if has('autocmd')
	autocmd VimEnter * set vb t_vb=
endif

" Disable GUI interface elements
"	Also add these lines to .gvimrc to turn it off in gvim/macvim
set guioptions-=m " Disable menubar
set guioptions-=T " Disable toolbar
set guioptions-=r " Disable right scroll-bar
set guioptions-=R " Disable right scroll-bar
set guioptions-=l " Disable left scroll-bar
set guioptions-=L " Disable left scroll-bar


" Path settings
" ------------------------------------------------------------------------------
if has('autochdir')
	set autochdir " Automatically set pwd/cwd to file's parent directory
endif

" If current path is part of a git or mercurial repository it will
" change the directory root to the repository root
function! s:set_working_directory_for_project()
	let wd = expand("%:p:h")
	silent exe "cd " . wd

	let git_root = s:git_root()
	if git_root != ""
		silent exe "cd " . git_root
		return
	endif

	let hg_root = s:mercurial_root()
	if hg_root != ""
		silent exe "cd " . hg_root
		return
	endif
endfunction

" mercurial_root() returns the repository root if the current path is
" within a mercurial repository.
function! s:mercurial_root()
	let mercurial_root = system('hg root')

	if v:shell_error != 0
		return ""
	endif
	return mercurial_root
endfunction

" git_root() returns the repository root if the current path is
" within a git repository.
function! s:git_root()
	let git_root = system('git rev-parse --show-toplevel')
	if v:shell_error != 0
		return ""
	endif
	return git_root
endfunction

" Check for mercurial/git repository everytime a buffer is opened
" Disabled temporarily. On buffer close second line of function throws an
" error, despite being set only to BufEnter and silent used before exe
" command. Todo: debug!
" au BufEnter * call s:set_working_directory_for_project()

" Window settings
" ------------------------------------------------------------------------------
set splitbelow " New window goes below
set splitright " New windows goes right
set winminheight=0 " Allow splits to be reduced to a single line.

set cmdheight=1 " Set command height
" set cursorline " highlight current line; off until I can find a way to
" prevent underlining in vim (not a problem in gvim/macvim)
set laststatus=2 " 0 is always off, 1 is if there is more than 1 window, 2 is always on.
set lazyredraw " Don't redraw while in macros
set mouse=a " Enable mouse all modes, command, visual, insert, and normal
set nostartofline " Don't reset cursor to start of line when moving around.
set nowrap
set number
set report=0 " Always report number of lines changed for a command
set ruler " Displays the linenumber, column number in the status line (default is far right)
set showcmd
set scrolloff=4 " Minimum number of lines to show around the cursor while scrolling
set sidescrolloff=4 " Minimum number of horizontal characters while scrolling horizontally

" Relative line numbers on normal mode, regular numbers on insert.
if has('autocmd')
	set rnu
	au InsertEnter * :set nu
	au InsertLeave * :set rnu
	au FocusLost * :set nu
	au FocusGained * :set rnu
	set numberwidth=5
endif

" Run mkview on buffer leave, and reload on buffer enter.
" Views store window settings when viewing a buffer.
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

if exists('+colorcolumn')
	" Vim 7.3+ includes colorcolumn option, which highlights columns over the defined width
	" set colorcolumn=80

	" Alternatively can be set relative to textwidth:
	" set colorcolumn=+1
else
	" If support doesn't exist add ErrorMsg syntax highlighting
	" au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif


" Status line
" ------------------------------------------------------------------------------
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
" set statusline +=%5*%{&ff}%*            "file format
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%3*\ %y%*                "file type
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4c\ %*             "column number
" set statusline +=%2*0x%04B\ %*          "character under cursor

" Status line alternatives

" hi User1 guibg=#455354 guifg=fg      ctermbg=238 ctermfg=fg  gui=bold,underline cterm=bold,underline term=bold,underline
" hi User2 guibg=#455354 guifg=#CC4329 ctermbg=238 ctermfg=196 gui=bold           cterm=bold           term=bold
" set statusline=[%n]\ %1*%<%.99t%*\ %2*%h%w%m%r%*%y[%{&ff}→%{strlen(&fenc)?&fenc:'No\ Encoding'}]%=%-16(\ L%l,C%c\ %)%P

" set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" set statusline=%F\ %m%r%w%y\ %=(%L\ loc)\ [#\%03.3b\ 0x\%02.2B]\ \ %l,%v\ \ %P


" Theme settings
" ------------------------------------------------------------------------------
set background=dark
if has("gui_running")
	colorscheme buzz
	set guifont=monaco:h12
else
	colorscheme buzz
 	"Colorscheme does not load correctly.
 	"Force reload on enter until I can debug this.
	" autocmd VimEnter * colorscheme buzz
endif
syntax on " make sure this is turned on after filetype on.

" Returns the syntax grammar of the item below the cursor
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <leader>sy :call <SID>SynStack()<CR>

" Buffer settings
" ------------------------------------------------------------------------------

" Default text formatting options (default is tcq)
set formatoptions= " See :h fo-table; for more information on each option
set formatoptions+=c " Format comments
set formatoptions+=r " Continue comments by default
set formatoptions+=o " Make comment when using o or O from comment line
set formatoptions+=q " Format comments with gq
set formatoptions+=n " Recognize numbered lists
set formatoptions+=2 " Use indent from 2nd line of a paragraph
set formatoptions+=l " Don't break lines that are already long
set formatoptions+=1 " Break before 1-letter words

" Match pairs (use % to jump)
" Defaults to "(:),{:},[:]", this adds angle brackets to the default list
set matchpairs+=<:>

set backspace=start,indent,eol " Allow backspacing over everything in insert mode
set iskeyword+=_,$,@,%,#
set list " Show invisible characters
" set listchars=tab:▸\ ,eol:¬ " Show only invisible tabs and trailing whitespace
set virtualedit=onemore " cursor can go one char past end of line
set listchars=tab:¬\ ,eol:¬ " Show only invisible tabs and trailing whitespace
set nojoinspaces " Insert a single space after punctuation with a join command.
set showmatch
" set virtualedit=onemore " cursor can go one char past end of line
" Set the linewrap width. 0 sets it to nothing.
" See 'formatoptions' for advanced wrap settings
set textwidth=0

" Indenting
set autoindent
set copyindent " use existing indents for new indents
set preserveindent " save as much indent structure as possible
set shiftround " always round indents to multiple of shiftwidth
" Sets how many spaces for each step of (auto)indent in normal mode (<, >, =)
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4 " Sets the width of a tab character
set noexpandtab " Expandtab translates tabs to spaces. No prefix turns this off
" softabstop fine tunes the amount of whitespace to be inserted.
" The default (0) turns this off

" Also softtabstop takes precedence over tabstop.
" If tabstop is larger than softtabstop, inserting a tab will insert spaces
" equal to the length of softtabstop (even if noexpand tab is set).

" Once enough softtabstops are used in a row to be equal (or larger) than the
" tabstop width, the spaces are converted to a tab character
" (assuming noexpandtab is set).
" In this scenario backspace works the same as softtabstop in reverse.
set softtabstop=4

" Lisp
if has('autocmd')
	autocmd filetype lisp,scheme setlocal lisp
endif

" Search
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlights search results.
set ignorecase " Ignores case in searches by default
set incsearch " Searches as you type
set smartcase " Turns on case sensitivity if search contains a capital letter

" Allow switching away from a current buffer with unsaved changes to another
" buffer without throwing a warning. Still prompts before quitting with warning.
" set hidden

" Auto-write (:w) unsaved buffers when switching buffers (e.g. :bn or :bp).
" This is a alternative workflow to hidden.
" set autowrite

" When entering a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
if has('autocmd')
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif
endif

" Enable soft-wrapping for text files
if has('autocmd')
	autocmd filetype text,markdown,html setlocal wrap linebreak nolist
endif

" Set php commands
if has('autocmd')
	" Highlight embedded SQL Syntax
	let php_sql_query=1
	" Highlight embedded HTML in strings
	let php_htmlInStrings=1
endif

" Set missing filetypes
if has('autocmd')
	au BufNewFile,BufRead *.less set filetype=less
	au BufNewFile,BufRead /etc/nginx/conf/* set filetype=nginx
	au BufNewFile,BufRead *.json set filetype=javascript
	au BufNewFile,BufRead *.proto set filetype=proto
	" au BufNewFile,BufRead *.notes set filetype=mkd
	au BufNewFile,BufRead *.pp set filetype=sh " Puppet files
	au BufNewFile,BufRead *.pp set tabstop=4 " Puppet files
	au BufNewFile,BufRead *.pp set noexpandtab " Puppet files
endif

" Key bindings
" ==============================================================================

" Pay attention to command-line bindings. For example, gVim's can use bindings
" like <C-s>. But on the command-line this is the shortcut for suspend. It
" takes precedence over vim shortcuts.

" Rebind Esc
imap <C-[> <Esc>
vmap <C-[> <Esc>

" No man page lookup
inoremap K k

" Faster Esc
inoremap jk <Esc>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Rebind zz (move current line to middle) to zm.
nnoremap zm zz

" Disable EX mode
map Q <Nop>

" Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Faster split resizing (+,-)
if bufwinnr(1)
	map + <C-W>+
	map - <C-W>-
endif

" Insert spaces with enter in normal mode
" Note: O and o are still useful to immediately enter insert mode after.
" Shift enter <S-CR> can not be detected on many terminals. Added O rule.
" Not completely happy with it, but works for now.
" See: http://stackoverflow.com/a/598404/657661
nnoremap <CR> o<ESC>
nnoremap <S-CR> O<ESC>
nnoremap O O<ESC>

" Make Y consistent with C and D
nnoremap Y y$

" Navigate by visual lines
noremap k gk
noremap j gj

" Make arrow keys work as expected in wrapped lines in interactive mode
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Make case toggling in visual mode harder to accidentally hit
" In MacVim this is also bound to <D-u>/<D-U>
vnoremap u ""
vnoremap U ""

" Indent similar to TextMate.
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv
vnoremap < <gv
vnoremap > >gv

" piece-wise copying of the line above the current one
imap <C-L> @@@<ESC>hhkywjl?@@@<CR>P/@@@<CR>3s
"
" Makes searches use sane regexes
" Good to know, but I like dumb simple string search as the default
" (http://stevelosh.com/blog/2010/09/coming-home-to-vim/)
" nnoremap / /\v
" vnoremap / /\v

" Leader bindings
" ------------------------------------------------------------------------------
let mapleader=','

" Write
nmap <leader>w :w<CR>
vmap <leader>w :w<CR>

" Select all
nmap <leader>a ggVG
vmap <leader>a ggVG

" Fix cut and paste in command line vim on Mac OS X. See:
" http://superuser.com/a/134751
" http://stackoverflow.com/a/2555659/657661
nmap <leader>pa :set invpaste paste?<CR>

" Remove search highlighting
nmap <leader>[ :noh<Return><Esc>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" Smart paste, includes formatting like indentation
nnoremap <leader>pf  p'[v']=
nnoremap <leader>Pf  P'[v']=

" Markdown helpers
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-
nnoremap <leader>3 I# <Esc>A #<Esc>
nnoremap <leader>4 I## <Esc> ##<Esc>
nnoremap <leader>5 I### <Esc>A ###<Esc>
nnoremap <leader>6 I#### <Esc>A ####<Esc>

" CD to directory of current file
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" Build off '[I' to create a more advanced find word under cursor
nnoremap <leader>fi [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>]"

" Whitespace functions and bindings

" Prepare function saves current state (cursor position), executes given
" command, then reloads state.
"
" Used to tidy whitespace on command without losing position or polluting
" search history.
"
" See http://vimcasts.org/episodes/tidying-whitespace/ for more information

" Preparation: save last search, and cursor position.
function! Preserve(command)
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	execute a:command
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" Remove trailing whitespace on command
nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>
"
" Format entire page on command. Careful when used on mixed language pages
" (e.g. a php file with html, php and js)
nmap <leader>= :call Preserve("normal gg=G")<CR>

" Plugin specific bindings are included in the plugins section


" Plugins
" ==============================================================================

" Not all plugins will have settings below. See .vim/bundle/ for a list of
" all installed plugins using pathogen.

" CtrlP
" ------------------------------------------------------------------------------
let g:ctrlp_max_files = 5000
let g:ctrlp_working_path_mode = 2

" Optimize file searching
if has("unix")
	let g:ctrlp_user_command = {
		\   'types': {
		\       1: ['.git/', 'cd %s && git ls-files']
		\   },
		\   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
		\ }
endif


" Colorizer plugin
" ------------------------------------------------------------------------------
nmap <leader>co <Plug>Colorizer


" Commentary plugin
" ------------------------------------------------------------------------------
if has('autocmd')
	autocmd FileType php setlocal commentstring=\/\/\ %s
	autocmd FileType js setlocal commentstring=\/\/\ %s
	autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
endif


" Easy Motion plugin
" ------------------------------------------------------------------------------
"	Keep it from conflicting with other modules
let g:EasyMotion_leader_key = '<Leader>m'


" Fuzzy Finder plugin
" " Disabled
" ------------------------------------------------------------------------------
" nmap <leader>ff :FufFile<CR>
" nmap <leader>fff :FufFile **/<CR>

" let g:fuzzy_ignore = ".svn/**;.git/**;.hg/**;*.gif;*.jpg;*.jpeg;*.png;*.pdf;*.docx;*.doc;*.ppt;*.pptx;*.psd"
" let g:fuzzy_matching_limit = 50
" let g:fuf_dataDir = '~/.vim/history/fuzzy-finder.history'
" let g:fuf_maxMenuWidth = 120


" HTML Auto Close Tag
" ------------------------------------------------------------------------------
"	Add additional filetypes
if has('autocmd')
  autocmd FileType xhtml,xml,php runtime ftplugin/html/html_autoclosetag.vim
endif


" Indent Guides plugin
" ------------------------------------------------------------------------------
"	Plugin binds toggle on/off to <leader>ig by default
let g:indent_guides_enable_on_vim_startup=0


" Most Recently Used plugin
" " Disabled
" ------------------------------------------------------------------------------
" let MRU_File='~/.vim_mru_files'
" let MRU_Max_Entries=1000


" NERDTree plugin
" ------------------------------------------------------------------------------
let g:NERDTreeWinPos="right"
let g:NERDTreeIgnore=['.git$', '\~$']
"let NERDTreeSortOrder = ['\/$', '\.yaml$', '\.txt$', '\.py$', '\.js$', '\.html$', '*']
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeKeepTreeInNewTab=1
let g:NERDTreeWinSize=40
let g:NERDTreeBookmarksFile='$HOME/.vim/history/NERDTreeBookmarks.history'

" map <leader>t :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>nt :NERDTreeToggle<CR>
map <leader>ntf :NERDTreeFind<CR>


" snipMate plugin
" ------------------------------------------------------------------------------
let g:snips_author = 'Chris Laskey'


" Surround plugin
" ------------------------------------------------------------------------------
"	Map ascii 45 (-) in PHP files to the following mapping:
if has('autocmd')
	autocmd FileType php let b:surround_45 = "<?php \r ?>"
endif


" Todo list plugin
" ------------------------------------------------------------------------------
let g:tlTokenList=['//*', 'future', 'todo']


" vim-conque terminal plugin
" " Disabled
" ------------------------------------------------------------------------------
" let g:ConqueTerm_CWInsert = 1
" let g:ConqueTerm_ExecFileKey = '<F11>'
" let g:ConqueTerm_SendFileKey = '<F10>'
" let g:ConqueTerm_SendVisKey = '<F9>'
" map <leader>tt <Esc>:ConqueTermTab bash
" map <leader>ts <Esc>:ConqueTermSplit bash
" map <leader>tv <Esc>:ConqueTermVSplit bash
" map <leader>ef <F11>
" " map <leader>eb <F10> Disabled due to crashes
" map <leader>ev <F9>


" vim-slime plugin
" ------------------------------------------------------------------------------
let g:slime_target = "tmux"
map <leader>vs <C-c><C-c>
map <leader>vc <C-c>v


" Yankring plugin
" " Disabled
" ------------------------------------------------------------------------------
" let g:yankring_max_history = 100
" let g:yankring_history_dir = '~/.vim/history'
" let g:yankring_history_file ='yankring.history'


" Usage tips
" :verbose set autoindent?		Determine where a settings value was last set. Great for debugging what file overwrote .vimrc setting!
" :w !sudo tee %				Save with sudo (http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
