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
" public setting - [g:neatview_initfun:neatview#StructTree()|neatview#StructClear()]
let g:neatview_enabled          = get(g:, 'neatview_enabled', 0)
let g:neatview_autostart        = get(g:, 'neatview_autostart', 0)
let g:neatview_initfun          = get(g:, 'neatview_initfun', 'NeatviewStructTree')

" controlled plugin
let g:neatview_setname          = get(g:, 'neatview_setname', {})
let g:neatview_settype          = get(g:, 'neatview_settype', {})
let g:neatview_setpart          = get(g:, 'neatview_setpart', {})
let g:neatview_setbuff          = get(g:, 'neatview_setbuff', {})
let g:neatview_setcoth          = get(g:, 'neatview_setcoth', {})
let g:neatview_setsize          = get(g:, 'neatview_setsize', {})
let g:neatview_setopen          = get(g:, 'neatview_setopen', {})
let g:neatview_setclse          = get(g:, 'neatview_setclse', {})
let g:neatview_setstat          = get(g:, 'neatview_setstat', {})
let g:neatview_setshow          = get(g:, 'neatview_setshow', {})

" statusline color
let g:neatview_hlstatusline_0   = get(g:, 'neatview_hlstatusline_0', '#59647A')
let g:neatview_hlstatusline_1   = get(g:, 'neatview_hlstatusline_1', '#A3D97D')
let g:neatview_hlstatusline_2   = get(g:, 'neatview_hlstatusline_2', '#59647A')
let g:neatview_hlstatusline_3   = get(g:, 'neatview_hlstatusline_3', '#006400')
let g:neatview_hlstatusline_4   = get(g:, 'neatview_hlstatusline_4', '#1E5791')
let g:neatview_hlstatusline_5   = get(g:, 'neatview_hlstatusline_5', '#A2000C')
let g:neatview_hlstatusline_6   = get(g:, 'neatview_hlstatusline_6', '#006400')
let g:neatview_hlstatusline_7   = get(g:, 'neatview_hlstatusline_7', '#1E5791')
let g:neatview_hlstatusline_8   = get(g:, 'neatview_hlstatusline_8', '#A2000C')

" other setting
let g:neatview_mainwin          = 0
let g:neatview_modelist         = {"n"      : 'NORMAL',
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
if exists('g:neatview_enabled') && g:neatview_enabled ==# 1

    " --------------------------------------------------
    " neatview#InitStruct
    " --------------------------------------------------
    function neatview#InitStruct()
        " set show
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
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
                if l:filtype ==# g:neatview_settype[kc]
                    let g:neatview_setshow[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
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
                    if l:bufname ==# g:neatview_setbuff[kc]
                        call win_execute(l:winidn, 'set filetype='.g:neatview_settype[kc])
                    elseif l:buftype ==# g:neatview_setbuff[kc]
                        call win_execute(l:winidn, 'set filetype='.g:neatview_settype[kc])
                    endif
                endfor
            endif
        endfor
        " set statusline
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
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
                if g:neatview_settype[kc] ==# l:filtype
                    let l:searchkey = kc
                    break
                endif
            endfor
            if !empty(l:searchkey)
                if g:neatview_setstat[l:searchkey] ==# 1
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
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_setname)
                for il in l:winlist
                    let l:bufnbr = il.bufnr
                    let l:winnbr = il.winnr
                    let l:winidn = il.winid
                    let l:filtype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'info'
                        call win_execute(l:winidn, 'silent wincmd L')
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'output'
                        call win_execute(l:winidn, 'silent wincmd J')
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'tab'
                        call win_execute(l:winidn, 'silent wincmd K')
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'tree'
                        call win_execute(l:winidn, 'silent wincmd H')
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'info'
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'output'
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'tab'
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'tree'
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
                    if l:filtype ==# g:neatview_settype[kc] && g:neatview_setpart[kc] ==# 'info'
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
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_setname)
                if !empty(g:neatview_setcoth[a:name]) && index(g:neatview_setcoth[a:name], kc) != -1
                    if l:setshow[kc] ==# 1
                        silent execute g:neatview_setclse[kc]
                    endif
                endif
            endfor
            " handle state
            if a:ope ==# 'open'
                if l:setshow[a:name] != 1
                    silent execute g:neatview_setopen[a:name]
                endif
            elseif a:ope ==# 'close'
                if l:setshow[a:name] ==# 1
                    silent execute g:neatview_setclse[a:name]
                endif
            endif
            " handle restore
            for [kc, vc] in items(g:neatview_setname)
                if !empty(g:neatview_setcoth[a:name]) && index(g:neatview_setcoth[a:name], kc) != -1
                    if l:setshow[kc] ==# 1
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
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
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
                if g:neatview_settype[kc] ==# l:filtype
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
            if g:neatview_setpart[kc] ==# 'tree'
                call neatview#OperateWin(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'tab'
                call neatview#OperateWin(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'output'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'info'
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
            if g:neatview_setpart[kc] ==# 'output'
                if (a:type ==# "")
                    if g:neatview_setshow[kc] ==# 0
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
            if g:neatview_setpart[kc] ==# 'info'
                if (a:type ==# "")
                    if g:neatview_setshow[kc] ==# 0
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
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
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
                if g:neatview_settype[kc] ==# l:filtype
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
            if g:neatview_setpart[kc] ==# 'tree'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'tab'
                call neatview#OperateWin(kc, 'open')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'output'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_setname)
            if g:neatview_setpart[kc] ==# 'info'
                call neatview#OperateWin(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StatusName
    " --------------------------------------------------
    function! neatview#StatusName(...)
        let l:filtype = getbufvar(bufnr('%'), '&filetype')
        let l:buftype = getbufvar(bufnr('%'), '&buftype')
        let l:staname = l:filtype
        for [kc, vc] in items(g:neatview_setname)
            if !empty(g:neatview_settype[kc]) && !empty(l:buftype) && g:neatview_settype[kc] ==# l:filtype
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
        if (l:stacon ==# 'tree')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ [%{neatview#StatusName()}]\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        elseif (l:stacon ==# 'tab')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ [%{neatview#StatusName()}]\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_7#%(\ [*:%{len(filter(range(1,bufnr('$')),'buflisted(v:val)&&empty(getbufvar(v:val,''&buftype''))'))}]\ %)%#NeatviewHlStatusline_7#
            setlocal statusline+=%#NeatviewHlStatusline_8#%(\ %{len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')'))>0?'[+:'.len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')')).']':''}\ %)%#NeatviewHlStatusline_8#

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        elseif (l:stacon ==# 'output')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ [%{neatview#StatusName()}]\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_7#%(\ %{exists('w:quickfix_title')?'['.w:quickfix_title.']':''}\ %)%#NeatviewHlStatusline_7#

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        elseif (l:stacon ==# 'info')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ [%{neatview#StatusName()}]\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        elseif (l:stacon ==# 'main')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_1#\ %{has_key(g:neatview_modelist,mode())?g:neatview_modelist[mode()]:mode()}\ %#NeatviewHlStatusline_1#
            setlocal statusline+=%#NeatviewHlStatusline_2#\ %F\ %#NeatviewHlStatusline_2#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_3#%(\ %{empty(&filetype)?'Unknown':&filetype}\ %)%#NeatviewHlStatusline_3#
            setlocal statusline+=%#NeatviewHlStatusline_4#%(\ %{&fileencoding.(&bomb?',BOM':'').('['.&fileformat.']')}\ %)%#NeatviewHlStatusline_4#
            setlocal statusline+=%#NeatviewHlStatusline_5#%(\ %r%m\ %)%#NeatviewHlStatusline_5#

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %([%b\ 0x%B]%)\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %12.(%l,%c%V%)\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        elseif (l:stacon ==# 'other')
            setlocal  statusline=%#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_2#\ %F\ %#NeatviewHlStatusline_2#
            setlocal statusline+=%#NeatviewHlStatusline_0#%<

            setlocal statusline+=%#NeatviewHlStatusline_0#\ %=\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %12.(%l,%c%V%)\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#\ %5.P\ %#NeatviewHlStatusline_0#
            setlocal statusline+=%#NeatviewHlStatusline_0#
        endif
        return &statusline
    endfunction

    " --------------------------------------------------
    " neatview#ColorBgtype
    " --------------------------------------------------
    function! neatview#ColorBgtype(hex) abort
        let l:r = str2nr(a:hex[1:2], 16)
        let l:g = str2nr(a:hex[3:4], 16)
        let l:b = str2nr(a:hex[5:6], 16)
        let l:brightness = (0.299 * l:r + 0.587 * l:g + 0.114 * l:b) / 255
        return l:brightness > 0.5 ? 'White' : 'Black'
    endfunction

    " --------------------------------------------------
    " neatview#ColorMask
    " --------------------------------------------------
    function! neatview#ColorMask(color, alpha) abort
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
    " neatview#ColorInvert
    " --------------------------------------------------
    function! neatview#ColorInvert(hex)
        let sat = 1.5
        let lit = 0.4

        " HexToHSL
        let r = str2nr(a:hex[1:2], 16) / 255.0
        let g = str2nr(a:hex[3:4], 16) / 255.0
        let b = str2nr(a:hex[5:6], 16) / 255.0

        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let delta = max - min

        let l = (max + min) / 2.0

        if delta ==# 0.0
            let h = 0.0
            let s = 0.0
        else
            let s = l < 0.5 ? delta / (max + min) : delta / (2.0 - max - min)
            if max ==# r
                let h = (g - b) / delta
            elseif max ==# g
                let h = 2.0 + (b - r) / delta
            else
                let h = 4.0 + (r - g) / delta
            endif
            let h = h * 60.0
            if h < 0.0
                let h = h + 360.0
            endif
        endif

        " change saturation and light
        let s = s * sat > 1.0 ? 1.0 : s * sat
        let l = l * lit

        " HSLToHex
        let h = h >= 360.0 ? 0.0 : h / 360.0
        let s = s < 0.0 ? 0.0 : s > 1.0 ? 1.0 : s
        let l = l < 0.0 ? 0.0 : l > 1.0 ? 1.0 : l

        if s ==# 0.0
            let r = l
            let g = l
            let b = l
        else
            let q = l < 0.5 ? l * (1.0 + s) : l + s - l * s
            let p = 2.0 * l - q

            let rt = h + 1.0/3.0
            let rt = rt < 0.0 ? rt + 1.0 : rt > 1.0 ? rt - 1.0 : rt
            let r = rt < 1.0/6.0 ? p + (q - p) * 6.0 * rt : rt < 1.0/2.0 ? q : rt < 2.0/3.0 ? p + (q - p) * (2.0/3.0 - rt) * 6.0 : p

            let gt = h
            let gt = gt < 0.0 ? gt + 1.0 : gt > 1.0 ? gt - 1.0 : gt
            let g = gt < 1.0/6.0 ? p + (q - p) * 6.0 * gt : gt < 1.0/2.0 ? q : gt < 2.0/3.0 ? p + (q - p) * (2.0/3.0 - gt) * 6.0 : p

            let bt = h - 1.0/3.0
            let bt = bt < 0.0 ? bt + 1.0 : bt > 1.0 ? bt - 1.0 : bt
            let b = bt < 1.0/6.0 ? p + (q - p) * 6.0 * bt : bt < 1.0/2.0 ? q : bt < 2.0/3.0 ? p + (q - p) * (2.0/3.0 - bt) * 6.0 : p
        endif

        let r = float2nr(round(r * 255.0))
        let g = float2nr(round(g * 255.0))
        let b = float2nr(round(b * 255.0))
        let r = r < 0 ? 0 : r > 255 ? 255 : r
        let g = g < 0 ? 0 : g > 255 ? 255 : g
        let b = b < 0 ? 0 : b > 255 ? 255 : b

        return printf("#%02X%02X%02X", r, g, b)
    endfunction

    " --------------------------------------------------
    " neatview#ColorName
    " --------------------------------------------------
    function! neatview#ColorName(color)
        let l:color_hex = {
                    \ 'Red':            '#FF0000',
                    \ 'LightRed':       '#FF6666',
                    \ 'DarkRed':        '#8B0000',
                    \ 'Green':          '#00FF00',
                    \ 'LightGreen':     '#66FF66',
                    \ 'DarkGreen':      '#006400',
                    \ 'Blue':           '#0000FF',
                    \ 'LightBlue':      '#6666FF',
                    \ 'DarkBlue':       '#00008B',
                    \ 'Cyan':           '#00FFFF',
                    \ 'LightCyan':      '#66FFFF',
                    \ 'DarkCyan':       '#008B8B',
                    \ 'Magenta':        '#FF00FF',
                    \ 'LightMagenta':   '#FF66FF',
                    \ 'DarkMagenta':    '#8B008B',
                    \ 'Yellow':         '#FFFF00',
                    \ 'LightYellow':    '#FFFF66',
                    \ 'Brown':          '#A52A2A',
                    \ 'DarkYellow':     '#CCCC00',
                    \ 'Gray':           '#808080',
                    \ 'LightGray':      '#C0C0C0',
                    \ 'DarkGray':       '#404040',
                    \ 'Black':          '#000000',
                    \ 'White':          '#FFFFFF',
                    \ }

        " parse color
        let l:input_rgb = [0, 0, 0]
        if a:color =~? '^#[0-9a-f]\{3}$'
            let l:hex = a:color[1:]
            let l:input_rgb = [str2nr(l:hex[0].l:hex[0], 16), str2nr(l:hex[1].l:hex[1], 16), str2nr(l:hex[2].l:hex[2], 16)]
        elseif a:color =~? '^#[0-9a-f]\{6}$'
            let l:hex = a:color[1:]
            let l:input_rgb = [str2nr(l:hex[0:1], 16), str2nr(l:hex[2:3], 16), str2nr(l:hex[4:5], 16)]
        elseif a:color =~? '^rgb(\s*\d\+\s*,\s*\d\+\s*,\s*\d\+\s*)$'
            let l:parts = split(matchstr(a:color, '\d\+\s*,\s*\d\+\s*,\s*\d\+'), '\s*,\s*')
            let l:input_rgb = [str2nr(l:parts[0]), str2nr(l:parts[1]), str2nr(l:parts[2])]
        elseif has_key(l:color_hex, a:color)
            let l:hex = l:color_hex[a:color][1:]
            if len(l:hex) ==# 3
                let l:input_rgb = [str2nr(l:hex[0].l:hex[0], 16), str2nr(l:hex[1].l:hex[1], 16), str2nr(l:hex[2].l:hex[2], 16)]
            else
                let l:input_rgb = [str2nr(l:hex[0:1], 16), str2nr(l:hex[2:3], 16), str2nr(l:hex[4:5], 16)]
            endif
        else
            return 'Black'
        endif

        " check brightness
        let l:brightness = l:input_rgb[0] * 0.299 + l:input_rgb[1] * 0.587 + l:input_rgb[2] * 0.114
        if l:input_rgb[2] > max([l:input_rgb[0], l:input_rgb[1]]) + 20
            return l:brightness > 150 ? 'LightBlue' : 'DarkBlue'
        endif
        if abs(l:input_rgb[0] - l:input_rgb[1]) < 30 && abs(l:input_rgb[1] - l:input_rgb[2]) < 30
            if l:brightness > 180
                return 'White'
            elseif l:brightness > 120
                return 'LightGray'
            elseif l:brightness > 60
                return 'Gray'
            else
                return l:brightness > 30 ? 'DarkGray' : 'Black'
            endif
        endif

        " find name
        let l:min_distance = 999999
        let l:nearest_color = 'Black'
        for [l:color_name, l:hex] in items(l:color_hex)
            let l:palette_hex = l:hex[1:]
            if len(l:palette_hex) ==# 3
                let l:palette_rgb = [ str2nr(l:palette_hex[0].l:palette_hex[0], 16), str2nr(l:palette_hex[1].l:palette_hex[1], 16), str2nr(l:palette_hex[2].l:palette_hex[2], 16)]
            else
                let l:palette_rgb = [ str2nr(l:palette_hex[0:1], 16), str2nr(l:palette_hex[2:3], 16), str2nr(l:palette_hex[4:5], 16)]
            endif

            let l:dr = l:input_rgb[0] - l:palette_rgb[0]
            let l:dg = l:input_rgb[1] - l:palette_rgb[1]
            let l:db = l:input_rgb[2] - l:palette_rgb[2]
            let l:distance = l:dr*l:dr*0.3 + l:dg*l:dg*0.59 + l:db*l:db*0.11

            if l:distance < l:min_distance
                let l:min_distance = l:distance
                let l:nearest_color = l:color_name
            endif
        endfor

        " adjust result
        if l:brightness > 180 && l:nearest_color =~? '^Dark'
            let l:nearest_color = substitute(l:nearest_color, 'Dark', 'Light', '')
        elseif l:brightness < 80 && l:nearest_color =~? '^Light'
            let l:nearest_color = substitute(l:nearest_color, 'Light', 'Dark', '')
        endif

        return l:nearest_color
    endfunction

    " --------------------------------------------------
    " neatview#SetHlcolor
    " --------------------------------------------------
    function! neatview#SetHlcolor() abort
        " check bgcolor
        let l:gbg = !empty(synIDattr(hlID('StatusLine'), 'bg', 'gui'))   ? synIDattr(hlID('StatusLine'), 'bg', 'gui')   : '#171C22'
        let l:hlstatusline_0     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_0) : g:neatview_hlstatusline_0
        let l:hlstatusline_1     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_1) : g:neatview_hlstatusline_1
        let l:hlstatusline_2     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_2) : g:neatview_hlstatusline_2
        let l:hlstatusline_3     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_3) : g:neatview_hlstatusline_3
        let l:hlstatusline_4     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_4) : g:neatview_hlstatusline_4
        let l:hlstatusline_5     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_5) : g:neatview_hlstatusline_5
        let l:hlstatusline_6     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_6) : g:neatview_hlstatusline_6
        let l:hlstatusline_7     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_7) : g:neatview_hlstatusline_7
        let l:hlstatusline_8     = neatview#ColorBgtype(l:gbg) ==# "White" ? neatview#ColorInvert(g:neatview_hlstatusline_8) : g:neatview_hlstatusline_8

        " hl statusline
        execute 'hi! NeatviewHlStatusline_0 ctermfg='.neatview#ColorName(l:hlstatusline_0).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_0.' guibg='.l:gbg.' gui=NONE'
        execute 'hi! NeatviewHlStatusline_1 ctermfg='.neatview#ColorName(l:hlstatusline_1).' ctermbg='.neatview#ColorName(neatview#ColorInvert(l:hlstatusline_1)).' cterm=NONE guifg='.l:hlstatusline_1.' guibg='.neatview#ColorInvert(l:hlstatusline_1).' gui=NONE'
        execute 'hi! NeatviewHlStatusline_2 ctermfg='.neatview#ColorName(l:hlstatusline_2).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_2.' guibg='.l:gbg.' gui=NONE'
        execute 'hi! NeatviewHlStatusline_3 ctermfg='.neatview#ColorName(l:hlstatusline_3).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_3.' guibg='.neatview#ColorMask(l:gbg, 0.03).' gui=NONE'
        execute 'hi! NeatviewHlStatusline_4 ctermfg='.neatview#ColorName(l:hlstatusline_4).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_4.' guibg='.neatview#ColorMask(l:gbg, 0.05).' gui=NONE'
        execute 'hi! NeatviewHlStatusline_5 ctermfg='.neatview#ColorName(l:hlstatusline_5).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_5.' guibg='.neatview#ColorMask(l:gbg, 0.07).' gui=NONE'
        execute 'hi! NeatviewHlStatusline_6 ctermfg='.neatview#ColorName(l:hlstatusline_6).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_6.' guibg='.l:gbg.' gui=NONE'
        execute 'hi! NeatviewHlStatusline_7 ctermfg='.neatview#ColorName(l:hlstatusline_7).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_7.' guibg='.l:gbg.' gui=NONE'
        execute 'hi! NeatviewHlStatusline_8 ctermfg='.neatview#ColorName(l:hlstatusline_8).' ctermbg='.neatview#ColorName(l:gbg).' cterm=NONE guifg='.l:hlstatusline_8.' guibg='.l:gbg.' gui=NONE'

        " prompt message
        hi! NeatviewPmtDef ctermfg=Gray   ctermbg=NONE cterm=Bold guifg=#B1B3B8 guibg=NONE gui=Bold
        hi! NeatviewPmtNor ctermfg=Blue   ctermbg=NONE cterm=Bold guifg=#79BBFF guibg=NONE gui=Bold
        hi! NeatviewPmtSuc ctermfg=Green  ctermbg=NONE cterm=Bold guifg=#95D475 guibg=NONE gui=Bold
        hi! NeatviewPmtWar ctermfg=Yellow ctermbg=NONE cterm=Bold guifg=#EEBE77 guibg=NONE gui=Bold
        hi! NeatviewPmtErr ctermfg=Red    ctermbg=NONE cterm=Bold guifg=#F56C6C guibg=NONE gui=Bold
    endfunction

    " --------------------------------------------------
    " neatview_cmd_bas
    " --------------------------------------------------
    augroup neatview_cmd_bas
        autocmd!
        autocmd BufEnter,BufWritePost * call neatview#InitStruct()
        autocmd QuickFixCmdPost [^l]* if !empty(getqflist()) | call neatview#OperateWin('quickfix', 'open') | call neatview#StructOutput('open') | endif
        autocmd WinNew,VimResized * call neatview#ResizeWin()
        autocmd ColorScheme * call neatview#SetHlcolor()
        autocmd VimEnter * call neatview#SetHlcolor()
        if g:neatview_autostart ==# 1
            autocmd VimEnter * call timer_start(0, {-> execute(g:neatview_initfun, '')})
        endif
    augroup END

    " --------------------------------------------------
    " command
    " --------------------------------------------------
    command! -nargs=? NeatviewStructTree   call neatview#StructTree()
    command! -nargs=? NeatviewStructOutput call neatview#StructOutput(<q-args>)
    command! -nargs=? NeatviewStructInfo   call neatview#StructInfo(<q-args>)
    command! -nargs=? NeatviewStructClear  call neatview#StructClear()

endif

" ============================================================================
" Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo
