let [s:lev, s:indentLevel] = [0, 0]
function foldfunctions#init()
	setlocal foldmethod=expr
	setlocal foldlevel=0
	setlocal foldnestmax=1
	let s:lev = 0
	let s:indentLevel = 0
endf

function foldfunctions#php()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#fold(v:lnum,'(private\ )?(protected\ )?(public\ )?(static\ )?<function>','\}')
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
