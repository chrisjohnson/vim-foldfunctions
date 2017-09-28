# vim-foldfunctions
Find top-level functions (from a naive parsing POV, not actual language syntax), and make them the only folds in the file.

In supported files, overrides the default `foldmethod` with the included expr handling approach, which depends on **sane indentation** (functions start and end on the same indentation level).

Please report cases in the issues tab but realize that I'm not going to bend the plugin over backward to support every edge case for every language.

![Screenshot](http://g.recordit.co/AKUiqTjJWO.gif)

## Supported FileTypes

- ruby
- php
- javascript
- vim
- cpp

## Usage

Just load it! In the languages it supports, it will enable itself and set the appropriate `foldlevel` and `foldnestmax`. Otherwise it will leave your global options alone. My .vimrc looks like this:

```
" Defaults for unsupported FileTypes
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

## Re-running

An occasional issue with iterative fold parsing like this is that it doesn't know when the "last line" state which it tracks is still the line it thinks it was. If it detects a change it will re-orient itself but some conditions will prevent it from detecting that.

You could reload the file to re-parse, or you could trigger the FileType autocmds automatically, like such:

```
" t in quickfix to open in new tab
autocmd FileType qf nnoremap <silent> <buffer> t <C-W><Enter><C-W>T
```

... becomes ...

```
" t in quickfix to open in new tab (and re-run folding)
autocmd FileType qf nnoremap <silent> <buffer> t <C-W><Enter><C-W>T :doauto FileType<CR>
```
