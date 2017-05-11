src = main

pdf: clean main.tex main.bib
	xelatex $(src)
	bibtex $(src)
	xelatex $(src)
	xelatex $(src)

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

