# vim-foldfunctions
Find top-level functions (from a naive parsing POV, not actual language syntax), and make them the only folds in the file.

In supported files, overrides the default `foldmethod` with the included expr handling approach, which depends on **sane indentation** (functions start and end on the same indentation level).

May not work with tabs, but it wouldn't be hard to add support (PRs welcome).

![Screenshot](http://g.recordit.co/v8eYn3mCQl.gif)

## Supported Languages

- Ruby
- PHP
- Javascript

## Usage

Just load it! In the languages it supports, it will enable itself and set the appropriate `foldlevel` and `foldnestmax`. Otherwise it will leave your global options alone. My .vimrc looks like this:

```
" Folding

" Defaults for non-parsed languages
set foldlevel=1
set foldmethod=syntax

" Global settings for all folding
set foldminlines=3
set foldcolumn=1

set foldtext=MyFoldText() 
function! MyFoldText()
	let n = v:foldend - v:foldstart + 1 
	let line = getline(v:foldstart)
	let sub = substitute(line, '^\s*', '', 'g')
	return "+-- " . sub . " --(" . n . " lines)" . v:folddashes
endfunction

" Mappings
" Space to toggle folds
nnoremap <Space> za
" <leader>Space to focus on current fold
nnoremap <leader><Space> zMzv:set foldminlines=1<cr>
```
