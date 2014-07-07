" Itchy: Scratch buffers for Vim
" 
" Author: David Briscoe
" Contributor: Curtis McEnroe
" Version: 2.0
" Date: 07 Jul 2014
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
if !exists("g:itchy_always_split")
    let g:itchy_always_split = 0
endif
if !exists("g:itchy_split_direction")
    let g:itchy_split_direction = 0
endif


command! -nargs=? -complete=filetype Scratch call itchy#new_buffer(g:itchy_always_split, <f-args>)
command! -nargs=? -complete=filetype ScratchNoSplit call itchy#new_buffer(0, <f-args>)

" Open a Scratch buffer
nnoremap <Plug>(itchy-open-scratch) :Scratch<CR>
" Open a Scratch buffer of the same filetype as the current buffer.
nnoremap <Plug>(itchy-open-same-filetype-scratch) :exec 'Scratch '. &filetype<CR>

" vim:et:ts=2 sw=2:
