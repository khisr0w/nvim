set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc_temp

" New Configs for Nvim

tnoremap <Esc> <C-\><C-n>
set clipboard+=unnamedplus
"set statusline+=%F

hi Pmenu guibg=#504945
hi PmenuSel guibg=#ec524b

:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

nnoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>
inoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>

nnoremap <C-X> :silent !..\debug.bat<CR>

" key mapping for the quickfix jumps after compilation
:nnoremap <A-n> :cn<CR>
:nnoremap <A-b> :cN<CR>
:nnoremap <A-s> <Esc>:wa<CR>:silent call CompileSilent()<CR><C-w>p:q<CR>:cope<CR>

" Make the swap file warnings go away
" set shortmess+=A

:set makeprg=cmd 
:set splitbelow
:set splitright
function! CompileSilent()
	:wa
	:call setqflist([], 'a', {'tile' : 'MSVC Compilation'})
	:silent cgete system("pushd \%programfiles(x86)\%\\Microsoft Visual Studio 14.0\\VC & vcvarsall.bat x64 & popd & ..\\build.bat")
	:silent cc 1
	:wa
	:cl
endfunction

