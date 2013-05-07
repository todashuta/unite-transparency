let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name' : 'transparency',
      \ 'hooks' : {},
      \ 'action_table' : {'*' : {}},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  if exists('&transparency')
    let s:beforetransparency = &transparency
  endif
endfunction

function! s:unite_source.hooks.on_close(args, context)
  if s:beforetransparency == &transparency
    return
  endif
  execute 'set transparency='.s:beforetransparency
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
  return s:unite_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
