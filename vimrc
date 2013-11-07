" ==============================================  
" Functions  
" ============================================== 

" Platform
function! MySys()
  if has("win32")
    return "windows"
  else
    return "linux"
  endif
endfunction

function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc' 

" ==============================================  
" General settings  
" ==============================================  
set nocp  
set ru  
set nu  
"set cin  
"set cino = :0g0t0(sus  
set sm  
set ai  
set sw=4  
set ts=4  
set noet  
set lbr  
set hls  
"set backspace = indent , eol , start  
"set whichwrap = b , s , < , > , [ , ]  
"set fo+ = mB  
set selectmode =  
"set mousemodel = popup 
set keymodel =  
"set selection = inclusive  
"set matchpairs+ =  
"nmap <C-W><H> <C-L>
"nmap <C-W><L> <C-R>

" ==============================================  
" Cursor movement  
" ==============================================  
"nnoremap gj  
"nnoremap gk  
"vnoremap gj  
"vnoremap gk  
"inoremap gj  
"inoremap gk  
"nnoremap g$  
"nnoremap g0  
"vnoremap g$  
"vnoremap g0  
"inoremap g$  
"inoremap g0  
"nmap :confirm bd  
"vmap :confirm bd  
"omap :confirm bd  
"map! :confirm bd  
syntax on  
"set foldmethod=syntax  
if (has( " gui_running " ))  
set nowrap  
set guioptions+=b 
colo inkpot  
else  
set wrap  
"set color
colo torte 
endif  
"let mapleader = " , "  
if !has("gui_running")  
set t_Co=8  
set t_Sf=^[[3%p1%dm  
set t_Sb=^[[4%p1%dm  
endif  

""""""""""""""""""""""""""""""
" Tag list (ctags)
""""""""""""""""""""""""""""""
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1            
let Tlist_Exit_OnlyWindow = 1          
"let Tlist_Use_Right_Window = 1     
let Tlist_Use_Left_Window = 1
let Tlist_Sort_Type = 'name'
let Tlist_Show_Menu = 1
let Tlist_Auto_Open = 1
nmap <silent> <F8> :TlistToggle<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    """"""""""""" Standard cscope/vim boilerplate
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    " show msg when any other cscope db added
    set cscopeverbose

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).

    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <<A href="mailto:C-@%3Es" A >C-@>s<> <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Es" A >C-@>s<> :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Eg" A >C-@>g<> :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Ec" A >C-@>c<> :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Et" A >C-@>t<> :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Ee" A >C-@>e<> :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3Ef" A >C-@>f<> :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <<A href="mailto:C-@%3Ei" A >C-@>i<> :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <<A href="mailto:C-@%3Ed" A >C-@>d<> :scs find d <C-R>=expand("<cword>")<CR><CR>

    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left
    nmap <<A href="mailto:C-@%3E%3CC-@%3Es" A >C-@><C-@>s<> :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Eg" A >C-@><C-@>g<> :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Ec" A >C-@><C-@>c<> :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Et" A >C-@><C-@>t<> :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Ee" A >C-@><C-@>e<> :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Ef" A >C-@><C-@>f<> :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Ei" A >C-@><C-@>i<> :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <<A href="mailto:C-@%3E%3CC-@%3Ed" A >C-@><C-@>d<> :vert scs find d <C-R>=expand("<cword>")<CR><CR>

    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100
endif      

""""""""""""""""""""""""""""""
" netrw setting
""""""""""""""""""""""""""""""
let g:netrw_winsize = 30
nmap <silent> <leader>fe :Sexplore!<cr> 
     
""""""""""""""""""""""""""""""
" BufExplorer
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber 

""""""""""""""""""""""""""""""
" winManager setting
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "BufExplorer|FileExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <F7> :WMToggle<cr> 

""""""""""""""""""""""""""""""
" lookupfile setting
""""""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./filenametags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./filenametags"'
endif

nmap <silent> <leader>lk :LUTags<cr>
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>
nmap <silent> <F9> :Grep<CR>
nmap <silent> <F12> :A<CR>
nmap <silent> <F3> <C-]>

""""""""""""""""""""""""""""""
" omnicppcomplete setting
""""""""""""""""""""""""""""""
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=cppcomplete#Complete

set nocp
set completeopt=longest,menu 
filetype plugin on

let g:SuperTabRetainCompletionType=2  
let g:SuperTabDefaultCompletionType="<C-X><C-O>"


"colorscheme crt
"colorscheme darkblue2
colorscheme desert
set autoindent
set smartindent

"第一行设置tab键为4个空格，第二行设置当行之间交错时使用4个空格

set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set nohls
set incsearch

"代码折叠
"set foldenable
"set foldmethod=indent
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

"搜索高亮显示
set hlsearch

map <f2>   ::NERDTree<cr>
map <f3>   ::NERDTreeClose<cr>

au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif   
