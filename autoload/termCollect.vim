let s:save_cpo=&cpo
set cpo&vim

let s:termList = []
let s:lastTermIndex = 0
let s:newShellCmd = 'botright split term://' . g:termCollect_shell
let s:lastTermBufnr = 0

function! termCollect#init() "{{{
    if has('nvim')
        let s:termOpenfunc = function('s:neovimTermOpenfunc')
    " else
    "     let s:termOpenfunc = function('term_start')
    endif
endfunction "}}}

" TODO args and opts
function! s:neovimTermOpenfunc(createWin,...)
    if a:createWin
        exec 'botright split term://' . g:termCollect_shell
    else
        exec 'edit term://' . g:termCollect_shell
    endif
endfunction

function! termCollect#toggle(...) "{{{
    if exists('b:termCollect_isTermCollect')
        exec 'hide'
        return
    endif

    if s:foucusOnExistWin(s:termList) != -1
        return
    endif
    
    " if no terminal, create terminal
    if empty(s:termList)
        call s:termOpenfunc(1)
        call s:termEnvInit()
        return
    endif

    " witch exists one
    if bufexists(s:lastTermBufnr)
        exec 'botright sbuffer '.s:lastTermBufnr
    else
        exec 'botright sbuffer '.s:termList[0]
        let s:lastTermBufnr = bufnr('%')
    endif
endfunction "}}}

function! s:foucusOnExistWin(bufflist) "{{{
    for bufnr in a:bufflist
        if bufwinnr(bufnr) != -1
            call win_gotoid(bufwinid(bufnr))
            return 1
        endif
    endfor
    return -1
endfunction "}}}

function! termCollect#updateTermList() "{{{
    " unlet s:termList[ index(s:termList,bufnr('%'))]
    call filter(s:termList,'bufexists(v:val)')
    if index(s:termList, s:lastTermBufnr) == -1
        let s:lastTermBufnr = s:termList[0]
    endif
endfunction "}}}

" TODO: too urgly
" TODO: vim support!
function! termCollect#tatusline()
    let l:retstring = ''
    let l:index = 0
    while l:index < len(s:termList)
        if bufnr('%') == s:termList[l:index]
            let l:retstring .= '[> ' . l:index  .' <] '
        else
            let l:retstring .= '[  ' . l:index  .'  ] '
        endif
        let l:index += 1
    endwhile
    return l:retstring
    " return "%#termCollect_select#[\ yes\ ]%*\ %#termCollect_noselect#[\ no\ ]%*"
endfunction

function! s:termEnvInit() "{{{
    let b:termCollect_isTermCollect = 1
    call add(s:termList, bufnr('%'))
    let s:lastTermBufnr = bufnr('%')
    setlocal nobuflisted
    
    augroup termCollectWin
        autocmd!
        autocmd BufDelete,TermClose <buffer> call termCollect#updateTermList()
    augroup END

    " config status line:
    setlocal statusline=%{termCollect#tatusline()}

    " keymap
    nmap <buffer> <f8> <Plug>(termCollect-new)
    nmap <buffer> <f9> <Plug>(termCollect-pre)
    nmap <buffer>  <f10> <Plug>(termCollect-next)
    tmap <buffer>  <f8> <C-\><C-n><Plug>(termCollect-new):<C-u>startinsert<CR>
    tmap <buffer>  <f9> <C-\><C-n><Plug>(termCollect-pre):<C-u>startinsert<CR>
    tmap <buffer>  <f10> <C-\><C-n><Plug>(termCollect-next):<C-u>startinsert<CR>
endfunction "}}}

function! termCollect#newTerm() "{{{
    if !exists('b:termCollect_isTermCollect')
        return
    endif
    call s:termOpenfunc(0)
    call s:termEnvInit()
endfunction "}}}

" TODO: arg index
function! termCollect#nextTerm() "{{{
    if !exists('b:termCollect_isTermCollect')
        return
    endif

    let l:preIndex = index(s:termList,bufnr('%')) + 1
    if l:preIndex >= len(s:termList)
        let l:preIndex = 0
    endif
    exec 'buffer '.s:termList[ l:preIndex ]
    let s:lastTermBufnr = bufnr('%')
endfunction "}}}

" TODO: arg index
function! termCollect#preTerm() "{{{
    if !exists('b:termCollect_isTermCollect')
        return
    endif
    let l:preIndex = index(s:termList,bufnr('%')) - 1
    if l:preIndex < 0
        let l:preIndex = len(s:termList) - 1
    endif
    exec 'buffer '.s:termList[ l:preIndex ]
    let s:lastTermBufnr = bufnr('%')
endfunction "}}}

function! termCollect#termDbg()
    echo s:termList
    echo s:lastTermBufnr
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo