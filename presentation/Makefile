src = pre
xelatex: 
	xelatex $(src)
pdf : clean $(src).tex
	xelatex $(src).tex
	xelatex $(src).tex
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
		*.bcf \
		*.snm \
		*.nav \
		*.bib \
