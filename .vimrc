" =============================================================================
"                               General settings
" =============================================================================
set nocompatible        " iMproved.

set autoindent          " Copy indent from current line when starting a new line
set backspace=indent,eol,start " Backspacing over everything in insert mode.
set hidden              " Allow for putting dirty buffers in background.
set history=1024        " Lines of command history
set ignorecase          " Case-insensitive search
set incsearch           " Jumps to search word as you type.
set smartcase           " Override ignorecase when searching uppercase.
set modeline            " Enables modelines.
set wildmode=longest,list:full " Complete longest common string, then show options.

" Low priority for these files in tab-completion.
set suffixes+=.aux,.bbl,.blg,.dvi,.log,.pdf,.fdb_latexmk     " LaTeX
set suffixes+=.info,.out,.o,.lo

set viminfo='20,\"500

scriptencoding utf-8

" =============================================================================
"                                   Styling
" =============================================================================
set background=dark     " Syntax highlighting for a dark terminal background.
set hlsearch            " Highlight search results.
set ruler               " Show the cursor position all the time.
set showbreak=…         " Highlight non-wrapped lines.
set showcmd             " Display incomplete command in bottom right corner.

if has('gui_running')
    set columns=80
    set lines=25
    set guioptions-=T   " Remove the toolbar.
    set guifont=Monaco:h11
    set transparency=5
else
    set t_Co=256        " We use 256 color terminal emulators these days.
endif

" Folding
if version >= 600
    set foldenable
    set foldmethod=marker
endif

" =============================================================================
"                                  Formatting
" =============================================================================
set formatoptions=tcrqn " see :h 'fo-table for a detailed explanation
"set formatoptions=croql
set copyindent          " Copy the structure of existing indentation
set shiftwidth=4        " tab indention 
set tabstop=4           " number of spcaes for a tab
set textwidth=79        " textwidth
set expandtab           " expand tabs to spaces

" Indentation Tweaks.
" e-s = do not indent if opening bracket is not first character in a line.
" g0  = do not indent C++ scope declarations.
" t0  = do not indent a function's return type declaration.
set cino=e-s,g0,t0

" =============================================================================
"                                   Spelling
" =============================================================================
if v:version >= 700
  set spelllang=en,de,pt
  set spellfile=~/.vim/spellfile.add
endif

" =============================================================================
"                                 Key Bindings
" =============================================================================

let mapleader=','   " Change the mapleader from '\' to ','.

nnoremap <esc> :noh<return>

" Toggle list mode (display unprintable characters).
nnoremap <F11> :set list!<CR>

" Toggle paste mode.
set pastetoggle=<F12>

" Quicker navigation for non-wrapped lines.
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" =============================================================================
"                               Custom Functions
" =============================================================================

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

nmap <Leader>$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap <Leader>= :call Preserve("normal gg=G")<CR>

" =============================================================================
"                                Filetype Stuff
" =============================================================================

if &t_Co > 2 || has('gui_running')
  syntax on
endif

" R stuff
autocmd BufNewFile,BufRead *.r set ft=r
autocmd BufNewFile,BufRead *.R set ft=r
autocmd BufNewFile,BufRead *.s set ft=r
autocmd BufNewFile,BufRead *.S set ft=r
autocmd BufRead *.Rout set ft=r
autocmd BufRead *.Rhistory set ft=r

" Custom file types
autocmd BufRead,BufNewFile *.dox     set filetype=doxygen spell
autocmd BufRead,BufNewFile *.mail    set filetype=mail
autocmd BufRead,BufNewFile *.bro     set filetype=bro
autocmd BufRead,BufNewFile *.ll      set filetype=llvm
autocmd BufRead,BufNewFile Portfile  set filetype=tcl

" Respect Doxygen comments.
autocmd FileType c,cpp set comments-=://
autocmd FileType c,cpp set comments+=:///
autocmd FileType c,cpp set comments+=://

autocmd Filetype ruby set sw=2 ts=2
autocmd Filetype mail set tw=72 spell
autocmd Filetype tex set sw=2 ts=2 iskeyword+=: spell

" Prepend CTRL on Alt-key mappings: Alt-{B,C,L,I}
"autocmd Filetype tex imap <C-M-b> <Plug>Tex_MathBF
"autocmd Filetype tex imap <C-M-c> <Plug>Tex_MathCal
"autocmd Filetype tex imap <C-M-l> <Plug>Tex_LeftRight
"autocmd Filetype tex imap <C-M-i> <Plug>Tex_InsertItem

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
    autocmd!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg u
augroup END

" =============================================================================
"                                    Vundle
" =============================================================================
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Vundle base
Bundle 'gmarik/vundle'

" LaTeX
Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
let g:tex_flavor = 'latex' " Prevents Vim 7 from setting filetype to 'plaintex'.

" Command-T
Bundle 'git://git.wincent.com/command-t.git'
let g:CommandTMatchWindowAtTop = 1  " Show window at top.

" Solarized colorscheme
Bundle 'altercation/vim-colors-solarized'
let g:solarized_menu = 0
let g:solarized_termtrans = 1
let g:solarized_contrast = 'high'
let g:solarized_contrast = 'high'
let g:solarized_hitrail = 1
if !has('gui_running')
  let g:solarized_termcolors = 256
end
colorscheme solarized

Bundle 'godlygeek/tabular'
Bundle 'rson/vim-conque'
Bundle 'rstacruz/sparkup'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/Vim-R-plugin'
" Bundle 'xolox/vim-easytags'

" MBE has some issues with fugitive at the moment.
"Bundle 'fholgado/minibufexpl.vim'
"let g:miniBufExplSplitBelow = 1
"let g:miniBufExplMapCTabSwitchBufs = 1

" Needs to be executed after Vundle.
filetype plugin indent on

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
