func! dirvish_do#sudo#exec(cmd) abort
	let l:password = inputsecret("Password: ")
	if len(l:password) == 0
		echoerr "No password provided"
		return
	endif
	let l:cmd = 'sudo -p "" -S ' . a:cmd
	let l:result = system(l:cmd, l:password)
	if v:shell_error
		echoerr l:result
	endif
	return l:result
endfunction

func! dirvish_do#sudo#rm(path) abort
	let l:cmd = isdirectory(a:path) ? 'rm -rf ' : 'rm '
	return dirvish_do#sudo#exec(l:cmd . a:path)
endfunction
