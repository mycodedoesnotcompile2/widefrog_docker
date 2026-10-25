set visualbell
set t_vb=
set syntax=c
syntax on
set number
set nocompatible
set laststatus=2
set scrolloff=3
set sidescrolloff=2
set numberwidth=3
map <F10> :set invnumber<CR>

filetype plugin on
filetype indent on

set smartindent
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

map <F11> :set invpaste<CR>
set pastetoggle=<F11>

set ignorecase
set smartcase
set incsearch
set hlsearch
noremap ;; :%s:::g<Left><Left><Left>

map <silent> ,# :s/^/#/<CR><Esc>:nohlsearch<CR>
map <silent> ,/ :s/^/\/\//<CR><Esc>:nohlsearch<CR>
map <silent> ,> :s/^/> /<CR><Esc>:nohlsearch<CR>
map <silent> ," :s/^/\"/<CR><Esc>:nohlsearch<CR>
map <silent> ,% :s/^/%/<CR><Esc>:nohlsearch<CR>
map <silent> ,! :s/^/!/<CR><Esc>:nohlsearch<CR>
map <silent> ,; :s/^/;/<CR><Esc>:nohlsearch<CR>
map <silent> ,- :s/^/--/<CR><Esc>:nohlsearch<CR>
map <silent> ,d :s/^/dnl /<CR><Esc>:nohlsearch<CR>
map <silent> ,c :s:\(^\s*\)\(//\\|--\\|> \\|[#"%!;]\\|dnl \):\1:e<CR><Esc>:nohlsearch<CR>

map <silent> ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>
map <silent> ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR><Esc>:nohlsearch<CR>
map <silent> ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
map <silent> ,u :s:\(^\s*\)\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$:\1\3:e<CR><Esc>:nohlsearch<CR>
