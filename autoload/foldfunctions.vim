let [s:lev, s:indentLevel] = [1, 0]
function foldfunctions#init()
	setlocal foldmethod=expr
	setlocal foldlevel=0
	setlocal foldnestmax=1
	let s:lev = 0
endf

function foldfunctions#php()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#foldphp(v:lnum)
endf

function foldfunctions#foldphp(lnum)
	" TODO
endf

function foldfunctions#javascript()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#foldjavascript(v:lnum)
endf

function foldfunctions#foldjavascript(lnum)
	" TODO
endf

function foldfunctions#ruby()
	call foldfunctions#init()
	setlocal foldexpr=foldfunctions#foldruby(v:lnum)
endf

function foldfunctions#foldruby(lnum)
	let line = getline(a:lnum)
	if s:lev > 0
		let indentMatch = s:indentLevel > 0 ? '\s{' . s:indentLevel . '}' : ''
		if line =~ '\v^' . indentMatch . '<end>'
			let s:indentLevel = 0
			let s:lev = 0
			return '<1'
		endif
		return s:lev
	else
		let startmatches = matchlist(line, '\v^(\s*)<def>')
		if startmatches[0] != ''
			let s:indentLevel = indent(a:lnum)
			let s:lev = 1
			return '>1'
		endif
	endif
endf
