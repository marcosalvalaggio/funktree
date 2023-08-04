" Maintainer:   Marco Salvalaggio <mar.salvalaggio@gmail.com>
" License:      GNU General Public License v3.0


if exists('g:loaded_funktree') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo
set cpo&vim

hi def link WhidHeader      Number
hi def link WhidSubHeader   Identifier

command! Funk lua require'funktree'.funktree()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_funktree = 1

