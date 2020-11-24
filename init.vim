set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc_temp

" New Configs for Nvim
cd ~

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

nnoremap <C-X> :silent cd %:p:h<CR>:silent !..\debug.bat<CR>:silent cd /<CR>

" key mapping for the quickfix jumps after compilation
:nnoremap <A-n> :cn<CR>
:nnoremap <A-b> :cN<CR>
:nnoremap <A-s> <Esc>:wa<CR>:silent call CompileSilent()<CR><C-w>p:q<CR>:cope<CR>

cab e e %:p:h
cab sp sp %:p:h
cab vsp vsp %:p:h
cab split split %:p:h
cab vsplit vsplit %:p:h
cab E e
au BufWinEnter *.cpp,*.c,*.h,*.hpp,*.bat cd %:p:h | cd /

:set makeprg=cmd 
:set splitbelow
:set splitright
function! CompileSilent()
	:wa
	:call setqflist([], 'a', {'title' : 'MSVC Compilation'})
	:cd %:p:h
	:silent cgete system("pushd \%programfiles(x86)\%\\Microsoft Visual Studio 14.0\\VC & vcvarsall.bat x64 & popd & ..\\build.bat")
	:cd /
	:silent cc 1
	:wa
	:cl
endfunction

function! MakeProj(...)
	if(a:0 == 0)
		echoerr "Please provide the name for your project"
	else
		execute 'let name = a:1'
		silent execute '!mkdir ' . name
		execute 'cd ' . name
		if(a:0 == 2)
			execute 'sp ' . a:2
			silent w
			q
		endif
		echo "++++ Project Successfully Created ++++"
	endif
endfunction
com! -nargs=* -complete=file MakeProj call MakeProj(<f-args>)
cab makeproj MakeProj

"redir @x
"echo expand("%:t:r")
"redir END
"redir @x>>
"echo "_"
"echo expand("%:e")
"redir END

"function! Sp(...)
"  if(a:0 == 0)
"    sp
"  else
"    let i = a:0
"    while(i > 0)
"      execute 'let file = a:' . i
"      execute 'sp ' . file
"      let i = i - 1
"    endwhile
"  endif
"endfunction
"com! -nargs=* -complete=file Sp call Sp(<f-args>)
"cab sp Sp

"function! OpenFullPath()
"	:cd /
"	:file %:p
"	:e %:p
"	:cd -
"endfunction

" Make the swap file warnings go away
" set shortmess+=A

" Write full path in the buffer name, in order to make it work with MSVC
" quickfix compilation
"au BufReadPre *.cpp,*.c,*.h,*.hpp cd /
"au BufReadPost *.cpp,*.c,*.h,*.hpp e %:p
"au BufWinEnter *.cpp,*.c,*.h,*.hpp call OpenFullPath()
""au BufAdd *.cpp,*.c,*.h,*.hpp e %:p
