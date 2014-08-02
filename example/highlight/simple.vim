" 
let s:Highlight = vital#of("vital").import("Coaster.Highlight")

" ハイライトを行うオブジェクトの生成
let s:highlighter = s:Highlight.make()

" ハイライトの設定を追加
" この時点ではハイライトは行われない
call s:highlighter.add("alpha", "WarningMsg", '\l')
call s:highlighter.add("ALPHA", "Search", '\u')
call s:highlighter.add("number", "MoreMsg", '\d')


function! CoasterHighlight()
	" 現在のバッファで
	" add で設定したハイライトを有効にする
	call s:highlighter.enable_all()
endfunction

function! CoasterUnhighlight()
	" 現在のバッファで
	" add で設定したハイライトを無効にする
	call s:highlighter.disable_all()
endfunction


