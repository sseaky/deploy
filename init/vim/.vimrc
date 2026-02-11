" @Author: Seaky
" @Modified: 2026-02-11

" =================================================================
" 1. 基础显示与编码设置
" =================================================================
syntax on
filetype on
filetype indent on
set autoread          " 文件在外部被修改时自动载入
set shortmess=atI     " 启动时不显示援助索马里儿童的提示
set mouse-=a           " 禁用鼠标以方便终端复制
set number            " 显示行号
set cursorline        " 突出显示当前行
set history=1000      " 历史命令保存行数
set backspace=indent,eol,start

" 编码处理：优先 UTF-8，兼容中文常用编码
set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" =================================================================
" 2. 缩进与搜索逻辑
" =================================================================
set tabstop=4         " Tab 宽度
set shiftwidth=4      " 自动缩进宽度
set softtabstop=4
set expandtab         " 将 Tab 转为空格
set smarttab
set si                " 智能缩进

set showmatch         " 高亮匹配的括号
set hlsearch          " 高亮搜索结果
set ignorecase        " 搜索时忽略大小写
set incsearch         " 开启即时搜索
set smartcase         " 如果搜索包含大写字母，则开启大小写敏感

set ruler             " 在右下角显示光标位置
set showcmd           " 在状态栏显示输入的命令
set scrolloff=6       " 滚动时距离顶部/底部保留 6 行

" =================================================================
" 3. 按键映射 (Key Mappings)
" =================================================================
let mapleader = ','

" 快速操作
nnoremap ; :
inoremap kj <Esc>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" 快捷键切换：F6 切换行号，F7 切换粘贴模式 (解决粘贴缩进错乱)
nnoremap <F6> :set nonumber!<CR>:set nocursorline!<CR>
nnoremap <F7> :set paste!<CR>

" 记住上次编辑的位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" =================================================================
" 4. 自动化处理 (文件头生成)
" =================================================================
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    if &filetype == 'sh'
        call setline(1, "#!/bin/bash")
    elseif &filetype == 'python'
        call setline(1, "#!/usr/bin/env python")
        call append(1, "# -*- coding: utf-8 -*-")
    endif
    normal G
    normal o
endfunction

" =================================================================
" 5. 插件扩展 (需安装 Vundle)
" =================================================================
" 如果你运行 vim.sh 时带了 -p 参数，下面的注释会被安装脚本自动取消
" source ~/.vimrc_vundle