#!/bin/bash

file=thesis

# Initial clean up
rm -f ${file}.toc
rm -f ${file}.aux 
rm -f ${file}.lof
rm -f ${file}.log
rm -f ${file}.blg
rm -f ${file}.dvi
rm -f ${file}.ps
rm -f ${file}.pdf
rm -f ${file}.bbl
#killall -name xpdf

# TeX up the document
latex ${file}
latex ${file}
bibtex ${file}
latex ${file}
latex ${file}
dvips -t letter -Ppdf -G0 -o ${file}.ps ${file}.dvi
ps2pdf ${file}.ps

# Final clean up
rm -f ${file}.toc
rm -f ${file}.aux 
rm -f ${file}.lof
rm -f ${file}.log
rm -f ${file}.blg
rm -f ${file}.bbl

# View the output
#xpdf ${file}.pdf

