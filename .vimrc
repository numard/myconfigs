" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" To install on a new machine:
"  1. copy this .vimrc
"  2. mkdir -p ~/.vim/bundle
"  3. cd ~/.vim/bundle
"  4. git clone https://github.com/gmarik/Vundle.vim
"  5. vim , :PluginInstall
"  6. solve any dependencies errors ( press l after Vundle finishes to see its
"  work log...
"
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"
" Keep Plugin commands between vundle#begin/end.
" see https://github.com/gmarik/Vundle.vim for Plugin syntax examples...
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
"
" fugitive - git plugin
Plugin 'tpope/vim-fugitive'
Plugin 'plasticboy/vim-markdown'
if has("python")
    " Undo tree
    Plugin 'sjl/gundo.vim'
    " Enough said...
    Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
endif
" Syntax checker
Plugin 'scrooloose/syntastic'
" Autocompleter
Plugin 'davidhalter/jedi-vim'
if has("lua")
    Plugin 'Shougo/neocomplete.vim'
endif
Plugin 'rodjek/vim-puppet'
Plugin 'honza/vim-snippets'
Plugin 'godlygeek/tabular'
" Color scheme...may need to tweak colors on iterm too...
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
" Add support for .editorconfig files
Plugin 'editorconfig/editorconfig-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Put your non-Plugin stuff after this line
" --- /from https://github.com/gmarik/Vundle.vim

" It is intended to allow overriding <Leader>.
" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif


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

" ================ powerline settings ================
" Enabled even if powerline is not loaded as it shows a boring but still
" useful status line.
set laststatus=2    " Always display the statusline in all windows
set showtabline=2   " Always display the tabline, even if there is only one tab
set noshowmode      " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set encoding=utf-8 " Necessary to show Unicode glyphs
let g:Powerline_symbols = 'fancy'
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
set fillchars+=stl:\ ,stlnc:\
" These are not *just* related to powerline, but needed by it too
set encoding=utf-8
set term=xterm-256color
set t_Co=256
set termencoding=utf-8

" ===================== Gundo =====================
" if exists('loaded_gundo')
    nnoremap<C-A> :call gundo#GundoToggle()<cr>
" endif

" ================== Syntastic =====================
" if exists('loaded_syntastic_plugin')
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
" endif 
" ================ Search Settings  =================

set incsearch        "Find the next match as we type the search
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks

" ================ Turn Off Swap Files ==============

" set noswapfile
" set nobackup
" set nowb

if v:version >= 730
    " ================ Persistent Undo ==================
    " Keep undo history across sessions, by storing in file.
    " Only works all the time.

    silent !mkdir ~/.vim/backups > /dev/null 2>&1
    set undodir=~/.vim/backups
    set undofile
endif

" Load vimrc after saving it
autocmd! BufWritePost vimrc nested :source ~/.vimrc

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
autocmd BufNewFile,BufRead text,python,ruby,php setl tw=80 ts=4 sts=4 sw=4 et list listchars=tab:>.,trail:-

" 2 space tabbing for puppet"
autocmd FileType puppet setl sw=2 ts=2 sts=2 et list listchars=tab:>.,trail:-

" Highlight lines that are too long
autocmd BufNewFile,BufRead * match Error /\%>80v.\+/

" =====================================================
" This will make CTRL+L toggle line numbers on/off and CTRL+I (because CtrlP is the autocomplete...) toggle paste mode on/off
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
nnoremap <C-I> :call g:TogglePasteMode()<cr>
" =====================================================

" =====================================================
" NO LUCK w/my colours? Highlight ending spces...but not highlighting each space you type 
"  at the end of the line, only when you open a file or leave insert mode.
"highlight ExtraWhitespace ctermbg=red guibg=red
"au ColorScheme * highlight ExtraWhitespace guibg=red
"au BufEnter * match ExtraWhitespace /\s\+$/
"au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"au InsertLeave * match ExtraWhiteSpace /\s\+$/

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

" set wildmode=list:longest
" set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
" set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
" set wildignore+=*vim/backups*
" set wildignore+=*sass-cache*
" set wildignore+=*DS_Store*
" set wildignore+=vendor/rails/**
" set wildignore+=vendor/cache/**
" set wildignore+=*.gem
" set wildignore+=log/**
" set wildignore+=tmp/**
" set wildignore+=*.png,*.jpg,*.gif

"

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" Solarized colour scheme - installed as bundle under pathogen"
set background=dark
"colorscheme solarized
