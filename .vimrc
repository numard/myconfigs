" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" TODO: this may not be in the correct place. It is intended to allow overriding <Leader>.
" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

execute pathogen#infect()

" FIXME probably this 
" =============== Pathogen Initialization ===============
" This loads all the plugins in ~/.vim/bundle
" Use tpope's pathogen plugin to manage all other plugins

"  runtime bundle/tpope-vim-pathogen/autoload/pathogen.vim
"  call pathogen#infect()
"  call pathogen#helptags()

" ================ General Config ====================

set number                      "Line numbers are good
set ruler                       "line/column / % in status bar
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set nocp                        " Enable more options

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax enable
syntax on

"Git diff split..."
autocmd FileType gitcommit DiffGitCached | wincmd L | wincmd p

" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Highlight tabs and trailing spaces
autocmd BufNewFile,BufRead * set tw=80 ts=4 sts=4 sw=4 et list listchars=tab:>.,trail:-

" Highlight lines that are too long
autocmd BufNewFile,BufRead * match Error /\%>80v.\+/

" This will make CTRL+L toggle line numbers on/off and CTRL+P toggle paste mode on/off
function! g:ToggleNuMode()
    if(&nu == 1)
        set nonu
    else
        set nu
    endif
endfunc

function! g:TogglePasteMode()
    if(&paste == 1)
        set nopaste
    else
        set paste
    endif
endfunc

nnoremap <C-L> :call g:ToggleNuMode()<cr>
nnoremap <C-P> :call g:TogglePasteMode()<cr>
" =====================================================

" NO LUCK w/my colours? Highlight ending spces...but not highlighting each space you type 
"  at the end of the line, only when you open a file or leave insert mode.
"highlight ExtraWhitespace ctermbg=red guibg=red
"au ColorScheme * highlight ExtraWhitespace guibg=red
"au BufEnter * match ExtraWhitespace /\s\+$/
"au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"au InsertLeave * match ExtraWhiteSpace /\s\+$/

" ================ Search Settings  =================

set incsearch        "Find the next match as we type the search
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks

" ================ Turn Off Swap Files ==============

" set noswapfile
" set nobackup
" set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set expandtab " Replace tabs with 4 spaces
set tabstop=4 " Set tabs to be 4 spaces
set shiftwidth=4 " Auto tab 4 spaces
set softtabstop=4 " Backspace will act as though 4 spaces are a tab

filetype plugin on
filetype indent on

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set wrapmargin=4
set wrap       
set linebreak    "Wrap lines at convenient points
"prevent automatically inserting line breaks in newly entered text.
set textwidth=0
set wrapmargin=0
"keep your existing 'textwidth' settings for most lines in your file, but not
"have Vim automatically reformat when typing on existing lines,
set formatoptions+=l

" ================ Key remapping ====================

nore ; :
nore , ;

" reselect after line indent..."
vnoremap < <gv
vnoremap > >gv

" improve movement wrapped lines"
" nnoremap j gj
" nnoremap k gk

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1


" Solarized colour scheme - installed as bundle under pathogen"
set background=dark
set t_Co=256
" colorscheme solarized
