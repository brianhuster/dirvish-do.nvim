!git add .
let s:commitMsg = input("Commit message: ", "", "file")
if len(s:commitMsg) == 0
	finish
endif
exec "!git commit -m '".s:commitMsg."'"
!git pull --rebase
!git push
