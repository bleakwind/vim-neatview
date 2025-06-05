" vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4: */
"
" +--------------------------------------------------------------------------+
" | $Id: neatview.vim 2018-10-18 10:06:29 Bleakwind Exp $                    |
" +--------------------------------------------------------------------------+
" | Copyright (c) 2008-2018 Bleakwind(Rick Wu).                              |
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
" 01: neatview_struct setting
" ============================================================================
let g:neatview_struct_enabled       = get(g:, 'neatview_struct_enabled', 0)
let g:neatview_struct_setname       = get(g:, 'neatview_struct_setname', {})
let g:neatview_struct_settype       = get(g:, 'neatview_struct_settype', {})
let g:neatview_struct_setpart       = get(g:, 'neatview_struct_setpart', {})
let g:neatview_struct_setbuff       = get(g:, 'neatview_struct_setbuff', {})
let g:neatview_struct_setcoth       = get(g:, 'neatview_struct_setcoth', {})
let g:neatview_struct_setsize       = get(g:, 'neatview_struct_setsize', {})
let g:neatview_struct_setopen       = get(g:, 'neatview_struct_setopen', {})
let g:neatview_struct_setclse       = get(g:, 'neatview_struct_setclse', {})
let g:neatview_struct_setnohi       = get(g:, 'neatview_struct_setnohi', {})
let g:neatview_struct_setstat       = get(g:, 'neatview_struct_setstat', {})
let g:neatview_struct_setshow       = get(g:, 'neatview_struct_setshow', {})

let g:neatview_struct_mainwin       = 0
let g:neatview_struct_modelist      = {"n"      : 'NORMAL',
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
" 02: neatview_reopen setting
" ============================================================================
let g:neatview_reopen_enabled       = get(g:, 'neatview_reopen_enabled', 0)
let g:neatview_reopen_setpath       = get(g:, 'neatview_reopen_setpath', $HOME.'/.vim/neatview')

let s:neatview_reopen_filelist      = g:neatview_reopen_setpath.'/filelist'
let s:neatview_reopen_filedata      = {}

" ============================================================================
" 01: neatview_struct detail
" g:neatview_struct_enabled = 1
" - Char for String:   `~!@#$%^&+-=()[]{},.;'/:|\"*?<>
" - Char for Filename: `~!@#$%^&+-=()[]{},.;'/:
" ============================================================================
if exists('g:neatview_struct_enabled') && g:neatview_struct_enabled == 1

    " --------------------------------------------------
    " neatview#StructInit
    " --------------------------------------------------
    function neatview#StructInit()
        " set show
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:neatview_struct_setname)
            let g:neatview_struct_setshow[kc] = 0
            for il in l:winlist
                let l:bufnr = il.bufnr
                let l:winnr = il.winnr
                let l:winid = il.winid
                let l:filetype = getbufvar(il.bufnr, '&filetype')
                let l:buftype = getbufvar(il.bufnr, '&buftype')
                let l:bufname = bufname(il.bufnr)
                if l:filetype == g:neatview_struct_settype[kc]
                    let g:neatview_struct_setshow[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:neatview_struct_setname)
            if !empty(g:neatview_struct_setbuff[kc])
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:bufname == g:neatview_struct_setbuff[kc]
                        call win_execute(l:winid, 'set filetype='.g:neatview_struct_settype[kc])
                    elseif l:buftype == g:neatview_struct_setbuff[kc]
                        call win_execute(l:winid, 'set filetype='.g:neatview_struct_settype[kc])
                    endif
                endfor
            endif
        endfor
        " set statusline
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:searchkey = ''
            for [kc, vc] in items(g:neatview_struct_setname)
                if g:neatview_struct_settype[kc] == l:filetype
                    let l:searchkey = kc
                    break
                endif
            endfor
            if !empty(l:searchkey)
                if g:neatview_struct_setstat[l:searchkey] == 1
                    call win_execute(l:winid, 'call neatview#StructStatusline(g:neatview_struct_setpart[l:searchkey])')
                endif
            elseif index(l:buflist, l:bufnr) != -1
                let g:neatview_struct_mainwin = l:winid
                call win_execute(l:winid, 'call neatview#StructStatusline("main")')
            else
                call win_execute(l:winid, 'call neatview#StructStatusline("other")')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructResize
    " --------------------------------------------------
    function neatview#StructResize()
        call neatview#StructInit()
        if g:neatview_struct_mainwin > 0
            let l:winid_original = bufwinid('%')
            " check layout
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'silent wincmd L')
                        if g:neatview_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'output'
                        call win_execute(l:winid, 'silent wincmd J')
                        if g:neatview_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'tab'
                        call win_execute(l:winid, 'silent wincmd K')
                        if g:neatview_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'tree'
                        call win_execute(l:winid, 'silent wincmd H')
                        if g:neatview_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            " check size
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'vertical resize '.g:neatview_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'output'
                        call win_execute(l:winid, 'resize '.g:neatview_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'tab'
                        call win_execute(l:winid, 'resize '.g:neatview_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'tree'
                        call win_execute(l:winid, 'vertical resize '.g:neatview_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " fix size
            for [kc, vc] in items(g:neatview_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:neatview_struct_settype[kc] && g:neatview_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'vertical resize '.g:neatview_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " back winid
            if l:winid_original != bufwinid('%')
                call win_gotoid(l:winid_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#StructOperate
    " --------------------------------------------------
    function neatview#StructOperate(name, ope)
        call neatview#StructInit()
        if g:neatview_struct_mainwin > 0 && has_key(g:neatview_struct_setname, a:name)
            let l:winid_original = bufwinid('%')
            " save state
            let l:setshow = {}
            for [kc, vc] in items(g:neatview_struct_setshow)
                let l:setshow[kc] = g:neatview_struct_setshow[kc]
            endfor
            " handle close
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:neatview_struct_setname)
                if !empty(g:neatview_struct_setcoth[a:name]) && index(g:neatview_struct_setcoth[a:name], kc) != -1
                    if l:setshow[kc] == 1
                        silent exe g:neatview_struct_setclse[kc]
                    endif
                endif
            endfor
            " handle state
            if a:ope == 'open'
                silent exe g:neatview_struct_setopen[a:name]
            elseif a:ope == 'close'
                silent exe g:neatview_struct_setclse[a:name]
            endif
            " handle restore
            for [kc, vc] in items(g:neatview_struct_setname)
                if !empty(g:neatview_struct_setcoth[a:name]) && index(g:neatview_struct_setcoth[a:name], kc) != -1
                    if l:setshow[kc] == 1
                        silent exe g:neatview_struct_setopen[kc]
                    endif
                endif
            endfor
            " resize struct
            call neatview#StructResize()
            " back winid
            if l:winid_original != bufwinid('%')
                call win_gotoid(l:winid_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#StructTree
    " --------------------------------------------------
    function neatview#StructTree()
        call neatview#StructInit()
        call win_gotoid(g:neatview_struct_mainwin)
        " clean other
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:neatview_struct_setname)
                if g:neatview_struct_settype[kc] == l:filetype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winid, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'tree'
                call neatview#StructOperate(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'tab'
                call neatview#StructOperate(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'output'
                call neatview#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'info'
                call neatview#StructOperate(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructOutput
    " --------------------------------------------------
    function neatview#StructOutput(type = "")
        call neatview#StructInit()
        call win_gotoid(g:neatview_struct_mainwin)
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'output'
                if (a:type == "")
                    if g:neatview_struct_setshow[kc] == 0
                        call neatview#StructOperate(kc, 'open')
                    else
                        call neatview#StructOperate(kc, 'close')
                    endif
                else
                    call neatview#StructOperate(kc, a:type)
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructInfo
    " --------------------------------------------------
    function neatview#StructInfo(type = "")
        call neatview#StructInit()
        call win_gotoid(g:neatview_struct_mainwin)
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'info'
                if (a:type == "")
                    if g:neatview_struct_setshow[kc] == 0
                        call neatview#StructOperate(kc, 'open')
                    else
                        call neatview#StructOperate(kc, 'close')
                    endif
                else
                    call neatview#StructOperate(kc, a:type)
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructClear
    " --------------------------------------------------
    function neatview#StructClear()
        call neatview#StructInit()
        call win_gotoid(g:neatview_struct_mainwin)
        " clean other
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:neatview_struct_setname)
                if g:neatview_struct_settype[kc] == l:filetype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winid, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'tree'
                call neatview#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'tab'
                call neatview#StructOperate(kc, 'open')
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'output'
                call neatview#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:neatview_struct_setname)
            if g:neatview_struct_setpart[kc] == 'info'
                call neatview#StructOperate(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " neatview#StructStatusname
    " --------------------------------------------------
    function! neatview#StructStatusname(...)
        let l:filetype = getbufvar(bufnr('%'), '&filetype')
        let l:buftype = getbufvar(bufnr('%'), '&buftype')
        let l:staname = l:filetype
        for [kc, vc] in items(g:neatview_struct_setname)
            if !empty(g:neatview_struct_settype[kc]) && !empty(l:buftype) && g:neatview_struct_settype[kc] == l:filetype
                let l:staname = g:neatview_struct_setname[kc]
                break
            endif
        endfor
        return l:staname
    endfunction

    " --------------------------------------------------
    " neatview#StructMixwhite
    " --------------------------------------------------
    function! neatview#StructMixwhite(color, alpha) abort
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
    " neatview#StructCalcfg
    " --------------------------------------------------
    function! neatview#StructCalcfg(hex) abort
        let l:r = str2nr(a:hex[1:2], 16)
        let l:g = str2nr(a:hex[3:4], 16)
        let l:b = str2nr(a:hex[5:6], 16)
        let l:brightness = (0.299 * l:r + 0.587 * l:g + 0.114 * l:b) / 255
        return l:brightness > 0.5 ? 'Black' : 'White'
    endfunction

    " --------------------------------------------------
    " neatview#StructStatusline
    " --------------------------------------------------
    function! neatview#StructStatusline(...)
        let l:stacon = exists('a:1') ? a:1 : ''
        if (l:stacon == 'tree')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StructStatusname()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'tab')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StructStatusname()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#%(\ [*:%{len(filter(range(1,bufnr('$')),'buflisted(v:val)&&empty(getbufvar(v:val,''&buftype''))'))}]\ %)%#StatusLine_7#
            setlocal statusline+=%#StatusLine_8#%(\ %{len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')'))>0?'[+:'.len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')')).']':''}\ %)%#StatusLine_8#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'output')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StructStatusname()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#%(\ %{exists('w:quickfix_title')?'['.w:quickfix_title.']':''}\ %)%#StatusLine_7#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'info')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ [%{neatview#StructStatusname()}]\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'main')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_1#\ %{has_key(g:neatview_struct_modelist,mode())?g:neatview_struct_modelist[mode()]:mode()}\ %#StatusLine_1#
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
    " neatview#StructHlcolor
    " --------------------------------------------------
    function! neatview#StructHlcolor() abort
        let l:cfg = !empty(synIDattr(hlID('StatusLine'), 'fg', 'cterm')) ? synIDattr(hlID('StatusLine'), 'fg', 'cterm') : 'LightGray'
        let l:cbg = !empty(synIDattr(hlID('StatusLine'), 'bg', 'cterm')) ? synIDattr(hlID('StatusLine'), 'bg', 'cterm') : 'Black'
        let l:gfg = !empty(synIDattr(hlID('StatusLine'), 'fg', 'gui'))   ? synIDattr(hlID('StatusLine'), 'fg', 'gui')   : '#59647A'
        let l:gbg = !empty(synIDattr(hlID('StatusLine'), 'bg', 'gui'))   ? synIDattr(hlID('StatusLine'), 'bg', 'gui')   : '#171C22'
        if neatview#StructCalcfg(l:gbg) == "White"
            let l:cfg_0 = l:cfg         | let l:cbg_0 = l:cbg           | let l:gfg_0 = l:gfg           | let l:gbg_0 = l:gbg
            let l:cfg_1 = "Green"       | let l:cbg_1 = "DarkGreen"     | let l:gfg_1 = "#A3D97D"       | let l:gbg_1 = "#467623"
            let l:cfg_2 = "LightGray"   | let l:cbg_2 = l:cbg           | let l:gfg_2 = "#59647A"       | let l:gbg_2 = l:gbg
            let l:cfg_3 = "DarkGreen"   | let l:cbg_3 = l:cbg           | let l:gfg_3 = "#006400"       | let l:gbg_3 = neatview#StructMixwhite(l:gbg, 0.03)
            let l:cfg_4 = "Blue"        | let l:cbg_4 = l:cbg           | let l:gfg_4 = "#1E5791"       | let l:gbg_4 = neatview#StructMixwhite(l:gbg, 0.05)
            let l:cfg_5 = "Red"         | let l:cbg_5 = l:cbg           | let l:gfg_5 = "#A2000C"       | let l:gbg_5 = neatview#StructMixwhite(l:gbg, 0.07)
            let l:cfg_6 = "DarkGreen"   | let l:cbg_6 = l:cbg           | let l:gfg_6 = "#006400"       | let l:gbg_6 = l:gbg
            let l:cfg_7 = "Blue"        | let l:cbg_7 = l:cbg           | let l:gfg_7 = "#1E5791"       | let l:gbg_7 = l:gbg
            let l:cfg_8 = "Red"         | let l:cbg_8 = l:cbg           | let l:gfg_8 = "#A2000C"       | let l:gbg_8 = l:gbg
        else
            let l:cfg_0 = l:cfg         | let l:cbg_0 = l:cbg           | let l:gfg_0 = l:gfg           | let l:gbg_0 = l:gbg
            let l:cfg_1 = "Green"       | let l:cbg_1 = "DarkGreen"     | let l:gfg_1 = "#A3D97D"       | let l:gbg_1 = "#467623"
            let l:cfg_2 = "LightGray"   | let l:cbg_2 = l:cbg           | let l:gfg_2 = "#59647A"       | let l:gbg_2 = l:gbg
            let l:cfg_3 = "DarkGreen"   | let l:cbg_3 = l:cbg           | let l:gfg_3 = "#006400"       | let l:gbg_3 = neatview#StructMixwhite(l:gbg, 0.03)
            let l:cfg_4 = "Blue"        | let l:cbg_4 = l:cbg           | let l:gfg_4 = "#1E5791"       | let l:gbg_4 = neatview#StructMixwhite(l:gbg, 0.05)
            let l:cfg_5 = "Red"         | let l:cbg_5 = l:cbg           | let l:gfg_5 = "#A2000C"       | let l:gbg_5 = neatview#StructMixwhite(l:gbg, 0.07)
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
    " neatview#StructDebug
    " --------------------------------------------------
    function neatview#StructDebug()
        echo printf("= %-8s = %-8s = %-8s = %-16s = %-16s = %-16s", 'bufnr', 'winnr', 'winid', 'filetype', 'buftype', 'bufname')
        let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            echo printf("> %-8d > %-8d > %-8d > %-16s > %-16s > %-16s", l:bufnr, l:winnr, l:winid, l:filetype, l:buftype, l:bufname)
        endfor
    endfunction

    " --------------------------------------------------
    " NeatviewStructCmd
    " --------------------------------------------------
    augroup NeatviewCmdStruct
        autocmd!
        autocmd BufEnter,BufWritePost * call neatview#StructInit()
        autocmd QuickFixCmdPost [^l]* call neatview#StructOutput('open')
        autocmd VimResized * call neatview#StructResize()
        autocmd ColorScheme * call neatview#StructHlcolor()
        autocmd VimEnter * call neatview#StructHlcolor()
        autocmd VimEnter * call neatview#StructTree()
    augroup END

endif

" ============================================================================
" 02: neatview_reopen detail
" g:neatview_reopen_enabled = 1
" ============================================================================
if exists('g:neatview_reopen_enabled') && g:neatview_reopen_enabled == 1

    " --------------------------------------------------
    " neatview#ReopenBuild
    " --------------------------------------------------
    function! neatview#ReopenBuild(buf)
        if filereadable(s:neatview_reopen_filelist)
            let l:savelist = []
            let l:bufname = fnamemodify(bufname(a:buf), ':p')
            let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
            if index(l:buflist, a:buf) != -1
                for il in l:buflist
                    let l:name = fnamemodify(bufname(il), ':p')
                    if !empty(l:name)
                        if l:name == l:bufname
                            call add(l:savelist, l:name."*C*1*1*1")
                        else
                            call add(l:savelist, l:name."*X*1*1*1")
                        endif
                    endif
                endfor
                let s:neatview_reopen_filedata = l:savelist
                call writefile(s:neatview_reopen_filedata, s:neatview_reopen_filelist, 'b')
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#ReopenClose
    " --------------------------------------------------
    function! neatview#ReopenClose(buf)
        if filereadable(s:neatview_reopen_filelist)
            let l:savelist = []
            let s:neatview_reopen_filedata = readfile(s:neatview_reopen_filelist)
            for il in s:neatview_reopen_filedata
                let l:rec = split(il, '*')
                if (l:rec[0] != a:buf)
                    call add(l:savelist, l:rec[0]."*X*".l:rec[2]."*".l:rec[3]."*".l:rec[4]."")
                endif
            endfor
            let s:neatview_reopen_filedata = l:savelist
            call writefile(s:neatview_reopen_filedata, s:neatview_reopen_filelist, 'b')
        endif
    endfunction

    " --------------------------------------------------
    " neatview#ReopenRestore
    " --------------------------------------------------
    function! neatview#ReopenRestore()
        if filereadable(s:neatview_reopen_filelist)
            let l:savelist = []
            let l:currfile = ''
            let s:neatview_reopen_filedata = readfile(s:neatview_reopen_filelist)
            for il in s:neatview_reopen_filedata
                let l:rec = split(il, '*')
                if exists("l:rec[0]") && l:rec[0] != "" && filereadable(l:rec[0])
                    silent exe "edit ".l:rec[0]
                    if l:rec[1] == 'C'
                        let l:currfile = l:rec[0]
                    endif
                endif
            endfor
            if !empty(l:currfile)
                silent exe "edit ".l:currfile
            endif
        endif
    endfunction

    " --------------------------------------------------
    " neatview#ReopenBldcmd
    " --------------------------------------------------
    function! neatview#ReopenBldcmd()
        if !isdirectory(g:neatview_reopen_setpath)
            call mkdir(g:neatview_reopen_setpath, 'p', 0777)
        endif
        augroup NeatviewCmdReopenBldcmd
            autocmd!
            autocmd BufAdd,BufEnter * nested call neatview#ReopenBuild(str2nr(expand('<abuf>')))
            autocmd BufDelete * nested call neatview#ReopenClose(expand('<afile>:p'))
        augroup END
    endfunction

    " --------------------------------------------------
    " NeatviewCmdReopen
    " --------------------------------------------------
    augroup NeatviewCmdReopen
        autocmd!
        autocmd VimEnter * nested call neatview#ReopenBldcmd()
        autocmd VimEnter * nested call neatview#ReopenRestore()
    augroup END

endif

" ============================================================================
" Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo
