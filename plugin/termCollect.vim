scriptencoding utf-8

if !exists('g:termCollect_shell')
    let g:termCollect_shell = 'bash'
endif


call termCollect#init()

nnoremap <silent> <Plug>(termCollect-toggle) :<C-u>call termCollect#toggle()<CR>
nnoremap <silent> <Plug>(termCollect-new) :<C-u>call termCollect#newTerm()<CR>
nnoremap <silent> <Plug>(termCollect-next) :<C-u>call termCollect#nextTerm()<CR>
nnoremap <silent> <Plug>(termCollect-pre) :<C-u>call termCollect#preTerm()<CR>

nmap <f7> <Plug>(termCollect-toggle)
" nmap <f8> <Plug>(termCollect-new)
" nmap <f9> <Plug>(termCollect-pre)
" nmap <f10> <Plug>(termCollect-next)
" tmap <f8> <C-\><C-n><Plug>(termCollect-new)
" tmap <f9> <C-\><C-n><Plug>(termCollect-pre)
" tmap <f10> <C-\><C-n><Plug>(termCollect-next)


"nnoremap <f5> :<C-u>call termCollect#termDbg()<CR>

hi termCollect_select cterm=bold ctermfg=232 ctermbg=179
hi termCollect_noselect cterm=None ctermfg=214 ctermbg=242
