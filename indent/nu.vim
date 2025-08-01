" Vim indent file
" Language: Nushell
" Maintainer: El Kasztano
" Last Updated: 07 December 2023

" Only load if no other indent file is loaded
if exists('b:did_indent') | finish | endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions=L0,(s,Ws,J1,j1,+0,f5,m1,i0
setlocal cinkeys=0{,0},!^F,o,O,0[,0],0),0#

setlocal autoindent
setlocal indentkeys=0{,0},!^F,o,O,0[,0],0),0#

setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

setlocal indentexpr=GetNuIndent(v:lnum)

" only define once
if exists("*GetNuIndent") | finish | endif

let s:save_cpo = &cpo
set cpo&vim

function GetNuIndent(lnum)
	let prevlnum = prevnonblank(v:lnum - 1) "get number of last non blank line
	let line = getline(a:lnum)
	let synname = synIDattr(synID(a:lnum, 1, 1), "name")
	if (synname == "nuString") || (synname == "nuComment")
		return -1
	endif
	if getline(prevlnum) =~ '\%(^.*[$\|^.*[\s*#.*$\)'
		return (prevlnum > 0) * indent(prevlnum) + shiftwidth()
	endif
	if getline(v:lnum) =~ "^\s*]\>"
		return (prevlnum > 0) * indent(prevlnum) - shiftwidth()
	endif
	return cindent(a:lnum)	
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
