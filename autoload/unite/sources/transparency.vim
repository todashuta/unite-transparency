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
  return map(range(0, 100, 4), '{
        \ "word" : v:val,
        \ "kind" : "command",
        \ "action__command" : "set transparency=" . v:val,
        \ }')
endfunction

function! unite#sources#transparency#define()
  return (has('gui_running') && exists('&transparency')) ?
        \ s:unite_source : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
