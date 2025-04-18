execute 'highlight Primary ctermfg='.primaryFg.' ctermbg='.primaryBg
execute 'highlight Accent ctermfg='.accentFg.' ctermbg='.accentBg
execute 'highlight Gap ctermfg=NONE ctermbg=NONE'
execute 'highlight Secondary ctermfg='.secondaryFg.' ctermbg='.secondaryBg
execute 'highlight Error ctermfg='.criticalFg.' ctermbg='.criticalBg
execute 'highlight Inactive ctermfg='.infoFg.' ctermbg='.infoBg
execute 'highlight Line ctermfg=244 ctermbg=NONE'
execute 'highlight WinSeparator ctermfg=244 ctermbg=NONE'

set fillchars+=stl:\―,stlnc:\―

function! TabLineCurrentBuffer()
  let bufpath = expand("%:~:.:h")
  let bufname = expand("%:t")
  if empty(bufname)
    let bufname = "[No Name]"
  endif

  let path = (!empty(bufpath) && bufpath != ".") ? "%#Secondary# " . bufpath . " %#Gap# " : ""
  let name = (&modified ? "%#Accent# " : "%#Primary# ") . bufname . " %#Gap# "

  return path . name
endfunction

function TabLineTabs()
  if tabpagenr('$') <= 1
    return ''
  endif

  let tabs = ''
  for i in range(tabpagenr('$'))
    let tabnr = i + 1

    " set the tab page number (for mouse clicks)
    let tabs .= '%' . tabnr . 'T'

    let tabs .= '%#Gap# '

    if tabnr == tabpagenr()
      let tabs .= '%#Accent# '
    else
      let tabs .= '%#Primary# '
    endif

    let buflist = tabpagebuflist(tabnr)
    let winnr = tabpagewinnr(tabnr)
    let tabs .=  tabnr . ' '
  endfor

  " after the last tab reset tab page nr
  let tabs .= '%T'

  return tabs . '%#Gap# %#Primary# '
endfunction

function! TabLine()
  let currentBuffer = TabLineCurrentBuffer()
  let tabs = TabLineTabs()
  return '%#Primary# %#Gap# ' . currentBuffer . '%#Primary#%=' . tabs
endfunction

set showtabline=2
set tabline=%!TabLine()

function! CocStatus()
  if !exists(':CocCommand')
    return ''
  endif

  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) 
    return ''
  endif

  let errorCount = get(info, "error", 0)
  if empty(errorCount)
    return ''
  endif

  let errorLineNr = printf(' (Line %d) ', (info.lnums)[0])
  return ' Errors: '.errorCount.errorLineNr
endfunction

function! StatusLine()
  let isActive = g:statusline_winid == win_getid()

  if (!isActive)
    let bufnr = get(getwininfo(g:statusline_winid)[0], 'bufnr')
    let bufFiletype = getbufvar(bufnr, '&filetype')
    let bufReadonly = getbufvar(bufnr, '&readonly')

    let bufpath = fnamemodify(bufname(bufnr), ":~:.:h")
    let bufname = fnamemodify(bufname(bufnr), ":t")
    if empty(bufname)
      let bufname = "[No Name]"
    endif

    let inactiveLine = '%#Inactive# '
    let inactiveLine .= '%#Gap# '
    let inactiveLine .= (!empty(bufpath) && bufpath != ".") ? '%#Inactive# '.bufpath.' %#Gap# ' : ''
    let inactiveLine .= '%#Inactive# '
    let inactiveLine .= bufname.' '
    let inactiveLine .= '%#Gap# '
    let inactiveLine .= '%#Line# '
    let inactiveLine .= '%='
    let inactiveLine .= '%#Gap# '
    let inactiveLine .= bufFiletype.' '.(bufReadonly ? '%r ' : '')
    let inactiveLine .= '%#Inactive#'
    let inactiveLine .= ' %p%% '
    let inactiveLine .= '%#Gap# '
    let inactiveLine .= '%#Inactive#'
    let inactiveLine .= ' %l/%L : %v '
    let inactiveLine .= '%#Gap# '
    let inactiveLine .= '%#Inactive#'
    let inactiveLine .= ' 0x%B '

    return inactiveLine
  endif

  let modeMap = {
        \ 'n': { 'name': ' NORMAL ', 'highlight': '%#Primary#' },
        \ 'i': { 'name': ' INSERT ', 'highlight': '%#Accent#' },
        \ 'v': { 'name': ' VISUAL ', 'highlight': '%#Secondary#' },
        \ 'V': { 'name': ' VISUAL LINE ', 'highlight': '%#Secondary#' },
        \ "\<C-V>": { 'name': ' VISUAL BLOCK ', 'highlight': '%#Secondary#' },
        \ 'c': { 'name': ' COMMAND ', 'highlight': '%#Secondary#' },
        \ 't': { 'name': ' TERMINAL ', 'highlight': '%#Secondary#' }
        \}

  let modeRaw = mode()
  let modeFallback = { 'name': '['.modeRaw.']', 'highlight': '%#Secondary#' }
  let mode = get(modeMap, modeRaw, modeFallback)

  let modeName = get(mode, 'name')
  let modeHighlight = get(mode, 'highlight')
  let cocStatus = CocStatus()

  let line = modeHighlight.' '
  let line .= '%#Gap# '
  let line .= modeHighlight.modeName
  let line .= '%#Gap# '
  let line .= '%#Line# '
  let line .= '%='
  let line .= '%#Gap# '
  let line .= &filetype.' '.(&readonly ? '%r ' : '')
  let line .= modeHighlight
  let line .= ' %p%% '
  let line .= '%#Gap# '
  let line .= modeHighlight
  let line .= ' %l/%L : %v '
  let line .= '%#Gap# '
  let line .= modeHighlight
  let line .= ' 0x%B '

  if !empty(cocStatus)
    let line .= '%#Gap# '
    let line .= '%#Error#'.cocStatus
  endif

  return line
endfunction

set noruler
set noshowmode
set laststatus=2
set statusline=%!StatusLine()
