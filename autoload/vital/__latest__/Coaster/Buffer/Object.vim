scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:obj = {
\	"__variable" : {}
\}


function! s:obj.number()
	return self.__variable.bufnr
endfunction


function! s:obj.invoke(func, args)
	return call(a:func, [self.number()] + a:args)
endfunction


function! s:obj.name()
	return self.invoke("bufname")
endfunction


function! s:obj.get_variable(...)
	return self.invoke("getbufvar", a:000)
endfunction


function! s:obj.set_variable(...)
	return self.invoke("setbufvar", a:000)
endfunction


function! s:obj.get_option(name)
	return self.get_variable("&" . a:name)
endfunction


function! s:obj.set_option(name, var)
	return self.set_variable("&" . a:name, a:var)
endfunction


function! s:obj.winnr()
	return self.invoke("bufwinnr")
endfunction


function! s:obj.is_exists()
	return bufexists(self.number())
endfunction


function! s:obj.is_listed()
	return self.invoke("buflisted")
endfunction


function! s:obj.is_loaded()
	return self.invoke("bufloaded")
endfunction


function! s:obj.is_current()
	return self.number() == bufnr("%")
endfunction


function! s:obj.is_modifiable()
	return self.get_option("modifiable")
endfunction


function! s:obj.tap()
	if !self.is_exists() || self.is_tapped()
		return
	endif
	let self.__variable.tab_bufnr = bufnr("%")
	split
	execute "b" self.number()
	return self.number()
endfunction


function! s:obj.untap()
	if !self.is_tapped()
		return
	endif
	quit
	silent! execute "buffer" self.__variable.tab_bufnr
	unlet self.__variable.tab_bufnr
	return self.number()
endfunction


function! s:obj.is_tapped()
	return has_key(self.__variable, "tab_bufnr")
endfunction


function! s:obj.execute(cmd)
	if self.is_current()
		execute a:cmd
		return
	endif
	if self.tap()
		try
			execute a:cmd
		finally
			call self.untap()
		endtry
	endif

" 	let view = winsaveview()
" 	try
" 		noautocmd silent! execute "bufdo if bufnr('%') == " a:expr . ' | ' . string(a:cmd) . ' | endif'
" 	finally
" 		noautocmd silent! execute "buffer" bufnr
" 		call winrestview(view)
" 	endtry
endfunction


function! s:obj.setline(lnum, text, ...)
	" 	if has("python")
" 		return s:setbufline_if_python(a:expr, a:lnum, a:text)
" 	else
" 		return s:execute(bufnr(a:expr), "call setline(" . a:lnum . "," . string(a:text) . ")")
" 	endif

	let force = get(a:, 1, 0)
	if !(self.is_modifiable() || force)
		return
	endif
	if self.tap()
		try
			let modifiable = &modifiable
			set modifiable
			call setline(a:lnum, a:text)
		finally
			let &modifiable = modifiable
			call self.untap()
		endtry
	endif
" 	return self.execute("call setline(" . a:lnum . "," . string(a:text) . ")")
endfunction


function! s:obj.clear(...)
	let force = get(a:, 1, 0)
	if !(self.is_modifiable() || force)
		return
	endif
	if self.tap()
		try
			let modifiable = &modifiable
			set modifiable
			silent % delete _
		finally
			let &modifiable = modifiable
			call self.untap()
		endtry
	endif
endfunction


function! s:make(expr)
	let obj = deepcopy(s:obj)
	let obj.__variable.bufnr = bufnr(a:expr)
	return obj
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
