Should be run with foldminlines=1, like:

```
# Delete any saved views to be sure it doesn't cache old foldfunctions definitions
rm -rf  ~/.vim/view/*vim-foldfunctions*
# Open all tests
vim -c "set foldminlines=1" -p tests/*/*
```
