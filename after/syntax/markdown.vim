" Make vim-css-color identify color code within Markdown files:
if match(&runtimepath, 'vim-css-color') != -1
  call css_color#init('hex', 'none', ',mkdListItemLine,mkdNonListItemBlock')
  " call css_color#init('hex', 'none', 'Normal')
endif
