MAIN = main
NAME = sysuthesis
CLSFILES = $(NAME).cls
BSTFILES = $(NAME)-numerical.bst

SHELL = bash
LATEXMK = latexmk -xelatex
# VERSION = $(shell cat $(NAME).cls | egrep -o "\\ustcthesisversion{v[0-9.]+" \
# 	  | egrep -o "v[0-9.]+")
TEXMF = $(shell kpsewhich --var-value TEXMFHOME)

.PHONY : main cls doc clean all install distclean zip FORCE_MAKE

main : $(MAIN).pdf

all : main doc

cls : $(CLSFILES) $(BSTFILES)

doc : $(NAME)-guide.pdf

$(MAIN).pdf : $(MAIN).tex $(CLSFILES) $(BSTFILES) FORCE_MAKE
	$(LATEXMK) $<

$(NAME)-guide.pdf : $(NAME)-guide.tex FORCE_MAKE
	$(LATEXMK) $<

clean : FORCE_MAKE
	$(LATEXMK) -c $(MAIN).tex $(NAME)-guide.tex

cleanall :
	$(LATEXMK) -C $(MAIN).tex $(NAME)-guide.tex

install : cls doc
	mkdir -p $(TEXMF)/{doc,source,tex}/latex/$(NAME)
	mkdir -p $(TEXMF)/bibtex/bst/$(NAME)
	cp $(BSTFILES) $(TEXMF)/bibtex/bst/$(NAME)
	cp $(NAME).pdf $(TEXMF)/doc/latex/$(NAME)
	cp $(CLSFILES) $(TEXMF)/tex/latex/$(NAME)

zip : main doc
	ln -sf . $(NAME)
	zip -r ../$(NAME)-$(VERSION).zip $(NAME)/{*.md,LICENSE,\
	$(NAME)-guide.tex,$(NAME)-guide.pdf,$(NAME).cls,*.bst,*.bbx,*.cbx,figures,\
	$(MAIN).tex,sysusetup.tex,chapters,bib,$(MAIN).pdf,\
	latexmkrc,Makefile}
	rm $(NAME)
