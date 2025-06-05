# vim-neatview

## A vim plugin for enhanced window management...
vim-neatview is a Vim plugin designed to provide enhanced window management capabilities, helping users maintain an organized and efficient workspace. The plugin offers two main features:
- Window Structure Management: Helps organize different types of windows (tree, tab, output, info) in a consistent layout.
- Session Restoration: Remembers and restores your open files.

## Features
- Window Structure Management (neatview_struct)
    - Organizes windows into different parts: tree, tab, output, info panels
    - Automatically resizes and positions windows
    - Maintains window layout consistency
    - Provides commands to toggle different window types
    - Customizable window behaviors and appearances

- Session Restoration (neatview_reopen)
    - Saves and restores open files between sessions
    - Configurable storage location for session files

## Screenshot
![Viewmap Screenshot](https://github.com/bleakwind/vim-neatview/blob/main/vim-neatview-struct.png)

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

neatview_struct
```vim
" Set 1 enable neatview_struct (default: 0)
let g:neatview_struct_enabled = 1
" Mapping of component identifiers to display names
let g:neatview_struct_setname[xxx]  = ''
" Filetype associations for each component
let g:neatview_struct_settype[xxx]  = ''
" Window position type: 'tree' (left), 'info' (right), 'output' (bottom), 'tab' (top)
let g:neatview_struct_setpart[xxx]  = ''
" Buffer names for specific component identification
let g:neatview_struct_setbuff[xxx]  = ''
" Related components that should be operated together
let g:neatview_struct_setcoth[xxx]  = []
" Initial size (rows/columns) for each component
let g:neatview_struct_setsize[xxx]  = xx
" Commands to open specific components
let g:neatview_struct_setopen[xxx]  = ''
" Commands to close specific components
let g:neatview_struct_setclse[xxx]  = ''
" Disable cursor highlighting in window (1=disable, 0=enable)
let g:neatview_struct_setnohi[xxx] = xx
" Show special status in statusline (1=show, 0=hide)
let g:neatview_struct_setstat[xxx] = xx
" Current visibility state of components (1=visible, 0=hidden)
let g:neatview_struct_setshow[xxx] = xx
```

neatview_struct: For example, I used these 4 Vim plugins: Nerdtree, Minibufexpl, Quickfix, Vim Viewmap. Here is my config:
```vim
let g:neatview_struct_setname                       = {}
let g:neatview_struct_settype                       = {}
let g:neatview_struct_setpart                       = {}
let g:neatview_struct_setbuff                       = {}
let g:neatview_struct_setcoth                       = {}
let g:neatview_struct_setsize                       = {}
let g:neatview_struct_setopen                       = {}
let g:neatview_struct_setclse                       = {}
let g:neatview_struct_setnohi                       = {}
let g:neatview_struct_setstat                       = {}
let g:neatview_struct_setshow                       = {}

let g:neatview_struct_setname['nerdtree']           = 'Filelist'
let g:neatview_struct_settype['nerdtree']           = 'nerdtree'
let g:neatview_struct_setpart['nerdtree']           = 'tree'
let g:neatview_struct_setbuff['nerdtree']           = ''
let g:neatview_struct_setcoth['nerdtree']           = []
let g:neatview_struct_setsize['nerdtree']           = 30
let g:neatview_struct_setopen['nerdtree']           = 'NERDTree'
let g:neatview_struct_setclse['nerdtree']           = 'NERDTreeClose'
let g:neatview_struct_setnohi['nerdtree']           = 0
let g:neatview_struct_setstat['nerdtree']           = 0
let g:neatview_struct_setshow['nerdtree']           = 0

let g:neatview_struct_setname['minibufexpl']        = 'Bufferlist'
let g:neatview_struct_settype['minibufexpl']        = 'minibufexpl'
let g:neatview_struct_setpart['minibufexpl']        = 'tab'
let g:neatview_struct_setbuff['minibufexpl']        = ''
let g:neatview_struct_setcoth['minibufexpl']        = []
let g:neatview_struct_setsize['minibufexpl']        = 1
let g:neatview_struct_setopen['minibufexpl']        = 'MBEOpen'
let g:neatview_struct_setclse['minibufexpl']        = 'MBEClose'
let g:neatview_struct_setnohi['minibufexpl']        = 1
let g:neatview_struct_setstat['minibufexpl']        = 0
let g:neatview_struct_setshow['minibufexpl']        = 0

let g:neatview_struct_setname['quickfix']           = 'Quickfix'
let g:neatview_struct_settype['quickfix']           = 'qf'
let g:neatview_struct_setpart['quickfix']           = 'output'
let g:neatview_struct_setbuff['quickfix']           = ''
let g:neatview_struct_setcoth['quickfix']           = []
let g:neatview_struct_setsize['quickfix']           = 10
let g:neatview_struct_setopen['quickfix']           = 'botright copen '.g:neatview_struct_setsize['quickfix']
let g:neatview_struct_setclse['quickfix']           = 'cclose'
let g:neatview_struct_setnohi['quickfix']           = 0
let g:neatview_struct_setstat['quickfix']           = 1
let g:neatview_struct_setshow['quickfix']           = 0

let g:neatview_struct_setname['viewmap']            = 'Codemap'
let g:neatview_struct_settype['viewmap']            = 'viewmap'
let g:neatview_struct_setpart['viewmap']            = 'info'
let g:neatview_struct_setbuff['viewmap']            = 'vim-viewmap'
let g:neatview_struct_setcoth['viewmap']            = []
let g:neatview_struct_setsize['viewmap']            = 20
let g:neatview_struct_setopen['viewmap']            = 'ViewmapOpen'
let g:neatview_struct_setclse['viewmap']            = 'ViewmapClose'
let g:neatview_struct_setnohi['viewmap']            = 1
let g:neatview_struct_setstat['viewmap']            = 1
let g:neatview_struct_setshow['viewmap']            = 0
```

neatview_reopen
```vim
" Set 1 enable neatview_reopen (default: 0)
let g:neatview_reopen_enabled = 1
" Set neatview_reopen save place
let g:neatview_reopen_setpath = g:config_dir_data.'neatview'
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

