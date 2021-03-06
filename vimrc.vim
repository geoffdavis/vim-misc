scriptencoding utf-8
set encoding=utf-8

"----------------------------------------------------------------------
" Basic Options
"----------------------------------------------------------------------
let mapleader=";"         " The <leader> key
set autoread              " Reload files that have not been modified
set backspace=2           " Makes backspace not behave all retarded-like
if exists('+colorcolumn') " Highlight 80 character limit
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
set cursorline            " Highlight the line the cursor is on
set hidden                " Allow buffers to be backgrounded without being saved
set laststatus=2          " Always show the status bar
set list                  " Show invisible characters
set listchars=tab:›\ ,eol:¬,trail:⋅ "Set the characters for the invisibles
if exists('+relativenumber')
    set relativenumber    " Show relative line numbers
else
    set number
endif
set ruler                 " Show the line number and column in the status bar
" Conditionally set up term color support
if $TERM =='xterm-256color' || $TERM == 'screen-256color' || $COLORTERM == 'gnome-terminal'
    set t_Co=256          " Use 256 colors
endif
set scrolloff=999         " Keep the cursor centered in the screen
set showmatch             " Highlight matching braces
set showmode              " Show the current mode on the open buffer
set splitbelow            " Splits show up below by default
set splitright            " Splits go to the right by default
set title                 " Set the title for gvim
set visualbell            " Use a visual bell to notify us

if !has("win32")
    set showbreak=↪           " The character to put to show a line has been wrapped
end

syntax on                 " Enable filetype detection by syntax

" Backup settings
execute "set directory=" . g:vim_home_path . "/swap"
execute "set backupdir=" . g:vim_home_path . "/backup"
if exists('+undodir')
    execute "set undodir=" . g:vim_home_path . "/undo"
    set backup
    set undofile
    set writebackup
endif


" Search settings
set hlsearch   " Highlight results
set ignorecase " Ignore casing of searches
set incsearch  " Start showing results as you type
set smartcase  " Be smart about case sensitivity when searching

" Tab settings
set expandtab     " Expand tabs to the proper type and size
set tabstop=4     " Tabs width in spaces
set softtabstop=4 " Soft tab width in spaces
set shiftwidth=4  " Amount of spaces when shifting

" Tab completion settings
set wildmode=list:longest     " Wildcard matches show a list, matching the longest first
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups

" GUI settings
if has("gui_running")
    colorscheme solarized
    set guioptions=cegmt

    if has("win32")
        set guifont=Inconsolata:h11
    else
        set guifont=Inconsolata\ for\ Powerline:h14
    endif

    if exists("&fuopt")
        set fuopt+=maxhorz
    endif
endif

"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
" Remap a key sequence in insert mode to kick me out to normal
" mode. This makes it so this key sequence can never be typed
" again in insert mode, so it has to be unique.
inoremap jj <esc>
inoremap jJ <esc>
inoremap Jj <esc>
inoremap JJ <esc>
inoremap jk <esc>
inoremap jK <esc>
inoremap Jk <esc>
inoremap JK <esc>

" Make j/k visual down and up instead of whole lines. This makes word
" wrapping a lot more pleasent.
map j gj
map k gk

" cd to the directory containing the file in the buffer. Both the local
" and global flavors.
nmap <leader>cd :cd %:h<CR>
nmap <leader>lcd :lcd %:h<CR>

" Shortcut to edit the vimrc
nmap <silent> <leader>vimrc :e ~/.vimrc<CR>

" Make navigating around splits easier
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Shortcut to yanking to the system clipboard
map <leader>y "*y
map <leader>p "*p

" Get rid of search highlights
noremap <silent><leader>/ :nohlsearch<cr>

" Command to write as root if we dont' have permission
cmap w!! %!sudo tee > /dev/null %

" Expand in command mode to the path of the currently open file
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Buffer management
nnoremap <leader>d   :bd<cr>

" CtrlP
nnoremap <leader>t :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>l :CtrlPLine<cr>

"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
" Clear whitespace at the end of lines automatically
autocmd BufWritePre * :%s/\s\+$//e

" Don't fold anything.
autocmd BufWinEnter * set foldlevel=999999

" Reload Powerline when we read a Puppet file. This works around
" some weird bogus bug.
autocmd BufNewFile,BufRead *.pp call Pl#Load()

"----------------------------------------------------------------------
" Plugin settings
"----------------------------------------------------------------------
" CtrlP
let g:ctrlp_max_files = 10000
if has("unix")
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
    \ }
endif

let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

func! MyCtrlPMappings()
    nnoremap <buffer> <silent> <c-@> :call <sid>DeleteBuffer()<cr>
endfunc

func! s:DeleteBuffer()
  let line = getline('.')
  let bufid = line =~ '\[\d\+\*No Name\]$' ? str2nr(matchstr(line, '\d\+'))
        \ : fnamemodify(line[2:], ':p')
  exec "bd" bufid
  exec "norm \<F5>"
endfunc<D-j>

" EasyMotion
let g:EasyMotion_leader_key = '<leader><leader>'

" JSON
let g:vim_json_syntax_conceal = 0

" Powerline
let g:Powerline_symbols="fancy" " Fancy styling

" Startify
let g:startify_list_order = ['bookmarks', 'files', 'sessions']
let g:startify_bookmarks = [
    \ '~/src/IGPP/puppet_environments',
    \ '~/src/IGPP/antelope_contrib',
    \ '~/src/IGPP/anfsrc',
    \ '~/src/IGPP/antelope_build',
    \ ]
let g:startify_custom_header = [
    \ '                    __  __    _             _     ',
    \ '                   / _|/ _|  | |           (_)    ',
    \ '   __ _  ___  ___ | |_| |_ __| | __ ___   ___ ___ ',
    \ '  / _` |/ _ \/ _ \|  _|  _/ _` |/ _` \ \ / / / __|',
    \ ' | (_| |  __/ (_) | | | || (_| | (_| |\ V /| \__ \',
    \ '  \__, |\___|\___/|_| |_| \__,_|\__,_| \_/ |_|___/',
    \ '   __/ |                                          ',
    \ '  |___/                                           ',
    \ '',
    \ '  ======================================================',
    \ '',
    \ ]

" Syntastic
let g:syntastic_python_checker="pyflakes"
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['cpp', 'go', 'puppet'] }
