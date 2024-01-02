#/bin/bash

# Start a clean vim for testing development.

REPO_TOP=$(git rev-parse --show-toplevel)
cd "${REPO_TOP}"

vim -Nu <(cat <<EOF
filetype off
set rtp+=~/.vim/bundle/vader.vim
set rtp+=./
filetype plugin indent on
syntax enable
autocmd filetype todo setlocal omnifunc=todo#Complete
EOF
) $*

