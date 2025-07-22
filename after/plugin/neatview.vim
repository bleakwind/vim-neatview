" vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4: */
"
" +--------------------------------------------------------------------------+
" | $Id: neatview.vim 2025-07-18 02:30:17 Bleakwind Exp $                    |
" +--------------------------------------------------------------------------+
" | Copyright (c) 2008-2025 Bleakwind(Rick Wu).                              |
" +--------------------------------------------------------------------------+
" | This source file is neatview.vim.                                        |
" | This source file is release under BSD license.                           |
" +--------------------------------------------------------------------------+
" | Author: Bleakwind(Rick Wu) <bleakwind@qq.com>                            |
" +--------------------------------------------------------------------------+
"

if exists('g:neatview_plugin') || &compatible
    finish
endif
let b:neatview_plugin = 1

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" ============================================================================
" neatview setting
" ============================================================================
let g:neatview_enabled      = get(g:, 'neatview_enabled', 0)

let g:neatview_setname      = get(g:, 'neatview_setname', {})
let g:neatview_settype      = get(g:, 'neatview_settype', {})
let g:neatview_setpart      = get(g:, 'neatview_setpart', {})
let g:neatview_setbuff      = get(g:, 'neatview_setbuff', {})
let g:neatview_setcoth      = get(g:, 'neatview_setcoth', {})
let g:neatview_setsize      = get(g:, 'neatview_setsize', {})
let g:neatview_setopen      = get(g:, 'neatview_setopen', {})
let g:neatview_setclse      = get(g:, 'neatview_setclse', {})
let g:neatview_setnohi      = get(g:, 'neatview_setnohi', {})
let g:neatview_setstat      = get(g:, 'neatview_setstat', {})
let g:neatview_setshow      = get(g:, 'neatview_setshow', {})

let g:neatview_mainwin      = 0
let g:neatview_modelist     = {"n"      : 'NORMAL',
                             \ "no"     : 'OPERATOR-PENDING',
                             \ "v"      : 'VISUAL',
                             \ "V"      : 'VISUAL-LINE',
                             \ "\<C-V>" : 'VISUAL-BLOCKWISE',
                             \ "s"      : 'SELECT',
                             \ "S"      : 'SELECT-LINE',
                             \ "\<C-S>" : 'SELECT-BLOCKWISE',
                             \ "i"      : 'INSERT',
                             \ "R"      : 'REPLACE',
                             \ "Rv"     : 'REPLACE-VIRTUAL',
                             \ "c"      : 'COMMAND',
                             \ "cv"     : 'EX-VIM',
                             \ "ce"     : 'EX-NORMAL',
                             \ "r"      : 'ENTER',
                             \ "rm"     : 'MORE',
                             \ "r?"     : 'CONFIRM',
                             \ "!"      : 'EXTERNAL'}

" ============================================================================
" neatview detail
" g:neatview_enabled = 1
" ============================================================================
if exists('g:neatview_enabled') && g:neatview_enabled == 1

    " --------------------------------------------------
    " neatview#InitStruct
    " --------------------------------------------------
    function neatview#InitStruct()
        " set show
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:neatview_setname)
            let g:neatview_setshow[kc] = 0
            for il in l:winlist
                let l:bufnbr = il.bufnr
                let l:winnbr = il.winnr
                let l:winidn = il.winid
                let l:filtype = getbufvar(il.bufnr, '&filetype')
                let l:buftype = getbufvar(il.bufnr, '&buftype')
                let l:bufname = bufname(il.bufnr)
                if l:filtype == g:neatview_settype[kc]
                    let g:neatview_setshow[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:neatview_setname)
            if !empty(g:neatview_setbuff[kc])
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:bufname == g:neatview_setbuff[kc]
                        call win_execute(l:winidn, 'set filetype='.g:neatview_settype[kc])
                    elseif l:buftype == g:neatview_setbuff[kc]
                        call win_execute(l:winidn, 'set filetype='.g:neatview_settype[kc])
                    endif
                endfor
            endif
        endfor
        " set statusline
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnbr = il.bufnr
            let l:winnbr = il.winnr
            let l:winidn = il.winid
            let l:filtype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:searchkey = ''
            for [kc, vc] in items(g:neatview_setname)
                if g:neatview_settype[kc] == l:filtype
                    let l:searchkey = kc
                    break
                endif
            endfor
            if !empty(l:searchkey)
                if g:neatview_setstat[l:searchkey] == 1
                    call win_execute(l:winidn, 'call neatview#StatusLine(g:neatview_setpart[l:searchkey])')
                endif
            elseif index(l:buflist, l:bufnbr) != -1
                let g:neatview_mainwin = l:winidn
                call win_execute(l:winidn, 'call neatview#StatusLine("main")')
            else
                call win_execute(l:winidn, 'call neatview#StatusLine("other")')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#ResizeWin
    " --------------------------------------------------
    function neatview#ResizeWin()
        call neatview#InitStruct()
        if g:neatview_mainwin > 0
            let l:winidn_original = bufwinid('%')
            " check layout
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'info'
                        call win_execute(l:winidn, 'silent wincmd L')
                        if g:neatview_setnohi[kc] == 1
                            call win_execute(l:winidn, 'setlocal nocursorline')
                            call win_execute(l:winidn, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'output'
                        call win_execute(l:winidn, 'silent wincmd J')
                        if g:neatview_setnohi[kc] == 1
                            call win_execute(l:winidn, 'setlocal nocursorline')
                            call win_execute(l:winidn, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'tab'
                        call win_execute(l:winidn, 'silent wincmd K')
                        if g:neatview_setnohi[kc] == 1
                            call win_execute(l:winidn, 'setlocal nocursorline')
                            call win_execute(l:winidn, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'tree'
                        call win_execute(l:winidn, 'silent wincmd H')
                        if g:neatview_setnohi[kc] == 1
                            call win_execute(l:winidn, 'setlocal nocursorline')
                            call win_execute(l:winidn, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            " check size
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'info'
                        call win_execute(l:winidn, 'vertical resize '.g:neatview_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'output'
                        call win_execute(l:winidn, 'resize '.g:neatview_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'tab'
                        call win_execute(l:winidn, 'resize '.g:neatview_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'tree'
                        call win_execute(l:winidn, 'vertical resize '.g:neatview_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " fix size
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype == g:neatview_settype[kc] && g:neatview_setpart[kc] == 'info'
                        call win_execute(l:winidn, 'vertical resize '.g:neatview_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " back winid
            if l:winidn_original != bufwinid('%')
                call win_gotoid(l:winidn_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#OperateWin
    " --------------------------------------------------
    function neatview#OperateWin(name, ope)
        call neatview#InitStruct()
        if g:neatview_mainwin > 0 && has_key(g:neatview_setname, a:name)
            let l:winidn_original = bufwinid('%')
            " save state
            let l:setshow = {}
            for [kc, vc] in items(g:neatview_setshow)
                let l:setshow[kc] = g:neatview_setshow[kc]
            endfor
            " handle close
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_setname)
                if !empty(g:neatview_setcoth[a:name]) && index(g:neatview_setcoth[a:name], kc) != -1
                    if l:setshow[kc] == 1
                        silent execute g:neatview_setclse[kc]
                    endif
                endif
            endfor
            " handle state
            if a:ope == 'open'
                if l:setshow[a:name] != 1
                    silent execute g:neatview_setopen[a:name]
                endif
            elseif a:ope == 'close'
                if l:setshow[a:name] == 1
                    silent execute g:neatview_setclse[a:name]
                endif
            endif
            " handle restore
            for [kc, vc] in items(g:neatview_setname)
                if !empty(g:neatview_setcoth[a:name]) && index(g:neatview_setcoth[a:name], kc) != -1
                    if l:setshow[kc] == 1
                        silent execute g:neatview_setopen[kc]
                    endif
                endif
            endfor
            " resize win
            call neatview#ResizeWin()
            " back winid
            if l:winidn_original != bufwinid('%')
                call win_gotoid(l:winidn_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#StructTree
    " --------------------------------------------------
    function neatview#StructTree()
        call neatview#InitStruct()
        call win_gotoid(g:neatview_mainwin)
        " clean other
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnbr = il.bufnr
            let l:winnbr = il.winnr
            let l:winidn = il.winid
            let l:filtype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:neatview_setname)
                if g:neatview_settype[kc] == l:filtype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winidn, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'tree'
                call neatview#OperateWin(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'tab'
                call neatview#OperateWin(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'output'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'info'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructOutput
    " --------------------------------------------------
    function neatview#StructOutput(type = "")
        call neatview#InitStruct()
        call win_gotoid(g:neatview_mainwin)
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'output'
                if (a:type == "")
                    if g:neatview_setshow[kc] == 0
                        call neatview#OperateWin(kc, 'open')
                    else
                        call neatview#OperateWin(kc, 'close')
                    endif
                else
                    call neatview#OperateWin(kc, a:type)
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructInfo
    " --------------------------------------------------
    function neatview#StructInfo(type = "")
        call neatview#InitStruct()
        call win_gotoid(g:neatview_mainwin)
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'info'
                if (a:type == "")
                    if g:neatview_setshow[kc] == 0
                        call neatview#OperateWin(kc, 'open')
                    else
                        call neatview#OperateWin(kc, 'close')
                    endif
                else
                    call neatview#OperateWin(kc, a:type)
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructClear
    " --------------------------------------------------
    function neatview#StructClear()
        call neatview#InitStruct()
        call win_gotoid(g:neatview_mainwin)
        " clean other
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnbr = il.bufnr
            let l:winnbr = il.winnr
            let l:winidn = il.winid
            let l:filtype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:neatview_setname)
                if g:neatview_settype[kc] == l:filtype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winidn, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'tree'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'tab'
                call neatview#OperateWin(kc, 'open')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'output'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] == 'info'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#MixWhite
    " --------------------------------------------------
    function! neatview#MixWhite(color, alpha) abort
        let l:res_color = a:color
        if a:color =~? '^#[0-9a-fA-F]\{6}$' && a:alpha >= 0.0 && a:alpha <= 1.0
            let l:r = str2nr(a:color[1:2], 16)
            let l:g = str2nr(a:color[3:4], 16)
            let l:b = str2nr(a:color[5:6], 16)

            let l:mixed_r = float2nr(l:r * (1.0 - a:alpha) + 255 * a:alpha)
            let l:mixed_g = float2nr(l:g * (1.0 - a:alpha) + 255 * a:alpha)
            let l:mixed_b = float2nr(l:b * (1.0 - a:alpha) + 255 * a:alpha)

            let l:mixed_r = max([0, min([255, l:mixed_r])])
            let l:mixed_g = max([0, min([255, l:mixed_g])])
            let l:mixed_b = max([0, min([255, l:mixed_b])])

            let l:res_color = printf('#%02X%02X%02X', l:mixed_r, l:mixed_g, l:mixed_b)
        endif
        return l:res_color
    endfunction

    " --------------------------------------------------
    " neatview#CalcFg
    " --------------------------------------------------
    function! neatview#CalcFg(hex) abort
        let l:r = str2nr(a:hex[1:2], 16)
        let l:g = str2nr(a:hex[3:4], 16)
        let l:b = str2nr(a:hex[5:6], 16)
        let l:brightness = (0.299 * l:r + 0.587 * l:g + 0.114 * l:b) / 255
        return l:brightness > 0.5 ? 'Black' : 'White'
    endfunction

    " --------------------------------------------------
    " neatview#StatusName
    " --------------------------------------------------
    function! neatview#StatusName(...)
        let l:filtype = getbufvar(bufnr('%'), '&filetype')
        let l:buftype = getbufvar(bufnr('%'), '&buftype')
        let l:staname = l:filtype
        for [kc, vc] in items(g:neatview_setname)
            if !empty(g:neatview_settype[kc]) && !empty(l:buftype) && g:neatview_settype[kc] == l:filtype
                let l:staname = g:neatview_setname[kc]
                break
            endif
        endfor
        return l:staname
    endfunction

    " --------------------------------------------------
    " neatview#StatusLine
    " --------------------------------------------------
    function! neatview#StatusLine(...)
        let l:stacon = a:0 > 0 ? a:1 : ''
        if (l:stacon == 'tree')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StatusName()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'tab')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StatusName()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#%(\ [*:%{len(filter(range(1,bufnr('$')),'buflisted(v:val)&&empty(getbufvar(v:val,''&buftype''))'))}]\ %)%#StatusLine_7#
            setlocal statusline+=%#StatusLine_8#%(\ %{len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')'))>0?'[+:'.len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')')).']':''}\ %)%#StatusLine_8#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'output')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StatusName()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#%(\ %{exists('w:quickfix_title')?'['.w:quickfix_title.']':''}\ %)%#StatusLine_7#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'info')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StatusName()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'main')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_1#\ %{has_key(g:neatview_modelist,mode())?g:neatview_modelist[mode()]:mode()}\ %#StatusLine_1#
            setlocal statusline+=%#StatusLine_2#\ %F\ %#StatusLine_2#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_3#%(\ %{empty(&filetype)?'Unknown':&filetype}\ %)%#StatusLine_3#
            setlocal statusline+=%#StatusLine_4#%(\ %{&fileencoding.(&bomb?',BOM':'').('['.&fileformat.']')}\ %)%#StatusLine_4#
            setlocal statusline+=%#StatusLine_5#%(\ %r%m\ %)%#StatusLine_5#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %([%b\ 0x%B]%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %12.(%l,%c%V%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'other')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_2#\ %F\ %#StatusLine_2#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %12.(%l,%c%V%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        endif
        return &statusline
    endfunction

    " --------------------------------------------------
    " neatview#SetHlcolor
    " --------------------------------------------------
    function! neatview#SetHlcolor() abort
        let l:cfg = !empty(synIDattr(hlID('StatusLine'), 'fg', 'cterm')) ? synIDattr(hlID('StatusLine'), 'fg', 'cterm') : 'LightGray'
        let l:cbg = !empty(synIDattr(hlID('StatusLine'), 'bg', 'cterm')) ? synIDattr(hlID('StatusLine'), 'bg', 'cterm') : 'Black'
        let l:gfg = !empty(synIDattr(hlID('StatusLine'), 'fg', 'gui'))   ? synIDattr(hlID('StatusLine'), 'fg', 'gui')   : '#59647A'
        let l:gbg = !empty(synIDattr(hlID('StatusLine'), 'bg', 'gui'))   ? synIDattr(hlID('StatusLine'), 'bg', 'gui')   : '#171C22'
        if neatview#CalcFg(l:gbg) == "White"
            let l:cfg_0 = l:cfg         | let l:cbg_0 = l:cbg           | let l:gfg_0 = l:gfg           | let l:gbg_0 = l:gbg
            let l:cfg_1 = "Green"       | let l:cbg_1 = "DarkGreen"     | let l:gfg_1 = "#A3D97D"       | let l:gbg_1 = "#467623"
            let l:cfg_2 = "LightGray"   | let l:cbg_2 = l:cbg           | let l:gfg_2 = "#59647A"       | let l:gbg_2 = l:gbg
            let l:cfg_3 = "DarkGreen"   | let l:cbg_3 = l:cbg           | let l:gfg_3 = "#006400"       | let l:gbg_3 = neatview#MixWhite(l:gbg, 0.03)
            let l:cfg_4 = "Blue"        | let l:cbg_4 = l:cbg           | let l:gfg_4 = "#1E5791"       | let l:gbg_4 = neatview#MixWhite(l:gbg, 0.05)
            let l:cfg_5 = "Red"         | let l:cbg_5 = l:cbg           | let l:gfg_5 = "#A2000C"       | let l:gbg_5 = neatview#MixWhite(l:gbg, 0.07)
            let l:cfg_6 = "DarkGreen"   | let l:cbg_6 = l:cbg           | let l:gfg_6 = "#006400"       | let l:gbg_6 = l:gbg
            let l:cfg_7 = "Blue"        | let l:cbg_7 = l:cbg           | let l:gfg_7 = "#1E5791"       | let l:gbg_7 = l:gbg
            let l:cfg_8 = "Red"         | let l:cbg_8 = l:cbg           | let l:gfg_8 = "#A2000C"       | let l:gbg_8 = l:gbg
        else
            let l:cfg_0 = l:cfg         | let l:cbg_0 = l:cbg           | let l:gfg_0 = l:gfg           | let l:gbg_0 = l:gbg
            let l:cfg_1 = "Green"       | let l:cbg_1 = "DarkGreen"     | let l:gfg_1 = "#A3D97D"       | let l:gbg_1 = "#467623"
            let l:cfg_2 = "LightGray"   | let l:cbg_2 = l:cbg           | let l:gfg_2 = "#59647A"       | let l:gbg_2 = l:gbg
            let l:cfg_3 = "DarkGreen"   | let l:cbg_3 = l:cbg           | let l:gfg_3 = "#006400"       | let l:gbg_3 = neatview#MixWhite(l:gbg, 0.03)
            let l:cfg_4 = "Blue"        | let l:cbg_4 = l:cbg           | let l:gfg_4 = "#1E5791"       | let l:gbg_4 = neatview#MixWhite(l:gbg, 0.05)
            let l:cfg_5 = "Red"         | let l:cbg_5 = l:cbg           | let l:gfg_5 = "#A2000C"       | let l:gbg_5 = neatview#MixWhite(l:gbg, 0.07)
            let l:cfg_6 = "DarkGreen"   | let l:cbg_6 = l:cbg           | let l:gfg_6 = "#006400"       | let l:gbg_6 = l:gbg
            let l:cfg_7 = "Blue"        | let l:cbg_7 = l:cbg           | let l:gfg_7 = "#1E5791"       | let l:gbg_7 = l:gbg
            let l:cfg_8 = "Red"         | let l:cbg_8 = l:cbg           | let l:gfg_8 = "#A2000C"       | let l:gbg_8 = l:gbg
        endif
        execute "hi! StatusLine_0 ctermfg=".l:cfg_0." ctermbg=".l:cbg_0." cterm=NONE guifg=".l:gfg_0." guibg=".l:gbg_0." gui=NONE"
        execute "hi! StatusLine_1 ctermfg=".l:cfg_1." ctermbg=".l:cbg_1." cterm=NONE guifg=".l:gfg_1." guibg=".l:gbg_1." gui=NONE"
        execute "hi! StatusLine_2 ctermfg=".l:cfg_2." ctermbg=".l:cbg_2." cterm=NONE guifg=".l:gfg_2." guibg=".l:gbg_2." gui=NONE"
        execute "hi! StatusLine_3 ctermfg=".l:cfg_3." ctermbg=".l:cbg_3." cterm=NONE guifg=".l:gfg_3." guibg=".l:gbg_3." gui=NONE"
        execute "hi! StatusLine_4 ctermfg=".l:cfg_4." ctermbg=".l:cbg_4." cterm=NONE guifg=".l:gfg_4." guibg=".l:gbg_4." gui=NONE"
        execute "hi! StatusLine_5 ctermfg=".l:cfg_5." ctermbg=".l:cbg_5." cterm=NONE guifg=".l:gfg_5." guibg=".l:gbg_5." gui=NONE"
        execute "hi! StatusLine_6 ctermfg=".l:cfg_6." ctermbg=".l:cbg_6." cterm=NONE guifg=".l:gfg_6." guibg=".l:gbg_6." gui=NONE"
        execute "hi! StatusLine_7 ctermfg=".l:cfg_7." ctermbg=".l:cbg_7." cterm=NONE guifg=".l:gfg_7." guibg=".l:gbg_7." gui=NONE"
        execute "hi! StatusLine_8 ctermfg=".l:cfg_8." ctermbg=".l:cbg_8." cterm=NONE guifg=".l:gfg_8." guibg=".l:gbg_8." gui=NONE"
    endfunction

    " --------------------------------------------------
    " neatview_cmd_bas
    " --------------------------------------------------
    augroup neatview_cmd_bas
        autocmd!
        autocmd BufEnter,BufWritePost * call neatview#InitStruct()
        autocmd QuickFixCmdPost [^l]* if !empty(getqflist()) | call neatview#OperateWin('quickfix', 'open') | call neatview#StructOutput('open') | endif
        autocmd VimResized * call neatview#ResizeWin()
        autocmd ColorScheme * call neatview#SetHlcolor()
        autocmd VimEnter * call neatview#SetHlcolor()
        autocmd VimEnter * call neatview#StructTree()
    augroup END

endif

" ============================================================================
" Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo
