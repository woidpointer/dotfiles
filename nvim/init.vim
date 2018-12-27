"------------------------------------------------------------------------------
"
"
"
"
"
"
"
"------------------------------------------------------------------------------

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction



call plug#begin('~/.local/share/nvim/plugged')


Plug 'jnurmine/Zenburn'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'rhysd/vim-clang-format'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'tpope/vim-fugitive'

"Plug 'Valloric/ListToggle'
"Plug 'scrooloose/syntastic'
"Plug 'jiangmiao/auto-pairs'

call plug#end()


set lcs=trail:·,tab:»·
set list
set cursorline
set undofile
set title
set spell spelllang=en_us
set spellcapcheck=""

set signcolumn=yes


filetype plugin indent on
syntax on

" set 256 color mode
set t_Co=256

" try-catch block around the color selection because the first time the 
" zenburn color is not available because it is installed by plug
try
  color zenburn
catch
  color desert
endtry

set ruler
set number
set relativenumber
set colorcolumn=80

" Tab settings
set shiftwidth=2
set softtabstop=2
set expandtab

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2


" Remap leader key to space
let mapleader=" "


" autocmd vimenter * NERDTree
" ClangFormat
autocmd Filetype c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd Filetype c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>

" YouCompleteMe
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"Do not ask when starting vim
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_collect_identifiers_from_tags_files = 1
set tags+=./.tags
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" NERDTREE 
map <C-n> :NERDTreeToggle<CR>

map <C-p> :FZF<CR>

" AIRLINE
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='zenburn'

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'


" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>




" Buffer Handling
"
"  This allows buffers to be hidden if you've modified a buffer.
"  This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" " This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" " This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

let g:lt_location_list_toggle_map = '<leader>tl'
let g:lt_quickfix_list_toggle_map = '<leader>tq'

"-------------------------------------------------------------------------------
" fonts-powerline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

