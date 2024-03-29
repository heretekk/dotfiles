" Example code here.
"
" autocmd BufReadPost quickfix setlocal modifiable
" 	\ | silent exe 'g/^/s//\=line(".")." "/'
" 	\ | setlocal nomodifiable

augroup GeneralAutocmdSetting
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//ge
  autocmd InsertLeave * set nopaste
  autocmd QuickFixCmdPost *grep* cwindow
  autocmd Filetype json setl conceallevel=0
augroup END

augroup HighlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.yml.j2,*.yaml.j2 set ft=yaml " or, set ft=ansible by vim-ansible-yaml plugin
  au BufNewFile,BufRead *.conf,*.conf.j2 set ft=conf
augroup END

augroup ColorSchemeSetting
  autocmd!
  autocmd ColorScheme * hi LineNr ctermfg=239
  autocmd ColorScheme * hi Normal ctermbg=none
augroup END

augroup EmmetSetting
  autocmd!
  autocmd FileType html,css,scss,javascript EmmetInstall
augroup END

augroup QuickRunSetting
  autocmd!
  autocmd Filetype quickrun set syntax=zsh
  let g:quickrun_config = {}
  autocmd BufNewFile,BufRead *.rs  let g:quickrun_config.rust = {'exec' : 'cargo run'}
augroup END

augroup VimLspSetting
  autocmd!
  autocmd FileType rust,go,python nmap gd <plug>(lsp-definition)
  autocmd BufWritePre *.py silent LspDocumentFormatSync
augroup END

