call vital#of("vital").unload()
let s:Highlight = vital#of("vital").import("Coaster.Highlight")
call clearmatches()
let s:highlighter = s:Highlight.make()


let s:groups = [
\	"Search",
\	"WarningMsg",
\	"Error",
\	"Exception",
\]
let s:count = 0


function! CoasterUpdate()
	call s:highlighter.disable_all()
	call s:highlighter.enable_all()
endfunction


function! CoasterAdd(word)
	let group = s:groups[ s:count % len(s:groups) ]
	call s:highlighter.add(group, group, a:word)
	call CoasterUpdate()
	let s:count += 1
endfunction


function! CoasterDelete(word)
	call s:highlighter.delete_by("pattern ==# " . string(a:word))
	call CoasterUpdate()
	let s:count -= 1
endfunction


function! CoasterDeleteAll()
	let s:count = 0
	call s:highlighter.disable_all()
	call s:highlighter.delete_all()
endfunction


command! CoasterAdd call CoasterAdd('\<' . expand("<cword>") . '\>')
command! CoasterDelete call CoasterDelete('\<' . expand("<cword>") . '\>')
command! CoasterDeleteAll call CoasterDeleteAll()


augroup coaster-example-quickhighlight
	autocmd!
	autocmd CursorMoved * call CoasterUpdate()
augroup END

