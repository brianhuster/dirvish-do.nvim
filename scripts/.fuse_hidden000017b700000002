Git add .
let s:commitMsg = input("Commit message: ", "", "file")
if len(s:commitMsg) == 0
	finish
endif
exec "Git commit -m '" . s:commitMsg . "'"
Git pull --rebase
Git push
