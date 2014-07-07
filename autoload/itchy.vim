" Itchy: Scratch buffers for Vim
" 

let s:scratch_number = 1

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

function! itchy#new_buffer(force_split, ...)
  " Create a new scratch buffer.
  " Single optional argument: scratch buffer's filetype. Can be a dot (.) to
  " copy the current buffer's filetype.

  " Figure out the filetype
  if a:0 < 1
    let file_type = ''
    let ft_command = ''
  else
    let file_type = a:1
    if file_type == '.'
      let file_type = &filetype
    endif

    let ft_command = 'setlocal filetype='.file_type
    let file_type = file_type .'-'
  end

  " Determine the split method
  if &modified || a:force_split
    if s:should_split_horiz()
      let edit_cmd = 'new'
    else
      let edit_cmd = 'vnew'
    endif
  else
    let edit_cmd = 'edit'
  endif

  exe printf('%s %s%s%i%s', edit_cmd, g:itchy_buffer_prefix, file_type, s:scratch_number, g:itchy_buffer_suffix)
  let s:scratch_number += 1

  " Scratch buffer settings
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
  exe ft_command
  command! -buffer -bang -nargs=+ -complete=file Saveas call s:unscratch() | exec 'saveas<bang> '. <f-args> | delcommand Saveas
endfunction

function! s:unscratch()
  setlocal buftype&
  setlocal bufhidden&
  setlocal swapfile&
  setlocal buflisted&
endf

" vim:et:ts=2 sw=2:
