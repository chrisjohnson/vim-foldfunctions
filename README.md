# vim-foldfunctions
Set the foldlevel and foldnestmax according to the top-most level that functions/methods are defined at

foldmethod=expr
Examples:

https://github.com/mgedmin/dotvim/blob/master/syntax/python.vim
https://gist.github.com/vim-voom/4390083
https://www.ibm.com/developerworks/library/l-vim-script-1/index.html#N101CB
https://vi.stackexchange.com/questions/2176/how-to-write-a-fold-expr

Track the indentation when a foldlevel starts in a variable
For any given line, if the line ends a foldlevel (use the indentation level to track), end foldlevel
Else, return = to maintain current fold level
