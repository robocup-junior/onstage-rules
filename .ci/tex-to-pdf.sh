#!/bin/bash
set -euo pipefail

OUTPUT_FILE=$1

cp manual.sty tmp/
cp -r media tmp/
cd tmp

# Apply custom styling to DocBook
dblatex -T db2latex $OUTPUT_FILE.xml -t tex --texstyle=./manual.sty -p ../custom.xsl

# Go through the generated .tex output, find the place where the preamble ends
# (marked by the \mainmatter command) and create a file without it.
cat $OUTPUT_FILE.tex | awk 'f;/\\mainmatter/{f=1}'  > $OUTPUT_FILE"_without_preamble.tex"
# Concat the standardized preamble with the "without_preamble" version of the file
cat ../preamble.tex $OUTPUT_FILE"_without_preamble.tex" > $OUTPUT_FILE.tex
texliveonfly $OUTPUT_FILE.tex
pdflatex $OUTPUT_FILE.tex
pdflatex $OUTPUT_FILE.tex

mv $OUTPUT_FILE.pdf ../rules_documents/

cd ..
rm -r tmp
