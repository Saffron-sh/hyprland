" --- Basic settings ---
set nocompatible
syntax on           " enable syntax highlighting
filetype plugin on

set number          " show line numbers
set showcmd         " show command in bottom bar
set cursorline      " highlight current line
set ruler           " show cursor position in the status line

" --- Indentation ---
set tabstop=4       " number of spaces a <Tab> counts for
set shiftwidth=4    " indentation size
set expandtab       " convert tabs to spaces
set autoindent      " auto-indent new lines

" --- Searching ---
set ignorecase      " case-insensitive search...
set smartcase       " ...unless you use uppercase
set incsearch       " search as you type
set hlsearch        " highlight matches

" --- Usability ---
set backspace=2     " make backspace work normally
set clipboard=unnamedplus " use system clipboard
set wildmenu        " improved command-line completion
set mouse=a         " enable mouse support

" --- Appearance ---
set background=dark " better defaults for dark terminals

