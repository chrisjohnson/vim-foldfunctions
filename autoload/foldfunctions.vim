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

function foldfunctions#fold(lnum, startToken, endToken)
	let line = getline(a:lnum)

	" This is not a complete top-to-bottom parsing, get context
	if a:lnum != s:lnum
		if a:lnum == 1
			let s:lev = foldfunctions#isstart(line, a:startToken) ? '>1' : 0
		else
			" Assume the level of the previous line
			let prevLine = a:lnum - 1
			let s:lev = foldlevel(prevLine)
			" ... unless that line ends a fold, then go back up
			let s:indentLevel = indent(foldfunctions#foldstart(prevLine))
			echom 'prevLine:' . prevLine . ' :: isend:' . foldfunctions#isend(getline(prevLine), a:endToken) . ' :: s:lev:' . s:lev . ' :: s:indentLevel:' . s:indentLevel . ' :: foldstart:' . foldfunctions#foldstart(prevLine) . ' :: line:' . getline(prevLine)
			if foldfunctions#isend(getline(prevLine), a:endToken)
				echom 'found'
				let s:lev = 0
			endif
		endif
	endif

	" We have context, parse using indentation level
	let s:lnum = a:lnum + 1
	if s:lev > 0
		if foldfunctions#isend(line, a:endToken)
			let s:indentLevel = 0
			let s:lev = 0
			return '<1'
		endif
		return 1
	else
		if foldfunctions#isstart(line, a:startToken)
			let s:indentLevel = indent(a:lnum)
			let s:lev = 1
			return '>1'
		endif
	endif

	return 0
endf

function foldfunctions#foldstart(lnum)
	let [currentLevel, foldStart] = [-1, -1]
	let currentLine = a:lnum
	let startLevel = foldlevel(a:lnum)
	if currentLine == 1
		echom 'foldfunctions#foldstart(' . a:lnum . '):' . (startLevel > 0 ? 1 : -1)
		return startLevel > 0 ? 1 : -1
	endif
	echom 'startLevel:' . startLevel
	while currentLine > 0
		let currentLevel = foldlevel(currentLine)
		echom currentLine . '::' . currentLevel
		if (currentLevel < startLevel) || (currentLine == 1)
			echom 'foldfunctions#foldstart(' . a:lnum . '):' . (currentLine + 1)
			return currentLine + 1
		endif
		" Load the next line
		let currentLine -= 1
	endwhile

	echom 'foldfunctions#foldstart(' . a:lnum . '):-1'
	return -1
endfunction

function foldfunctions#isstart(line, startToken)
	let startmatches = matchlist(a:line, '\v^\s*(' . a:startToken . ')')
	if startmatches[1] != ''
		return 1
	endif

	return 0
endfunction

function foldfunctions#isend(line, endToken)
	let indentMatch = s:indentLevel > 0 ? '\s{' . s:indentLevel . '}' : ''
	if (a:line =~ '\v^' . indentMatch . a:endToken) && (s:lev > 0)
		return 1
	endif

	return 0
endfunction
