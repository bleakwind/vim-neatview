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
![Viewmap Screenshot](https://github.com/bleakwind/vim-neatview/blob/main/vim-neatview.png)

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

neatview: For example, I used these 4 Vim plugins: Nerdtree, Bufferlist, Quickfix, Vim Viewmap. Here is my config:
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

let g:neatview_setname['nerdtree']          = 'Filelist'
let g:neatview_settype['nerdtree']          = 'nerdtree'
let g:neatview_setpart['nerdtree']          = 'tree'
let g:neatview_setbuff['nerdtree']          = ''
let g:neatview_setcoth['nerdtree']          = []
let g:neatview_setsize['nerdtree']          = 30
let g:neatview_setopen['nerdtree']          = 'NERDTree'
let g:neatview_setclse['nerdtree']          = 'NERDTreeClose'
let g:neatview_setstat['nerdtree']          = 0
let g:neatview_setshow['nerdtree']          = 0

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
| Command                         | Description                       |
| ------------------------------- | --------------------------------- |
| `:call neatview#StructTree()`   | Display only tree and tab windows |
| `:call neatview#StructOutput()` | Toggle output window visibility   |
| `:call neatview#StructInfo()`   | Toggle info window visibility     |
| `:call neatview#StructClear()`  | Display only tab windows          |

For example, I would like map these:
| Command                                      | Description                       |
| -------------------------------------------- | --------------------------------- |
| `map <F5> :call neatview#StructTree()<CR>`   | Display only tree and tab windows |
| `map <F6> :call neatview#StructOutput()<CR>` | Toggle output window visibility   |
| `map <F7> :call neatview#StructInfo()<CR>`   | Toggle info window visibility     |
| `map <F8> :call neatview#StructClear()<CR>`  | Display only tab windows          |

## License
BSD 2-Clause - See LICENSE file
