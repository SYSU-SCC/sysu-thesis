src = main

pdf: clean main.tex main.bib
	xelatex -shell-escape $(src).tex
	bibtex $(src)
	xelatex -shell-escape $(src).tex
	xelatex -shell-escape $(src).tex

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

