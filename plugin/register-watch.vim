" registerの内容を常に表示する

if exists('g:loaded_register_watch')
  finish
endif
let g:loaded_register_watch = 1

let s:save_cpo = &cpo
set cpo&vim

let g:register_watch_targets = '"0123456789abcdefghijklmnopqrstuvwxyz-*+.:%#'
let g:register_watch_separator = ' '

let s:target_buf_name = 'register-watch-buf'
let s:target_buf_number = 0

fu! RegisterWatchNew()
  sil execute 'vnew' s:target_buf_name
  let s:target_buf_number = bufnr(s:target_buf_name)

  call s:set_params()
  call s:update(0)
  call s:attach_yank_callback()
endfu

fu! RegisterWatchStart()
  let s:target_buf_number = bufnr("%")

  call s:set_params()
  call s:update(0)
  call s:attach_yank_callback()
endfu

fu! s:set_params()
  setl buftype=nofile
  setl noswapfile
  setl undolevels=-1
  setl nonumber
endfu

fu! s:update(timer) abort
  for i in range(0, len(g:register_watch_targets) - 1)
    let l:target = g:register_watch_targets[i]
    call setbufline(s:target_buf_number, i + 1, l:target . g:register_watch_separator . getreg(l:target))
  endfor
endfu

fu! s:attach_yank_callback()
  aug register-watch
    au!
    au TextYankPost * call timer_start(1, function("s:update"))
  aug end
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
