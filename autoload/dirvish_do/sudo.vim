func! dirvish_do#sudo#exec(cmd) abort
	let l:password = inputsecret("Password: ")
	if !l:password || len(l:password) == 0
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

func! dirvish_do#sudo#mkdir(dir) abort
	return dirvish_do#sudo#exec('mkdir -p ' . a:dir)
endfunction

func! dirvish_do#sudo#rm(path) abort
	if isdirectory(a:path)
		return dirvish_do#sudo#exec('rm -rf ' . a:path)
	else
		return dirvish_do#sudo#exec('rm ' . a:path)
	endif
endfunction

func! dirvish_do#sudo#mv(src, dest) abort
	return dirvish_do#sudo#exec('mv ' . a:src . ' ' . a:dest)
endfunction

func! dirvish_do#sudo#cp(src, dest) abort
	return dirvish_do#sudo#exec('cp -r ' . a:src . ' ' . a:dest)
endfunction

func! dirvish_do#sudo#mkfile(path) abort
	return dirvish_do#sudo#exec('touch ' . a:path)
endfunction
