vim.cmd([[
let g:c_function_highlight = 1
syntax on
set hlsearch
set incsearch
set backspace=indent,eol,start
set nowrap

set breakindent showbreak=..
set linebreak
"set foldmethod=indent foldcolumn=4
set tabstop=4 shiftwidth=4 expandtab

set cindent
set smartindent
set autoindent
set smarttab
set ignorecase
set smartcase
"set softtabstop=0 noexpandtab
set nonu
set norelativenumber
set cursorline
set belloff=all
"set autochdir

"autocmd FileType help,* wincmd L
"au GUIEnter * simalt ~x
autocmd FileType make setlocal noexpandtab

autocmd BufNewFile,BufRead *.vs,*.fs set ft=glsl
"autocmd BufWritePost *.c,*.h system('pushd .. && ctags && popd')

hi Search ctermbg=white ctermfg=red
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

colorscheme gruvbox
cd ~
cab scratch E:/den/content/posts/scratch.md
cab WA w

tnoremap <Esc> <C-\><C-n>
"set clipboard+=unnamedplus
set laststatus=2

hi Pmenu guibg=#504945
hi PmenuSel guibg=#ec524b

:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

nnoremap <C-X> :silent !..\debug.bat<CR>

" key mapping for the quickfix jumps after compilation
:nnoremap µ :cn<CR>
:nnoremap ∫ :cN<CR>

nnoremap <A-s> <Esc>:wa<CR>:call CompileSilentAndRun()<CR>
":nnoremap <A-s> <Esc>:wa<CR>:silent call CompileSilentAndRun()<CR><C-w>p:q<CR>:cope<CR>

"au BufWinEnter *.cpp,*.c,*.h,*.hpp,*.bat cd %:p:h | cd /
au BufNewFile *.h,*.hpp silent w | HeaderNewFileTemplate() | cd %:p:h
au BufNewFile *.cpp,*.c silent w | CPPNewFileTemplate() | cd %:p:h
au BufUnload *.cpp,*.c,*.h,*.hpp call UpdateFile()

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
				if(search('\(|.*Copyright.*©.*Sayed.*Abid.*Hashimi.|\)', 'W') == 7)
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
	call setpos('.', [curpos[0], curpos[1], curpos[2], curpos[3] ])
endfunction

function! CompileSilentAndRun()
	:wa
	:call setqflist([], 'a', {'title' : 'Compilation and Run'})
	":silent cgete system('pushd .. && make -B run && popd')
	:silent cgete system('pushd .. && cd binary && cmake --build . && cmake --build . --target exec && popd')
	:silent cc 1
	:wa
	:cl
endfunction
function! CompileSilent()
	:wa
	:call setqflist([], 'a', {'title' : 'Compilation'})
	":silent cgete system('pushd .. && make -B debug && popd')
	:silent cgete system('pushd .. && cmake --build binary && popd')
	:silent cc 1
	:wa
	:cl
endfunction

function! CPPNewFileTemplate(...)

	execute 'let filemacro = toupper(expand("%:t:r")) . "_" . toupper(expand("%:e"))'
	execute 'let linenum = 1'
	let head = "/*  +======| File Info |===============================================================+"
	silent call appendbufline("", linenum, head)
	let linenum = linenum + 01
	let pad = "    |                                                                                  |"
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	let end = "    +==================================================| Sayed Abid Hashimi |==========+  */"

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
	:0
	execute 'normal dd'

endfunction

com! -nargs=* -complete=file CPPNewFileTemplate call CPPNewFileTemplate(<f-args>)

function! HeaderNewFileTemplate(...)

	execute 'let filemacro = toupper(expand("%:t:r")) . "_" . toupper(expand("%:e"))'
	execute 'let linenum = 1'
	let head = "/*  +======| File Info |===============================================================+"
	silent call appendbufline("", linenum, head)
	let linenum = linenum + 01
	let pad = "    |                                                                                  |"
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	let end = "    +==================================================| Sayed Abid Hashimi |==========+  */"

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
com! -nargs=* -complete=file HeaderNewFileTemplate call HeaderNewFileTemplate(<f-args>)

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
]])

platform = require("platform")
vim.o.shell = platform.shell_path
