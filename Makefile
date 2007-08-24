# A simple Makefile for managing my dissertation.
# (c) Harish Narayanan, 2005--2007

FILE= thesis
LFLAGS=
BFLAGS=
DFLAGS= -t letter -Ppdf -G0 -o $(FILE).ps
PFLAGS= #-p #-dPDFSETTINGS=/prepress

all: thesis

clean:
	@echo "Cleaning cruft:"
	rm -f *~ *.aux *.bbl *.blg *.dvi *.loa *.lof *.log *.lot *.out *.toc
	(cd auxiliary; make clean)
	(cd chapters; make clean)
	(cd images; make clean)

compose:
	@echo "TeXing-up the document:"
	latex 	$(LFLAGS) $(FILE)
	latex 	$(LFLAGS) $(FILE)
	bibtex 	$(BFLAGS) $(FILE)
	latex 	$(LFLAGS) $(FILE)
	latex 	$(LFLAGS) $(FILE)
	dvips 	$(DFLAGS) $(FILE).dvi
	ps2pdf 	$(PFLAGS) $(FILE).ps

pristine:	
	make clean
	@echo "Removing older output files:"
	rm -f *.pdf *.ps

thesis: 
	make pristine
	make compose
	make clean
