#!/usr/bin/env bash

VIM_INDENT=${VIM_INDENT:-4}

apk add --no-cache vim &&
rm -rf /var/cache/apk/* && 
mkdir -p ~/.vim/autoload ~/.vim/bundle && 
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

if [[ ! -r ~/.vim/autoload/pathogen.vim ]]; then
    echo "ERROR: $0: failed to get pathogen (vim plugin manager)"
fi

cat << EOF >> /etc/vim/vimrc
" added by $0 $(date +'%Y-%m-%d %H:%M:%S')
execute pathogen#infect()
hi Comment ctermfg=6
set tabstop=$VIM_INDENT
set shiftwidth=$VIM_INDENT
set shiftround
set expandtab
set smartindent
set pastetoggle=<F1>
EOF

rm -rf /var/cache/apk/*
