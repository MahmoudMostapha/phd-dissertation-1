# A simple Makefile for managing my doctoral dissertation.
# (c) Harish Narayanan, 2005--2007

# Fundamental variables

LATEX   = latex
BIBTEX  = bibtex
DVIPS   = dvips
PS2PDF  = ps2pdf    #Use pstopdf instead on Mac OS X
DISTILL = distiller #Requires Acrobat Distiller 

LFLAGS  = 					#latex flags
BFLAGS  = 					#bibtex flags
DFLAGS  = -t letter -Ppdf -G0 -o thesis.ps	#dvips flags
PFLAGS  = #-p #-dPDFSETTINGS=/prepress		#ps2pdf flags
DIFLAGS = 					#distiller flags

SOURCES = thesis.tex thesis.bib thesis.bst *.sty \
	auxiliary/*.tex chapters/*.tex images/*.eps

OTHER   = manifest/*

# Human-readable targets

all:	  thesis

compose:  thesis.dvi

polish:   thesis.pdf

preview:  thesis.dvi
	  xdvi thesis.dvi&

thesis:   pristine polish clean

# Actual drudgery

clean:
	@echo	"Cleaning cruft:"
	rm -f *~ *.aux *.bbl *.blg *.dvi *.loa *.lof *.log *.lot *.out *.toc
	(cd auxiliary; make clean)
	(cd chapters; make clean)
	(cd images; make clean)
	(cd manifest; make clean)

pristine: clean
	@echo	"Removing older output files:"
	rm -f *.pdf *.ps

thesis.dvi: $(SOURCES)
	@echo	"Creating the dvi file:"
	$(LATEX)   $(LFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(BIBTEX)  $(BFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(LATEX)   $(LFLAGS) thesis

thesis.ps: thesis.dvi
	@echo	"Creating the postscript file:"
	$(DVIPS)   $(DFLAGS) thesis.dvi 

thesis.pdf: thesis.ps
	@echo   "Creating the PDF file:"
	$(PS2PDF)  $(PFLAGS) thesis.ps