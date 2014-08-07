call vital#of("vital").unload()
let s:V = vital#of("vital")
let s:Buffer = s:V.import("Coaster.Buffer")
let s:Search = s:V.import("Coaster.Search")

" カーソル上のテキストを <C-x> <C-a> で切り替える
let s:data = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']

nnoremap <silent> <C-x> :call <SID>increment()<CR>
nnoremap <silent> <C-a> :call <SID>decrement()<CR>


function! s:change(flag)
	let data = s:data

	" カーソル位置から \w\+ にマッチする範囲を取得する
	let [first, last] = s:Search.region('\w\+', "Wncb", "Wnce")

	" Buffer と Search で使用する位置の形式が違うので合わせる
	let first = [0] + first + [0]
	let last  = [0] + last + [0]

	" 任意の範囲のテキストを取得
	let cword = s:Buffer.get_text_from_region(first, last, "v")
	let index = index(data, cword)
	if index == -1
		return
	endif

	" 任意の範囲にテキストを貼り付け
	call s:Buffer.paste_for_text("v", first, last, data[(index + a:flag) % len(data)])
endfunction

function! s:increment()
	call s:change(1)
endfunction

function! s:decrement()
	call s:change(-1)
endfunction


