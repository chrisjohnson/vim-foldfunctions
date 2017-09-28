let [b:lev, b:lnum, b:indentMatch] = [0, 1, '']
function! foldfunctions#init()
	setlocal foldmethod=expr
	setlocal foldlevel=0
	setlocal foldnestmax=1
	let b:lev = 0
	let b:indentMatch = ''
	let b:lnum = 1
endf

function! foldfunctions#php()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'((abstract|final) )?((private|protected|public) )?(static )?<function>','\}')"
endf

function! foldfunctions#javascript()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'([^\/[:space:]]|\/[^\/]).*\\(.*\\)\\s*','\}','\\{\\s*$')"
endf

function! foldfunctions#vim()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'<function>','<endf')"
endf

function! foldfunctions#ruby()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'<def>','<end>')"
endf

function! foldfunctions#cpp()
	call foldfunctions#init()
	let &l:foldexpr = "foldfunctions#fold(v:lnum,'([^\/[:space:]]|\/[^\/]).*\\(.*\\)(\\s*const\\s*)?\\s*','\}','\\{\\s*$')"
endf

function! foldfunctions#fold(lnum, startToken, endToken, ...)
	let line = getline(a:lnum)
	let l:nextLineStartToken = get(a:, 1, '')

	" This is not a complete top-to-bottom parsing, get context
	if a:lnum != b:lnum
		if a:lnum == 1
			let b:lev = foldfunctions#isstart(line, a:lnum + 1, l:nextLineStartToken) ? 1 : 0
			let b:indentMatch = foldfunctions#getindent(line)
		else
			" Assume the level of the previous line
			let prevLine = a:lnum - 1
			let b:lev = foldlevel(prevLine)
			" ... unless that line ends a fold, then go back up
			let b:indentMatch = foldfunctions#getindent(getline(foldfunctions#foldstart(prevLine)))
			if foldfunctions#isend(getline(prevLine), a:endToken)
				let b:lev = 0
				let b:indentMatch = ''
			endif
		endif
	endif

	" We have context, parse using indentation level
	let b:lnum = a:lnum + 1
	if b:lev > 0
		if foldfunctions#isend(line, a:endToken)
			let b:indentMatch = ''
			let b:lev = 0
			return '<1'
		endif
		return 1
	else
		if foldfunctions#isstart(line, a:startToken, a:lnum + 1, l:nextLineStartToken)
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

function! foldfunctions#isstart(line, startToken, ...)
	let l:nextLnum = get(a:, 1, 0)
	let l:nextLineStartToken = get(a:, 2, '')

	if l:nextLineStartToken == ''
		" The startToken is all in a single expression
		let matches = matchlist(a:line, '\v^(\s*)(' . a:startToken . ')')
		if len(matches) > 0
			let b:indentMatch = matches[1]
			return 1
		else
			return 0
		endif
	else
		" Try the next-line token on the current line first
		let matches = matchlist(a:line, '\v^(\s*)(' . a:startToken . l:nextLineStartToken . ')')
		if len(matches) > 0
			let b:indentMatch = matches[1]
			return 1
		endif
			" Try it split over both lines
			let l:nextLine = getline(l:nextLnum)
			let matches = matchlist(l:nextLine, '\v^(\s*)(' . l:nextLineStartToken . ')')
			if a:line =~ '\v^(\s*)(' . a:startToken . ')' && len(matches) > 0
				let b:indentMatch = matches[1]
				return 1
			endif
		endif
	endif

	return 0
endfunction

" Depends on b:indentMatch being set
function! foldfunctions#isend(line, endToken)
	if (a:line =~ '\v^' . b:indentMatch . a:endToken) && (b:lev > 0)
		return 1
	endif

	return 0
endfunction

function! foldfunctions#getindent(line)
	let matches = matchlist(a:line, '\v^(\s*)([^[:space:]])')
	if len(matches) < 1
		return ''
	endif

	return matches[1]
endfunction
