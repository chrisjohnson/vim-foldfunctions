let [s:lev, s:indentLevel, s:lnum] = [0, 0, 1]
function foldfunctions#init()
	setlocal foldmethod=expr
	setlocal foldlevel=0
	setlocal foldnestmax=1
	let s:lev = 0
	let s:indentLevel = 0
	let s:lnum = 1
endf

function foldfunctions#php()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'((abstract|final) )?((private|protected|public) )?(static )?<function>','\}')"
endf

function foldfunctions#javascript()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'<function>','\}')
endf

function foldfunctions#ruby()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'<def>','<end>')
endf

function foldfunctions#foldstart(lnum)
	let [currentLevel, foldStart] = [-1, -1]
	let currentLine = a:lnum
	let startLevel = foldlevel(a:lnum)
	while foldStart == -1
		let currentLevel = foldlevel(currentLine)
		if (currentLevel < startLevel) || (currentLine == 1)
			let foldStart = currentLine
		endif
		" Load the next line
		let currentLine -= 1
	endwhile

	if foldStart == -1
		foldStart = 1
	endif

	return foldStart
endfunction

function foldfunctions#fold(lnum, startToken, endToken)
	if a:lnum != s:lnum
		" This is not an in-order parsing, get context

		" Assume the level of the previous line
		let s:lev = foldlevel(a:lnum - 1)
		" ... unless that line ends a fold, then go back up
		let s:indentLevel = indent(foldfunctions#foldstart(a:lnum - 1))
		let indentMatch = s:indentLevel > 0 ? '\s{' . s:indentLevel . '}' : ''
		if getline(a:lnum-1)=~ '\v^' . indentMatch . a:endToken && s:lev > 0
			let s:lev = 0
		endif
	endif

	let line = getline(a:lnum)
	let s:lnum = a:lnum + 1
	if s:lev > 0
		let indentMatch = s:indentLevel > 0 ? '\s{' . s:indentLevel . '}' : ''
		if line =~ '\v^' . indentMatch . a:endToken
			let s:indentLevel = 0
			let s:lev = 0
			return '<1'
		endif
		return s:lev
	else
		let startmatches = matchlist(line, '\v^(\s*)(' . a:startToken . ')')
		if startmatches[2] != ''
			let s:indentLevel = indent(a:lnum)
			let s:lev = 1
			return '>1'
		endif
	endif
endf
