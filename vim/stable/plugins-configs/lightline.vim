"" auzu
set statusline+=%{anzu#search_status()}
"" lightline
set laststatus=2
set t_Co=256
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
  \'colorscheme': 'wombat',
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['readonly', 'filename', 'modified'],
  \  ]
  \},
  \'component_function': {
  \  'lsp': 'LspNextError'
  \},
\}

" let g:lightline = {
"   \'colorscheme': 'wombat',
"   \'active': {
"   \  'left': [
"   \    ['mode', 'paste'],
"   \    ['readonly', 'filename', 'modified'],
"   \    ['ale'],
"   \  ]
"   \},
"   \'component_function': {
"   \  'ale': 'ALEStatus'
"   \},
" \}
