syntax on
set hlsearch
set incsearch
set backspace=indent,eol,start
set nowrap
set breakindent
set cindent
set smartindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=0 noexpandtab
set nu
set relativenumber
set cursorline
set belloff=all
set autochdir

hi Search ctermbg=white ctermfg=red
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

if has('gui_running')
	set guioptions-=m  "menu bar
	set guioptions-=T  "toolbar
	set guioptions-=r  "scrollbar
	set guioptions-=L  "scrollbar
	set guifont=Fantasque_Sans_Mono:h12:cANSI:qDRAFT
	colorscheme gruvbox
	au GUIEnter * simalt ~x
	nnoremap <C-S> :call CompileSilent()<CR>
	inoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>
endif

" ============================================================================

cd ~
cab w wa
cab WA w

"au VimEnter * jobstart(['pushd F:\dev', '&', 'escToCaps.exe', '&', 'popd'])
"au VimEnter * jobstart(['cmd.exe', 'ping neovim.io')

tnoremap <Esc> <C-\><C-n>
"set clipboard+=unnamedplus
set laststatus=2
set statusline+=%F

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

"au BufWinEnter *.cpp,*.c,*.h,*.hpp,*.bat cd %:p:h | cd /
au BufNewFile *.cpp,*.c,*.h,*.hpp,*.bat silent w | CNewFileTemplate() | cd %:p:h
au BufWritePre *.cpp,*.c,*.h,*.hpp,*.bat call UpdateFile()

"echo bufname(1)

:set makeprg=cmd 
:set splitbelow
:set splitright

function! UpdateFile()
	let curpos = getcurpos()
	:0
	if(search('/\*', 'Wc') == 1)
		if(search('\(+======.*|.*File.*Info.*|\)', 'W') == 1)
			if(search('\(Last.*Modified.*:\)', 'W') == 5)
				if(search('\(|.*Sayed.*Abid.*Hashimi.*,.*Copyright.*©.*All.*rights.*reserved.|\)', 'W') == 7)
					:0
					let line = search('\(Last.*Modified.*:\)', 'W')
					execute 'let text = "    |    Last Modified:  " . strftime("%c", localtime())'
					let i = 88 - len(text)
					while(i > 1)
						execute 'let text = text . " "'
						let i = i - 01
					endwhile
					execute 'let text = text . "|"'
					silent call setline(line, text)
				endif
			endif
		endif
	endif
	call setpos('.', [curpos[0], curpos[1], curpos[2], curpos[3]])
endfunction

function! CompileSilent()
	:wa
	:call setqflist([], 'a', {'title' : 'MSVC Compilation'})
	:silent cgete system('pushd "%programfiles(x86)%\Microsoft Visual Studio 14.0\VC" & vcvarsall.bat x64 & popd & ..\\build.bat')
	:silent cc 1
	:wa
	:cl
endfunction

function! CNewFileTemplate(...)

	execute 'let filemacro = toupper(expand("%:t:r")) . "_" . toupper(expand("%:e"))'
	execute 'let linenum = 1'
	let head = "/*  +======| File Info |===============================================================+"
	silent call appendbufline("", linenum, head)
	let linenum = linenum + 01
	let pad = "    |                                                                                  |"
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	let end = "    +=====================| Sayed Abid Hashimi, Copyright © All rights reserved |======+  */"

	let subd = expand("%:p:h:t")
	let created = strftime("%c", getftime(expand("%:p")))
	execute 'let first = "    |     Subdirectory:  /" . subd'
	execute 'let second = "    |    Creation date:  " . created'
	execute 'let third = "    |    Last Modified:  "'
	let values = [first, second, third]

	let item = len(values)
	execute 'let i = 0'
	while(i < item)

		let j = len(head) - len(values[i])
		while(j > 1)
			execute 'let values[i] = values[i] . " "'
			let j = j - 01
		endwhile
		execute 'let values[i] = values[i] . "|"'
		silent call appendbufline("", linenum, values[i])
		let linenum = linenum + 01
		let i = i + 01
	endwhile
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, end)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "")
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "#if !defined(" . filemacro . ")")
	let linenum = linenum + 01

	execute 'let i = 10'
	while(i > 0)
		silent call appendbufline("", linenum, "")
		let linenum = linenum + 01
		let i = i - 01
	endwhile

	silent call appendbufline("", linenum, "#define " . filemacro)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "#endif")
	let linenum = linenum + 01
	:0
	execute 'normal dd'
endfunction
com! -nargs=* -complete=file CNewFileTemplate call CNewFileTemplate(<f-args>)

function! MakeProj(...)
	if(a:0 == 0)
		echoerr "Please provide the name for your project"
	else
		execute 'let name = a:1'
		silent execute '!mkdir ' . name
		execute 'cd ' . name
		if(a:0 == 2)
			if(!empty(bufname()))
				silent w
			endif
			execute 'e ' . a:2
			silent w
		endif
	endif
	echo "++++ Project Successfully Created ++++"
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
