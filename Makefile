src = main

pdf: clean main.tex reference.bib
	xelatex -shell-escape $(src)
	bibtex reference
	xelatex -shell-escape $(src)
	xelatex -shell-escape $(src)

show:
	xdg-open $(src).pdf

clean:
	-@rm -rf \
		*~ \
		*.aux \
		*.bbl \
		*.blg \
		*.dvi \
		*.ent \
		*.loa \
		*.lof \
		*.lot \
		*.toc \
		*.log \
		*.out \
		.fuse* \
		*.run.xml \
		*.bcf
	-@find . -name *.aux -exec rm {} \;

