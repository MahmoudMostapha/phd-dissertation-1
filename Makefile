# A simple build-system for managing my doctoral dissertation.
# (c) Harish Narayanan, 2007

# Fundamental variables:

# A versioning scheme to keep track of progress
VERSION = 0.0.9

# Change these to your heart's content.
LATEX   = latex
BIBTEX  = bibtex
DVIPS   = dvips
PS2PDF  = ps2pdf14 #On Mac OS X, use pstopdf instead.

SOURCES = Makefile thesis.tex thesis.bib thesis.bst *.sty \
	  auxiliary/*.tex chapters/*.tex \
          images/*/*.eps images/*/*/*.eps images/*/*/*/*.eps

OTHER   = manifest/*

# Subtle changes to the command-line flags below can have significant
# impact on the quality of generated documents. Comment-out the ps2pdf
# flags below if on Mac OS X.
LFLAGS  = 					#latex flags
BFLAGS  = -terse				#bibtex flags
DFLAGS  = -q -z -Z -t letter -Ppdf -G0 -o thesis.ps  #dvips flags
PFLAGS  = -dPDFSETTINGS=/prepress		#ps2pdf flags
ADPATH  = "/Library/Application Support/Adobe/Adobe PDF/Settings/"
ADFILE  = "High Quality Print.joboptions"	#distiller settings file


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

archive:  pristine
	  hg archive -ttbz2 ../older/thesis-$(VERSION).tar.bz2

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
	@echo "Setting the version number:"
	perl -pi -e 's/GROWTH \(.*\)/GROWTH \(${VERSION}\)/' auxiliary/front-matter.tex
	@echo "Creating the dvi file:"
	$(LATEX)   $(LFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(BIBTEX)  $(BFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis && \
	$(LATEX)   $(LFLAGS) thesis && $(LATEX)   $(LFLAGS) thesis

thesis.ps: thesis.dvi
	@echo "Creating the postscript file:"
	$(DVIPS)   $(DFLAGS) thesis.dvi
	@echo "Fix capitalisation to allow creation of elegant PDF bookmarks:"
	perl -pi -e 's/Title \(([A-Z])([A-Z].*)\)/Title (\1\L\2)/' thesis.ps
#       If you have access to GNU sed (i.e., You're not working on Mac
#       OS X), comment-out the preceding command and uncomment the
#       following. It'll be faster, and it's not fucking perl.
#	sed '/Title (\([A-Z]\)\([A-Z].*\))/ s//Title (\1\L\2)/' \
#	thesis.ps > tmp.ps && mv tmp.ps thesis.ps

thesis.pdf: thesis.ps
	@echo   "Creating the PDF file:"
	$(PS2PDF)  $(PFLAGS) thesis.ps

distiller: thesis.ps
	@echo	"Creating the PDF file using Acrobat Distiller:"
	osascript distiller.applescript thesis.ps $(ADPATH)$(ADFILE)