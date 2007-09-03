# A simple build-system for managing my doctoral dissertation.
# (c) Harish Narayanan, 2007

# Fundamental variables:

# Change these to your heart's content.
LATEX   = latex
BIBTEX  = bibtex
DVIPS   = dvips
PS2PDF  = ps2pdf    #Use pstopdf instead on Mac OS X.

SOURCES = thesis.tex thesis.bib thesis.bst *.sty \
	  auxiliary/*.tex chapters/*.tex \
          images/*/*.eps images/*/*/*.eps images/*/*/*/*.eps

OTHER   = manifest/*

# Subtle changes to the command-line flags below can have significant
# impact on the quality of generated documents.
LFLAGS  = 					#latex flags
BFLAGS  = 					#bibtex flags
DFLAGS  = -t letter -Ppdf -G0 -z -o thesis.ps	#dvips flags
PFLAGS  = #-p #-dPDFSETTINGS=/prepress		#ps2pdf flags

# Human-readable targets:

# I find it easiest to use the following names while running make. For
# e.g., running 'make thesis' (or just 'make') cleans the source
# distribution of cruft and generates a pristine PDF.

all:	  thesis

compose:  thesis.dvi

polish:   thesis.pdf

preview:  thesis.dvi
	  xdvi thesis.dvi&

thesis:   pristine polish
	  make clean

distill:  pristine distiller
	  make clean

# Actual drudgery:

# Shoo, here be dragons.

clean:
	@echo "Cleaning cruft:"
	rm -f *~ *.aux *.bbl *.blg *.brf *.dvi *.loa *.lof *.log *.lot *.out \
	*.ps *.toc *.tmp
	(cd auxiliary; make clean)
	(cd chapters; make clean)
	(cd images; make clean)
	(cd manifest; make clean)

pristine: clean
	@echo "Removing older output files:"
	rm -f *.pdf

thesis.dvi: $(SOURCES)
	@echo "Creating the dvi file:"
	$(LATEX)   $(LFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(BIBTEX)  $(BFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(LATEX)   $(LFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis

thesis.ps: thesis.dvi
	@echo "Creating the postscript file:"
	$(DVIPS)   $(DFLAGS) thesis.dvi
	@echo "Fix capitalisation to allow creation of elegant PDF bookmarks:"
	perl -pi -e 's/Title \(([A-Z])([A-Z].*)\)/Title(\1\L\2)/' thesis.ps
#       If you have access to GNU sed, I believe the following ought
#       to work instead. It'll be faster, and it's not fucking perl.
#       sed '/Title (\([A-Z]\)\([A-Z].*\))/ s//Title (\1\L\2)/' \
#       thesis.ps > tmp.ps && mv tmp.ps thesis.ps

thesis.pdf: thesis.ps
	@echo   "Creating the PDF file:"
	$(PS2PDF)  $(PFLAGS) thesis.ps

distiller: thesis.ps
	@echo	"Creating the PDF file using Acrobat Distiller:"
	osascript distiller.applescript thesis.ps