" Itchy: Scratch buffers for Vim
" 
" Author: Curtis McEnroe
" Version: 0.1.0
" Date: February 2 2012
" License: ISC

if exists('g:itchy_loaded') || &cp
  finish
endif
let g:itchy_loaded = 1

if !exists('g:itchy_buffer_prefix')
  let g:itchy_buffer_prefix = 'Scratch-'
endif
if !exists('g:itchy_buffer_suffix')
  let g:itchy_buffer_suffix = ''
endif
if !exists('g:itchy_startup')
  let g:itchy_startup = 0
endif
if !exists("g:itchy_always_split")
    let g:itchy_always_split = 0
endif
if !exists("g:itchy_split_direction")
    let g:itchy_split_direction = 0
endif


let s:buffer_number = 1

" Is the current window narrowly shaped?
function! s:is_narrow()
    return winheight(0)*2 > winwidth(0)
endf

" Should the split be opened horizontally?
" itchy_split_direction can mean:
"   0: guess the direction
"   1: vertical
"   2: horizontal
function! s:should_split_horiz()
  if g:itchy_split_direction == 0
    return s:is_narrow()
  else
    return g:itchy_split_direction == 2
  endif
endf

function! s:new_buffer(...)
  if a:0 == 0
    let buffer_name = g:itchy_buffer_prefix . s:buffer_number . g:itchy_buffer_suffix
    let s:buffer_number += 1
  else
    let buffer_name = g:itchy_buffer_prefix . a:1 . g:itchy_buffer_suffix
  endif

  if &modified || g:itchy_always_split
    if s:should_split_horiz()
      let edit_cmd = 'new'
    else
      let edit_cmd = 'vnew'
    endif
  else
    let edit_cmd = 'edit'
  endif

  exe edit_cmd .' '. buffer_name

  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
endfunction

if g:itchy_startup == 1
  autocmd VimEnter * if argc() == 0 | silent! call s:new_buffer() | endif
endif

command! -nargs=? Scratch call s:new_buffer(<f-args>)

" vim:et:ts=2 sw=2:
