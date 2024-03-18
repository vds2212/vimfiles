syn match VimwikiLinkDelimeter /\[\[\([^\\\]]*\]\]\)\@=/ conceal
syn match VimwikiLinkDelimeter /\(\[\[[^\\\]]*\)\@<=\]\]/ conceal
syn match VimwikiLinkBody /\(\[\[\)\@<=[^\\\]]*\(\]\]\)\@=/
