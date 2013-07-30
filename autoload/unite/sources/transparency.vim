let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name' : 'transparency',
      \ 'hooks' : {},
      \ 'action_table' : {'*' : {}},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  let s:initial_transparency = &transparency
endfunction

function! s:unite_source.hooks.on_close(args, context)
  if s:initial_transparency == &transparency
    unlet s:initial_transparency
    return
  endif
  let &transparency = s:initial_transparency
  unlet s:initial_transparency
endfunction

let s:unite_source.action_table['*'].preview = {
      \ 'description' : 'preview this transparency',
      \ 'is_quit' : 0,
      \ }

function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction

function! s:unite_source.gather_candidates(args, context)
  if unite#util#is_mac()
    let list = range(0, 100, 4)
  elseif unite#util#is_windows()
    let list = range(255, 105, -6)
  else
    call unite#util#print_error('Your environment does not support the current version of unite-transparency.')
    finish
  endif

  return map(list, '{
        \ "word" : v:val,
        \ "kind" : "command",
        \ "action__command" : "set transparency=" . v:val,
        \ }')
endfunction

function! unite#sources#transparency#define()
  return (has('gui_running') && exists('+transparency')) ?
        \ s:unite_source : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
