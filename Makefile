# A simple makefile for managing LaTeX files.
# (c) Harish Narayanan, 2005--2007

FILE= thesis
LFLAGS=
BFLAGS=
DFLAGS=-t letter -Ppdf -G0 -o $(FILE).ps
PFLAGS=-dPDFSETTINGS=/prepress

paper:  clean
	@echo "TeXing files!"
	latex $(LFLAGS) $(FILE)
	latex $(LFLAGS) $(FILE)
	bibtex $(BFLAGS) $(FILE)
	latex $(LFLAGS) $(FILE)
	latex $(LFLAGS) $(FILE)
	dvips $(DFLAGS) $(FILE).dvi
	ps2pdf $(PFLAGS) $(FILE).ps

clean:
	@echo "Cleaning cruft!"
	rm -f *.aux *.lof *.log *.toc *~

