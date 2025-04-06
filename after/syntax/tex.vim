
syn cluster texSpell contains=texAbstract,texBoldItalStyle,texBoldStyle,texChapterZone,texCommentGroup,texDocZone,texEmphStyle,texItalBoldStyle,texItalStyle,texMatcher,texMatchGroup,texMatchNMGroup,texMathText,texParaZone,texParen,texPartZone,texSectionZone,texStyleGroup,texSubParaZone,texSubSectionZone,texSubSubSectionZone,texTitle,texZone

syn match TimeNoSpell '\<\d\dh\d\d\>' contains=@NoSpell containedin=@texSpell
syn match YourNoSpellGroup 'grr' contains=@NoSpell containedin=@texSpell
