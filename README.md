# vim-neatview

## A vim plugin for enhanced window management...
vim-neatview is a Vim plugin designed to provide enhanced window management capabilities, helping users maintain an organized and efficient workspace. The plugin offers two main features:
- Window Structure Management: Helps organize different types of windows (tree, tab, output, info) in a consistent layout.
- Session Restoration: Remembers and restores your open files.

## Features
- Window Structure Management (neatview)
    - Organizes windows into different parts: tree, tab, output, info panels
    - Automatically resizes and positions windows
    - Maintains window layout consistency
    - Provides commands to toggle different window types
    - Customizable window behaviors and appearances

## Screenshot
![Neatview Screenshot](https://github.com/bleakwind/vim-neatview/blob/main/vim-neatview.png)

## Requirements
Recommended Vim 8.1+

## Installation
```vim
" Using Vundle
Plugin 'bleakwind/vim-neatview'
```

And Run:
```vim
:PluginInstall
```
## Configuration
Add these to your `.vimrc`:

neatview
```vim
" Set 1 enable neatview (default: 0)
let g:neatview_enabled = 1
" Set 1 autostart neatview (default: 0)
let g:neatview_autostart = 1
" Set init function (default: 'NeatviewStructTree')
let g:neatview_initfun = 'NeatviewStructTree'
" Mapping of component identifiers to display names
let g:neatview_setname[xxx]  = ''
" Filetype associations for each component
let g:neatview_settype[xxx]  = ''
" Window position type: 'tree' (left), 'info' (right), 'output' (bottom), 'tab' (top)
let g:neatview_setpart[xxx]  = ''
" Buffer names for specific component identification
let g:neatview_setbuff[xxx]  = ''
" Related components that should be operated together
let g:neatview_setcoth[xxx]  = []
" Initial size (rows/columns) for each component
let g:neatview_setsize[xxx]  = xx
" Commands to open specific components
let g:neatview_setopen[xxx]  = ''
" Commands to close specific components
let g:neatview_setclse[xxx]  = ''
" Show special status in statusline (1=show, 0=hide)
let g:neatview_setstat[xxx] = xx
" Current visibility state of components (1=visible, 0=hidden)
let g:neatview_setshow[xxx] = xx
```

Color Customization
```vim
" Statusline color list
let g:neatview_hlstatusline_0 = '#59647A'
let g:neatview_hlstatusline_1 = '#A3D97D'
let g:neatview_hlstatusline_2 = '#59647A'
let g:neatview_hlstatusline_3 = '#006400'
let g:neatview_hlstatusline_4 = '#1E5791'
let g:neatview_hlstatusline_5 = '#A2000C'
let g:neatview_hlstatusline_6 = '#006400'
let g:neatview_hlstatusline_7 = '#1E5791'
let g:neatview_hlstatusline_8 = '#A2000C'
```

neatview: For example, I used these 4 Vim plugins: Bufferlist, Filelist, Quickfix, Viewmap. Here is my config:
```vim
let g:neatview_setname                      = {}
let g:neatview_settype                      = {}
let g:neatview_setpart                      = {}
let g:neatview_setbuff                      = {}
let g:neatview_setcoth                      = {}
let g:neatview_setsize                      = {}
let g:neatview_setopen                      = {}
let g:neatview_setclse                      = {}
let g:neatview_setstat                      = {}
let g:neatview_setshow                      = {}

let g:neatview_setname['bufferlist']        = 'Bufferlist'
let g:neatview_settype['bufferlist']        = 'bufferlist'
let g:neatview_setpart['bufferlist']        = 'tab'
let g:neatview_setbuff['bufferlist']        = 'vim-bufferlist'
let g:neatview_setcoth['bufferlist']        = []
let g:neatview_setsize['bufferlist']        = 1
let g:neatview_setopen['bufferlist']        = 'BufferlistOpen'
let g:neatview_setclse['bufferlist']        = 'BufferlistClose'
let g:neatview_setstat['bufferlist']        = 1
let g:neatview_setshow['bufferlist']        = 0

let g:neatview_setname['filelist']          = 'Filelist'
let g:neatview_settype['filelist']          = 'filelist'
let g:neatview_setpart['filelist']          = 'tree'
let g:neatview_setbuff['filelist']          = 'vim-filelist'
let g:neatview_setcoth['filelist']          = []
let g:neatview_setsize['filelist']          = 30
let g:neatview_setopen['filelist']          = 'FilelistOpen'
let g:neatview_setclse['filelist']          = 'FilelistClose'
let g:neatview_setstat['filelist']          = 1
let g:neatview_setshow['filelist']          = 0

let g:neatview_setname['quickfix']          = 'Quickfix'
let g:neatview_settype['quickfix']          = 'qf'
let g:neatview_setpart['quickfix']          = 'output'
let g:neatview_setbuff['quickfix']          = ''
let g:neatview_setcoth['quickfix']          = []
let g:neatview_setsize['quickfix']          = 10
let g:neatview_setopen['quickfix']          = 'botright copen '.g:neatview_setsize['quickfix']
let g:neatview_setclse['quickfix']          = 'cclose'
let g:neatview_setstat['quickfix']          = 1
let g:neatview_setshow['quickfix']          = 0

let g:neatview_setname['viewmap']           = 'Codemap'
let g:neatview_settype['viewmap']           = 'viewmap'
let g:neatview_setpart['viewmap']           = 'info'
let g:neatview_setbuff['viewmap']           = 'vim-viewmap'
let g:neatview_setcoth['viewmap']           = []
let g:neatview_setsize['viewmap']           = 20
let g:neatview_setopen['viewmap']           = 'ViewmapOpen'
let g:neatview_setclse['viewmap']           = 'ViewmapClose'
let g:neatview_setstat['viewmap']           = 1
let g:neatview_setshow['viewmap']           = 0
```

## Usage
| Command                 | Description                       |
| ----------------------- | --------------------------------- |
| `:NeatviewStructTree`   | Display only tree and tab windows |
| `:NeatviewStructOutput` | Toggle output window visibility   |
| `:NeatviewStructInfo`   | Toggle info window visibility     |
| `:NeatviewStructClear`  | Display only tab windows          |

For example, I would like map these:
| Command                                      | Description                       |
| -------------------------------------------- | --------------------------------- |
| `map <F5> :call neatview#StructTree()<CR>`   | Display only tree and tab windows |
| `map <F6> :call neatview#StructOutput()<CR>` | Toggle output window visibility   |
| `map <F7> :call neatview#StructInfo()<CR>`   | Toggle info window visibility     |
| `map <F8> :call neatview#StructClear()<CR>`  | Display only tab windows          |

## License
BSD 2-Clause - See LICENSE file
