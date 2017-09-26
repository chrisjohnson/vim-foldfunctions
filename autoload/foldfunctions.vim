let [b:lev, b:indentLevel, b:lnum] = [0, 0, 1]
function! foldfunctions#init()
	setlocal foldmethod=expr
	setlocal foldlevel=0
	setlocal foldnestmax=1
	let b:lev = 0
	let b:indentLevel = 0
	let b:lnum = 1
endf

function! foldfunctions#php()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'((abstract|final) )?((private|protected|public) )?(static )?<function>','\}')"
endf

function! foldfunctions#javascript()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'<function>','\}')
endf

function! foldfunctions#vim()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'<function>','<endf')
endf

function! foldfunctions#ruby()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'<def>','<end>')
endf

function! foldfunctions#cpp()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'.+\\(.*\\)(\\s*const\\s*)?\\s*\\{','\}')"
endf

function! foldfunctions#fold(lnum, startToken, endToken)
	let line = getline(a:lnum)

	" This is not a complete top-to-bottom parsing, get context
	if a:lnum != b:lnum
		if a:lnum == 1
			let b:lev = foldfunctions#isstart(line, a:startToken) ? 1 : 0
			let b:indentLevel = indent(a:lnum)
		else
			" Assume the level of the previous line
			let prevLine = a:lnum - 1
			let b:lev = foldlevel(prevLine)
			" ... unless that line ends a fold, then go back up
			let b:indentLevel = indent(foldfunctions#foldstart(prevLine))
			if foldfunctions#isend(getline(prevLine), a:endToken)
				let b:lev = 0
				let b:indentLevel = 0
			endif
		endif
	endif

	" We have context, parse using indentation level
	let b:lnum = a:lnum + 1
	if b:lev > 0
		if foldfunctions#isend(line, a:endToken)
			let b:indentLevel = 0
			let b:lev = 0
			return '<1'
		endif
		return 1
	else
		if foldfunctions#isstart(line, a:startToken)
			let b:indentLevel = indent(a:lnum)
			let b:lev = 1
			return '>1'
		endif
	endif

	return 0
endf

function! foldfunctions#foldstart(lnum)
	let [currentLevel, foldStart] = [-1, -1]
	let currentLine = a:lnum
	let startLevel = foldlevel(a:lnum)
	if currentLine == 1
		return startLevel > 0 ? 1 : -1
	endif
	while currentLine > 0
		let currentLevel = foldlevel(currentLine)
		if (currentLevel < startLevel) || (currentLine == 1)
			return currentLine + 1
		endif
		" Load the next line
		let currentLine -= 1
	endwhile

	return -1
endfunction

function foldfunctions#isstart(line, startToken)
	if a:line =~ '\v^\s*(' . a:startToken . ')'
		return 1
	endif

	return 0
endfunction

" Depends on b:indentLevel being set
function foldfunctions#isend(line, endToken)
	let indentMatch = b:indentLevel > 0 ? '\s{' . b:indentLevel . '}' : ''
	if (a:line =~ '\v^' . indentMatch . a:endToken) && (b:lev > 0)
		return 1
	endif

	return 0
endfunction
