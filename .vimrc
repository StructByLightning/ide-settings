execute pathogen#infect()
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
set autoindent
set showmatch "highlight matching brackets
set cursorline "highlight current line
set showcmd "display last command in bottom line
set number "line nums on
syntax on "syntax highlighting
colorscheme badwolf
set tabstop=4
set softtabstop=4 "number of spaces in tab when editing
set shiftwidth=4
set expandtab "convert tabs to spaces
filetype plugin indent on
let t_Co=256 "enable full colors
let g:cpp_experimental_template_highlight = 1

"ctags stuff
function! DelTagOfFile(file)
    let fullpath = a:file
    let cwd = getcwd()
    let tagfilename = cwd . "/tags"
    let f = substitute(fullpath, cwd . "/", "", "")
    let f = escape(f, './')
    let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
    let resp = system(cmd)
endfunction

function! UpdateTags()
    let f = expand("%:p")
    let cwd = getcwd()
    let tagfilename = cwd . "/tags"
    let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
    call DelTagOfFile(f)
    let resp = system(cmd)
endfunction
autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

set wrap! "disable text wrapping
map <MiddleMouse> <Nop> "disable middle click paste
imap <MiddleMouse> <Nop> "disable middle click paste

set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L" "add filename to status line
" changes the text displayed on a fold
function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let expansionString = repeat("-", w - strwidth(nblines.comment.'"'))
    let txt = '' . comment . expansionString
    return txt
endfunction
setlocal foldtext=MyFoldText()
hi Folded ctermfg=022
let anyfold_activate=1
set foldlevel=10
let anyfold_identify_comments=0
let anyfold_fold_toplevel=1
autocmd BufWinLeave * mkview
autocmd User anyfoldLoaded loadview

"use system clipboard
noremap <Leader>y "+y
noremap <Leader>p "+p
set clipboard=unnamedplus

au BufNewFile,BufRead *.shtml set filetype=html
au BufNewFile,BufRead *.ejs set filetype=html
