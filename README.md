# vim-foldfunctions
This was cobbled together to give me more useful folding. I was tired of managing nested fold levels, all I really ever care about is folding top-level functions, nothing below that.

So for the supported languages (currently PHP, Ruby, JS), it will override the default foldmethod with the built-in expr handling approach, set foldlevel=0 and foldnestmax=1, and declare all top-level functions (and everything inside) as foldlevel 1, and everything else as foldlevel 0

This plugin is pretty naive at parsing your source code. It doesn't claim to be perfect. It also largely depends on sane indentation. It may or may not support tabs, but I'm sure it wouldn't be hard to add support if I got back around to using a codebase with tabs.
