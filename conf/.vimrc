map <F4> :set spell!<CR>
map <F5> :set hlsearch!<CR>
map <F6> :set cursorline! cursorcolumn!<CR>
map <F7>:'<,'>w !xclip -i<CR>
map <F8>:r !xclip -o<CR>
set nocompatible
set ruler
set number
"set list
set listchars=tab:..,trail:-

set tabstop=8
set shiftwidth=4
set expandtab
set cursorline
set cursorcolumn

set modeline
set backspace=indent,eol,start
set fileformats=unix,dos,mac
set smartindent                 " smart autoindenting when starting a new line
set smarttab

set wildignore=*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildmenu                    " command-line completion in an enhanced mode
set history=50          " keep 50 lines of command line history
set showcmd             " display incomplete commands

set laststatus=2

let g:tex_indent_items = 0

if has('mouse')
  set mouse=a
endif

set autoread                    " read open files again when changed outside Vim
augroup checktime
    au!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter        * silent! checktime
        autocmd CursorHold      * silent! checktime
        autocmd CursorHoldI     * silent! checktime
        "these two _may_ slow things down. Remove if they do.
        "autocmd CursorMoved     * silent! checktime
        "autocmd CursorMovedI    * silent! checktime
    endif
augroup END

au! BufRead,BufNewFile *.md set filetype=markdown

filetype plugin indent on
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized

