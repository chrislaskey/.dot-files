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
set updatetime=300 " Recommended by coc.nvim plugin

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

if has('autocmd')
    au BufNewFile,BufRead *.eex set filetype=eelixir
    au BufNewFile,BufRead *.heex set filetype=eelixir
    au BufNewFile,BufRead *.es6 set filetype=javascript
    au BufNewFile,BufRead *.ex set filetype=elixir
    au BufNewFile,BufRead *.exs set filetype=elixir
    au BufNewFile,BufRead *.json set filetype=javascript
    au BufNewFile,BufRead *.less set filetype=less
    au BufNewFile,BufRead *.notes set filetype=mkd
    au BufNewFile,BufRead *.pp set filetype=puppet
    au BufNewFile,BufRead *.proto set filetype=proto
    au BufNewFile,BufRead /etc/nginx/conf/* set filetype=nginx
    autocmd filetype lisp,scheme setlocal lisp
endif

if has('autocmd')
  " Fix issues with syntax highlighting getting out of sync.
  " NOTE: this has a performance hit!
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
endif

" set wildmenu " More advanced listing when using tab auto complete
" set wildmode=list,full " Determines the way the advanced listing is displayed
set wildignore+=.svn/*,.git/*,.hg/*,*.gif,*.jpg,*.jpeg,*.png,*.pdf
set wildignore+=*.docx,*.doc,*.ppt,*.pptx,*.psd,*.pyc,*.DS_Store

" Shorten message length
" set shortmess=aoOtI
set shortmess+=c " Recommended by coc.nvim

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
"   Also add these lines to .gvimrc to turn it off in gvim/macvim
set guioptions-=m " Disable menubar
set guioptions-=T " Disable toolbar
set guioptions-=r " Disable right scroll-bar
set guioptions-=R " Disable right scroll-bar
set guioptions-=l " Disable left scroll-bar
set guioptions-=L " Disable left scroll-bar


" Path settings
" ------------------------------------------------------------------------------
" if has('autochdir')
"     set autochdir " Automatically set pwd/cwd to file's parent directory
" endif

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
set undofile " Persisted undo across vim sessions

" Recommended by coc.nvim:
"   Always show the signcolumn, otherwise it would shift the text each time
"   diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Relative line numbers on normal mode, regular numbers on insert.
" NOTE: Disable when pairing
" if has('autocmd')
"     set rnu
"     au InsertEnter * :set nu
"     au InsertLeave * :set rnu
"     au FocusLost * :set nu
"     au FocusGained * :set rnu
"     set numberwidth=5
" endif

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
" To turn on source this file using `:so ~/.vimrc`
nnoremap <leader>sy :call <SID>SynStack()<CR>
" Bug in vim-javascript package. To fix remove all mentions of `jsTemplateString`

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
" set list " Show invisible characters
" set listchars=tab:¬\ ,eol:¬ " Show only invisible tabs and trailing whitespace
set virtualedit=onemore " cursor can go one char past end of line
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
set shiftwidth=2
set smartindent
set smarttab
set tabstop=2 " Sets the width of a tab character
set expandtab " Expandtab translates tabs to spaces. No prefix turns this off
" softabstop fine tunes the amount of whitespace to be inserted.
" The default (0) turns this off

" Also softtabstop takes precedence over tabstop.
" If tabstop is larger than softtabstop, inserting a tab will insert spaces
" equal to the length of softtabstop (even if noexpand tab is set).

" Once enough softtabstops are used in a row to be equal (or larger) than the
" tabstop width, the spaces are converted to a tab character
" (assuming noexpandtab is set).
" In this scenario backspace works the same as softtabstop in reverse.
set softtabstop=2

" Search
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlights search results.
set ignorecase " Ignores case in searches by default
set incsearch " Searches as you type
set smartcase " Turns on case sensitivity if search contains a capital letter

" Tags
set tags+=gems.tags

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

if has('autocmd')
    " Filetype specific settings
    autocmd filetype text,markdown,html setlocal wrap linebreak nolist " Enable soft-wrapping for text files
    autocmd filetype ruby,eruby,scss,javascript,html,css,yaml,puppet,elixir,eelixir setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    " Set php commands
    let php_sql_query=1 " Highlight embedded SQL Syntax
    let php_htmlInStrings=1 " Highlight embedded HTML in strings
    au BufNewFile,BufRead *.php set tabstop=4 " Use spaces instead of tabs
    au BufNewFile,BufRead *.php set expandtab
    au BufNewFile,BufRead *.php set nocompatible
    au BufNewFile,BufRead *.php filetype indent plugin on

    " Puppet files
    au BufNewFile,BufRead *.pp set nocompatible
    au BufNewFile,BufRead *.pp filetype indent plugin on
endif

" Vim Plugins
" ==============================================================================
" Note: many plugins are included using pathogen and do not require an
" explicit entry here.

" Vim Plug (see: https://github.com/junegunn/vim-plug)
" ------------------------------------------------------------------------------
" NOTE: After adding new plugins with vim-plug, open VIM and run `:PlugInstall`.

call plug#begin('~/.vim/vim-plug-files')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}

let g:coc_global_extensions = ['coc-tsserver']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

call plug#end()

" Key bindings
" ==============================================================================

" Pay attention to command-line bindings. For example, gVim's can use bindings
" like <C-s>. But on the command-line this is the shortcut for suspend. It
" takes precedence over vim shortcuts.

" Rebind Esc
imap <C-[> <Esc>
vmap <C-[> <Esc>

" No man page lookup
noremap K k

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

" Select pasted content
nnoremap gp `[v`]]

" piece-wise copying of the line above the current one
imap <C-L> @@@<ESC>hhkywjl?@@@<CR>P/@@@<CR>3s

" Makes searches use sane regexes
" Good to know, but I like dumb simple string search as the default
" (http://stevelosh.com/blog/2010/09/coming-home-to-vim/)
" nnoremap / /\v
" vnoremap / /\v

" Add various language specific debug commands
if has('autocmd')
  autocmd FileType javascript imap <buffer> cll console.log()<Esc>==F(a
  " output console.log("$1", $1)
  autocmd FileType javascript vmap <buffer> cll yocll'<Esc>pa', <Esc>p
  " output console.log("$1", $1) where $1 is the next word
  autocmd FileType javascript nmap <buffer> cll yiwocll'<Esc>pa', <Esc>p

  autocmd FileType elixir imap <buffer> cll IO.inspect()<Esc>==F(a
  " output IO.puts "---$1"\nIO.inspect($1)
  autocmd FileType elixir vmap <buffer> cll yoIO.puts "---<Esc>pa"<Esc>ocll<Esc>p
  " output IO.puts "---$1"\nIO.inspect($1) where $1 is the next word
  autocmd FileType elixir nmap <buffer> cll yiwoIO.puts "---<Esc>pa"<Esc>ocll<Esc>p
endif

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

" Run git blame on highlighted section
vmap <Leader>bl :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
" nmap <silent> <leader>d "_d
" vmap <silent> <leader>d "_d

" Smart paste, includes formatting like indentation
nnoremap <leader>pf  p'[v']=
nnoremap <leader>Pf  P'[v']=

" Markdown helpers
" nnoremap <leader>1 yypVr=
" nnoremap <leader>2 yypVr-
" nnoremap <leader>3 I### <Esc>A ###<Esc>
" nnoremap <leader>4 I#### <Esc>A ####<Esc>
" nnoremap <leader>5 I##### <Esc>A #####<Esc>
" nnoremap <leader>6 I###### <Esc>A ######<Esc>

" Buffer navigation helpers
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>b :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>

nnoremap <Leader>d :bd<CR>
nnoremap <Leader>f :bp<CR>
nnoremap <Leader>g :bn<CR>

" CD to directory of current file
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" Build off '[I' to create a more advanced find word under cursor
nnoremap <leader>fi [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>]"

" Tabular plugin alignment
" nnoremap <leader>f :Tabular block<cr>

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

" Not all plugins will have settings below. For a list of installed plugins see:
"
" - vim-plug section of `~/.vimrc` for all installed plugins using vim-plug
" - `.vim/bundle` directory for list of all installed plugins using pathogen

" Conquer of Complete (coc)
" ------------------------------------------------------------------------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <CR> pumvisible() ? "\<C-y><CR>" : "\<CR>"
" See: https://github.com/neoclide/coc.nvim/issues/262
" inoremap <silent><expr> <CR> pumvisible() && complete_info()["selected"] ? "\<C-y>\<CR>" : pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" " Use <c-space> to trigger completion.
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" " GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" " Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)

" " Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')

" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" CtrlP
" ------------------------------------------------------------------------------
let g:ctrlp_max_files = 500000
let g:ctrlp_working_path_mode = 2
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
map <leader>pr :CtrlPClearAllCaches<cr>

if has("unix")
    let g:ctrlp_user_command = {
        \   'types': {
        \       1: ['.git/', 'cd %s && { git ls-files; git ls-files --exclude-standard --others; }']
        \   },
        \   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
        \ }
endif

" Support `ag`
" if executable("ag")
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" endif

" Support `ripgrep`
" if executable("rg")
"   set grepprg=rg\ --color=never
"   let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
"   let g:ctrlp_use_caching = 0
" endif

" Colorizer plugin
" ------------------------------------------------------------------------------
nmap <leader>co <Plug>Colorizer


" Commentary plugin
" ------------------------------------------------------------------------------
if has('autocmd')
    autocmd FileType php setlocal commentstring=\/\/\ %s
    autocmd FileType js setlocal commentstring=\/\/\ %s
    autocmd FileType puppet setlocal commentstring=#\ %s
    autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
endif


" Easy Motion plugin
" ------------------------------------------------------------------------------
"   Keep it from conflicting with other modules
" let g:EasyMotion_leader_key = '<Leader>m'


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
"   Add additional filetypes
if has('autocmd')
  autocmd FileType xhtml,xml,php runtime ftplugin/html/html_autoclosetag.vim
endif


" Indent Guides plugin
" ------------------------------------------------------------------------------
"   Plugin binds toggle on/off to <leader>ig by default
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

" elm.vim plugin
" ------------------------------------------------------------------------------
nnoremap <leader>el :ElmEvalLine<CR>
vnoremap <leader>es :<C-u>ElmEvalSelection<CR>
nnoremap <leader>em :ElmMakeCurrentFile<CR>>
if has('autocmd')
    au BufWritePost *.elm ElmMakeFile("Main.elm")
endif

" snipMate plugin
" ------------------------------------------------------------------------------
let g:snips_author = 'Chris Laskey'


" Surround plugin
" ------------------------------------------------------------------------------
"   Map ascii 45 (-) in PHP files to the following mapping:
if has('autocmd')
    autocmd FileType php let b:surround_45 = "<?php \r ?>"
endif


" Todo list plugin
" ------------------------------------------------------------------------------
let g:tlTokenList=['//*', 'future', 'todo']


" vim-airline status line plugin
" ------------------------------------------------------------------------------
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#enabled=0
let g:airline_powerline_fonts=0
let g:airline_powerline_fonts=0
let g:airline_statusline_ontop=0

function! InitAirline()
  let spc = g:airline_symbols.space

  " Custom sections
  " For defaults see file `./bundle/vim-airline/autoload/airline/init.vim`
  let g:airline_section_b = airline#section#create(['Buf #[%n] '])
  let g:airline_section_z = airline#section#create(['linenr', ':%v'])
endfunction

autocmd VimEnter * call InitAirline()


" vim-jsx plugin
" ------------------------------------------------------------------------------
let g:jsx_ext_required = 0


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
" :verbose set autoindent?      Determine where a settings value was last set. Great for debugging what file overwrote .vimrc setting!
" :w !sudo tee %                Save with sudo (http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
" gq                            Highlight a selection and use `gq` to autocorrect length of the paragraph
